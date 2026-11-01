---
id: R-npc-memory-last-known
type: reference
title: Last-known-position memory with decay
status: reviewed
updated: 2026-11-01
tags: [ai, perception, memory]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: []
code_blocks: 1
related: "R-npc-state-machine", "R-npc-perception-model", "R-npc-think-budget"
---

# Memory

An NPC that instantly forgets is dumb; one that never forgets is unfair. Memory is a decaying belief with
a confidence, not a boolean.

## Model

```lua
-- Untested
local Memory = {}
Memory.__index = Memory

function Memory.new()
    return setmetatable({ pos = nil, at = 0, confidence = 0, source = "none" }, Memory)
end

function Memory:update(pos, now, source, strength)
    self.pos, self.at, self.source = pos, now, source
    self.confidence = math.clamp((self.confidence or 0) + strength, 0, 1)
end

function Memory:decay(dt)
    self.confidence = math.max(0, self.confidence - dt / 8)   -- forget in ~8 s
    if self.confidence <= 0 then self.pos = nil; self.source = "none" end
end

function Memory:position() return self.pos end
```

## How confidence is set

| Event | Strength |
|---|---|
| Direct sight (close) | +0.6 per 0.2 s tick (saturates fast) |
| Direct sight (far) | +0.25 |
| Heard a noise | +0.3 |
| Saw a door open | +0.2 |
| Lost sight | no add, decay applies |

## How it is used

- `Investigate` walks to `memory.pos`.
- `Search` samples points around `memory.pos` at radius ~8.
- If confidence < 0.2 when Investigate starts, skip straight back to Patrol (avoids long, pointless walks).

## Anti-patterns

- Storing only a position with no timestamp → the NPC investigates something 2 minutes stale.
- Never decaying → the NPC camps forever.
- Overwriting memory from a weak source (a distant footstep) while a strong one is fresh → the NPC walks
  away from a player it can see.

## Test

1. Target visible 3 s then hidden → Investigate reaches the last position, Search for ~6 s, then Patrol.
2. Target moves 30 studs while hidden → the NPC does not know the new spot.
3. New weak noise during a chase → memory position unchanged.

