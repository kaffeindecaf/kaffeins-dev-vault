---
id: R-floorplan-patterns
type: reference
title: Floorplan patterns: hub-and-spoke, loops, linear
status: reviewed
updated: 2026-11-01
tags: [level, layout, patterns]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "R-branching-routes", "R-level-blockout-template", "H-safe-room-rhythm"
---

# Floorplan patterns

Three shapes cover most levels. Pick one deliberately; a mixed floorplan that resolves to a corridor with
one branch is a linear level pretending.

## Hub and spoke

```text
        [room]
          |
[room]-- HUB --[room]
          |
        [room]
```

- Good: the player learns one navigational anchor; easy to add rooms; safe rooms fit naturally.
- Bad: every threat funnels through the hub, so the hub becomes either safe or lethal.
- Use for: a mansion, a hospital wing, a house with a central hall.

## Loop

```text
  ┌──────────────┐
  │              │
  ▓──[A]──[B]────▓   ▓ = chase corridor
  │              │
  └──[C]──[D]────┘
```

- Good: fleeing becomes possible; chases have a rhythm; players learn the loop and feel clever.
- Bad: needs enough turns that a pursuer cannot see both sides; otherwise it is a racetrack.
- Use for: horror chases, heist escape routes.

## Linear with branches

```text
[entry]--[A]--[B]--[C]--[exit]
           \      /
            [side]
```

- Good: easiest to pace (the designer controls the sequence), best for story beats.
- Bad: backtracking, and a single blocked door ends the run.
- Use for: scripted horror sequences, tutorial sections.

## Multiplayer note

Hub-and-spoke splits a party; loops keep them together. If your game needs co-op tension, prefer loops with
one widening (the party can split and rejoin).

See [[R-branching-routes]] · [[R-sample-level-abandoned-building]].

