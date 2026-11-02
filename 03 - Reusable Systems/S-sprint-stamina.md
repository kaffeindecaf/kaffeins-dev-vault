---
id: S-sprint-stamina
type: system
title: Sprint and stamina with server reconciliation
status: reviewed
updated: 2026-11-01
tags: [systems, movement, security]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: [UserInputService, RunService]
dependencies: []
code_blocks: 2
related: "R-server-authority-replication", "R-mobile-safe-areas", "S-crouch-and-crawl"
---

# Sprint and stamina

Client-predicted for feel, server-authoritative for fairness. The server's only job is a ceiling and
a drain; the client interpolates so it feels instant.

## Server

```lua
-- Untested
local Sprint = {}
local stamina = {}   -- [player] = 0..1
local MAX_WALK, MAX_SPRINT = 16, 32

function Sprint.setSprinting(player, want)
    local cur = stamina[player] or 1
    if want and cur > 0.05 then
        player.Character.Humanoid.WalkSpeed = MAX_SPRINT
    else
        player.Character.Humanoid.WalkSpeed = MAX_WALK
        Sprint.setSprinting(player, false)
    end
end

-- single tick for all players
RunService.Heartbeat:Connect(function(dt)
    for player, value in stamina do
        local sprinting = player.Character and player.Character.Humanoid.WalkSpeed > MAX_WALK
        local nextValue = value + (sprinting and -dt / 8 or dt / 12)   -- 8s to empty, 12s to refill
        stamina[player] = math.clamp(nextValue, 0, 1)
        StaminaUpdate:FireClient(player, stamina[player])
    end
end)
```

## Client

```lua
-- Untested: input only; the server still decides.
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(i, processed)
    if processed then return end
    if i.KeyCode == Enum.KeyCode.LeftShift then SprintRequest:FireServer(true) end
end)
UIS.InputEnded:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.LeftShift then SprintRequest:FireServer(false) end
end)
```

Include a **touch** button that fires the same request — the majority of Roblox players are on a phone,
and a keyboard-only sprint is a design bug ([[R-mobile-safe-areas]]).

## Failure modes

- Client sets `WalkSpeed` directly → server overwrites, causing visible stutter. Only the server
  writes speed.
- Stamina drained on the client → infinite sprint exploit.
- Two systems writing `WalkSpeed` (sprint and a crouch script) → they fight; single writer per property.
- Dash combined with sprint → the anti-cheat sees 60+ studs/s and rubber-bands the player back
  ([[R-server-authority-replication]]); give dashes a server-stamped grace.

## Test cases

1. Hold sprint → speed 32, stamina drains, stops at 0.
2. Release → back to 16, stamina refills.
3. Sprint at 0 stamina → denied.
4. Respawn → stamina reset to config default, not 0.
5. Phone: touch button produces identical behaviour.

