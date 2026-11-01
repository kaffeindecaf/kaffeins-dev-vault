---
id: H-intensity-config
type: principle
title: Intensity configuration and accessibility settings
status: reviewed
updated: 2026-11-01
tags: [horror, accessibility, config]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "H-multiplayer-fairness", "R-reduced-motion-policy", "H-adaptive-director"
---

# Intensity configuration

Expose intensity as three or four named levels, not a 0–100 slider. Named levels can be tested and
reasoned about; a slider cannot.

## Levels

| Level | Name | Flash | Camera motion | Audio spikes | Threat frequency |
|---|---|---|---|---|---|
| 0 | Calm | none | none | moderate | low |
| 1 | Standard | ≤ 3 Hz, no full-screen white | shake ≤ 0.3° | as designed | as designed |
| 2 | Intense | ≤ 3 Hz | shake ≤ 1° | as designed | +25% |
| 3 | Maximum (opt-in) | as designed | shake ≤ 2° | as designed | +50% |

**Level 1 is the default.** Levels 2–3 are opt-in and named so the player knows what they are choosing.
Level 0 must be playable, not a punishment.

## What each level must change

- **Flash cap** — luminance delta per second, and no full-screen white.
- **Camera** — shake amplitude, bob, FOV punch, and any roll (off below level 2).
- **Audio** — max simultaneous stingers, and whether a stinger can play at full volume without a
  ramp-in.
- **Pacing** — the director's intensity cap ([[H-adaptive-director]]).

## Storage

Save the setting with player data, and apply **before the first frame** after spawn. A "preferences are
applied after 20 seconds" bug means the player with photosensitivity sees one flash. Default when the
key is missing: level 1.

## Test plan

1. Set each level, play 60 s, measure: max luminance delta per second, max camera shake amplitude,
   count of stingers.
2. Level 0 in a scripted threat section → no flash, no shake, threat still legible (audio + light).
3. Setting persists across rejoin.
4. Level 0 + level 3 players in one server → the server uses 0.

