---
id: H-cooldowns-and-rarity
type: principle
title: Cooldowns, rarity and the cost of repeating a scare
status: reviewed
updated: 2026-11-01
tags: [horror, pacing, economy]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "H-adaptive-director", "H-tension-hierarchy", "H-environmental-events-catalog"
---

# Cooldowns and rarity

A scare is a resource. Spend it and it is gone for a while — that is what makes the *next* one land.

## Three clocks

| Clock | Typical | Controls |
|---|---|---|
| Global threat cooldown | 60–120 s | minimum gap between full threat states |
| Per-beat cooldown | 45–180 s (by cost) | the same cue cannot repeat |
| Beat budget window | rolling 5 min | caps total beats (e.g. 6 per 5 min) |

Without the third clock you get six *different* scares in a minute, which is the same failure as six of
the same one.

## Rarity tiers

| Tier | Frequency | Example |
|---|---|---|
| Common | every 30–60 s | distant thud, pipe knock, wind shift |
| Uncommon | 2–4 min | a door creaks open somewhere, a light dips |
| Rare | once per round | the figure at the end of the corridor |
| Unique | once per playthrough | the room that is different after you come back |

The Rare and Unique beats are the ones players talk about. Protect them: never let a bug (or a debug
command) fire them early, and never reuse them as filler.

## Cost model

Give each beat a cost 1–3 and derive the budget from progress:

```lua
-- Untested
local function intensityBudget(progress, cap)
    local base = 1 + math.floor(progress * 2)     -- 1 early, 3 late
    return math.min(3, math.min(base, cap))
end
```

## Test it

Log `(time, beatId, cost)` for a session and check the histogram: if one id is >20% of all beats, its
cooldown is too short, or the pool is too small.

