---
id: G-npc-test-matrix
type: guide
title: NPC behavioural test matrix
status: reviewed
updated: 2026-11-01
tags: [ai, testing, quality]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: []
code_blocks: 1
related: "R-ai-debug-overlay", "R-stuck-detection", "G-profiling-workflow"
---

# NPC test matrix

Every row is a scenario you can reproduce. Mark a row only when you have seen the expected result, and
record where (Studio playtest, two clients, published).

| # | Scenario | Expected | Method |
|---|---|---|---|
| 1 | Player walks into sight, 20 studs, lit room | Suspicious → Chase within 0.5 s | Studio, single client |
| 2 | Player leaves sight behind a wall | Chase → Investigate(last pos) → Search → Patrol | Studio |
| 3 | Player hides in a closet mid-chase | NPC investigates the closet, cannot acquire, gives up | Studio |
| 4 | Player peeks from hiding | NPC acquires while peeking, loses on hide | Studio |
| 5 | Door closed between NPC and player | Path via open door, or Recover if none | Studio |
| 6 | Two players, one closer | Target stays stable 2 s; switches with hysteresis | 2 clients |
| 7 | Target disconnects mid-chase | Drop target, Recover, no error | 2 clients |
| 8 | Round ends during chase | Disabled immediately, no catch after | Studio |
| 9 | NPC pushed into geometry | Recompute → sidestep → Recover; log line | Studio |
| 10 | 10 NPCs + 4 players | Frame time within budget | MicroProfiler |
| 11 | Player in a safe zone | Never acquired, never enters | Studio |
| 12 | Reduced-motion player caught | No camera shake; catch still resolves | Studio |
| 13 | Server sees 1000 remote calls | No AI state corruption, budgets hold | Studio with a spam client |

## Evidence

For each row record: date, build (place id + version), what you did, what you saw, and a screenshot path if
visual. An unrecorded pass is a rumour.

## What this matrix does not cover

- Long-session memory leaks (run a 30-minute idle session separately).
- Published-only behaviour (streaming, join/leave timing).
- Perception of third-party accessories on avatars — check a player wearing a hat and a backpack.

See [[R-ai-debug-overlay]] for the tools that make rows 1–9 visible, and [[G-profiling-workflow]] for row 10.

