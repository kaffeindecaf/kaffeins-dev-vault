---
id: R-sample-level-abandoned-building
type: spec
title: Worked sample level: the abandoned care home
status: reviewed
updated: 2026-11-01
tags: [level, sample, spec]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "R-level-blockout-template", "R-floorplan-patterns", "R-puzzle-dependency-graph", "H-tension-hierarchy"
---

# Sample level — the abandoned care home

A complete worked plan, to be built as a blockout. It is a **specification**, not a claim that this level
exists.

## Premise

You are looking for a resident's file. The building is occupied by one pursuer who patrols the ground
floor and one investigator who responds to noise. Ten-minute target session.

## Zones

| Zone | Rooms | Type | Threat |
|---|---|---|---|
| Entry hall | entrance, reception | neutral | none for 90 s |
| West wing | day room, kitchen, pantry | threat | investigator |
| East wing | 4 bedrooms, bathroom | threat | pursuer patrol |
| Basement | boiler, laundry, file room | climax | both can enter |
| Stairwell | connects all | neutral | transit |
| Store room | one room, warm light | safe | none, enforced |

## Route (intended)

```text
Entry → reception (objective: find the file room) → kitchen (clue: keys on a hook)
→ west wing (crowbar in pantry) → basement door (needs key) → boiler (cut power)
→ file room (safe opens) → escape through the laundry window
```

## Puzzle dependency

1. Crowbar (pantry) → pries the basement door's panel (an alternative to the key).
2. Key (kitchen hook) → opens the basement door directly.
3. Power switch (boiler) → disables the magnetic lock on the file cabinet.

Two routes to the basement is deliberate: it halves the softlock surface.

## Blockout numbers

| Room | Size (W×H×D) | Doors | Cover |
|---|---|---|---|
| Reception | 20×11×16 | 2 | desk |
| Kitchen | 18×9×14 | 2 | island, pantry |
| Day room | 24×11×20 | 3 | chairs, piano |
| Bedrooms ×4 | 12×9×12 | 1 each | bed, wardrobe |
| Boiler | 16×9×16 | 1 | pipes, tank |
| File room | 14×9×12 | 1 | shelves |

## Pacing budget

| Minute | Beat |
|---|---|
| 0–1 | entry, safe, learn the building |
| 1–3 | first suggestion (footsteps above), find the kitchen clue |
| 3–5 | investigator near the pantry, hiding opportunity |
| 5–7 | basement, threat zone, power puzzle |
| 7–9 | file room, climax (pursuer enters) |
| 9–10 | escape, release |

## What this sample does not specify

Art, lighting values, audio assets (see [[MOC-asset-library]] for candidates — all untested), and NPC
routes (see [[R-patrol-waypoints]]).

Build it as a grey box, run [[R-level-playtest-checklist]], then iterate.

