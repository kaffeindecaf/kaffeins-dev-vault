---
id: R-ai-debug-overlay
type: reference
title: NPC debug overlay and logging that ships disabled
status: reviewed
updated: 2026-11-01
tags: [ai, debugging, tooling]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: []
code_blocks: 1
related: "R-logging-and-tracing", "R-stuck-detection", "R-npc-state-machine"
---

# AI debug overlay

You cannot tune what you cannot see. An overlay that draws state, path and perception, gated behind a
flag, saves hours.

## What to draw

| Element | Colour | Meaning |
|---|---|---|
| State label above head | white text | `BrainState` attribute |
| Sight cone | yellow, translucent | current facing + FOV |
| Sight ray hit | red line | blocked sightline endpoint |
| Last-known position | orange sphere | memory position |
| Path waypoints | blue spheres + lines | current `Path:GetWaypoints()` |
| Target | green line | current target connection |

## Implementation sketch

```lua
-- Untested: server-side debug parts, destroyed on toggle off.
local Debug = { enabled = false, parts = {} }

function Debug:drawLine(a, b, color)
    if not self.enabled then return end
    local p = Instance.new("Part")
    p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch = true, false, false, false
    p.Size = Vector3.new(0.1, 0.1, (b - a).Magnitude)
    p.CFrame = CFrame.lookAt((a + b) / 2, b)
    p.Color, p.Material = color, Enum.Material.Neon
    p.Parent = workspace
    table.insert(self.parts, p)
end

function Debug:clear()
    for _, p in self.parts do p:Destroy() end
    table.clear(self.parts)
end
```

Clear and redraw each 0.2 s tick; never leave parts accumulating.

## Gating

- `RunService:IsStudio()` **and** a flag in config. A debug overlay in a published game is both a
  performance cost and a leak of your AI logic.
- A Studio-only admin command (`!ai_debug`) is the pleasant way to toggle it
  ([[G-admin-command-pattern]]).

## Logging that complements the overlay

Log transitions with reason and inputs: `Chase -> Investigate (lost sight 4.1s, conf 0.6, pos 24,3,-96)`.
The overlay shows the present; the log shows how you got there.

See [[R-logging-and-tracing]] · [[R-stuck-detection]].

