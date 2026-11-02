--!nocheck
-- Tested: Studio tagged cosmetic hysteresis; engine replication and server simulation stay separate.
local CollectionService = game:GetService("CollectionService")
local Culler = {}
Culler.__index = Culler
function Culler.new(tag, enterDistance, exitDistance, toggle, cap)
    assert(enterDistance > 0 and exitDistance > enterDistance, "hysteresis_required")
    local self = setmetatable({items = {}, list = {}, cursor = 1, toggle = toggle,
        enter2 = enterDistance ^ 2, exit2 = exitDistance ^ 2, cap = cap or 1000}, Culler)
    local function add(model)
        if self.items[model] or not model:IsA("Model") then return end
        if #self.list >= self.cap then warn("culler capacity"); return end
        local row = {model = model, active = false}
        self.items[model] = row; table.insert(self.list, row)
        self:_toggle(row, false)
    end
    local function remove(model)
        local row = self.items[model]
        if not row then return end
        self:_toggle(row, false)
        self.items[model] = nil
        local index = table.find(self.list, row)
        if index then table.remove(self.list, index) end
    end
    self.connections = {
        CollectionService:GetInstanceAddedSignal(tag):Connect(add),
        CollectionService:GetInstanceRemovedSignal(tag):Connect(remove),
    }
    for _, model in ipairs(CollectionService:GetTagged(tag)) do add(model) end
    return self
end
function Culler:_toggle(row, enabled)
    local ok = pcall(self.toggle, row.model, enabled)
    if ok then row.active = enabled else warn("cosmetic toggle failed") end
end
function Culler:Step(position, budget)
    if #self.list == 0 then return end
    for _ = 1, math.min(budget or 25, #self.list) do
        if self.cursor > #self.list then self.cursor = 1 end
        local row = self.list[self.cursor]
        self.cursor += 1
        local delta = row.model:GetPivot().Position - position
        local distance2 = delta:Dot(delta)
        local enabled = if row.active then distance2 <= self.exit2 else distance2 <= self.enter2
        if enabled ~= row.active then self:_toggle(row, enabled) end
    end
end
function Culler:Destroy()
    for _, c in ipairs(self.connections) do c:Disconnect() end
    for _, row in ipairs(self.list) do self:_toggle(row, false) end
    table.clear(self.items); table.clear(self.list)
end
return Culler
