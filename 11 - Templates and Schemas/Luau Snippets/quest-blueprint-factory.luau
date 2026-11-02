--!nocheck
-- Tested: Studio trusted-event mocks and atomic reward claims; live event sourcing untested.
local Factory = {}
Factory.__index = Factory
function Factory.new(accounts, definitions, grant)
    local byEvent = {}
    for id, definition in pairs(definitions) do
        assert(type(id) == "string" and #id <= 80 and definition.version >= 1
            and accounts.Integer(definition.target) and definition.target > 0, "invalid_blueprint")
        byEvent[definition.event] = byEvent[definition.event] or {}
        table.insert(byEvent[definition.event], id)
    end
    return setmetatable({accounts = accounts, definitions = definitions, grant = grant, byEvent = byEvent}, Factory)
end
local function stateFor(data, id, definition)
    local key = id .. ":v" .. tostring(definition.version)
    local state = data.quests[key]
    if not state then
        state = {progress = 0, claimed = false}
        data.quests[key] = state
    end
    return state
end
function Factory:Emit(userId, event, eventId, amount)
    -- Server-generated operation ID; retry SAME id after an ambiguous write result.
    assert(type(eventId) == "string" and #eventId > 0 and #eventId <= 80, "invalid_event_id")
    assert(self.accounts.Integer(amount) and amount > 0, "invalid_amount")
    local ids = self.byEvent[event]
    if not ids then return false, "unknown_event" end
    return self.accounts:Update(userId, function(data)
        local rows = {}
        local token = event .. ":" .. eventId
        local previous = data.questEvents[token]
        if previous then assert(previous == amount, "event_id_conflict") end
        for _, id in ipairs(ids) do
            local definition = self.definitions[id]
            local state = stateFor(data, id, definition)
            if not previous then
                if not state.claimed then
                    state.progress = math.min(definition.target, state.progress + amount)
                end
            end
            table.insert(rows, {id = id, progress = state.progress, target = definition.target,
                claimed = state.claimed, title = definition.title})
        end
        data.questEvents[token] = amount
        return rows
    end)
end
function Factory:Claim(userId, id)
    local definition = self.definitions[id]
    if not definition then return false, "unknown_quest" end
    return self.accounts:Update(userId, function(data)
        local state = stateFor(data, id, definition)
        if state.claimed then return {status = "already_claimed"} end
        if state.progress < definition.target then return {status = "not_ready"} end
        self.grant(data, definition.reward)
        state.claimed = true
        return {status = "granted"}
    end)
end
function Factory:Snapshot(userId)
    return self.accounts:Update(userId, function(data)
        local rows = {}
        for id, definition in pairs(self.definitions) do
            local state = stateFor(data, id, definition)
            table.insert(rows, {id = id, progress = state.progress, target = definition.target,
                claimed = state.claimed, title = definition.title})
        end
        return rows
    end)
end
return Factory
