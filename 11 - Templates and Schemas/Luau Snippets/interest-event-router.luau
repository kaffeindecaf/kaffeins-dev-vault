--!nocheck
-- Untested: event routing; module loaded in Studio. SERVER ONLY, optional effects.
local Players = game:GetService("Players")
return function(remote, origin, radius, ...)
    assert(radius > 0, "invalid_radius")
    local radius2 = radius * radius
    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root then
            local delta = root.Position - origin
            if delta:Dot(delta) <= radius2 then remote:FireClient(player, ...) end
        end
    end
end
