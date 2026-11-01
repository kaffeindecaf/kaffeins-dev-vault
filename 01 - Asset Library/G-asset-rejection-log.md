---
id: G-asset-rejection-log
type: guide
title: Asset rejection log
status: reviewed
updated: 2026-11-01
tags: [assets, log, quality]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "G-asset-quality-rubric", "G-asset-verification-workflow", "MOC-asset-library"
---

# Asset rejection log

Records assets that failed verification, so nobody re-tests the same broken thing. **Empty until you verify
something** — this vault shipped without a Studio session.

## Format

| Date | Asset ID | Name | Failed at | Finding | Next |
|---|---|---|---|---|---|
| — | — | — | — | *no verifications have been run yet* | — |

## Failure categories

| Category | Meaning |
|---|---|
| `dead_listing` | the page no longer resolves |
| `restricted` | loads only for the uploading experience |
| `wrong_type` | the ID is not the type it was recorded as |
| `rig_mismatch` | animation incompatible with the target rig |
| `unsafe_scripts` | model contains hostile or unexplained code |
| `quality` | works, but wrong for the purpose |
| `rights` | usable, but licensing unclear (not a rejection — a hold) |

## When you reject

1. Add the row above.
2. Set the asset note: `status: deprecated`, and a line explaining why.
3. Never delete the asset note — the ID stays recorded so someone does not "discover" it again.

## Why this exists

Two hundred candidates will accumulate a lot of dead ends. A log turns each one into five seconds of reading
instead of five minutes of re-testing.

