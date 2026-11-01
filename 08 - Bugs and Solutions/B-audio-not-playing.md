---
id: B-audio-not-playing
type: bug
title: Sound is silent with no error in the Output
status: reviewed
updated: 2026-11-01
tags: [audio, assets, diagnosis]
source_urls: []
confidence: medium
verification: design_only
severity: high
hypothetical: true
client_server: both
code_blocks: 1
related: "G-asset-verification-workflow", "R-sound-service-3d", "G-animation-owner-checklist"
---

> ⚠️ **Hypothetical case, not a real incident.** Written from general Roblox behaviour to teach the
> diagnostic path. No log below came from a real session. Do not cite it as evidence.

# A sound that will not play

## Observed
`Sound.SoundId = "rbxassetid://9114145200"` never plays. No error in the Output; `IsPlaying` flickers true.

## Diagnostic order (cheapest first)

| # | Check | Rules out |
|---|---|---|
| 1 | Is `SoundId` literally `rbxassetid://<digits>`? | a bare number or typo |
| 2 | `Volume > 0`, not inside a muted `SoundGroup`? | mixing |
| 3 | Is the `Sound` parented into the DataModel? | orphaned instance |
| 4 | `RollOffMaxDistance` non-zero and camera in range? | distance attenuation |
| 5 | Does the Output show `Failed to load sound`? | permission / moderation |
| 6 | Does the same ID play in a place owned by a *different* account? | experience-restricted audio |
| 7 | Is the ID actually audio, not a model? | ID type confusion |

## Cause
Most likely the audio is restricted to the uploading experience, so it loads as silence for everyone else —
indistinguishable from "works" on the listing page.

## Fix
Use an accessible asset, or upload your own with the correct rights. Do not re-upload someone else's asset
([[R-content-and-ownership]]).

## Verification
The sound plays audibly in a place owned by the target account/group with a clear Output. Record it in the
asset note as `access_status: shared`, `verification: tested_studio`.

## Regression prevention
Asset records start at `access_status: unknown` for exactly this reason
([[G-asset-verification-workflow]]).

