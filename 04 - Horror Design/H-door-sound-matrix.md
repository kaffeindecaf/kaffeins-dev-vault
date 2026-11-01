---
id: H-door-sound-matrix
type: reference
title: Interactive door sound-state matrix
status: reviewed
updated: 2026-11-01
tags: [audio, doors, design]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: []
code_blocks: 1
related: "S-smart-door", "H-ambience-layering", "H-environmental-events-catalog"
---

# Door sound matrix

A door is the most-used interaction in a horror game and the cheapest source of tension. Each state
needs its own sound, and the *states* are what you should design first.

| State | Sound | Duration | Notes |
|---|---|---|---|
| Approach (proximity) | handle rattle | 0.2 s | only for locked doors, as feedback |
| Unlock | key/latch click | 0.15 s | confirm the input registered |
| Open slow | creak, low pitch | 1.2–2 s | volume scaled by push speed |
| Open fast | creak + whoosh | 0.8 s | reads as panic |
| Hold ajar | soft wood settle | 0.5 s | optional, adds life |
| Close slow | click + latch | 0.4 s | |
| Close slam | thud + rattle | 0.6 s | strong cue — use for a threat, not a player |
| Locked attempt | rattle ×2 | 0.5 s | pairs with a toast |
| Force/barge | splinter + bang | 1 s | rare, expensive |
| Ambient creak | single creak, no door | 1.5 s | the "is that a door?" beat |

## Implementation rules

1. **One prompt, one sound call.** Playing a sound in both `Triggered` and `Touched` doubles it.
2. **Positional, on the hinge part.** A door sound from the centre of a large model sounds wrong.
3. **Pitch variance of ±5%** on repeated creaks stops the "same sample" fatigue.
4. **Never gate gameplay on the sound finishing.** A 2 s creak must not block the door state change.
5. **Slam = threat signal.** If players can slam doors freely, the cue loses meaning.

## Mapping to a state machine

The door state machine ([[S-smart-door]]) should emit events (`Opening`, `Opened`, `Closing`, `Locked`)
and a separate audio component should map events → sounds. That way a silent door variant is a config
change, not a code change.

