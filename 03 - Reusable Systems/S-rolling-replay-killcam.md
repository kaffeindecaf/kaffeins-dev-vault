---
id: S-rolling-replay-killcam
type: system
title: Universal rolling replay and killcam recorder
status: draft
updated: 2026-11-02
tags: [systems, backend, reusable, v1]
source_urls: ["https://create.roblox.com/docs/reference/engine/classes/Animator","https://create.roblox.com/docs/reference/engine/classes/AnimationTrack"]
confidence: medium
verification: tested_studio
client_server: both
roblox_services: [RunService]
test_method: Studio Play mock fault harness and scoped runtime checks
tested_at: 2026-11-02
test_evidence: BACKEND_SYSTEMS_TEST_REPORT.md
related: ["T-backend-systems-catalog","SRC-backend-platform-contracts","S-camera-and-headbob"]
---

# Universal rolling replay and killcam recorder

Files: `rolling-replay-recorder.luau`, `replay-player.luau` in `11 - Templates and Schemas/Luau Snippets/`. Executed scope is documented below; project integration examples remain untested.

Keep a bounded rolling history of model pivots and active animation samples, then play a detached clip on client-only ghost models. Use it for combat replays, racing ghosts or visual bug reports; game-specific camera direction and UI are separate.

## Recorder and player contracts

Recorder: `new(seconds, hz, maxObjects?)`, `Register(id, model, animator?)`, `Unregister(id)`, `Sample(now)`, `Clip(seconds)`, `Destroy()`. Limits are at most ten seconds, 30 Hz, default 32 models and eight animation samples per model/frame. The host schedules sampling; missing time is not filled with invented frames.

Player: `new(clip, factory)` returns `Step(dt)` and `Destroy()`. The factory creates a fresh, script-free anchored noncolliding ghost, returning its Model and optional Animator. Use a trusted ghost template rather than cloning arbitrary live characters with scripts.

Untested: integration sketch; `Recorder` and `ReplayPlayer` are the required modules.

```lua
local recorder = Recorder.new(8, 10, 16)
recorder:Register("runner", character, animator)
-- Sample on a host timer: recorder:Sample(os.clock())
local clip = recorder:Clip(6)
if #clip >= 2 then
    local replay = ReplayPlayer.new(clip, buildAuditedGhost)
    -- RenderStepped: if not replay:Step(dt) then disconnect(); replay:Destroy() end
end
```

Use one clock domain per clip. CFrames are interpolated between samples; animations are resynchronized from sampled IDs, positions, speeds and weights. This is not a simulation rewind: particles, sound, joints outside the sampled animation, destruction, physics and exact animation blending are not reconstructed. Animation asset permission/loading still applies.

## Delivery and failure cases

Do not send a full maximum-size clip in one unbudgeted remote payload. Select relevant actors, downsample and chunk with a transfer ID and length cap; the host validates complete chunks before playback. That transport is intentionally project-owned. Never accept arbitrary client clips or animation IDs as authoritative moderation evidence.

| Case | Handling |
|---|---|
| Buffer full | Overwrite oldest samples |
| Object destroyed / unregister | Future frames omit it |
| Clip changed by caller | Detached frame tables protect recorder |
| Fewer than two frames | Do not start playback |
| Replay completes or is cancelled | Disconnect render loop, destroy tracks and ghosts |
| Factory/animation loading fails | Host catches setup errors and cleans partial ghosts |

Studio checked ring rollover/detachment and four client checks for transform interpolation, completion and ghost cleanup. Real animation playback, camera handoff, teleports, mobile load and chunked transport remain untested.
