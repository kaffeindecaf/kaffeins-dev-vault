---
id: H-director-api
type: principle
title: Horror director API contract and module sketch
status: reviewed
updated: 2026-11-01
tags: [horror, spec, api]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "H-adaptive-director", "H-cooldowns-and-rarity", "S-config-module"
---

# Horror director API

The contract for [[H-adaptive-director]], written so it can be implemented and tested independently of
the content it chooses.

```lua
-- Untested: sketch. Shape is the contract; internals are yours.
local Director = {}
Director.__index = Director

--- @param config table { cooldown, cooldownPerBeat, seed, maxIntensity }
function Director.new(config) end

--- Advance the system. Call on a slow tick (1 Hz), not per frame.
--- @param now number server clock seconds
function Director:update(now) end

--- Report facts the director reacts to. Cheap, idempotent.
function Director:notifyPlayerStress(player, value) end   -- 0..1
function Director:notifySafeRoom(player, inside) end
function Director:notifyThreatStart(now) end
function Director:notifyThreatEnd(now) end

--- Change the intensity cap (from player settings). Takes the minimum across players.
function Director:setAccessibilityCap(cap) end            -- 0..3

--- Read-only view for a debug overlay.
function Director:getState() end                          -- { state, budget, lastBeat, cooldownRemaining }

--- Deterministic replay for tests.
function Director:setSeed(seed) end
```

## Events out (a single bindable, not many remotes)

```lua
-- Untested
Director.Beat = Instance.new("BindableEvent")
-- Beat:Fire({ id = "distant_steps", cost = 1, kind = "ambientEvent", payload = { position = pos } })
```

Consumers subscribe: the ambience mixer, the lighting controller, the NPC pressure hint, the music
state machine. The director knows none of them — that is what makes it testable with a fake clock.

## Invariants worth asserting in code

| Invariant | Assert |
|---|---|
| Cooldowns respected | `now - lastThreat >= cooldown` |
| No repeat inside window | `now - lastBeatOf[id] >= cooldownPerBeat` |
| Cap respected | `beat.cost <= accessibilityCap` |
| Release after threat | state machine forbids THREAT → THREAT |

## Why a tick and not events

With a 1 Hz tick, 1000 minutes of pacing is 60,000 iterations — a test that runs in under a second.
Event-driven pacing is more elegant and far harder to reason about when debugging "why did it go quiet
for four minutes".

