---
id: R-runservice-update-loops
type: reference
title: RunService update frequencies — choose the cheapest loop that works
status: reviewed
updated: 2026-11-01
tags: [performance, loops, runservice]
source_urls: [ "https://create.roblox.com/docs/reference/engine/classes/RunService" ]
confidence: medium
verification: reference_only
related: [ "R-npc-think-budget", "R-janitor-cleanup" ]
---

# Update loops

| Signal | Where | Rate | Use for |
|---|---|---|---|
| `RenderStepped` | client only | per frame, **before** render | camera, input-driven visuals |
| `BindToRenderStep(name, priority, fn)` | client only | per frame, ordered | competing camera/visual writers |
| `PreSimulation` (`Stepped`) | both | per physics step | physics-adjacent work |
| `PostSimulation` (`Heartbeat`) | both | per physics step | sampling movement, AI ticks |
| `PreRender` (`RenderStepped` on client) | client | per frame | visual smoothing that must not lag |
| `task.wait(n)` loop | both | ≈ n seconds | timers, slow polling |

Two costs are easy to forget: **number of loops** and **work per iteration**. Ten `Heartbeat`
connections each doing 30 NPC raycasts is 300 raycasts a frame; one loop doing a quarter of them per
frame is the same feature at a quarter of the cost.

## Stagger the work, don't slow the input

```lua
-- Untested: round-robin tick over N items at 5 Hz total.
local RunService = game:GetService("RunService")
local items = {}          -- list of objects to think about
local cursor = 0
local SLICE = 0.05        -- seconds between ticks
local PER_TICK = 4        -- how many items per tick

local function tick()
    for _ = 1, math.min(PER_TICK, #items) do
        cursor = (cursor % #items) + 1
        local item = items[cursor]
        -- cheap work here
    end
end

local acc = 0
RunService.Heartbeat:Connect(function(dt)
    acc += dt
    if acc < SLICE then return end
    acc = 0
    tick()
end)
```

That gives every item ~5 Hz uniformity at `PER_TICK * 20` items with a fixed per-frame cost. See
[[R-npc-think-budget]] for the NPC-specific version and [[G-profiling-workflow]] for how to prove it
helped.

## Rules

- Anything that is not visual does **not** belong in `RenderStepped`.
- Never `while true do ... task.wait() end` for per-frame work; `task.wait()` without an argument is
  one frame, and the loop is then unkillable without a flag.
- Every connection is a potential leak: keep them in a janitor and clean on character removal
  ([[R-janitor-cleanup]]).
- `Heartbeat` `dt` is not a constant. Use it, don't assume 1/60.
