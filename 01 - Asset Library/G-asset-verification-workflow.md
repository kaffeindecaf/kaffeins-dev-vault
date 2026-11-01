---
id: G-asset-verification-workflow
type: guide
title: Asset verification workflow — from candidate to usable
status: reviewed
updated: 2026-11-01
tags: [assets, workflow, verification]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: "MOC-asset-library", "G-studio-audio-test", "G-studio-animation-test", "G-studio-model-inspection", "LICENSES_AND_SOURCES"
---

# Asset verification workflow

A candidate becomes usable through five checks. Each produces a recorded fact in the note, and no step may be
skipped because the listing "looks fine".

```text
candidate → resolves? → type correct? → accessible to THIS experience? → sounds/looks right? → rights clear? → usable
```

## Step 1 — Does the listing resolve? (2 min)

Open the `creator_store_url` from the note. Record `listing_status`:

| Result | Set | Meaning |
|---|---|---|
| page loads, name matches | `listed` | exists on the research date and today |
| 404 / removed | `not_listed` | dead ID — stop here |
| name is different | `listed` + note the mismatch | the ID may point at a different asset |

## Step 2 — Is the type what you think? (1 min)

The note's `asset_type` came from research. Confirm: audio is audio, a model is a model. A model pasted into a
`SoundId` produces silence, not an error.

## Step 3 — Is it accessible to *your* experience? (5–10 min)

This is the step that fails most often, and it can only be done in Studio:

| Type | Test | Blocker |
|---|---|---|
| audio | `Sound` in a clean place, `Play()`, read the Output | audio privacy: silent for other experiences |
| animation | `Animation` + `Animator`, check `track.Length` | animations are shared per experience |
| model/plugin | open in a **blank review place** and read every script | third-party code |

Manual checklists: [[G-studio-audio-test]] · [[G-studio-animation-test]] · [[G-studio-model-inspection]].

## Step 4 — Does it actually sound / look right? (subjective, 5 min)

An accessible asset can still be wrong: wrong length, wrong tone, loops with a click, a model with the wrong
scale. Listen/watch it in context (with the rest of the mix, or in the actual room).

## Step 5 — Rights (do this separately)

Access is not a licence. Record `license_status` only if the listing states terms you read. Otherwise leave it
`unknown` and treat the asset as unsuitable for anything commercial ([[LICENSES_AND_SOURCES]]).

## Writing the result back

```yaml
access_status: shared          # shared | restricted | blocked (with access_evidence)
license_status: unknown
safety_status: scripts_reviewed
studio_status: tested_studio
verification: tested_studio
test_evidence: "2026-11-01 blank place, Sound played, Output clean"
confidence: high
```

`access_evidence` is required by the validator as soon as `access_status != unknown`.

## The rule that keeps this honest

**Five verified assets beat two hundred unchecked ones.** Do this for the assets you are actually shipping, and
leave the rest honestly `untested`.

