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

## Curry delivery audit follow-up (2026-11-02)

- `ServerScriptService.anti theft script` attempts to kick players based on skin-color brightness; its `Humanoid.SkinColor` access was not tested. Remove the discriminatory restriction after owner review; this vault session did not alter the place.
- DeliveryHandler references a missing `ReplicatedStorage.RemoteEvents` folder; DeliveryReset uses an undefined table, while each touch handler has an independent local table and does not require a bowl. Confirm behavior in a safe test and design server-authoritative completion.
- The initial character root is retained by the progress script, and the source menu uses fixed dimensions and camera motion. Test respawn, keyboard, touch, gamepad, reduced motion and responsive layout; the new helpers are untested. Review external dependencies and asset rights.

## Pop Popcorn audit follow-up (2026-11-02)

- Receipt UpdateAsync and ordinary snapshot saves are not shown sharing a lock, while receipt history is capped at 50. Review stale writes, retries, cross-server concurrency and recoverable idempotency before relying on fulfillment; no purchase test occurred.
- Production consumes a batch before yielding presentation and does not visibly check output placement success. Test interruption, full or removed output, plot reset and recovery; this is a source-level risk, not a reproduced incident.
- The new Luau helpers and crop blockout are untested. Verify device/input/accessibility, model rights, audio access, remaining services and performance.

## Drive and Catch audit follow-up (2026-11-02)

- Receipt fulfillment can return PurchaseGranted after a reported time-upgrade failure or maxed carry; the observed receipt-token map is volatile. Review intended compensation, durable PurchaseId idempotency, store-tab delivery and failure handling before relying on it.
- Area spend/unlock and spin consumption/reward delivery have separate persistence and grant steps; test interruptions, failed load/save, retries and concurrent servers. This is a static observation, not a measured incident.
- New snippets and vehicle blockout are untested; model and audio rights, runtime behavior, device input, accessibility and performance remain unverified. Continue the uncovered service and model inspection.

## Grow A Tree audit follow-up (2026-11-02)

- The receipt dispatcher is intentionally disabled and requires an independently reviewed, durable idempotent fulfillment transaction. Profile adapter does not implement session lifecycle. Test failure, retry, concurrent-server and shutdown scenarios before any deployment.
- The model builders are primitive blockouts, not exported game models; source asset rights and model geometry remain unverified. Device, input, focus and server integration remain untested for the new snippets.

- Static inspection did not cover every descendant or script, runtime behavior, purchase security, grant durability, responsive layout, accessibility or performance. Continue the scoped audit and test in a separate safe place.
- Observed image and audio IDs have unknown ownership, access and reuse rights; verify each before reuse. The session reward snippet has not been executed.

Open items only. Closed items move to [[CHANGELOG]].

## Public release review

| # | Issue | Why it is open | Next action |
|---|---|---|---|
| R-04 | The repository is published (`github.com/kaffeindecaf/kaffeins-dev-vault`, 3 commits), but the staged diff has not had a line-by-line human review since. | Everything pushed is public; an unreviewed commit is a public mistake by definition. | Review each commit's diff before pushing; the release checks that remain are in [[RELEASE_CHECKLIST]]. |
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
| I-10 | Older recipes still lack Studio execution. The v1.0.0 backend pack now has scoped mock/runtime evidence in [[BACKEND_SYSTEMS_TEST_REPORT]]. | Partially resolved; test each project's adopted code and retain exact scope labels. |
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

## UI pattern extraction (2026-11-02)

| # | Issue | Impact | Next action |
|---|---|---|---|
| I-29 | The UI patterns and component snippets are based on Explorer/property inspection in Edit mode; the place was not played and no device screenshot or accessibility pass was captured. | Static hierarchy and offset dimensions do not prove runtime layout, interaction quality, responsive fit, or controller support. | Play the place and capture the P21-06 desktop, phone portrait/landscape, and gamepad checks in a separate evidence pass. |
| I-30 | Image and sound IDs read from the place were not checked for external access, moderation state, license, or reuse permission. | A value in a user's place is not evidence that another experience can use it or that the note can redistribute the asset. | Follow [[G-asset-verification-workflow]] for any ID selected for reuse and document the rights/access evidence before promotion. |

## Agent work log rollout (2026-11-01)

| # | Issue | Impact | Next action |
|---|---|---|---|
| I-25 | `AGENTS.md` still has no pointer to the work log: the write was refused by the credential guard (approval prompt timed out), so §2 "read before you write" and §6 "when you finish" are unchanged. | The rules still bind through [[SCHEMA]] §11 and [[G-worklog-protocol]], but the file an agent reads *first* does not mention that a log is mandatory. | A human approves the two-line edit to `AGENTS.md` §2 and §6. Until then, [[NEXT_STEPS]] step 0 and the session-start prompt carry it. |
| I-26 | The `gh` CLI is not installed on the authoring machine. | Remote checks used `git` and a browser; `gh pr checks`, `gh release` and `gh api` workflows are unavailable, and CI status cannot be asserted. | Install GitHub CLI if PR-level automation is wanted. Not required for clone/push. |

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
- **I-07 / I-15** ~~No git repository, no diff history~~ → repository initialised 2026-11-01 on
  branch `main` and pushed to `github.com/kaffeindecaf/kaffeins-dev-vault` (`a907afc`); see
  [[worklog-2026-11-01-worklog-templates]].
- **I-16** ~~Dashboards could go stale silently~~ → each generated dashboard carries its generation date, and
  `report --write-dashboards` regenerates all five.
- **I-17** ~~Unclear what "tested" means for the tooling~~ → `verification: tested_local` added to the enum and
  documented in [[SCHEMA]], so tool tests never masquerade as Roblox Studio tests.
