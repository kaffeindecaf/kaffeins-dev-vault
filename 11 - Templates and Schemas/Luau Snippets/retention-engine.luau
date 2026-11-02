--!nocheck
-- Tested: Studio mock UTC streaks, checkpoints, tiers and event boundary checks.
local Retention = {}
Retention.__index = Retention
function Retention.new(accounts, rewards, grant)
    assert(#rewards.daily > 0, "daily_rewards_required")
    return setmetatable({accounts = accounts, rewards = rewards, grant = grant}, Retention)
end
function Retention:ClaimDaily(userId, utcNow)
    assert(self.accounts.Integer(utcNow), "server_utc_timestamp_required")
    local day = math.floor(utcNow / 86400)
    return self.accounts:Update(userId, function(data)
        local r = data.retention
        if day <= r.lastDay then return {status = "already_claimed_or_clock_backwards"} end
        local streak = if day == r.lastDay + 1 then r.streak + 1 else 1
        local index = (streak - 1) % #self.rewards.daily + 1
        self.grant(data, self.rewards.daily[index])
        r.lastDay, r.streak = day, streak
        return {status = "granted", streak = streak, day = day}
    end)
end
function Retention:CheckpointPlaytime(userId, sessionId, totalSeconds)
    -- server-generated GUID + floor(os.clock() - sessionStart), never a client time report
    assert(type(sessionId) == "string" and #sessionId > 0 and #sessionId <= 80, "invalid_session")
    assert(self.accounts.Integer(totalSeconds), "invalid_duration")
    local key = "session:" .. sessionId
    return self.accounts:Update(userId, function(data)
        local r = data.retention
        local previous = r.claims[key] or 0
        local delta = math.max(0, totalSeconds - previous)
        assert(self.accounts.Integer(r.playSeconds + delta), "time_overflow")
        r.playSeconds += delta
        r.claims[key] = math.max(previous, totalSeconds)
        return {status = "checkpointed", seconds = r.playSeconds}
    end)
end
function Retention:ClaimPlaytime(userId, tierId)
    local tier = self.rewards.playtime[tierId]
    if not tier then return false, "unknown_tier" end
    return self.accounts:Update(userId, function(data)
        local key = "play:" .. tierId
        if data.retention.claims[key] then return {status = "already_claimed"} end
        if data.retention.playSeconds < tier.seconds then return {status = "not_ready"} end
        self.grant(data, tier.reward)
        data.retention.claims[key] = true
        return {status = "granted"}
    end)
end
function Retention:ClaimEvent(userId, eventId, utcNow, eligible)
    -- eligible is a server-owned NON-YIELDING predicate of durable data.
    assert(self.accounts.Integer(utcNow) and type(eligible) == "function", "invalid_event_claim")
    local event = self.rewards.events[eventId]
    if not event then return false, "unknown_event" end
    return self.accounts:Update(userId, function(data)
        local key = "event:" .. eventId
        if data.retention.claims[key] then return {status = "already_claimed"} end
        if utcNow < event.starts or utcNow >= event.ends or not eligible(data) then
            return {status = "ineligible"}
        end
        self.grant(data, event.reward)
        data.retention.claims[key] = true
        return {status = "granted"}
    end)
end
return Retention
