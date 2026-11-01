---
id: MOC-asset-library
type: moc
title: Asset Library — map of content
status: reviewed
updated: 2026-11-01
tags: [assets, moc]
source_urls: []
verification: reference_only
confidence: medium
generated: false
related: [ "N-HOME", "G-asset-verification-workflow" ]
---

# Asset Library

**206 researched Roblox asset candidates**, imported unchanged from the 2026-11-01
research collection. This is a **lookup**, not a permissioned asset source.

> ⚠️ **Nothing here has been verified.** An ID and a listing prove an asset exists. They do not
> prove it plays in your game, that you may use it, that it is safe, or that it still exists today.
> `access_status`, `license_status` and `studio_status` are `unknown`/`not_tested` on every record.
> Start with [[G-asset-verification-workflow]] before putting any of these in a game.

## Don't confuse the ID types

| Type | Use as | Never |
|---|---|---|
| `audio` | `Sound.SoundId = "rbxassetid://<id>"` | as an AnimationId |
| `animation` | `Animation.AnimationId = "rbxassetid://<id>"` | as a model ID |
| `model` | search the ID in Studio's Toolbox, review in a blank place | as a SoundId |
| `plugin` | Creator Store only, after review | install because a model said so |

## Indexes

| Index | What it gathers |
|---|---|
| [[IDX-footsteps]] | audio whose name or suggested use mentions a footstep, step, walk, run or surface — 27 records |
| [[IDX-doors]] | audio mentioning a door, latch, handle, hinge, lock, squeak or slam — 17 records |
| [[IDX-ambience]] | audio mentioning ambience, atmosphere, room tone, hum, wind, rain, weather or forest — 38 records |
| [[IDX-ui-sounds]] | audio mentioning ui, click, beep, notification, menu, button, hover, confirm or error — 50 records |
| [[IDX-horror-cues]] | audio mentioning horror, sting, tension, dread, screech, whisper, drone or music — 26 records |
| [[IDX-animations]] | records of type animation, grouped by rig hint and movement — 30 records |
| [[IDX-models]] | records of type model (containers, not animation IDs) — 30 records |
| [[IDX-ui-kits]] | models and records mentioning ui, icon, menu, gui, hud, pack or interface — 13 records |
| [[IDX-lighting]] | audio or models mentioning light, flashlight, lamp, flicker, fog or glow — 22 records |
| [[IDX-plugins]] | Studio plugins — 1 record(s), all uninspected |

## By type

| Type | Records | Folder |
|---|---:|---|
| audio | 145 | `01 - Asset Library/Audio/` |
| model | 30 | `01 - Asset Library/Models/` |
| animation | 30 | `01 - Asset Library/Animation/` |
| plugin | 1 | `01 - Asset Library/Plugin/` |

## By source grade

| Grade | Records | What it means (and does not) |
|---|---:|---|
| `D` | 66 | a Creator Store listing existed on the research date — not quality, licence or access |
| `I` | 105 | a third-party index (lead only) — not quality, licence or access |
| `G` | 21 | official Roblox animation documentation — not quality, licence or access |
| `F` | 9 | a DevForum reference (historical) — not quality, licence or access |
| `S` | 4 | a secondary listing (lead only) — not quality, licence or access |
| `R` | 1 | an official Roblox audio tutorial — not quality, licence or access |

## By original research category

| Category | Records |
|---|---:|
| 01 · Outdoor ambience & weather | 17 |
| 02 · Interior ambience, electronics & room tone | 16 |
| 03 · Footsteps, locomotion & environmental foley | 14 |
| 04 · Doors, locks, switches & physical interactions | 15 |
| 05 · UI clicks, prompts, inventory & gadget beeps | 32 |
| 06 · Horror stingers, suspense cues & music | 34 |
| 07 · Mechanical, radio, glitch & creature design | 17 |
| 08 · UI kits, icon packs & menus (models/plugins) | 12 |
| 09 · Character animations (individual animation IDs) | 30 |
| 10 · Animation systems, horror rigs & gameplay models | 9 |
| 11 · Flashlights, lighting & locations | 10 |

## Additional Creator Store candidates

The following three manually researched records were found after the raw import. They are not included in the 206-row imported totals above:
- [[MOC-new-creator-store-candidates]] — three additional candidate notes, all untested.

## Working with these records

- Read the caveat table at the top of any `asset-*.md` note.
- Verification workflow: [[G-asset-verification-workflow]].
- Quality rubric and review outcomes: [[G-asset-quality-rubric]].
- Rejected / unusable findings: [[G-asset-rejection-log]].
- Totals and evidence: [[ASSET_VERIFICATION_REPORT]].
- Import provenance: [[IMPORT_REPORT]] and `imports/SOURCE_MANIFEST_PUBLIC.json` in public checkouts
  (local immutable manifest: `imports/raw/SOURCE_MANIFEST.json`).

Search: `python scripts/gamedev_kb.py search "door creak" --type asset --limit 10`
Exact ID: `python scripts/gamedev_kb.py asset 9114145200`
