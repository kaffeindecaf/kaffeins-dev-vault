---
id: R-server-authority-replication
type: reference
title: Server authority and the replication boundary
status: reviewed
updated: 2026-11-01
tags: [architecture, security, replication]
source_urls: [ "https://create.roblox.com/docs/projects/client-server" ]
confidence: medium
verification: reference_only
related: [ "R-remotes-and-validation", "R-script-types-and-placement" ]
---

# Server authority

The client is a rendering and input device that you do not control. Roblox replicates *state you
set on the server*; a client can set its own copy of almost anything and it will look right to that
one player.

## What only the server may decide

- money, XP, inventory contents, unlocks, cooldowns
- whether a player is hidden, caught, in-range, or has line of sight
- loot claim ownership, round state, respawns
- anything written to a DataStore

## The pattern

```lua
-- Untested: shape of a server-authoritative interaction.

-- ServerScriptService/InteractionServer (Script)
local Players = game:GetService("Players")
local Remotes = game.ReplicatedStorage.Remotes
local Interact = Remotes.Interact

local MAX_RANGE = 8

Interact.OnServerEvent:Connect(function(player, target)
    -- 1. type check: never trust the argument types
    if typeof(target) ~= "Instance" then return end
    if not target:IsA("BasePart") then return end
    if not target:HasTag("Interactable") then return end

    -- 2. authority check: is the claim physically possible?
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not (root and hum) or hum.Health <= 0 then return end
    if (root.Position - target.Position).Magnitude > MAX_RANGE then return end

    -- 3. rate limit: see R-request-rate-limiting
    -- 4. do the thing here, on the server, and replicate the result
    target:SetAttribute("Open", true)
end)
```

## Three failure modes to design against

| Failure | Symptom | Fix |
|---|---|---|
| Trusting a client value | exploits, impossible states | re-derive from server state |
| Trusting a client *position* | teleport-to-loot | distance-check on the server every time |
| Replicating authority | client writes the attribute first, server agrees later | server writes, client only renders |

## Client prediction vs authority

Player movement is client-simulated by Roblox itself. Everything you add on top (sprint speed, dash,
crouch) needs a server echo: the client predicts for feel, the server decides for truth. If the two
disagree, snap — never let the client's version persist.

```lua
-- Untested: server rejects an impossible speed claim
local SpeedGuard = {}
local lastPos, lastT = {}, {}
RunService.Heartbeat:Connect(function()
    local now = os.clock()
    for _, plr in Players:GetPlayers() do
        local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local prev, pt = lastPos[plr], lastT[plr] or now
        if prev then
            local dt = math.max(now - pt, 0.001)
            local speed = (root.Position - prev).Magnitude / dt
            if speed > 64 then            -- generous ceiling: sprint 32 + dash
                root.CFrame = CFrame.new(prev)   -- rubber-band
            end
        end
        lastPos[plr], lastT[plr] = root.Position, now
    end
end)
return SpeedGuard
```

## Audit question

For each player-visible change: *"if this client sent a different number, would anything bad happen?"*
If yes, the number is not validated yet. Checklist: [[G-server-authority-checklist]].
