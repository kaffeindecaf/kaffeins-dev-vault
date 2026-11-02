-- Untested: straight-segment projection for presentation; not proof of travel.
-- Caller supplies current position and route endpoints, and handles respawn.
local function progress(position, startPoint, endPoint)
	if typeof(position) ~= "Vector3" or typeof(startPoint) ~= "Vector3" or typeof(endPoint) ~= "Vector3" then return nil, "invalid vectors" end
	local segment = endPoint - startPoint
	local length = segment.Magnitude
	if length ~= length or length <= 0 or length == math.huge then return nil, "invalid route" end
	local projected = (position - startPoint):Dot(segment / length)
	if projected ~= projected or math.abs(projected) == math.huge then return nil, "invalid position" end
	local distance = math.clamp(projected, 0, length)
	return {Distance = distance, Total = length, Fraction = distance / length}
end
return progress
