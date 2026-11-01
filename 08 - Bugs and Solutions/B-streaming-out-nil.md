---
id: B-streaming-out-nil
type: bug
title: Client raycast passes through a wall that exists
status: reviewed
updated: 2026-11-01
tags: [streaming, client, npc]
source_urls: []
confidence: medium
verification: design_only
severity: high
hypothetical: true
client_server: both
code_blocks: 1
related: "R-streamingenabled", "R-raycasting-and-collision-filters", "R-npc-perception-model"
---

> ⚠️ **Hypothetical case, not a real incident.** Written from general Roblox behaviour to teach the
> diagnostic path. No log below came from a real session. Do not cite it as evidence.

# Raycast misses present geometry

## Observed
A client line-of-sight check reports "clear" through a wall the server respects.

## Diagnosis

| Check | Finding |
|---|---|
| Server raycast | blocked (correct) |
| Client raycast | unblocked |
| `FindFirstChild` for the wall on the client | nil |
| Same check after 3 s standing there | blocked |

## Cause
Streaming is a client-side view; unstreamed geometry does not exist for the client, so `Raycast` passes
through it ([[R-streamingenabled]]).

## Fix
- Gameplay perception on the **server**.
- `Player:RequestStreamAroundAsync(position)` before camera moves/cutscenes.
- `ModelStreamingMode = Persistent` for anything that must always exist.

## Verification
Compare client and server raycasts at three distances; they agree where the area is streamed, and no gameplay
query remains on the client.

## Regression prevention
Review rule: client raycasts are for presentation only.

