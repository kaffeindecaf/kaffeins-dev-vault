---
id: H-profiling-budgets
type: principle
title: Profiling budgets for sources, particles and post-processing
status: reviewed
updated: 2026-11-01
tags: [horror, performance, vfx]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "G-profiling-workflow", "H-flicker-safety", "R-streamingenabled"
---

# Horror performance budgets

Atmosphere is expensive. These are starting budgets to measure against, not guarantees — every number
here must be replaced by a real measurement on the target device.

| Effect | Cost | Cheap alternative |
|---|---|---|
| 10+ `Sound` sources playing | low CPU, some mixer cost | group them, one bed per layer |
| 100+ `PointLight`s | high per-light shadow cost | 2–4 shadowed lights, the rest unshadowed |
| `Future` lighting | very high on mobile | `ShadowMap` with fewer casters, or `Voxel` on low end |
| Particles × 20 emitters | geometry + overdraw | fewer, larger, billboarded |
| `BlurEffect`/`DepthOfField` | full-screen pass | one at a time, never stacked |
| `ColorCorrection` | cheap | use freely |
| `Atmosphere` + fog | cheap | use freely |
| Glass / transparent stacked panes | overdraw | keep ≤ 3 layers visible |

## Budget approach

1. Pick a target device (the weakest phone you support).
2. Measure the *worst* moment: threat state, full ambience, NPCs pathing.
3. Set a frame-time ceiling and enforce it by gating effects: if the moving average exceeds the
   ceiling, disable a layer.

```lua
-- Untested: adaptive quality floor
local RunService = game:GetService("RunService")
local acc, frames = 0, 0
RunService.Heartbeat:Connect(function(dt)
    acc += dt; frames += 1
    if frames >= 120 then
        local avg = acc / frames
        if avg > 1 / 45 then
            workspace.ShadowQuality = "None"    -- example: drop a layer, log it
        end
        acc, frames = 0, 0
    end
end)
```

Logging the drop matters more than the drop: a silently degraded game is a game that looks broken on
one device for a year.

## Where horror hides its cost

- Shadow-casting lights in a lit corridor: many small lights, each a shadow pass.
- Transparent glass panes: overdraw, and reflections double it.
- Particles for fog: fill rate, not triangle count.
- The `Future` lighting bright-dark contrast: expensive on phones.

See [[G-profiling-workflow]] for how to capture the numbers.

