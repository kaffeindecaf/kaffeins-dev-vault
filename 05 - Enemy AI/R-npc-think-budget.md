---
id: R-npc-think-budget
type: reference
title: Think budgets and staggered ticks
status: reviewed
updated: 2026-11-01
tags: [ai, performance, scheduling]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: []
code_blocks: 1
related: "R-npc-state-machine", "R-pathfinding-cost", "R-runservice-update-loops", "R-ai-debug-overlay"
---

# Think budgets

Perception + pathfinding + state transitions are the AI cost. The fix is not a faster NPC, it is fewer
NPC thoughts per second spread evenly.

## The scheduler

```lua
-- Untested: one loop drives every NPC, round-robin, at a fixed per-NPC interval.
local RunService = game:GetService("RunService")
local NPCs = {}          -- array of brains
local SLICE = 0.2        -- each NPC thinks every 0.2 s
local acc = 0

RunService.Heartbeat:Connect(function(dt)
    acc += dt
    if acc < SLICE / math.max(1, #NPCs) then return end
    acc = 0
    local i = self.cursor % math.max(1, #NPCs) + 1
    self.cursor = i
    local brain = NPCs[i]
    if brain and brain.alive then brain:think(os.clock()) end
end)
```

With 10 NPCs and `SLICE = 0.2`, each NPC thinks every 0.2 s and the per-frame cost is one brain. Compare
with 10 independent `task.wait(0.2)` loops, which pile up on the same frame after a hitch.

## Budget table (starting points, measure them)

| Work | Per NPC | 10 NPCs |
|---|---|---|
| cone/distance check | ~1 µs | negligible |
| 2 rays | ~10–20 µs | 0.2 ms / tick |
| path recompute | 0.1–1 ms | must be rate-limited |
| movement update | negligible | — |

Path recomputation dominates. Cap it globally: at most N path computations per second server-wide, with
a queue. An NPC that cannot get a slot keeps moving on its last path.

## Rules

- Never `RenderStepped` for AI. AI is not visual.
- Never recompute a path on a timer *and* on `Blocked` *and* on target movement without a cooldown.
- Pause NPC thinking when no player is within a radius (the classic "far NPCs freeze, near ones think").
- Profile with real player counts; a 20-NPC test with no players is meaningless ([[G-profiling-workflow]]).

## Measure

`os.clock()` around `think()` accumulated per second. If your AI exceeds ~1–2 ms/s per NPC, something is
doing a ray or a path it does not need.

