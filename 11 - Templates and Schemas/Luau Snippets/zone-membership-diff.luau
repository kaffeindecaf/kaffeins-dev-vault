-- Untested: compare complete server-owned membership snapshots, not spatial queries.
local function diff(previous, current)
	local entered, exited = {}, {}
	for member in pairs(current) do
		if not previous[member] then table.insert(entered, member) end
	end
	for member in pairs(previous) do
		if not current[member] then table.insert(exited, member) end
	end
	return entered, exited
end

return diff
