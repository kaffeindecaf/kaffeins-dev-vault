-- Untested: pure planning only. Caller serializes and durably commits jobs.
-- All inputs are nonnegative integer resource/slot counts.
local function plan(input, batchSize, outputCount, outputCapacity)
	local function valid(value)
		return type(value) == "number" and value == value and value >= 0 and value < math.huge and value % 1 == 0
	end
	if not valid(input) or not valid(batchSize) or not valid(outputCount) or not valid(outputCapacity) then return nil, "invalid" end
	if batchSize == 0 or outputCount > outputCapacity then return nil, "invalid capacity" end
	if outputCount >= outputCapacity then return {State = "output_full"} end
	if input < batchSize then return {State = "waiting_for_input"} end
	return {State = "ready", InputToReserve = batchSize, OutputSlotsToReserve = 1}
end
return plan
