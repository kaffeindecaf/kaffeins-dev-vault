---
id: G-asset-favorites
type: guide
title: Favourites — curated picks (criteria first, picks later)
status: reviewed
updated: 2026-11-01
tags: [assets, curation]
source_urls: []
confidence: high
verification: design_only
client_server: both
code_blocks: 0
related: [ "MOC-asset-library", "G-asset-quality-rubric", "G-asset-verification-workflow" ]
---

# Favourites

An empty list on purpose. A favourite is an asset that passed verification **and** scored well on the rubric —
neither has happened yet, and inventing a "best sounds for X" list would be exactly the kind of confident
fiction this vault is built to avoid.

## What lands here

| Requirement | Threshold |
|---|---|
| Verification | `verification: tested_studio` with an `access_evidence` line |
| Rubric score | 13+/18 with no `1` in moderation risk or provenance (`G-asset-quality-rubric`) |
| Rights | `license_status` documented, or the asset is your own upload |
| Fit | used (or about to be used) in a real project |

## The list (empty until something qualifies)

| Use | Asset ID | Note | Rubric | Verified | Why it made the cut |
|---|---|---|---|---|---|
| — | — | — | — | — | *nothing verified yet* |

## Why no ranking

A ranking implies comparative testing. Nobody has heard these assets in this game, on this mix, on a phone
speaker. "Best audio candidate" from a spreadsheet of IDs is a guess wearing a ranking's clothes.

## How to add an entry

1. Work [[G-asset-verification-workflow]] on the asset.
2. Score it with [[G-asset-quality-rubric]] and write the score into the asset note.
3. Add one row above with the reason it beat the alternatives you also tested.
4. Keep the row if the asset is later rejected — mark it and link the rejection log.
