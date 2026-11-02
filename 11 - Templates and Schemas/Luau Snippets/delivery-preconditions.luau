-- Untested: server-side precondition helper, NOT a reward transaction or proximity check.
-- Caller derives all fields from trusted server state and serializes the final commit.
local function check(state)
	if type(state) ~= "table" or state.ProfileReady ~= true then return false, "unavailable" end
	if state.ObjectiveActive ~= true then return false, "inactive" end
	if state.AlreadyDelivered == true then return false, "already delivered" end
	if state.HasRequiredItem ~= true then return false, "item required" end
	if state.AtAuthorizedEndpoint ~= true or state.RequiredCheckpointsComplete ~= true then return false, "route incomplete" end
	return true
end
return check
