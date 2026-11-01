---
id: R-audio-placement-and-rights
type: reference
title: Audio placement and when re-uploading is not allowed
status: reviewed
updated: 2026-11-01
tags: [audio, assets, rights]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "R-sound-service-3d", "LICENSES_AND_SOURCES", "G-asset-verification-workflow"
---

# Where audio goes, and what you may not do

## Placement

| Need | Parent | Why |
|---|---|---|
| UI, music beds | `SoundService` | 2D, no attenuation |
| World source (door, drip) | the `BasePart` | 3D from that part |
| Following a rig | an `Attachment` | 3D from the attachment |
| Per-player feedback | the player's `PlayerGui` | heard only by that client |

Use a `SoundGroup` per category so you can mix and duck categories rather than 20 individual sounds
([[H-ambience-layering]]).

## Spatial rolloff

`RollOffMode = Inverse` (default) is natural falloff; `Linear` is predictable for a hard radius (a radio that
stops at a wall). Set `RollOffMaxDistance` deliberately: the default is far too long for interior sound.

## Re-uploading: the line

You may **not** download someone else's audio and re-upload it as your own. That is the classic way accounts
get actioned, and it is not a licence.

| Situation | Allowed |
|---|---|
| Use an accessible Creator Store audio as-is | yes, subject to its terms |
| Re-upload the same file under your account | **no** unless the licence says so |
| Cut/edit a sound you are licensed to edit | yes, if the terms allow derivatives |
| Use a sound from another game | no |
| Upload your own recording / a purchased library | yes (keep the receipt/licence) |

## Practical consequence for this vault

The catalogue records **IDs and links only**. There is no copy of any asset here, by design
([[LICENSES_AND_SOURCES]]). If an asset is inaccessible and you cannot licence it elsewhere, pick a different
asset.

