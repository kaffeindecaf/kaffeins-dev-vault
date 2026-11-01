---
id: B-animation-owner-mismatch
type: bug
title: Animation 'loads' but the character does not move
status: reviewed
updated: 2026-11-01
tags: [animation, assets, rig]
source_urls: []
confidence: medium
verification: design_only
severity: high
hypothetical: true
client_server: both
code_blocks: 1
related: "G-animation-owner-checklist", "R-animation-loading-and-priorities", "R-player-character-humanoid-animator"
---

> ⚠️ **Hypothetical case, not a real incident.** Written from general Roblox behaviour to teach the
> diagnostic path. No log below came from a real session. Do not cite it as evidence.

# Animation loads, no pose

## Observed
`LoadAnimation` succeeds, `track:Play()` runs, `track.Length == 0`, the character keeps its default pose.

## Diagnosis

| Symptom | Meaning |
|---|---|
| `track.Length == 0` | never loaded (access, ID type, or rig) |
| Output shows an access warning | not shared with this experience |
| Plays, no visible change | wrong rig type, or a higher-priority track wins |
| Moves only the torso | clip animates bones this rig does not have |

## Cause
Animation ownership is per-experience; a valid ID is not permission
([[R-animation-loading-and-priorities]]).

## Fix
Uploader shares it with the experience; or re-upload under the game's owner account/group; or replace it.

## Verification
`track.Length > 0` and the pose visibly changes; mark `tested_studio` in the asset note.

## Regression prevention
Check rig type **and** ownership at design time ([[G-animation-owner-checklist]]).

