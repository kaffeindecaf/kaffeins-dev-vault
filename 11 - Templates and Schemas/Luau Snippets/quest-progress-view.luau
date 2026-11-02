--!nocheck
-- Tested: Studio CLIENT synthetic rows plus row reuse/removal checks.
local View = {}
function View.new(parent)
    local frame = Instance.new("ScrollingFrame")
    frame.Size, frame.CanvasSize = UDim2.fromScale(1, 1), UDim2.fromOffset(0, 0)
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    local layout = Instance.new("UIListLayout")
    layout.Padding, layout.Parent = UDim.new(0, 6), frame
    local labels = {}
    local object = {}
    function object:Render(rows)
        local live = {}
        for index, row in ipairs(rows) do
            if index > 50 then break end
            live[row.id] = true
            local label = labels[row.id]
            if not label then
                label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -8, 0, 52)
                label.TextColor3 = Color3.new(1, 1, 1)
                label.TextSize, label.TextWrapped = 16, true
                local bar = Instance.new("Frame")
                bar.Name, bar.AnchorPoint, bar.Position = "Progress", Vector2.new(0, 1), UDim2.fromScale(0, 1)
                bar.BackgroundColor3, bar.BorderSizePixel = Color3.fromRGB(70, 180, 140), 0
                bar.Parent, label.Parent = label, frame
                labels[row.id] = label
            end
            label.LayoutOrder = index
            label.Text = string.format("%s  %d/%d%s", row.title or row.id, row.progress, row.target,
                if row.claimed then "  Claimed" else "")
            label.Progress.Size = UDim2.new(math.clamp(row.progress / math.max(1, row.target), 0, 1), 0, 0, 5)
        end
        for id, label in pairs(labels) do
            if not live[id] then label:Destroy(); labels[id] = nil end
        end
    end
    function object:Destroy() frame:Destroy(); table.clear(labels) end
    return object
end
return View
