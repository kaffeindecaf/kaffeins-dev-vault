---
id: G-new-asset-candidates-from-creator-store
type: guide
title: New Creator Store candidates — 2026-11-01
status: draft
updated: 2026-11-01
tags: [asset, creator-store, candidate, index]
source_urls:
  - https://create.roblox.com/store/asset/125578417483849/Horror-Ambience
  - https://create.roblox.com/store/asset/125209584906878
  - https://create.roblox.com/store/asset/8801933075/Flashlight
confidence: low
verification: reference_only
related: [ "MOC-asset-library", "MOC-new-creator-store-candidates", "G-asset-verification-workflow", "G-skill-roblox-mcp-workflow" ]
---

# New Creator Store candidates — 2026-11-01

These three official Creator Store pages were found in a new web search after the original 206-item
dataset was imported. They are recorded as additional candidates, separate from the byte-exact raw
import. Page existence does not establish that an asset is accessible to this experience, licensed
for a particular use, safe to insert, or tested in Studio.

| Candidate | Type | Note | Review priority |
|---|---|---|---|
| Horror Ambience | audio | [[asset-125578417483849]] | Check status; search result said it was not currently for sale. |
| Door Creak Open | audio | [[asset-125209584906878]] | Preview in a clean place; confirm access and fit. |
| Flashlight | model | [[asset-8801933075]] | Inspect hierarchy and every script before use. |

Index: [[MOC-new-creator-store-candidates]].

## Evidence and handling

- The IDs and asset types are copied from the official Creator Store search results and detail pages.
- `access_status` and `license_status` remain `unknown` until checked in Studio for the target
  experience. `studio_status` remains `not_tested`.
- Model IDs are for Creator Store insertion and must never be used as audio IDs.
- Inspect model scripts, linked modules, remotes and asset dependencies in a blank review place.
- Continue with [[G-asset-verification-workflow]] and the Studio process in
  [[G-skill-roblox-mcp-workflow]].

Roblox notes that Creator Store listings include access and acquisition details, and that some
models contain scripts which must be understood before insertion. See the [Creator Store guide](https://create.roblox.com/docs/production/creator-store).
