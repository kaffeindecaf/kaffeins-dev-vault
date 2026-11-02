-- Untested: pure server-side arithmetic; caller validates authorization and commits both values.
local function transfer(carried, stored, capacity)
	local function valid(value)
		return type(value) == "number" and value == value and value >= 0 and value < math.huge
	end
	if not valid(carried) or not valid(stored) or not valid(capacity) then return nil, "invalid" end
	if stored > capacity then return nil, "invalid capacity" end
	local moved = math.min(carried, capacity - stored)
	return {Moved = moved, Carried = carried - moved, Stored = stored + moved}
end
return transfer
