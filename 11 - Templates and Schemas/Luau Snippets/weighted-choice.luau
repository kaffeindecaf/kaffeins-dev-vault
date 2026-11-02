-- Untested: server-side selection helper, not a reward or purchase transaction.
-- Entries use stable Key and nonnegative finite Weight. Host controls Random and data.
local function choose(entries, random)
	local total = 0
	for _, entry in ipairs(entries) do
		local w = entry.Weight
		if type(w) ~= "number" or w ~= w or w < 0 or w == math.huge then return nil, "invalid weight" end
		total += w
	end
	if total <= 0 or total == math.huge then return nil, "invalid total" end
	local roll = random:NextNumber(0, total)
	local cumulative, last = 0, nil
	for _, entry in ipairs(entries) do
		if entry.Weight > 0 then
			last = entry
			cumulative += entry.Weight
			if roll < cumulative then return entry end
		end
	end
	return last -- floating-point endpoint
end
return choose
