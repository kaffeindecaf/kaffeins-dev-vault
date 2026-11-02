-- Untested: presentation layout only; caller validates collision and model dimensions.
local function offset(slot, capacity, columns, spacing)
	if type(slot) ~= "number" or type(capacity) ~= "number" or type(columns) ~= "number" or type(spacing) ~= "number" then return nil end
	if slot ~= slot or capacity ~= capacity or columns ~= columns or spacing ~= spacing or slot == math.huge or capacity == math.huge or columns == math.huge or spacing == math.huge then return nil end
	if slot % 1 ~= 0 or capacity % 1 ~= 0 or columns % 1 ~= 0 or slot < 1 or slot > capacity or columns < 1 or spacing < 0 then return nil end
	local rows = math.ceil(capacity / columns)
	local column = (slot - 1) % columns
	local row = math.floor((slot - 1) / columns)
	return Vector3.new((column - (columns - 1) / 2) * spacing, 0, (row - (rows - 1) / 2) * spacing)
end
return offset
