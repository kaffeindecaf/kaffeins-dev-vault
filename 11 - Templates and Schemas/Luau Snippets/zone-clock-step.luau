-- Untested: server-owned clock math only. Host samples zone state and sends snapshots.
-- All timestamps must share one monotonic clock. Handle transitions as they occur.
local function step(state, now, paused)
	assert(type(now) == "number" and now == now, "valid timestamp required")
	local delta = math.max(0, now - state.LastTime)
	-- The previous state applies to the elapsed interval.
	if not state.Paused then state.Remaining = math.max(0, state.Remaining - delta) end
	state.LastTime, state.Paused = now, paused == true
	return state.Remaining, state.Remaining <= 0
end
return step
