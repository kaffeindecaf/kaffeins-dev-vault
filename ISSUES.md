---
id: N-ISSUES
type: report
title: ISSUES — blockers, uncertainties and open work
status: draft
updated: 2026-11-01
tags: [issues, blockers]
source_urls: []
---

# ISSUES

Open items only. Closed items move to [[CHANGELOG]].

## Public release review

| # | Issue | Why it is open | Next action |
|---|---|---|---|
| R-04 | The repository is not initialized and public staging has not been reviewed. | Generated files and the sanitized public source manifest need a final staged-file review. | Initialize Git, inspect the staged file list and diff, then publish. |
| R-05 | Creator names are missing from some original records. | The asset notes provide IDs and source URLs, and the extraction log does not name the source developer. | Preserve available source links; do not invent names. See [[CREDITS]]. |

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
| I-10 | No Roblox Studio test has been run for any recipe. Every code block is labelled `Untested:`. | Open by design — this vault was built without touching a place. |
| I-11 | Level design has one complete worked level plan, not a library of layouts. | Open. |
| I-12 | Progression/economy is deliberately thin (no manipulative-monetisation patterns documented as recommendations). | Closed as a decision: out of scope for V1. |

## Extraction pass (2026-11-01)

| # | Issue | Impact | Next action |
|---|---|---|---|
| I-19 | The nine extracted notes are **adapted, not executed**. | Copying them into a project without testing is the same risk as any untested recipe. | Run one in a blank place (start with `S-round-phase-machine`) and relabel it `Tested:`. |
| I-20 | Generalisation renamed things (currency, folders, module names). | A rename is a bug surface: a path or attribute name that no longer matches the source project. | Diff before use in the source project; the notes say which identifiers changed. |
| I-21 | The source place's AI module (48 KB) was **not** transcribed. | Only its architecture is documented (`R-npc-state-machine`, `R-npc-think-budget`); its specific patrol/catch logic exists nowhere else. | Read it again if that logic is needed; do not reconstruct it from memory. |

## Vault fusion (2026-11-01)

| # | Issue | Impact | Next action |
|---|---|---|---|
| I-22 | `Door Creak Open` details page was not readable through the web reader; its record relies on the official Creator Store search result. | Current page state, full description, access and license remain unchecked. | Open the exact listing in Studio and record the observed result before use. |
| I-23 | No pre-rename file-hash manifest was recorded for the source game-vault package. | The package root was renamed after inventory; a pre/post hash comparison is unavailable. | Treat the renamed source as preserved by same-volume directory move; capture a current manifest if future migration is planned. |
| I-24 | An empty legacy working directory remains locked by a running process outside this vault. | The 524 files are in the active destination and matched by SHA-256; the legacy directory has no vault contents. | Close the process holding that directory and remove the empty stub if desired. |

## Agent work log rollout (2026-11-01)

| # | Issue | Impact | Next action |
|---|---|---|---|
| I-25 | `AGENTS.md` still has no pointer to the work log: the write was refused by the credential guard (approval prompt timed out), so §2 "read before you write" and §6 "when you finish" are unchanged. | The rules still bind through [[SCHEMA]] §11 and [[G-worklog-protocol]], but the file an agent reads *first* does not mention that a log is mandatory. | A human approves the two-line edit to `AGENTS.md` §2 and §6. Until then, [[NEXT_STEPS]] step 0 and the session-start prompt carry it. |
| I-26 | The `gh` CLI is not installed on the authoring machine. | Remote checks used `git` and a browser; `gh pr checks`, `gh release` and `gh api` workflows are unavailable, and CI status cannot be asserted. | Install GitHub CLI if PR-level automation is wanted. Not required for clone/push. |

## Known cosmetic issues

| # | Issue | Impact | Mitigation |
|---|---|---|---|
| I-18 | `imports/raw/…/README.md` collides with the root `README.md` as an Obsidian file stem. | `[[README]]` is ambiguous inside Obsidian; the validator ignores it (imports/ is excluded from the walk). | Imports must stay byte-exact, so the file is not renamed. Link the root README by path when it matters, or open `imports/` as a separate vault. |

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
- **I-07 / I-15** ~~No git repository, no diff history~~ → repository initialised 2026-11-01 on
  branch `main` and pushed to `github.com/kaffeindecaf/kaffeins-dev-vault` (`a907afc`); see
  [[worklog-2026-11-01-worklog-templates]].
- **I-16** ~~Dashboards could go stale silently~~ → each generated dashboard carries its generation date, and
  `report --write-dashboards` regenerates all five.
- **I-17** ~~Unclear what "tested" means for the tooling~~ → `verification: tested_local` added to the enum and
  documented in [[SCHEMA]], so tool tests never masquerade as Roblox Studio tests.
