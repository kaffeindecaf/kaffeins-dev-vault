-- Untested: server-side precondition helper, not a transaction or access guard.
-- Host owns catalog, current level, balance, proximity checks and durable commit.
local function check(catalog, currentLevel, balance, requestedLevel)
	if type(requestedLevel) ~= "number" or requestedLevel ~= requestedLevel or requestedLevel == math.huge or requestedLevel == -math.huge or requestedLevel % 1 ~= 0 then return false, "invalid" end
	if type(currentLevel) ~= "number" or type(balance) ~= "number" or balance ~= balance then return false, "unavailable" end
	local entry = catalog[requestedLevel]
	if not entry or type(entry.Cost) ~= "number" or entry.Cost ~= entry.Cost or entry.Cost < 0 or entry.Cost == math.huge then return false, "invalid" end
	if requestedLevel <= currentLevel then return false, "owned" end
	if requestedLevel ~= currentLevel + 1 then return false, "order" end
	if balance < entry.Cost then return false, "insufficient" end
	return true, entry
end
return check
