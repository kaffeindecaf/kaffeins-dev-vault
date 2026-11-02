--!nocheck
-- Tested: Studio per-room phase/finish/cleanup checks. Host calls Step at a bounded cadence.
local FSM = {}
FSM.__index = FSM
local allowed = {
    WaitingForPlayers = {Intermission = true},
    Intermission = {WaitingForPlayers = true, MapLoading = true},
    MapLoading = {WaitingForPlayers = true, ActiveRound = true},
    ActiveRound = {MatchOver = true},
    MatchOver = {WaitingForPlayers = true},
}
function FSM.new(config, countPlayers, loadMap)
    assert(config.minPlayers >= 1 and config.intermission >= 0 and config.loadTimeout > 0
        and config.roundDuration > 0 and config.resultsDuration >= 0, "invalid_config")
    local event = Instance.new("BindableEvent")
    return setmetatable({
        config = table.clone(config), countPlayers = countPlayers, loadMap = loadMap,
        clock = config.clock or os.clock,
        state = "WaitingForPlayers", epoch = 0, deadline = math.huge, changed = event,
        Changed = event.Event, destroyed = false, mapCleanup = nil,
    }, FSM)
end
function FSM:_cleanup()
    local fn = self.mapCleanup
    self.mapCleanup = nil
    if fn then local ok = pcall(fn); if not ok then warn("map cleanup failed") end end
end
function FSM:_set(nextState, now, duration, reason)
    assert(allowed[self.state][nextState], "illegal_transition")
    local previous = self.state
    self.state, self.deadline = nextState, now + duration
    self.epoch += 1
    self.changed:Fire(nextState, previous, self.epoch, reason)
end
function FSM:Snapshot()
    return {state = self.state, epoch = self.epoch, deadline = self.deadline}
end
function FSM:Finish(now, reason)
    if self.destroyed or self.state ~= "ActiveRound" then return false end
    self:_set("MatchOver", now, self.config.resultsDuration, reason or "finished")
    return true
end
function FSM:Step(now)
    if self.destroyed then return end
    local enough = self.countPlayers() >= self.config.minPlayers
    if self.state == "WaitingForPlayers" and enough then
        self:_set("Intermission", now, self.config.intermission)
    elseif self.state == "Intermission" then
        if not enough then self:_set("WaitingForPlayers", now, math.huge, "players_left")
        elseif now >= self.deadline then
            self:_set("MapLoading", now, self.config.loadTimeout)
            local token = self.epoch
            task.spawn(function()
                -- Loader returns a non-yielding idempotent cleanup function.
                -- Loader must clean partial work itself if it errors.
                local ok, cleanup = pcall(self.loadMap, token)
                if self.destroyed or self.state ~= "MapLoading" or self.epoch ~= token then
                    if ok and type(cleanup) == "function" then pcall(cleanup) end
                    return
                end
                if not ok or type(cleanup) ~= "function" then
                    self:_set("WaitingForPlayers", self.clock(), math.huge, "load_failed")
                    return
                end
                self.mapCleanup = cleanup
                if self.countPlayers() < self.config.minPlayers then
                    self:_cleanup()
                    self:_set("WaitingForPlayers", self.clock(), math.huge, "players_left")
                else
                    self:_set("ActiveRound", self.clock(), self.config.roundDuration)
                end
            end)
        end
    elseif self.state == "MapLoading" then
        if not enough or now >= self.deadline then
            self:_set("WaitingForPlayers", now, math.huge, "load_cancelled")
            -- Loader token now stale; returned map will be cleaned instead of activated.
        end
    elseif self.state == "ActiveRound" and (not enough or now >= self.deadline) then
        self:Finish(now, if enough then "time" else "players_left")
    elseif self.state == "MatchOver" and now >= self.deadline then
        self:_cleanup()
        self:_set("WaitingForPlayers", now, math.huge)
    end
end
function FSM:Destroy()
    if self.destroyed then return end
    self.destroyed = true; self.epoch += 1; self:_cleanup(); self.changed:Destroy()
end
return FSM
