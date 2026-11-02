--!nocheck
-- Tested: Studio mock storage 2026-11-02; live persistence untested. See T-backend-systems-catalog.
-- All economy writers MUST use this module. Never mix with cached profile saves.
local HttpService = game:GetService("HttpService")
local Store = {}
Store.__index = Store
local MAX_SAFE = 9007199254740991

local function integer(n)
    return type(n) == "number" and n == n and n >= 0 and n <= MAX_SAFE and n % 1 == 0
end
local function copy(value)
    if type(value) ~= "table" then return value end
    local result = {}
    for k, v in pairs(value) do result[k] = copy(v) end
    return result
end
local function fresh()
    return {
        schema = 1, coins = 0, receipts = {}, outbox = {}, inbox = {},
        retention = {streak = 0, lastDay = -1, playSeconds = 0, claims = {}},
        quests = {}, questEvents = {}, inventory = {},
    }
end
local function valid(data)
    if type(data) ~= "table" or data.schema ~= 1 or not integer(data.coins) then return false end
    for _, key in ipairs({"receipts", "outbox", "inbox", "retention", "quests", "questEvents", "inventory"}) do
        if type(data[key]) ~= "table" then return false end
    end
    local r = data.retention
    return integer(r.streak) and integer(r.playSeconds) and type(r.lastDay) == "number"
        and r.lastDay % 1 == 0 and r.lastDay >= -1 and type(r.claims) == "table"
end

function Store.new(dataStore, maxEntries, maxBytes)
    return setmetatable({
        dataStore = dataStore, maxEntries = maxEntries or 2000,
        maxBytes = maxBytes or 3000000, -- headroom, not a platform limit
        busy = {}, waiting = {}, queues = {}, closed = false,
    }, Store)
end
function Store.Count(map)
    local n = 0
    for _ in pairs(map) do n += 1 end
    return n
end
Store.Copy, Store.Integer = copy, integer

-- transform(data) -> nonnil result. It may run repeatedly: no yielding/external effects!
-- Returns true, result, committedSnapshot OR false, diagnostic.
function Store:Update(userId, transform)
    if self.closed then return false, "closed" end
    if not integer(userId) or userId == 0 then return false, "invalid_user" end
    local key = "u_" .. tostring(userId)
    self.waiting[key] = (self.waiting[key] or 0) + 1
    if self.waiting[key] > 16 then
        self.waiting[key] -= 1
        return false, "queue_full"
    end
    local queue = self.queues[key]
    if not queue then queue = {}; self.queues[key] = queue end
    local ticket = {}
    table.insert(queue, ticket)
    while (self.busy[key] or queue[1] ~= ticket) and not self.closed do task.wait() end
    local position = table.find(queue, ticket)
    if position then table.remove(queue, position) end
    if #queue == 0 then self.queues[key] = nil end
    self.waiting[key] -= 1
    if self.waiting[key] == 0 then self.waiting[key] = nil end
    if self.closed then return false, "closed" end
    self.busy[key] = true
    local answer
    local ok, saved = pcall(function()
        return self.dataStore:UpdateAsync(key, function(old, keyInfo)
            if old ~= nil and not valid(old) then error("schema_invalid_no_overwrite") end
            local data = if old == nil then fresh() else copy(old)
            answer = transform(data)
            assert(answer ~= nil, "transform_result_required")
            assert(valid(data), "invalid_result")
            for _, field in ipairs({"receipts", "outbox", "inbox", "quests", "questEvents", "inventory"}) do
                assert(Store.Count(data[field]) <= self.maxEntries, "history_capacity_" .. field)
            end
            assert(Store.Count(data.retention.claims) <= self.maxEntries, "claim_capacity")
            assert(#HttpService:JSONEncode(data) <= self.maxBytes, "record_capacity")
            -- Preserve metadata/UserIds when updating an existing record.
            local userIds = if keyInfo then keyInfo:GetUserIds() else {userId}
            local metadata = if keyInfo then keyInfo:GetMetadata() else {}
            return data, userIds, metadata
        end)
    end)
    self.busy[key] = nil
    if not ok then return false, "update_failed_or_unknown" end
    -- An error can mean a write committed but its response was lost: retry the SAME operation ID.
    return true, answer, saved
end
function Store:Snapshot(userId)
    -- Fresh atomic observation; deliberately not a long-lived cached authoritative profile.
    return self:Update(userId, function() return true end)
end
function Store:Close()
    self.closed = true -- host waits for in-flight calls under its shutdown deadline
end
return Store
