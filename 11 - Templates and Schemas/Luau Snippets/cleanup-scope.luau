-- Untested: explicit lifetime owner. Register non-yielding cleanup callbacks.
local Scope = {}
Scope.__index = Scope

function Scope.new()
	return setmetatable({ closed = false, tasks = {} }, Scope)
end

function Scope:Add(cleanup)
	assert(type(cleanup) == "function", "cleanup must be a function")
	if self.closed then
		local ok, err = pcall(cleanup)
		if not ok then warn("Late cleanup failed:", err) end
		return
	end
	table.insert(self.tasks, cleanup)
end

function Scope:Destroy()
	if self.closed then return end
	self.closed = true
	for i = #self.tasks, 1, -1 do
		local cleanup = self.tasks[i]
		self.tasks[i] = nil
		local ok, err = pcall(cleanup)
		if not ok then warn("Cleanup failed:", err) end
	end
end

return Scope
