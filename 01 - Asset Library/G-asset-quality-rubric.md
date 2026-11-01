---
id: G-asset-quality-rubric
type: guide
title: Asset quality rubric and review outcomes
status: reviewed
updated: 2026-11-01
tags: [assets, quality, review]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "G-asset-verification-workflow", "G-asset-rejection-log", "LICENSES_AND_SOURCES"
---

# Asset quality rubric

Functional verification says the asset *works*. The rubric says whether it is *good enough to ship*.

## Six criteria (score 1–3 each)

| Criterion | 1 | 2 | 3 |
|---|---|---|---|
| Clarity | muddy, wrong subject | recognisable | immediately readable for its purpose |
| Cohesion | clashes with the mix/art | neutral | sounds/looks like it was made for this |
| Loopability (audio) | audible seam | acceptable with a crossfade | seamless |
| Moderation risk | could be actioned | grey area | clearly fine |
| Provenance | no listing, source unknown | listing exists, creator unclear | listing + creator + terms read |
| Technical suitability | wrong length/format/scale | usable with work | drop-in |

Total 6–18. **Ship threshold: 13+ with no 1s.** Anything with a `1` in moderation risk or provenance is not
shippable regardless of the total.

## Review outcomes (what `verification`/status to record)

| Outcome | Meaning | Fields |
|---|---|---|
| `candidate` | imported, unexamined | `verification: untested` |
| `inspected` | looked at it, not used | `listing_status: listed`, note anything odd |
| `accessible` | confirmed in Studio it loads | `access_status: shared`, `access_evidence` |
| `tested_studio` | played/used in a test place | `studio_status: tested_studio`, `test_evidence` |
| `tested_published` | observed in a live experience | as above + date and place |
| `rejected` | broken, inaccessible, misleading, unsafe | move to [[G-asset-rejection-log]] |

## Rules

- **Rights are reviewed separately** from function ([[LICENSES_AND_SOURCES]]). A perfectly working asset with
  unclear rights is `license_status: unknown`, not "fine".
- **No invented rankings.** "Best" requires a stated criterion; this rubric is that criterion.
- **Score what you observed.** A rubric filled from a listing page is a guess.

