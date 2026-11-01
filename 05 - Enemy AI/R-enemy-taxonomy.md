---
id: R-enemy-taxonomy
type: reference
title: Enemy taxonomy: patrol, investigator, watcher, stalker, pursuer
status: reviewed
updated: 2026-11-01
tags: [ai, npc, design]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: []
code_blocks: 1
related: "R-npc-state-machine", "R-npc-perception-model", "R-npc-think-budget"
---

# Enemy taxonomy

Before writing a state machine, decide what kind of enemy it is. Each archetype has a different cost
profile and a different relationship with the player's attention.

| Archetype | Behaviour | Cost | Player counter |
|---|---|---|---|
| **Patrol** | fixed route, reacts to noise/sight | low | timing, cover |
| **Investigator** | goes to the last disturbance, searches, gives up | low-medium | decoy, patience |
| **Watcher** | stationary, wide cone, alerts others | low | avoid the cone |
| **Stalker** | follows at distance, flees when seen | medium | turn around |
| **Pursuer** | direct chase once alerted, fast, persistent | high (pathfinding) | distance, doors, hiding |
| **Nuisance** | environmental: rats, a flickering machine | very low | none; atmosphere only |

## Choosing

- One pursuer is enough for a tense round; two pursuers turn a stealth game into a chase game.
- An investigator is the best "first enemy" — it creates tension without demanding a chase system.
- A watcher is the cheapest way to make a *room* matter.
- Nuisances should never share the pursuit budget.

## Budget rule

Total per-frame AI cost is dominated by **pursuers** (pathfinding) and **sight checks** (raycasts).
A practical cap for a mobile target: 1–2 pursuers, 2–4 investigators, any number of watchers if they
only check a cone on a slow tick.

## What each needs

| Archetype | Needs | Does not need |
|---|---|---|
| Patrol | waypoints, sight, hearing | pathfinding (if waypoints are on walkable straight lines) |
| Investigator | last-known-position memory, search points | persistent chase |
| Watcher | cone, alert broadcast | movement |
| Stalker | distance keeping, flee trigger | pathfinding (use direct movement + obstacle nudge) |
| Pursuer | pathfinding, stuck detection, catch | patrol |

See [[R-npc-state-machine]] for the shared implementation.

