---
id: N-ASSET-VERIFICATION-REPORT
type: report
title: ASSET_VERIFICATION_REPORT — how verified the asset library actually is
status: draft
updated: 2026-11-01
tags: [assets, verification, evidence]
source_urls: []
confidence: high
verification: reference_only
client_server: both
code_blocks: 0
related: [ "MOC-asset-library", "G-asset-verification-workflow" ]
---

# Asset verification report

The honest answer: **nothing has been verified.** This vault was built without opening Roblox Studio, so every
asset record is a candidate with an ID, a source and a caveat.

## Totals

| Measure | Value |
|---|---|
| Original imported records | **206** |
| Additional web candidates | **3** |
| Total candidate notes | **209** (0 duplicate IDs) |
| Verified in Studio | **0** |
| Verified in a published experience | **0** |
| Access confirmed | **0** |
| Licence documented | **0** |
| Model/plugin scripts inspected | **0** |

## By type

| Type | Imported | Additional | Total | Can be verified by |
|---|---:|---:|---:|---|
| audio | 145 | 2 | 147 | playing it in a clean place (`G-studio-audio-test`) |
| animation | 30 | 0 | 30 | loading it on a rig, `track.Length > 0` (`G-studio-animation-test`) |
| model | 30 | 1 | 31 | inserting into a blank place, reading every script (`G-studio-model-inspection`) |
| plugin | 1 | 0 | 1 | Creator Store listing + privilege review |

## Original imported set by evidence grade

| Grade | Records | What it means | What it does not mean |
|---|---:|---|---|
| `I` | 105 | an independent index lists the audio ID | that the ID is correct, accessible or licensed |
| `D` | 66 | a Creator Store page existed on 2026-11-01 | that it plays in your game |
| `G` | 21 | official Roblox animation documentation | that the animation is shared with your experience |
| `F` | 9 | a DevForum reference (historical) | that it is current |
| `S` | 4 | a secondary listing | almost anything |
| `R` | 1 | an official audio tutorial | that it is usable commercially |

## Why the numbers are what they are

1. **Audio privacy** — an ID can exist and still load as silence outside the uploading experience. Only a Studio
   play test distinguishes the two.
2. **Animation sharing** — same problem, with a cleaner diagnostic (`track.Length == 0`).
3. **Model safety** — a model carries scripts. Reading them is a human decision, not a check an AI can make.
4. **Rights** — a listing is not a licence. Even a working asset can be unusable commercially.

## What would change this report

Work [[G-asset-verification-workflow]] on the assets you actually intend to ship, recording per asset:

```yaml
access_status: shared
access_evidence: "2026-11-01 clean place, played, Output clean"
studio_status: tested_studio
verification: tested_studio
```

Then re-run `python scripts/gamedev_kb.py report` — the verification counts are generated from the notes, so this
report's successor can quote real numbers instead of zeros.

## Deliberate non-claims

- No asset is described as "best", "high quality" or "safe". There is no ranking, because ranking would imply a
  test that was never run.
- No creator names are recorded. The research data did not include verified author attribution, and inferring it
  from an ID would be invention.

## Addendum — new Creator Store candidates (2026-11-01)

A separate official Creator Store search added three candidates after the 206-row source collection was
imported. These records are not part of `imports/raw/` and do not change its manifest.

| Measure | Value |
|---|---:|
| Original imported candidates | 206 |
| Additional Creator Store candidates | 3 |
| Total candidate notes | 209 |
| Newly verified in Studio | 0 |
| Newly confirmed for access or license | 0 |

The additional notes are [[asset-125578417483849]], [[asset-125209584906878]], and [[asset-8801933075]].
All three additional records are grade D from official Creator Store search/detail results. The Door
Creak Open details page was not readable by the web reader; its note states that limit and requires an
in-Studio check. See [[MOC-new-creator-store-candidates]] for their type and next review step.
