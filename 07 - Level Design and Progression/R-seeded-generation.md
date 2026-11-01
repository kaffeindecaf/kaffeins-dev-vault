---
id: R-seeded-generation
type: reference
title: Seeded generation for reproducible debugging
status: reviewed
updated: 2026-11-01
tags: [level, procgen, testing]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "R-procgen-constraints", "R-puzzle-dependency-graph", "S-loot-containers"
---

# Seeded generation

If a bug depends on a random layout, you cannot debug it unless you can regenerate that exact layout.

## Rules

1. **One `Random.new(seed)` per system**, never `math.random` for content generation.
2. **Log the seed** with the round (and show it in a debug overlay).
3. **Seed from a stable value** — round number + server start time, not `os.clock()` per call.
4. **Derive sub-seeds deterministically** for independent systems (layout, loot, director) so adding a
   system does not change the others.

```lua
-- Untested
local function makeRng(baseSeed: number, system: string)
    local h = 0
    for i = 1, #system do h = (h * 31 + string.byte(system, i)) % 2 ^ 31 end
    return Random.new((baseSeed + h) % 2 ^ 31)
end

local layoutRng = makeRng(roundSeed, "layout")
local lootRng   = makeRng(roundSeed, "loot")
local directorRng = makeRng(roundSeed, "director")
```

Adding a fourth system later does not perturb the first three — that is the whole point of deriving instead
of consuming one shared stream.

## Debugging workflow

```text
Player: "the basement door spawned inside a wall on round 47"
You:    replay seed 47 in a Studio test, look at attempt 0..4, find the failing constraint
```

Without the seed, that report is a shrug.

## Testing

1. Same seed twice → identical layout hash.
2. Different seeds → different layouts.
3. 10,000 layouts → the validator rejects zero (or the rejection rate is documented and bounded).
4. A layout generated on the server matches the one the client renders (send the seed, not the layout).

