-- Untested: server-only UpdateAsync transform adapter; not a profile system.
-- Use only within an established session-ownership and save pipeline; this
-- token comparison alone does not check lease expiration or renew a lease.
-- transform must be pure, non-yielding and tolerate repeat calls. No external grants here.
local function updateOwnedProfile(store, key, token, buildNext)
	local ok, result = pcall(function()
		return store:UpdateAsync(key, function(old)
			if type(old) ~= "table" or type(old._Session) ~= "table" then return nil end
			if old._Session.Token ~= token then return nil end
			-- buildNext must return a fresh serializable profile and preserve valid metadata.
			return buildNext(old)
		end)
	end)
	if not ok then return false, "store_error", result end
	if result == nil then return false, "cancelled_or_not_owner" end
	return true, "updated", result
end
return updateOwnedProfile
