-- Untested: server-side, per-key token bucket. Host supplies a monotonic clock.
local Bucket = {}
Bucket.__index = Bucket

local function finite(n)
	return type(n) == "number" and n == n and n > -math.huge and n < math.huge
end

function Bucket.new(capacity, refillPerSecond)
	assert(finite(capacity) and capacity >= 1, "capacity must be finite and at least one")
	assert(finite(refillPerSecond) and refillPerSecond > 0, "refill rate must be positive and finite")
	return setmetatable({ capacity = capacity, rate = refillPerSecond, entries = {} }, Bucket)
end

-- Call without yielding between checking and performing the guarded action.
function Bucket:Allow(key, now)
	assert(key ~= nil and finite(now), "key and finite time required")
	local entry = self.entries[key]
	if not entry then
		entry = { tokens = self.capacity, last = now }
		self.entries[key] = entry
	else
		local elapsed = math.max(0, now - entry.last)
		entry.tokens = math.min(self.capacity, entry.tokens + elapsed * self.rate)
		entry.last = math.max(entry.last, now)
	end
	if entry.tokens < 1 then return false end
	entry.tokens -= 1
	return true
end

function Bucket:Forget(key)
	self.entries[key] = nil
end

return Bucket
