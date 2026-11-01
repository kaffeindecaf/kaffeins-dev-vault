---
id: R-safe-room-threat-zone
type: reference
title: Safe room vs threat zone patterns
status: reviewed
updated: 2026-11-01
tags: [level, pacing, design]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "H-safe-room-rhythm", "R-room-arc", "R-spawn-placement"
---

# Safe rooms and threat zones

Level design is pacing made physical: the map decides when the player can rest.

## Zone types

| Zone | Threat | Light | Sound | Density |
|---|---|---|---|---|
| Safe | none, enforced | warm, steady | room tone | small, enclosed |
| Neutral | possible | dim, steady | ambience | medium |
| Threat | likely | cold, flickering | detail + cues | larger, more cover |
| Climax | guaranteed | dramatic | full mix | open, one exit |

## Transition rules

- Never put a threat zone directly adjacent to a safe room without a door — a threshold is the signal.
- A safe room's entrance should be **visible from inside** (you can watch the door).
- Threat zones need ≥ 2 exits or ≥ 2 cover spots, or the player is trapped and the death feels unfair.
- Climax zones can have one exit, but only if the threat is avoidable/escapable by skill.

## Density

```text
safe:    ██░░░░░░░░  1.5 objects/m² visual, 0 cover
neutral: █████░░░░░  3 objects/m², 1-2 cover
threat:  ███████░░░  5 objects/m², 3+ cover
climax:  ██████░░░░  4 objects/m², cover but no hiding
```

Density is what makes a room feel like a place; uniform density makes every room identical.

## Verification

Walk the intended path and log when you were in each zone type. The intended sequence for a 10-minute
round: neutral → threat → safe → threat → climax → safe.

