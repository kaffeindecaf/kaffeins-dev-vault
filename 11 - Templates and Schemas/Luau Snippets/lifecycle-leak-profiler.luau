--!nocheck
-- Tested: Studio suspect timing; weak references do not inspect GC retaining paths.
local Profiler = {}
Profiler.__index = Profiler
function Profiler.new(grace, maxRecords)
    return setmetatable({
        grace = grace or 60, cap = maxRecords or 2000, nextId = 0,
        weak = setmetatable({}, {__mode = "v"}), records = {}, ended = {},
    }, Profiler)
end
function Profiler:Track(scopeId, object, label)
    assert(type(object) == "table", "track a component table, not an engine Instance")
    local count = 0
    for _ in pairs(self.records) do count += 1 end
    if count >= self.cap then return nil, "profiler_capacity" end
    self.nextId += 1
    local id = self.nextId
    self.weak[id] = object
    self.records[id] = {scope = scopeId, label = tostring(label), trace = debug.traceback("", 2)}
    return id
end
function Profiler:EndScope(scopeId, now)
    if not self.ended[scopeId] then self.ended[scopeId] = now end
end
function Profiler:Poll(now, report)
    for id, record in pairs(self.records) do
        local ended = self.ended[record.scope]
        if self.weak[id] == nil then
            self.records[id] = nil
        elseif ended and now - ended >= self.grace and not record.reported then
            record.reported = true
            -- No live object passed to logger (which could itself retain it).
            report({label = record.label, trace = record.trace, age = now - ended})
        end
    end
    local active = {}
    for _, record in pairs(self.records) do active[record.scope] = true end
    for scope in pairs(self.ended) do
        if not active[scope] then self.ended[scope] = nil end
    end
end
function Profiler:Forget(id)
    self.weak[id], self.records[id] = nil, nil
end
function Profiler:Destroy()
    table.clear(self.records); table.clear(self.weak); table.clear(self.ended)
end
return Profiler
