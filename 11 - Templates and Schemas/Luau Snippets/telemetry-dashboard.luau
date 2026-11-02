--!nocheck
-- Tested: Studio client synthetic preview; server admin authorization/transport untested.
local Dashboard = {}
function Dashboard.new(playerGui)
    local gui = Instance.new("ScreenGui")
    gui.Name, gui.ResetOnSpawn, gui.IgnoreGuiInset = "BackendTelemetry", false, false
    local text = Instance.new("TextLabel")
    text.Size = UDim2.fromScale(0.6, 0.6)
    text.Position = UDim2.fromScale(0.02, 0.05)
    text.BackgroundColor3, text.BackgroundTransparency = Color3.fromRGB(15, 18, 25), 0.1
    text.TextColor3, text.TextSize = Color3.new(1, 1, 1), 14
    text.TextXAlignment, text.TextYAlignment = Enum.TextXAlignment.Left, Enum.TextYAlignment.Top
    text.Font, text.TextWrapped = Enum.Font.Code, true
    text.Parent, gui.Parent = gui, playerGui
    local object = {}
    function object:Render(rows)
        local lines = {"Remote telemetry | estimated application bytes", "user / route / direction / Hz / bytes / flags"}
        for index, row in ipairs(rows) do
            if index > 20 then break end
            table.insert(lines, string.format("%s / %s / %s / %.1f / %d / %d",
                tostring(row.userId), row.route, row.direction, row.hz, row.estimatedBytes, row.flags))
        end
        text.Text = table.concat(lines, "\n")
    end
    function object:Destroy() gui:Destroy() end
    object:Render({})
    return object
end
return Dashboard
