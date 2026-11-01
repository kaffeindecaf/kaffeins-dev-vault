---
id: N-IMPORT-REPORT
type: report
title: Import report — Roblox horror asset collection
status: reviewed
updated: 2026-11-01
tags: [import, assets, provenance]
source_urls: []
---

# Import report

Result of importing the previously researched Roblox asset collection into this vault.
This page is generated prose written by hand from the importer's real output — it is not a
template. Re-run `python scripts/import_assets.py` to reproduce.

## Reconciliation

| Measure | Value |
|---|---|
| Source records in `ALL_ASSETS.json` | **206** |
| Distinct `asset_id` values | **206** |
| Duplicate IDs inside the source | **0**  |
| Rows in `ALL_ASSETS.csv` | 206 |
| In CSV but not JSON | 0 |
| In JSON but not CSV | 0 |
| Reference count in source README | 206 (reference, not a target) |

## This run

| Outcome | Notes |
|---|---:|
| created | 0 |
| refreshed (source row changed, note untouched) | 0 |
| unchanged (already up to date) | 206 |
| preserved (human has edited the note) | 0 |

## By type

| asset_type | Records |
|---|---:|
| animation | 30 |
| audio | 145 |
| model | 30 |
| plugin | 1 |

## What is preserved, and what is not claimed

- The original files are byte-identical under `imports/raw/` (hashes in
  `imports/raw/SOURCE_MANIFEST.json`). Nothing in `imports/` is ever edited.
- Every imported note carries the verbatim source row inside a `json` block under
  **Provenance**, and `verification: untested`.
- `source_grade` is passed through unchanged. It records where the ID came from, not quality,
  licence, safety or current access.
- `access_status`, `license_status`, `safety_status` and `studio_status` are all
  *not yet established* — they are not inferred from a Creator Store listing.

## Known caveats in the source data

- The collection is audio-heavy (145 audio, 30 models, 30 animations, 1 plugin). Most of the
  audio rows are `I` grade (a third-party index) and are the least reliable: an ID can be
  mis-typed, moderated or access-restricted without the listing disappearing.
- 30 `model` rows are containers, not animation IDs. They must never be pasted into a
  `SoundId` or `AnimationId`.
- The one `plugin` row is a Studio plugin: installing it grants code execution in Studio.
  It is recorded, not installed.

## Next action

Work through [[G-asset-verification-workflow]] on the assets you actually need — a verified
five is worth more than an unchecked two hundred.
