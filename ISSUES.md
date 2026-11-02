---
id: N-ISSUES
type: report
title: ISSUES — blockers, uncertainties and open work
status: draft
updated: 2026-11-02
tags: [issues, blockers]
source_urls: []
---

# ISSUES

## 2026-11-02 — Practical snippets need Studio verification

- Exercise [[T-community-practical-snippets]] in an isolated Studio place, including teardown failures, rate-limit boundaries and zone transitions. Record evidence before promoting their verification status.

## 2026-11-02 — Community library evaluation

- [[R-community-libraries]] is research only: verify selected versions, licensing, compatibility and behavior in Studio before adoption. The supplied ProfileStore Creator Store listing could not be read by the research browser; its availability and access remain unchecked.

## Reusable pattern verification follow-up (2026-11-02)

- Selected code examples remain `Untested:` until they are exercised in a safe project test place.
- Before production adoption, verify persistence, receipt idempotency, interruption recovery, server
  ownership, accessibility, input behavior and performance in the target game.
- Asset IDs and model presence do not establish access, license or reuse rights; verify selected assets
  separately in the project that will use them.

Open items only. Closed items move to [[CHANGELOG]].

## Public release review

| # | Issue | Why it is open | Next action |
|---|---|---|---|
| R-04 | The repository is public and each new push publishes the current tree. | An unreviewed change can expose private project details or incorrect claims. | Review the full staged diff against [[RELEASE_CHECKLIST]] before any push. |
| R-05 | Creator names are missing from some original records. | The asset notes provide IDs and source URLs, and the extraction log does not name the source developer. | Preserve available source links; do not invent names. See [[CREDITS]]. |
| R-06 | Earlier public commits, tags and release archives may still contain project-specific notes removed from the current working tree. | Cleaning the current tree does not change already-published downloads or Git history. | Review and replace public release assets after the clean tree is approved. Do not rewrite history without a separate decision. |

## Blocked on a human in Roblox Studio

| # | Issue | Why it is blocked | Next action |
|---|---|---|---|
| I-01 | **No asset has been verified.** All 209 candidate notes (206 imported + 3 additional) are `untested`. | Requires opening Creator Store listings and playing audio in a Studio test place. An AI cannot hear audio or see another user's permissions. | Follow [[G-asset-verification-workflow]] on the assets in use. |
| I-02 | Animation access cannot be inferred from an ID. | Roblox shares animations per experience; a valid ID can load empty in yours. | Test in Studio, record `access_status`. |
| I-03 | Model/plugin safety is `uninspected` for all 32 model/plugin rows. | Requires reading every script inside the model in a blank place. | Inspect before use; record `safety_status`. |

## Known limitations of the tooling

| # | Issue | Impact | Mitigation |
|---|---|---|---|
| I-04 | Frontmatter uses a restricted YAML subset ([[DECISIONS]] D-0006). | Anchors, block scalars, multi-line strings and deep nesting are rejected. | Validator fails loudly (`yaml_block_scalar_unsupported`); keep frontmatter flat. |
| I-05 | `context --budget` approximates tokens at ~4 characters per token. | A pack may exceed a model's real token budget by a little. | Documented in the command output and in [[README]]; use `--count` to cap notes. |
| I-06 | Search is lexical (BM25 + boosts), not semantic. | A query using different vocabulary than the note can miss it. | Use the MOCs and tags; embeddings are deliberately deferred (roadmap P19). |
| I-27 | The test suite runs `scripts/import_assets.py` against the live vault root (`tests/test_kb.py`, importer test). | A "test" rewrites `IMPORT_REPORT.md` in the working tree, so a green run can leave an unexpected diff. Asset notes are subject to the idempotency check (`created=0 unchanged=206`) and are not modified. | Expect that diff and commit it, or point the test at a copied fixture vault. |
| I-08 | Dashboards are regenerated only when you run `report --write-dashboards`. | A stale dashboard is possible. | The dashboard header says when it was generated. |

## Content gaps (honest)

| # | Gap | Status |
|---|---|---|
| I-09 | Roblox encyclopedia is 24 notes — strong on architecture and security, thinner on animation blending internals. | Open; each note states its own scope. |
| I-10 | Older recipes still lack Studio execution. The v1.0.0 backend pack now has scoped mock/runtime evidence in [[BACKEND_SYSTEMS_TEST_REPORT]]. | Partially resolved; test each project's adopted code and retain exact scope labels. |
| I-11 | Level design has one complete worked level plan, not a library of layouts. | Open. |
| I-12 | Progression/economy is deliberately thin (no manipulative-monetisation patterns documented as recommendations). | Closed as a decision: out of scope for V1. |

## Extraction pass (2026-11-01)

| # | Issue | Impact | Next action |
|---|---|---|---|
| I-19 | The nine extracted notes are **adapted, not executed**. | Copying them into a project without testing is the same risk as any untested recipe. | Run one in a blank place (start with `S-round-phase-machine`) and relabel it `Tested:`. |
| I-20 | Generalisation renamed things (currency, folders, module names). | A rename is a bug surface: a path or attribute name that no longer matches the source project. | Diff before use in the source project; the notes say which identifiers changed. |

## Vault fusion (2026-11-01)

| # | Issue | Impact | Next action |
|---|---|---|---|
| I-22 | `Door Creak Open` details page was not readable through the web reader; its record relies on the official Creator Store search result. | Current page state, full description, access and license remain unchecked. | Open the exact listing in Studio and record the observed result before use. |

## UI pattern extraction (2026-11-02)

| # | Issue | Impact | Next action |
|---|---|---|---|
| I-29 | Several UI recipes have design-only evidence; no responsive runtime screenshots or accessibility pass are recorded. | Static layout guidance does not prove runtime fit, interaction quality or controller support. | Verify the recipe in a separate target project across supported devices and input methods before promotion. |
| I-30 | Asset identifiers found during project work do not establish external access, moderation status, license or reuse permission. | A value present in one project may not work in another or be eligible for redistribution. | Follow [[G-asset-verification-workflow]] for each candidate selected for reuse. |

## Known cosmetic issues

| # | Issue | Impact | Mitigation |
|---|---|---|---|
| I-28 | GitHub's frontmatter table renders an inline list (`tags: [a, b]`, `related: [...]`) as stray half-rows above the note body. | Cosmetic only; reading on GitHub looks slightly odd on all 494 notes. Obsidian and the CLI are unaffected. | Switch frontmatter lists to block style (`- item` lines, already supported by the parser) in one deliberate pass, or accept it. |
| I-18 | `imports/raw/…/README.md` collides with the root `README.md` as an Obsidian file stem. | `[[README]]` is ambiguous inside Obsidian; the validator ignores it (imports/ is excluded from the walk). | Imports must stay byte-exact, so the file is not renamed. Link the root README by path when it matters, or open `imports/` as a separate vault. |

## Backend v1.0.0 integration follow-up (2026-11-02)

| # | Issue | Impact | Next action |
|---|---|---|---|
| I-31 | Backend evidence uses mock storage/fake receipts and scoped Studio runtime checks, not live service integration. | Multi-server recovery, real purchases/gamepasses, real webhook delivery, animation playback and mobile performance are unproven. | Follow each system's integration checks and record evidence before production adoption; see [[BACKEND_SYSTEMS_TEST_REPORT]]. |
| I-32 | Account histories deliberately cap at 2,000 entries and never delete replay markers. | Long-running accounts can refuse new updates and defer purchases when they hit history/byte limits. | Design versioned archival/partitioning that preserves deduplication, migrate safely, and monitor headroom before enabling a live economy. |
| I-33 | Gift hints are ephemeral and offline senders require durable reconciliation or a later login. | A prepared transfer can remain pending after a crash before publishing a hint. | Add a budgeted durable-key sweep/known-sender job; never treat MessagingService or MemoryStore as the only recovery source. |

The backend pack's release identity is content versioning. It does not close these project-specific tests.

## Deferred by decision

| # | Item | Why |
|---|---|---|
| I-14 | All of Phase 19 (embeddings, MCP server, watch mode, editor integration) | Roadmap P19 is optional and depends on P18. Lexical search has not yet been shown insufficient, so building semantic retrieval now would add dependencies for no measured gain. |

## Resolved

- **R-01–R-03** ~~License and redistribution clearance~~ → maintainer selected CC0 1.0 and confirmed
  permission to redistribute the imported research and adapted notes. The attribution limits and
  sanitized public manifest are documented in [[CREDITS]] and [[RELEASE_CHECKLIST]].

- **I-13** ~~Import reconciliation uncertain~~ → 206 source rows, 206 distinct IDs, 0 duplicates,
  0 CSV/JSON mismatch (`IMPORT_REPORT.md`).
- **I-07 / I-15** ~~No repository or diff history~~ → repository is initialized and release preparation
  is tracked in [[RELEASE_CHECKLIST]].
- **I-16** ~~Dashboards could go stale silently~~ → each generated dashboard carries its generation date, and
  `report --write-dashboards` regenerates all five.
- **I-17** ~~Unclear what "tested" means for the tooling~~ → `verification: tested_local` added to the enum and
  documented in [[SCHEMA]], so tool tests never masquerade as Roblox Studio tests.
- **I-25** ~~Agent rules omitted the work-log handoff~~ → `AGENTS.md` now links the work-log protocol in
  its read-before-write and session-close sections.
