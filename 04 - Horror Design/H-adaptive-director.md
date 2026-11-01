---
id: H-adaptive-director
type: principle
title: Adaptive horror director — inputs, states and decision rules
status: reviewed
updated: 2026-11-01
tags: [horror, pacing, systems, spec]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "H-director-api", "H-cooldowns-and-rarity", "H-environmental-events-catalog", "R-seeded-generation"
---

# Adaptive horror director

A server-side system that picks the next "beat" of atmosphere instead of leaving scares on a fixed
timer. It is a **pacing controller**, not an AI that invents content: it chooses from a catalogue you
authored.

## Inputs

| Input | Source | Why |
|---|---|---|
| `timeSinceLastBeat` | server clock | prevents clustering |
| `timeSinceLastThreat` | server clock | enforces calm windows |
| `playerStress` | derived: recent chases, damage, deaths | don't pile on a struggling player |
| `progress` | round phase / objectives done | ramp intensity as the round advances |
| `playerCount` | server | multiplayer fairness |
| `locationCategory` | zone the majority of players are in | safe rooms never get scares |
| `recentBeats` | ring buffer of the last N events | avoid repeating the same cue |
| `accessibilityIntensity` | player settings (min of all players in the group) | cap intensity |

## Outputs

| Output | Channel |
|---|---|
| `ambienceLayer` | which ambience bed is playing and its target volume |
| `lightVariation` | a brightness flicker/dip preset |
| `ambientEvent` | one-shot: distant step, object fall, door creak |
| `enemyPressure` | hint for the NPC controller (patrol toward / stay away) |
| `musicState` | `none`, `low`, `build`, `threat` |
| `silence` | explicit silence beat (the strongest cue in the catalogue) |

## State machine

```text
IDLE_SAFE --(calm elapsed > N, stress low)--> SUGGEST
SUGGEST --(no player reaction / quiet continues)--> BUILD or back to CALM
BUILD --(intensity budget allows)--> THREAT (NPC pressure, not a jumpscare)
THREAT --(threat ends / player escapes)--> RELEASE (silence) --> COOLDOWN
COOLDOWN --(cooldown elapsed)--> IDLE_SAFE
* --(player in safe room)--> SUSPENDED (only room tone)
```

## Decision rules (deterministic, seedable)

```lua
-- Untested
function Director:pick(now)
    if self.state == "SUSPENDED" then return nil end
    if now - self.lastThreat < self.cooldown then return nil end
    if self.stress > 0.7 then return nil                  -- struggling player: back off
    local budget = self:intensityBudget()                  -- from progress + settings
    local pool = {}
    for _, beat in BEATS do
        if beat.cost <= budget and not self:tooRecent(beat.id) then
            table.insert(pool, beat)
        end
    end
    if #pool == 0 then return nil end
    return pool[self.rng:NextInteger(1, #pool)]
end
```

`self.rng` is a `Random.new(seed)` so a session can be reproduced exactly when someone reports "it
kept doing X" ([[R-seeded-generation]]).

## Multiplayer

Scares are **replicated cues** with **local** presentation where possible: a door creak plays at the
door for everyone, but a flashlight flicker only affects the player it targets. Intensity is capped at
the **minimum** of all players' settings in the server (see [[H-multiplayer-fairness]]).

## What it must never do

- Spawn enemies in a safe room or during a cutscene.
- Repeat the same beat twice within `cooldownPerBeat`.
- Escalate after a player death (the next beat must be Release/Cooldown).
- Override an accessibility cap.

## Test plan

1. 1000 simulated minutes with a fake clock, assert: no two threats < cooldown, every threat followed
   by release, no beat repeated inside its window, scale-invariant to player count 1/4/8.
2. With `accessibilityIntensity = 0`, assert only `ambientEvent` beats of cost 0 are chosen.
3. With `stress = 1.0`, assert no new beats for the configured window.
4. Determinism: same seed → same beat sequence.

API contract and module sketch: [[H-director-api]].

