--!nocheck
-- Tested: Studio fault mocks; outbox/inbox saga, not distributed ACID two-phase commit.
local Ledger = {}
Ledger.__index = Ledger
local TOPIC = "BackendGiftHints_v1"

function Ledger.new(accounts, hintMap, messaging)
    return setmetatable({accounts = accounts, hints = hintMap, messaging = messaging}, Ledger)
end
function Ledger:Hint(sender, id)
    -- Advisory only; expiry or lost delivery MUST NOT lose the gift.
    task.spawn(function()
        if self.hints then pcall(function()
            self.hints:SetAsync(tostring(sender) .. ":" .. id, {sender = sender, id = id}, 120)
        end) end
        if self.messaging then pcall(function()
            self.messaging:PublishAsync(TOPIC, {sender = sender, id = id})
        end) end
    end)
end
-- Generate/persist id ONCE on the trusted server BEFORE calling Send.
-- Retrying must reuse id, recipient and amount; a new id creates a new transfer.
function Ledger:Send(sender, recipient, amount, id)
    local A = self.accounts
    if not A.Integer(recipient) or recipient == 0 or sender == recipient
        or not A.Integer(amount) or amount == 0
        or type(id) ~= "string" or #id == 0 or #id > 80 then
        return false, "invalid_transfer"
    end
    local ok, outcome = A:Update(sender, function(data)
        local old = data.outbox[id]
        if old then
            assert(old.kind == "coins" and old.to == recipient and old.amount == amount, "transfer_id_conflict")
            return old.state
        end
        if data.coins < amount then return "insufficient_funds" end
        -- Atomic PREPARE: funds enter escrow and a durable intent is written together.
        data.coins -= amount
        data.outbox[id] = {kind = "coins", to = recipient, amount = amount, state = "prepared"}
        return "prepared"
    end)
    if not ok then return false, outcome end
    if outcome == "insufficient_funds" then return false, outcome end
    self:Hint(sender, id)
    return self:Resume(sender, id)
end
function Ledger:SendItem(sender, recipient, itemId, id)
    local A = self.accounts
    if not A.Integer(recipient) or recipient == 0 or sender == recipient
        or type(itemId) ~= "string" or #itemId == 0 or #itemId > 80
        or type(id) ~= "string" or #id == 0 or #id > 80 then return false, "invalid_transfer" end
    local ok, outcome = A:Update(sender, function(data)
        local prior = data.outbox[id]
        if prior then
            assert(prior.kind == "item" and prior.to == recipient and prior.itemId == itemId, "transfer_id_conflict")
            return prior.state
        end
        local item = data.inventory[itemId]
        if type(item) ~= "table" then return "item_not_owned" end
        data.inventory[itemId] = nil
        data.outbox[id] = {kind = "item", to = recipient, itemId = itemId, item = item, state = "prepared"}
        return "prepared"
    end)
    if not ok or outcome == "item_not_owned" then return false, outcome end
    self:Hint(sender, id)
    return self:Resume(sender, id)
end
function Ledger:Resume(sender, id)
    local A = self.accounts
    if type(id) ~= "string" or #id == 0 or #id > 80 then return false, "invalid_id" end
    local ok, _, source = A:Snapshot(sender)
    if not ok then return false, "sender_unavailable" end
    local tx = source.outbox[id]
    if not tx then return false, "unknown_transfer" end
    assert(A.Integer(tx.to) and tx.to > 0 and tx.to ~= sender, "corrupt_transfer")
    assert((tx.kind == "coins" and A.Integer(tx.amount) and tx.amount > 0)
        or (tx.kind == "item" and type(tx.itemId) == "string" and type(tx.item) == "table"), "corrupt_payload")
    if tx.state == "delivered" then return true, "delivered" end
    assert(tx.state == "prepared", "invalid_transfer_state")
    local token = tostring(sender) .. ":" .. id
    local credited = A:Update(tx.to, function(data)
        local prior = data.inbox[token]
        if prior then
            assert(prior.kind == tx.kind and prior.amount == tx.amount and prior.itemId == tx.itemId, "inbox_conflict")
            return "already_credited"
        end
        if tx.kind == "coins" then
            assert(A.Integer(data.coins + tx.amount), "balance_overflow")
            data.coins += tx.amount
        else
            assert(data.inventory[tx.itemId] == nil, "recipient_item_conflict")
            data.inventory[tx.itemId] = A.Copy(tx.item)
        end
        data.inbox[token] = {kind = tx.kind, amount = tx.amount, itemId = tx.itemId}
        return "credited"
    end)
    if not credited then return false, "pending_delivery" end
    local finalized = A:Update(sender, function(data)
        local current = data.outbox[id]
        assert(current and current.kind == tx.kind and current.to == tx.to
            and current.amount == tx.amount and current.itemId == tx.itemId, "outbox_conflict")
        current.state = "delivered"
        return true
    end)
    if not finalized then return false, "pending_ack" end
    return true, "delivered"
end
function Ledger:Recover(sender, limit)
    local ok, _, data = self.accounts:Snapshot(sender)
    if not ok then return false end
    local count = 0
    for id, tx in pairs(data.outbox) do
        if tx.state == "prepared" then
            self:Resume(sender, id)
            count += 1
            if count >= (limit or 10) then break end
        end
    end
    return true
end
function Ledger:Subscribe()
    assert(self.messaging, "messaging_required")
    return self.messaging:SubscribeAsync(TOPIC, function(message)
        local hint = message.Data
        if type(hint) == "table" and self.accounts.Integer(hint.sender)
            and type(hint.id) == "string" and #hint.id <= 80 then
            -- Never trust amount/recipient from a message. Re-read durable sender intent.
            task.spawn(function() self:Resume(hint.sender, hint.id) end)
        end
    end) -- host disconnects on shutdown; recover on login + bounded sweeper too
end
function Ledger:PollHints(limit)
    if not self.hints then return false, "no_hint_map" end
    local ok, rows = pcall(function()
        return self.hints:GetRangeAsync(Enum.SortDirection.Ascending, math.clamp(limit or 10, 1, 50))
    end)
    if not ok then return false, "hints_unavailable" end
    for _, row in ipairs(rows) do
        local hint = row.value
        if type(hint) == "table" and self.accounts.Integer(hint.sender) and type(hint.id) == "string" then
            self:Resume(hint.sender, hint.id)
        end
    end
    return true
end
return Ledger
