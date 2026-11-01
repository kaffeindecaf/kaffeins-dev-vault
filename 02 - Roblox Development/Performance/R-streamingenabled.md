---
id: R-streamingenabled
type: reference
title: StreamingEnabled — what disappears and what breaks
status: reviewed
updated: 2026-11-01
tags: [performance, streaming, replication]
source_urls: [ "https://create.roblox.com/docs/workspace/streaming" ]
confidence: medium
verification: reference_only
related: [ "R-raycasting-and-collision-filters", "R-pathfinding-cost" ]
---

# StreamingEnabled

With streaming on, the server sends a client only nearby parts. Memory and join time improve; the
cost is that **the client's DataModel is incomplete**, and code that assumes otherwise fails
intermittently — which is the hardest kind of bug to diagnose.

## What breaks

| Pattern | Why it breaks |
|---|---|
| `workspace:FindFirstChild("Door", true)` at startup on the client | the door may not be streamed yet |
| `.ChildAdded` listeners for far objects | they arrive later, or not at all |
| Raycasts aimed at unstreamed geometry | terrain/buildings absent → false line of sight |
| `GetPartBoundsInBox` over a large area | only returns streamed parts |
| Anchoring code to a specific model at spawn | model may appear after your script runs |

## Rules

1. **Server code is unaffected.** Streaming is a client-side view; all authority stays complete.
2. **Client code must wait or subscribe.** Use `:WaitForChild(name)` (not `FindFirstChild`) and
   `ChildAdded`, or `Player:RequestStreamAroundAsync(position)` before teleporting a camera/Cutscene.
3. **Do not stream if you rely on whole-map queries client-side.** If your minimap or AI debug
   overlay needs the map, build it from server data.
4. **`ModelStreamingMode`** lets you force specific models (`Persistent`) to always exist — use for
   the truck, spawn, HUD-critical props.
5. **Raycasts on the server are unaffected**; only client rays suffer. NPC perception belongs on the
   server anyway ([[R-npc-perception-model]]).

## Tuning knobs (workspace.StreamingEnabled + StreamingTargetRadius style settings)

- `StreamingMinRadius` — always-loaded bubble.
- `StreamingTargetRadius` — how far ahead it streams.
- `StreamingIntegrityMode` — `Limited`/`Disabled` prevent client-side tampering from revealing the
  whole map, at the cost of some pop-in flexibility.

Bigger radius = fewer bugs, more memory. For a small horror house (a few thousand parts) streaming is
often not worth enabling at all — measure before optimising. See [[G-profiling-workflow]].
