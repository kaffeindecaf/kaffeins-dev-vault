--!nocheck
-- Tested: Studio mock integrity checks; integrate with an EXISTING session save owner.
local Guard = {}
Guard.__index = Guard

function Guard.new(checks, alert)
    return setmetatable({checks = checks, alert = alert or warn, locked = {}, shadows = {}}, Guard)
end
local function clone(value, seen)
    if type(value) ~= "table" then return value end
    seen = seen or {}
    assert(not seen[value], "cyclic_profile")
    seen[value] = true
    local result = {}
    for k, v in pairs(value) do result[k] = clone(v, seen) end
    seen[value] = nil
    return result
end
local function finite(value)
    return type(value) == "number" and value == value and math.abs(value) < math.huge
end
function Guard.DefaultChecks(data)
    if type(data) ~= "table" then return false, "profile_not_table" end
    if type(data.Inventory) ~= "table" then return false, "inventory_missing" end
    if not finite(data.Coins) or data.Coins < 0 then return false, "coins_invalid" end
    return true
end
function Guard:Lock(sessionId, reason)
    if self.locked[sessionId] then return end
    self.locked[sessionId] = tostring(reason)
    -- Redacted alert only. Host may post to a configured server-only relay/webhook.
    task.spawn(function()
        local ok = pcall(self.alert, {kind = "data_integrity_lock", reason = tostring(reason)})
        if not ok then warn("Data Vault alert failed") end
    end)
end
function Guard:CanMutate(sessionId)
    return self.locked[sessionId] == nil
end
function Guard:Validate(sessionId, data)
    if self.locked[sessionId] then return false, self.locked[sessionId] end
    local ok, accepted, reason = pcall(self.checks, data, self.shadows[sessionId])
    if not ok or not accepted then
        self:Lock(sessionId, if ok then reason or "validation_rejected" else "validator_error")
        return false, self.locked[sessionId]
    end
    return true
end
function Guard:BeforeSave(sessionId, data)
    if not self:Validate(sessionId, data) then return nil, "session_locked" end
    local ok, snapshot = pcall(clone, data)
    if not ok then self:Lock(sessionId, "snapshot_failed"); return nil, "session_locked" end
    return snapshot -- ONLY pass this detached snapshot to your serialized save pipeline
end
function Guard:Saved(sessionId, snapshot)
    -- Call only after the save owner confirms a durable save of THIS snapshot.
    if not self.locked[sessionId] then self.shadows[sessionId] = clone(snapshot) end
end
function Guard:Forget(sessionId)
    self.shadows[sessionId], self.locked[sessionId] = nil, nil
end
return Guard
