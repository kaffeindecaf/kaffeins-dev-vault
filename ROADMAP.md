---
id: N-ROADMAP
title: Kaffeins Dev Vault — Master Roadmap
type: project-roadmap
status: planned
updated: 2026-11-02
tags: [roblox, obsidian, knowledge-base, roadmap, ai-agents]
---

# ROADMAP — Kaffeins Dev Vault

## Reusable pattern verification follow-up — 2026-11-02

- [ ] Exercise selected untested snippets in an isolated place; cover ownership, failure/retry,
  interruption, reconnect and cleanup paths before promoting their verification status.
- [ ] Check UI integrations across target screen sizes and input methods, including safe areas,
  localization, focus and reduced motion.
- [ ] Verify asset access, licensing and model safety for each asset selected by a game project.

> **Purpose:** A real build plan for an Obsidian vault that serves as a human-readable game-dev encyclopedia, a Roblox asset catalog, reusable Luau systems library, horror-design reference, and a reliable local knowledge layer for Hermes / Claude Code / Codex / Gemini CLI / OpenCode.
>
> **Operating rule:** This file is the project task ledger. **Do not check a box without creating the deliverable and actually verifying the result.** Update `STATUS.md` and `CHANGELOG.md` after every completed phase.

## Project contract and scope

- **Target root:** A clearly named knowledge-base folder in the configured workspace. If an existing folder/vault is present, inspect, preserve and ask before destructive changes.
- **Required source import:** A Roblox horror asset research set with a reported 206 candidate IDs in 11 categories, when the actual source files are available. A candidate is **not** a license or permissions guarantee; no invented records or misleading status upgrades.
- **Primary audience:** The developer in Obsidian, plus AI coding agents reading/querying the same local files.
- **Minimum dependencies:** Markdown reader and Python 3.11+. SQLite FTS5 is preferred for full-text search but must have a fallback. Roblox Studio and community plugins are optional for the base experience.
- **Change management:** Preserve imports, prefer additive edits, keep diffs/backups, never access other projects without consent, protect secrets and request approval for dangerous/external operations.
- **Code fidelity:** Luau examples that were not executed are labeled as untested. CLI tests can be automated; Roblox runtime tests are only marked verified when run in Studio/published test environments.
- **Ordering:** P0 phases establish a trustworthy working skeleton; P1 phases provide useful content, retrieval and testing; P2 phases are optional enhancements. A phase can be partially completed while the vault remains useful.

## Status protocol

| Marker | Meaning | When to set |
|---|---|---|
| `- [ ]` | Not completed / not verified | Default |
| `- [x]` | Completed **and verified** | Only after evidence |
| `⛔ Blocked` | Requires access/approval/dependency | Keep task unchecked; log to `ISSUES.md` |
| `~ Partial` | Some implementation exists | Keep task unchecked; document remainder |
| `P0 / P1 / P2` | Priority, not schedule | Work in dependency order |

**After every phase:** update checkboxes and `STATUS.md` (current phase, completed task IDs, validated commands, next command), `CHANGELOG.md` (dated, real changes), `ISSUES.md` (blockers) and `NEXT_STEPS.md` (three concrete next actions). If interrupted, the next agent must be able to continue solely from these files.

## Definition of Done (V1)

- [x] Vault exists, is safe to open and has working Markdown navigation with no plugins.
- [x] Schemas, note templates, citation/provenance rules and working content exist.
- [x] Source assets are imported accurately if source files are present; absent assets remain honestly pending.
- [x] Each major section has substantive examples, not empty placeholder notes.
- [x] Agent rules and context packs are usable without fictional integrations.
- [x] Local CLI validates notes, indexes/searches content and exports machine-readable results.
- [x] CLI output provides source file paths, verification warnings and reproducible examples.
- [x] Security tests protect files/secrets/outside paths and imported scripts are never executed.
- [x] Actual test output, known limitations, clear next steps and an updated roadmap are present.

## Workstream / dependency map

```text
00 Discovery & safety
   ├── 01 Vault scaffold ── 02 Schema/templates ── 03 Data migration ── 04 Asset catalog
   │                        └── 05 Roblox encyclopedia ── 06 Mechanics cookbook
   │                                            ├── 07 Horror design
   │                                            ├── 08 Enemy AI
   │                                            ├── 09 UI/UX and feel
   │                                            └── 10 Level design
   ├── 11 Agent rules/context (depends on schema + code foundations)
   └── 12 CLI retrieval (depends on schema + migration + agent rules)
                  ├── 13 Provenance & quality
                  ├── 14 Bug bank & regression
                  ├── 15 Dashboards & plugins
                  ├── 16 Project templates
                  └── 17 Security / performance
                              └── 18 Release acceptance
                                         └── 19 Optional extension backlog
```

**Implementation strategy:** Build a thin, working vertical slice first (one asset note, one mechanic, one bug example, one query end-to-end), then expand content and features. Do not defer testing until the end.

---

## Phase 00 — Discovery, safeguards and baseline (P0)

**Depends on:** None.  **Deliverables:** STATUS.md; DECISIONS.md; initial inventory report.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P00-01** Check whether running on Windows, Linux, WSL or other supported system; record platform assumptions.
- [x] **P00-02** Locate the configured workspace, accounting for platform-specific folders and redirection.
- [x] **P00-03** Identify the target Obsidian vault, its current owner, and whether it already exists.
- [x] **P00-04** Inspect for existing `.obsidian/` settings and preserve them without unsolicited edits.
- [x] **P00-05** Inventory any prior knowledge bases and locate the 206-entry horror asset collection or ZIP if present.
- [x] **P00-06** Count files and hash original data files before attempting migration; record SHA-256 digests.
- [x] **P00-07** Detect Python and SQLite FTS5 capabilities; provide fallback for unavailable features.
- [x] **P00-08** Detect available Git, Obsidian, Roblox Studio, Rojo, Selene and StyLua without forcing installation.
- [x] **P00-09** Check directory write permissions and choose a safe alternate location when Desktop is unavailable.
- [x] **P00-10** Define scope boundaries: allowed vault root, imports, exports, caches, and test fixtures.
- [x] **P00-11** Write non-destructive backup and rollback policy, especially for preexisting files.
- [x] **P00-12** Document allowed external lookups and explicitly prohibit automatic purchases or account changes.
- [x] **P00-13** Specify secret handling: `.env`, credentials, cookies and hidden application data are excluded from indexing.
- [x] **P00-14** Define local-first and offline operation as baseline requirements.
- [x] **P00-15** Create initial `DECISIONS.md` entries for chosen project name, path, tech stack and assumptions.
- [x] **P00-16** Create `ISSUES.md` for blockers, uncertainties and access errors with assigned next actions.
- [x] **P00-17** Create `STATUS.md` with current phase, checked milestone count and reproducible next command.
- [x] **P00-18** Write a simple baseline report listing detected inputs, existing data and intended outputs.

**Acceptance gate P00:** A fresh run can identify its exact operating root and leave all unrelated data untouched.

- [x] **GATE-P00** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 01 — Vault scaffold, documentation and navigation (P0)

**Depends on:** 00.  **Deliverables:** HOME.md; README.md; project folders; MOCs.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P01-01** Establish the approved Kaffeins Dev Vault location without silently replacing files.
- [x] **P01-02** Create root `HOME.md` with short links to library areas, tasks and active projects.
- [x] **P01-03** Create root `README.md` explaining goals, opening in Obsidian and no-plugin navigation.
- [x] **P01-04** Copy the provided master prompt into a stable reference location `07 - AI Agent Knowledge/Agent Rules/MASTER_AGENT_PROMPT.md`.
- [x] **P01-05** Create the 14 top-level content folders from the master prompt, preserving readable names.
- [x] **P01-06** Create `imports/raw` and `imports/staging`, plus `exports`, `scripts`, `tests`, `config`.
- [x] **P01-07** Create a category-level MOC in each major library using proper Obsidian links.
- [x] **P01-08** Create an `Asset Library` overview and per-type index stubs that are clearly marked as stubs.
- [x] **P01-09** Create a `Roblox Development` MOC with paths to reference, recipes and security notes.
- [x] **P01-10** Create a `Horror Design` MOC connecting audio, pacing, lighting and AI director concepts.
- [x] **P01-11** Create a `UI UX` MOC with mobile, gamepad, screen sizes and accessibility sections.
- [x] **P01-12** Create a `Code Snippets` MOC with verified, proposed and example-only sections.
- [x] **P01-13** Create a `Projects` MOC with a reusable project template link.
- [x] **P01-14** Add `NEXT_STEPS.md`, `CHANGELOG.md`, `PROJECT_CONFIG.md` and `SCHEMA.md` starter files.
- [x] **P01-15** Use human-readable filenames without collisions; prefer stable note IDs for technical references.
- [x] **P01-16** Add clear cross-links from `HOME.md` to at least one real populated note in each initial category.
- [x] **P01-17** Create `config/vault.json` containing relative content roots and deterministic export paths.
- [x] **P01-18** Add a short guide for linking/embedding diagrams and source screenshots while honoring rights.
- [x] **P01-19** Create a `LICENSES_AND_SOURCES.md` policy for links, attributions and code snippet licensing.
- [x] **P01-20** Check no broken links among newly created notes using a basic Markdown link scanner.
- [x] **P01-21** Check that plain Markdown viewers can navigate the tree even without Obsidian installed.
- [x] **P01-22** Run a folder collision check on case-insensitive Windows filesystems.

**Acceptance gate P01:** User can open HOME.md and navigate major categories without community plugins.

- [x] **GATE-P01** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 02 — Metadata schema, identity and reusable note templates (P0)

**Depends on:** 01.  **Deliverables:** SCHEMA.md; 14+ note templates; schema fixtures.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P02-01** Define stable unique string IDs with prefixes for asset, system, bug, project, source, prompt and reference.
- [x] **P02-02** Define required common frontmatter fields (`id`, `type`, `title`, `status`, `updated`, `tags`, `source_urls`).
- [x] **P02-03** Define controlled values for note type, confidence and verification status.
- [x] **P02-04** Define typed `asset_id` as string to preserve numeric precision and exact spelling.
- [x] **P02-05** Define `asset_type` enum: audio, animation, model, decal, image, mesh, plugin, unknown.
- [x] **P02-06** Define distinct listing, license, access, safety, Studio and published-runtime review fields.
- [x] **P02-07** Define `source_grade` passthrough for original research evidence, including D/G/R/F/I/S.
- [x] **P02-08** Define `source_urls` as a list, `related` as stable note IDs, and dates as ISO 8601.
- [x] **P02-09** Define `client_server` and `roblox_services` properties for technical recipes.
- [x] **P02-10** Define `test_status`, `test_method`, `tested_at`, `reviewed_by` and `test_evidence` fields.
- [x] **P02-11** Define note title naming rules, tag taxonomy and acceptable link styles.
- [x] **P02-12** Define how migrated source fields remain available in provenance metadata.
- [x] **P02-13** Write template for candidate asset with correct per-type usage and caveats.
- [x] **P02-14** Write template for Roblox service/API note with official documentation links.
- [x] **P02-15** Write template for Luau reusable module and API contract.
- [x] **P02-16** Write template for gameplay mechanic recipe.
- [x] **P02-17** Write template for enemy behavior or decision state.
- [x] **P02-18** Write template for horror direction/pacing pattern.
- [x] **P02-19** Write template for UI component and accessibility checks.
- [x] **P02-20** Write template for VFX/lighting recipe with performance budget.
- [x] **P02-21** Write template for bug and verified fix, including repro/regression.
- [x] **P02-22** Write templates for project, experiment, architecture decision, source record and agent prompt.
- [x] **P02-23** Create valid positive and invalid negative schema fixtures for automated validation.
- [x] **P02-24** Prove parser can round-trip representative Unicode titles, tags and embedded links.

**Acceptance gate P02:** All baseline note types have documented schemas, templates and validation fixtures.

- [x] **GATE-P02** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 03 — Non-destructive import of the 206-ID horror asset research set (P0)

**Depends on:** 00, 02.  **Deliverables:** imports/raw; normalized asset notes; import manifest.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P03-01** Locate the asset research source directory or archive; do not pretend it exists if missing.
- [x] **P03-02** If source is missing, create clear `imports/INSTRUCTIONS.md`, mark tasks blocked and proceed with other phases.
- [x] **P03-03** Copy sources to `imports/raw` without changing original filenames or bytes.
- [x] **P03-04** Validate ZIP entries and reject zip-slip paths, absolute paths and unsafe symlinks.
- [x] **P03-05** Load `ALL_ASSETS.json` as candidate source of truth; retain CSV for comparison.
- [x] **P03-06** Inspect source structure before mapping; preserve any unfamiliar fields in an `original` section or sidecar.
- [x] **P03-07** Record source file hashes, row count and distinct `asset_id` count.
- [x] **P03-08** Verify IDs are strings or safely stringify only fully valid exact integer digits.
- [x] **P03-09** Map existing `asset_type` and category to canonical enums without erasing category descriptions.
- [x] **P03-10** Carry over asset names, suggested use, research source, Creator Store links and evidence grades.
- [x] **P03-11** For each record, generate a stable Markdown note and store raw provenance metadata.
- [x] **P03-12** Never infer creator identity, active permissions, licensing status or audio playback from source-grade D.
- [x] **P03-13** Keep `studio_status` and `license_status` as unchecked until test evidence exists.
- [x] **P03-14** Preserve original 11 category Markdown notes under imports if necessary for traceability.
- [x] **P03-15** Build a category-aware ID/name lookup and detect malformed or duplicated records.
- [x] **P03-16** On duplicates, report exact source rows; do not discard data silently.
- [x] **P03-17** Reconcile normalized count against **actual** distinct ID count, with 206 as a reference rather than a fabricated result.
- [x] **P03-18** Write `IMPORT_REPORT.md` documenting imported, skipped, duplicated and needs-review items.
- [x] **P03-19** Create links from category MOCs to migrated asset entries.
- [x] **P03-20** Add migration idempotency: second import should not duplicate notes or overwrite manual reviews.
- [x] **P03-21** Test rollback by importing into a temporary fixture folder and comparing hashes before and after.
- [x] **P03-22** Mark every migrated candidate `not_tested` until individually verified.

**Acceptance gate P03:** Original sources remain intact, and ID counts reconcile against source with no silently lost records.

- [x] **GATE-P03** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 04 — Asset catalog, curation and verification workflow (P1)

**Depends on:** 03.  **Deliverables:** asset browser; verification checklists; asset quality rubric.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P04-01** Create cross-category asset dashboards grouped by asset type.
- [x] **P04-02** Create filter views/indices for audio, animation, model, plugin, image, decal, mesh and unknown.
- [x] **P04-03** Create index for footsteps by surface/material and walking pace.
- [x] **P04-04** Create index for doors: squeaks, latches, handles, locks and slams.
- [x] **P04-05** Create index for indoor and outdoor ambience including electrical hum, weather and room tone.
- [x] **P04-06** Create index for UI sounds: menu, hover, confirm, error, notification and device beeps.
- [x] **P04-07** Create index for horror cues: tension builds, stingers, sparse music, silence transitions.
- [x] **P04-08** Create index for icons, UI packs, props, rigs and reusable model systems.
- [x] **P04-09** Create index for animation IDs by rig type, target movement and ownership caveats.
- [x] **P04-10** Create flashlight and atmospheric lighting asset collection with potential performance costs.
- [x] **P04-11** Define quality rubric: clarity, cohesion, loopability, moderation risk, provenance, technical suitability.
- [x] **P04-12** Define review outcomes: candidate, inspected, accessible, tested_studio, tested_published, rejected.
- [x] **P04-13** Keep rights/license review separate from functional verification.
- [x] **P04-14** Write a safe manual Studio checklist for standalone audio playback and log observations.
- [x] **P04-15** Write a safe manual Studio checklist for animation ownership and compatible rig setup.
- [x] **P04-16** Write a safe manual Studio checklist for third-party model/plugin script inspection in an empty place.
- [x] **P04-17** Document audio placement (SoundService vs world/Attachment) and spatial-rolloff considerations.
- [x] **P04-18** Document when editing/reuploading a sound requires creator authorization; do not assume permission.
- [x] **P04-19** Create a curated 'favorites' view with explicit criteria and no invented rankings.
- [x] **P04-20** Provide an asset rejection log for broken, inaccessible, misleading or low-quality entries.
- [x] **P04-21** Create `ASSET_VERIFICATION_REPORT.md` with totals for each real status.

**Acceptance gate P04:** Every asset has a documented category/type and no unchecked entry is described as verified.

- [x] **GATE-P04** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 05 — Roblox / Luau fundamentals and engineering encyclopedia (P1)

**Depends on:** 01, 02.  **Deliverables:** service/API notes; code patterns; source links.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P05-01** Create Luau language overview: type annotations, tables, modules, iteration, error handling.
- [x] **P05-02** Document how `--!strict` helps and where gradual typing is appropriate.
- [x] **P05-03** Create guide to Script, LocalScript, ModuleScript placement and execution context.
- [x] **P05-04** Document server authority and replication boundaries with examples.
- [x] **P05-05** Document RemoteEvent and RemoteFunction use with validation and rate-limiting guidance.
- [x] **P05-06** Create safe pattern for server-side request validation and anti-spam budgets.
- [x] **P05-07** Document Player, Character, Humanoid, Animator, UserInputService and ContextActionService.
- [x] **P05-08** Document TweenService patterns and cancellation/cleanup.
- [x] **P05-09** Document RunService update frequencies; avoid per-frame loops for non-frame work.
- [x] **P05-10** Document Debris and alternatives for deterministic cleanup.
- [x] **P05-11** Create janitor/maid connection-cleanup pattern and explain memory leaks.
- [x] **P05-12** Document Workspace raycasts, RaycastParams and collision filters.
- [x] **P05-13** Document CollectionService tags for feature discovery and modular systems.
- [x] **P05-14** Document attributes vs ValueObjects vs ModuleScript config tradeoffs.
- [x] **P05-15** Document SoundService, Sound and 3D sound parenting.
- [x] **P05-16** Document Animation/Animator loading, track priorities, blending and ownership requirements.
- [x] **P05-17** Document DataStoreService retries, budgets, versioning, and failure handling.
- [x] **P05-18** Document MemoryStoreService and MessagingService high-level use/limits with sources.
- [x] **P05-19** Document StreamingEnabled and streamed-out object failure cases.
- [x] **P05-20** Document PathfindingService costs and navigation retries.
- [x] **P05-21** Document server/client logging, tracing, structured error reports.
- [x] **P05-22** Document common UI scaling and anchorpoint pitfalls across aspect ratios.
- [x] **P05-23** Document module dependencies, folder ownership and dependency cycles.
- [x] **P05-24** Document Roblox content restrictions, moderation and asset ownership at high level.
- [x] **P05-25** Create a `Roblox API links.md` referencing official Creator Hub as canonical source.
- [x] **P05-26** Distinguish production patterns from pseudocode with explicit status labels.
- [x] **P05-27** Provide at least five focused Luau snippets with correct placement instructions.

**Acceptance gate P05:** Core Roblox notes have sources, clear execution context and representative safe examples.

- [x] **GATE-P05** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 06 — Reusable mechanics cookbook and tested code examples (P1)

**Depends on:** 05.  **Deliverables:** recipe notes; modules; smoke-test scenes/checklists.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P06-01** Specify server-authoritative pickup interaction with distance and ownership checks.
- [x] **P06-02** Specify inventory data model, stackability, limits and replication contract.
- [x] **P06-03** Specify reusable interact prompt with keyboard, touch and gamepad semantics.
- [x] **P06-04** Specify smart doors with state transitions, locks, hinge behavior and sound hooks.
- [x] **P06-05** Specify key/keycard locks and access control with server-side checks.
- [x] **P06-06** Specify flashlight with battery/charge state, flicker, recharge and accessibility settings.
- [x] **P06-07** Specify portable item inspection and world-to-inventory flow.
- [x] **P06-08** Specify hiding spots with occupancy, cancel and multiplayer race conditions.
- [x] **P06-09** Specify sprinting/stamina as fair gameplay with server reconciliation.
- [x] **P06-10** Specify crouch/crawl with animation and collision tradeoffs.
- [x] **P06-11** Specify vaulting/climbing with safe positional checks.
- [x] **P06-12** Specify interactable drawers, cabinets and loot containers.
- [x] **P06-13** Specify multi-step puzzle framework with deterministic reset behavior.
- [x] **P06-14** Specify pressure plates, switches and timed sequences.
- [x] **P06-15** Specify quest/objective tracker with save-compatible progress.
- [x] **P06-16** Specify dialogue flow and branching consequences.
- [x] **P06-17** Specify checkpoints and respawn state recovery.
- [x] **P06-18** Specify configurable camera and head-bob with reduced-motion toggle.
- [x] **P06-19** Specify notification system with priority and duplicate suppression.
- [x] **P06-20** Specify item inspection UI with responsive layout.
- [x] **P06-21** Specify save/load with schema migration and failures.
- [x] **P06-22** Specify multiplayer late-join synchronization and reconnect behavior.
- [x] **P06-23** Specify reusable configuration module rather than hardcoded asset IDs in logic.
- [x] **P06-24** For each recipe list services, dependencies, execution context, API, failure modes and test cases.
- [x] **P06-25** Create a well-commented, runnable reference snippet for the highest-priority three recipes.
- [x] **P06-26** Never label a code snippet as Studio-tested without execution evidence.

**Acceptance gate P06:** Top three recipes are reproducibly testable; remaining recipes are honestly labeled design/reference.

- [x] **GATE-P06** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 07 — Horror pacing, audio direction and atmosphere (P1)

**Depends on:** 04, 06.  **Deliverables:** horror MOCs; adaptive director specification; VFX/audio recipes.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P07-01** Create hierarchy of tension: baseline calm, suggestion, buildup, threat, release and cooldown.
- [x] **P07-02** Document non-graphic environmental storytelling patterns.
- [x] **P07-03** Document uncertainty, anticipation and event rarity without relying on constant jumpscares.
- [x] **P07-04** Create adaptive horror director inputs: player progress, location, events and recent scares.
- [x] **P07-05** Define adaptive director outputs: ambience mix, light variation, ambient events and enemy intensity.
- [x] **P07-06** Design deterministic seed and cooldown logic to avoid repetitive scares.
- [x] **P07-07** Design multiplayer fairness for event timing and replicated cues.
- [x] **P07-08** Define configurable intensity cap and accessibility settings.
- [x] **P07-09** Create ambience layering guide with volume hierarchy and transitions.
- [x] **P07-10** Create sound occlusion and indoor/outdoor transition notes with Roblox feasibility caveats.
- [x] **P07-11** Create interactive door sound-state matrix for open/close/locked/strain.
- [x] **P07-12** Create room-tone, electrical hum, radio interference and weather sound palettes.
- [x] **P07-13** Create camera and light flicker recipes with seizure-safety precautions and disable switch.
- [x] **P07-14** Create safe-room rhythm and low-intensity decompression patterns.
- [x] **P07-15** Create environmental events catalog: distant steps, shifting shadows, object noises and silence.
- [x] **P07-16** Create a horror director API contract and minimal module sketch.
- [x] **P07-17** Document profiling budgets for sources, particles and post-processing.
- [x] **P07-18** Create difficulty/intensity tuning worksheet with playtester observations.
- [x] **P07-19** Link every example to existing candidate asset notes only when assets actually exist.

**Acceptance gate P07:** Horror director design specifies states, cooldowns, accessibility controls and a test plan.

- [x] **GATE-P07** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 08 — Enemy AI and NPC behavioral systems (P1)

**Depends on:** 05, 06.  **Deliverables:** state-machine reference; behavior recipes; tests.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P08-01** Create enemy taxonomy: patrol, investigate, watcher, stalker, pursuer and environmental nuisance.
- [x] **P08-02** Define server-owned state machine with Idle, Patrol, Suspicious, Investigate, Chase, Search and Recover.
- [x] **P08-03** Define explicit state transitions, guards, cooldowns and timeouts.
- [x] **P08-04** Document detection models using distance, line of sight, hearing and last known position.
- [x] **P08-05** Document behavior trees vs finite-state machines vs utility AI tradeoffs.
- [x] **P08-06** Write patrol waypoint schema and navigation fallbacks.
- [x] **P08-07** Document PathfindingService path recalculation thresholds and error recovery.
- [x] **P08-08** Document navmesh/door/blocker conditions and streaming issues.
- [x] **P08-09** Define perception budgets and staggered think ticks instead of all-NPC per-frame work.
- [x] **P08-10** Design memory of last seen/heard position with expiration.
- [x] **P08-11** Define multiplayer target selection and anti-oscillation rules.
- [x] **P08-12** Create pursuit throttling and stuck-detection recovery.
- [x] **P08-13** Define explicit safe room and game-state restrictions.
- [x] **P08-14** Document NPC animation handling, movement blending and rig compatibility.
- [x] **P08-15** Document spatial audio cues for enemy state transitions.
- [x] **P08-16** Create debugging overlays/logging guide that can be disabled in release.
- [x] **P08-17** Document deterministic test harness for transition behavior where feasible.
- [x] **P08-18** Create a small reference FSM module with testable transitions.
- [x] **P08-19** Document worst-case player/NPC scaling assumptions and profiling scenarios.
- [x] **P08-20** Create behavioral test matrix covering lost target, blocked door and disconnected player.

**Acceptance gate P08:** AI reference demonstrates bounded updates and valid transitions; known limitations are documented.

- [x] **GATE-P08** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 09 — UI/UX, responsive design, accessibility and game feel (P1)

**Depends on:** 05, 06.  **Deliverables:** component cookbook; design tokens; sample UI notes.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P09-01** Create UI style guide with spacing, type scales, color tokens and contrast.
- [x] **P09-02** Create horror HUD design guide with restrained emphasis and readable affordances.
- [x] **P09-03** Document UDim2 Scale vs Offset and responsive anchors.
- [x] **P09-04** Document AnchorPoint, constraints, UIScale and device inset behavior.
- [x] **P09-05** Create troubleshooting note for buttons drifting on resize.
- [x] **P09-06** Create troubleshooting note for unintended widening during resize.
- [x] **P09-07** Document mobile safe areas and touch target sizing.
- [x] **P09-08** Document controller focus/navigation and keyboard-only support.
- [x] **P09-09** Document text scaling, localization and long-string overflow.
- [x] **P09-10** Create accessible reduced-motion/reduced-flash settings policy.
- [x] **P09-11** Create main menu, pause menu and settings menu design patterns.
- [x] **P09-12** Create inventory slots, item tooltips and drag/drop design patterns.
- [x] **P09-13** Create interaction prompts, contextual affordances and feedback states.
- [x] **P09-14** Create notifications/toasts, objective updates and failure alerts.
- [x] **P09-15** Document UI transition recipes with TweenService and cancellable animations.
- [x] **P09-16** Document camera shake/head bob with user-controlled intensity.
- [x] **P09-17** Document sound layering for UI hover/select/cancel/error cues.
- [x] **P09-18** Create design reference note for monochrome horror icons with citation links.
- [x] **P09-19** Create guidelines for UI image assets, 9-slice usage and texture memory.
- [x] **P09-20** Create template for Excalidraw UI wireframes and non-plugin Markdown fallback.
- [x] **P09-21** Create minimum responsive verification matrix for multiple screen ratios.
- [x] **P09-22** Ensure examples do not use proprietary UI kits without rights.

**Acceptance gate P09:** UI cookbook covers desktop, phone, controller, responsive scaling and motion alternatives.

- [x] **GATE-P09** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 10 — Level design, puzzles, narrative and progression (P1)

**Depends on:** 06, 07.  **Deliverables:** level patterns; puzzle specs; progression notes.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P10-01** Create level blockout template with room purpose, exits and player sight lines.
- [x] **P10-02** Create top-down layout reference for hub-and-spoke and looping floor plans.
- [x] **P10-03** Document landmarks, orientation cues and readable navigation under low light.
- [x] **P10-04** Create safe room vs threat zone design patterns.
- [x] **P10-05** Document branching route choices and bottleneck avoidance in multiplayer.
- [x] **P10-06** Create room progression structure: introduction, exploration, reveal, challenge and release.
- [x] **P10-07** Create room-based puzzle catalog with accessibility and reset paths.
- [x] **P10-08** Document clue placement, redundancy and anti-softlock safeguards.
- [x] **P10-09** Define escape-room puzzle dependency graph template.
- [x] **P10-10** Define procedural generation constraints to preserve solvable paths.
- [x] **P10-11** Document seeded generation for reproducible debugging.
- [x] **P10-12** Document streaming and object budget implications for complex maps.
- [x] **P10-13** Create enemy spawn placement rules avoiding unfair spawns.
- [x] **P10-14** Document checkpoints, session duration considerations and pacing controls.
- [x] **P10-15** Create unlock/progression design examples without manipulative monetization patterns.
- [x] **P10-16** Document economy and rewards if project scope actually needs them.
- [x] **P10-17** Create level playtest checklist for navigation, stuck states and puzzle comprehension.
- [x] **P10-18** Create concept art/reference linking policy without copying assets.
- [x] **P10-19** Create a worked sample level plan for an abandoned building.

**Acceptance gate P10:** A sample playable-level specification is complete, traceable and checks puzzle solvability.

- [x] **GATE-P10** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 11 — Agent rules, prompting, context packs and project memory (P1)

**Depends on:** 02, 05.  **Deliverables:** AGENTS.md; agent role guides; context packs.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P11-01** Write `AGENTS.md` describing vault root, priorities, source fidelity and safe mutation protocol.
- [x] **P11-02** Write an agent brief for Hermes that uses local files/tools only as actually supported.
- [x] **P11-03** Write an agent brief for Codex, acknowledging configuration may differ.
- [x] **P11-04** Write an agent brief for Claude Code, with commands instead of fictitious integrations.
- [x] **P11-05** Write an agent brief for Gemini CLI, with paths and source links.
- [x] **P11-06** Write an agent brief for OpenCode with project-scoped conventions.
- [x] **P11-07** Create prompt template for finding three asset candidates and reporting access uncertainty.
- [x] **P11-08** Create prompt template for generating a secure server-authoritative mechanic.
- [x] **P11-09** Create prompt template for Luau code review and remote-security checks.
- [x] **P11-10** Create prompt template for performance profiling and targeted improvement.
- [x] **P11-11** Create prompt template for animation/inventory/UI implementation.
- [x] **P11-12** Create prompt template for investigating a bug against previous issue records.
- [x] **P11-13** Create prompt template for improving a horror director with testable outcomes.
- [x] **P11-14** Create context pack for Roblox client/server rules.
- [x] **P11-15** Create context pack for UI responsive design.
- [x] **P11-16** Create context pack for horror pacing and accessibility.
- [x] **P11-17** Create context pack for third-party asset validation.
- [x] **P11-18** Create citations rule: include note paths and verification status with answers.
- [x] **P11-19** Create instruction not to treat AI recollections as evidence or overwrite source facts.
- [x] **P11-20** Define proposed -> reviewed -> accepted -> tested knowledge promotion stages.
- [x] **P11-21** Document how humans review generated notes and reject unsourced assertions.
- [x] **P11-22** Define a change-proposal convention and optional patch/diff format.
- [x] **P11-23** Create an AI session wrap-up template with tasks completed, tests and next actions.

**Acceptance gate P11:** An agent can read AGENTS.md, retrieve evidence and respond without inventing permissions or tests.

- [x] **GATE-P11** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 12 — Local search, indexing, retrieval and automation CLI (P1)

**Depends on:** 02, 03, 11.  **Deliverables:** scripts/gamedev_kb.py; local index; exports; tests.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P12-01** Create a cross-platform CLI entry point with helpful `--help` and nonzero failure codes.
- [x] **P12-02** Implement `doctor` showing paths, dependencies and source counts.
- [x] **P12-03** Implement deterministic Markdown walker confined to configured vault root.
- [x] **P12-04** Exclude `.git`, secrets, caches, temporary exports and generated indexes.
- [x] **P12-05** Handle Unicode filenames, Windows paths, case conflicts and line endings.
- [x] **P12-06** Implement safe frontmatter reader using vetted dependency or restricted parser; document limitations.
- [x] **P12-07** Implement schema validation for required fields, enums, dates and unique IDs.
- [x] **P12-08** Implement duplicate-ID report and duplicate-asset-ID report.
- [x] **P12-09** Implement broken Obsidian wiki-link resolution report.
- [x] **P12-10** Implement SQLite FTS5 indexing when available.
- [x] **P12-11** Implement reliable no-FTS fallback search.
- [x] **P12-12** Ensure index builds are deterministic and idempotent.
- [x] **P12-13** Implement `search QUERY` with filters for type, category, status and limit.
- [x] **P12-14** Implement `search --json` with machine-readable citations and note metadata.
- [x] **P12-15** Implement an `asset ID` exact lookup that preserves numeric strings.
- [x] **P12-16** Implement `context QUERY --budget N` with notes, citations and compact excerpts.
- [x] **P12-17** Document that token-budget approximation is approximate, not a tokenizer guarantee.
- [x] **P12-18** Implement warnings on untested assets and permission-unknown entries.
- [x] **P12-19** Implement `export --format json` producing normalized records.
- [x] **P12-20** Implement `export --format csv` with safe quoting and stable columns.
- [x] **P12-21** Implement `report` for counts, categories, missing sources and verification states.
- [x] **P12-22** Implement CLI `validate` with summary and actionable per-file errors.
- [x] **P12-23** Add JSON schema or Python checks for each major note type.
- [x] **P12-24** Create CLI fixtures: valid note, malformed frontmatter, duplicate IDs, outside symlink, fake secret.
- [x] **P12-25** Create a test for exclusion of sensitive filenames and content.
- [x] **P12-26** Create a test for symlink/path traversal boundaries.
- [x] **P12-27** Create a test for ranking a title/tag match above incidental body mention.
- [x] **P12-28** Create a test for safe corrupted-cache recovery.
- [x] **P12-29** Create a test confirming second index run yields equivalent searchable results.
- [x] **P12-30** Document actual run commands for PowerShell and Bash.

**Acceptance gate P12:** The documented CLI commands run and have automated tests; outputs cite file paths and statuses.

- [x] **GATE-P12** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 13 — Documentation sources, provenance and knowledge quality (P1)

**Depends on:** 02, 12.  **Deliverables:** sources index; review rubrics; stale-content reports.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P13-01** Write editorial standard: one factual claim, one trustworthy source or an explicit uncertainty tag.
- [x] **P13-02** Prefer official Roblox Creator Hub for platform API and behavior statements.
- [x] **P13-03** Store content source URL, publisher/author when known and access date.
- [x] **P13-04** Check links for malformed URLs; do not claim to have visited sources without actual access.
- [x] **P13-05** Define per-source quote and reproduction limits and attribution rules.
- [x] **P13-06** Create source record templates for docs, tutorials and community reports.
- [x] **P13-07** Label community-sourced patterns separately from official API guidance.
- [x] **P13-08** Create status taxonomy: idea, draft, reviewed, tested, deprecated.
- [x] **P13-09** Create confidence rubric: low, medium, high grounded in evidence.
- [x] **P13-10** Create source freshness report and `needs-review` dashboard.
- [x] **P13-11** Define how to handle Roblox platform changes or deprecated API pages.
- [x] **P13-12** Link every imported record to its original research source.
- [x] **P13-13** Add review checklist for AI-generated implementation claims.
- [x] **P13-14** Add writing guidelines for succinct introductions and troubleshooting branches.
- [x] **P13-15** Create rules for original diagrams, screenshots and image rights.
- [x] **P13-16** Create editorial checklist for anti-duplication and canonical linking.
- [x] **P13-17** Run a sample provenance audit on at least ten notes and record results.

**Acceptance gate P13:** Sample audit shows claims and asset IDs trace back to sources and uncertain facts are labeled.

- [x] **GATE-P13** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 14 — Bug graveyard, experiments and regression testing (P1)

**Depends on:** 06, 09, 12.  **Deliverables:** bug/experiment templates; tests; QA report.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P14-01** Create `Bugs & Solutions` MOC indexed by system and issue type.
- [x] **P14-02** Write bug report template with environment, repro, logs and impact.
- [x] **P14-03** Write root-cause template separating hypothesis from verified evidence.
- [x] **P14-04** Write repair log template including rollback plan.
- [x] **P14-05** Write regression-test template with expected and observed outcome.
- [x] **P14-06** Write experiment template with hypothesis, variables, method and results.
- [x] **P14-07** Create bug examples *explicitly labeled as hypothetical*, not past solved incidents.
- [x] **P14-08** Create a responsive UI example explaining AnchorPoint/Scale behavior.
- [x] **P14-09** Create a hypothetical audio authorization issue with diagnostic checklist.
- [x] **P14-10** Create a hypothetical animation-owner mismatch troubleshooting checklist.
- [x] **P14-11** Create a hypothetical datastore failure checklist with safe test boundaries.
- [x] **P14-12** Document server-client replication debugging workflow.
- [x] **P14-13** Document profiling workflow with MicroProfiler/Developer Console as applicable.
- [x] **P14-14** Define severity and priority labels for bugs.
- [x] **P14-15** Create test matrix for new, updated, broken and renamed notes.
- [x] **P14-16** Create test for tag/category dashboard generation.
- [x] **P14-17** Create test for idempotent imports and no duplicate frontmatter IDs.
- [x] **P14-18** Create test for exact asset ID lookups.
- [x] **P14-19** Create test for unknown permissions retained after migration.
- [x] **P14-20** Create test for search result source citations.
- [x] **P14-21** Generate initial `TEST_REPORT.md` from real test execution.
- [x] **P14-22** Create guidance for actual Roblox Studio test evidence capture.
- [x] **P14-23** Mark unexecuted Roblox Studio tests as manual/pending rather than passing.

**Acceptance gate P14:** Every reported passing test has actual command/output or clear manually captured proof.

- [x] **GATE-P14** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 15 — Obsidian dashboards, Bases and optional plugin enhancements (P1)

**Depends on:** 01, 12.  **Deliverables:** dashboards; setup guide; graceful fallbacks.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P15-01** Create attractive, navigable `HOME.md` with sections and restrained formatting.
- [x] **P15-02** Create dynamic-looking static Markdown indices for assets and recipes.
- [x] **P15-03** Implement a note dashboard for verification statuses and missing metadata.
- [x] **P15-04** Implement project status dashboard with links and task counts.
- [x] **P15-05** Create quick links to recently updated notes using generated index.
- [x] **P15-06** Create asset preview conventions (external links, attachments only with permission).
- [x] **P15-07** Create Obsidian Bases guide and optional `.base` file only when schema is checked.
- [x] **P15-08** Create Dataview query guide with Markdown fallback tables.
- [x] **P15-09** Create Templater setup guide with no automatic installation.
- [x] **P15-10** Create Excalidraw diagrams guide with Mermaid/Markdown fallback.
- [x] **P15-11** Create Obsidian Git setup guide with safe ignore lists and data privacy notes.
- [x] **P15-12** Document conflict resolution and avoid writing to existing `.obsidian` settings unapproved.
- [x] **P15-13** Create list of known plugin minimum prerequisites and verified compatibility status.
- [x] **P15-14** Check all core content remains readable without any plugins.

**Acceptance gate P15:** Plugin-free navigation works; optional enhancements are clearly optional and not silently installed.

- [x] **GATE-P15** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 16 — Project workspaces, task workflow and reusable project starters (P1)

**Depends on:** 01, 06, 11.  **Deliverables:** project template; example project; cross-project indexes.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P16-01** Create a `_PROJECT_TEMPLATE` folder with project README, design spec and architecture.
- [x] **P16-02** Include project-level `ROADMAP.md`, feature board and backlog.
- [x] **P16-03** Include `ASSET_MANIFEST.md` linked to canonical asset notes.
- [x] **P16-04** Include `SYSTEM_DEPENDENCIES.md` for module/API relationships.
- [x] **P16-05** Include `TEST_PLAN.md` and testing evidence folder layout.
- [x] **P16-06** Include `BUGS.md`, `DECISIONS.md`, `CHANGELOG.md` and `RELEASE_NOTES.md` templates.
- [x] **P16-07** Include multiplayer/network security checklist for every project.
- [x] **P16-08** Include game-feel/accessibility checklist for every project.
- [x] **P16-09** Include source-of-truth note distinguishing code repo vs documentation vault.
- [x] **P16-10** Create sample horror project concept using reusable systems without claiming a game exists.
- [x] **P16-11** Link sample project to flashlight, smart doors, UI and horror director recipes.
- [x] **P16-12** Create AI task specification template with acceptance criteria and out-of-scope boundaries.
- [x] **P16-13** Create AI code-review prompt tied to source paths and tests.
- [x] **P16-14** Create project handoff note with exact current work state.
- [x] **P16-15** Document how to connect to an existing Roblox Studio/Rojo repository without modifying it automatically.
- [x] **P16-16** Create project backlog prioritization guide and dependency notation.
- [x] **P16-17** Ensure project templates use relative links that remain valid when copied.

**Acceptance gate P16:** A developer can clone the project template and navigate requirements, assets, roadmap and tests.

- [x] **GATE-P16** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 17 — Security, privacy, accessibility and performance hardening (P1)

**Depends on:** 00, 05, 12.  **Deliverables:** security and profiling reports.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P17-01** Test that the CLI never indexes secrets from `.env`, keys, user config or hidden credentials.
- [x] **P17-02** Test that unexpected paths and symlinks cannot escape the vault root.
- [x] **P17-03** Document untrusted Markdown, external URLs and unsafe commands in fetched instructions.
- [x] **P17-04** Document protection against prompt injection in retrieved notes and imported community content.
- [x] **P17-05** Keep document retrieval read-only by default; require consent for writes.
- [x] **P17-06** Ensure automated note edits offer backups, diffs and a dry-run mode.
- [x] **P17-07** Document model/plugin import review including scripts, external requires and suspicious remotes.
- [x] **P17-08** Document correct Roblox asset ownership and access verification.
- [x] **P17-09** Document safe moderation/licensing treatment for audio and images.
- [x] **P17-10** Add a source verification queue rather than assuming links imply a license.
- [x] **P17-11** Document player privacy and what not to log in game scripts.
- [x] **P17-12** Write server-authority and exploit resistance checklist for gameplay modules.
- [x] **P17-13** Write accessibility checklist for flashing, camera motion, audio cues and input methods.
- [x] **P17-14** Profile indexing a realistic vault and document measured results, not guessed performance.
- [x] **P17-15** Benchmark search on a small and large fixture set.
- [x] **P17-16** Check index cache behavior and disk growth safeguards.
- [x] **P17-17** Check file encoding and line-ending integrity across Windows/Linux.
- [x] **P17-18** Document offline failure behavior for missing Roblox/API/Obsidian access.
- [x] **P17-19** Run negative tests for malformed metadata and duplicate IDs.
- [x] **P17-20** Write `SECURITY_REVIEW.md` with findings and fixes.

**Acceptance gate P17:** Security review documents tested boundaries; unsafe imported code is never executed.

- [x] **GATE-P17** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 18 — End-to-end acceptance, release and reproducible handoff (P1)

**Depends on:** 01-17.  **Deliverables:** TEST_REPORT.md; NEXT_STEPS.md; release checklist.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [x] **P18-01** Run `doctor` and record actual detected capabilities.
- [x] **P18-02** Run `validate` and list errors, warnings and total note counts.
- [x] **P18-03** Run `index` and verify stable result counts across repeated runs.
- [x] **P18-04** Search for “door creak” and capture retrieved real source paths.
- [x] **P18-05** Search for “server authoritative pickup” and capture relevant recipe sources.
- [x] **P18-06** Search for “button shifts when resizing” and capture a responsive UI note.
- [x] **P18-07** Look up an exact known asset ID by string without truncation.
- [x] **P18-08** Confirm any model/plugin assets are never output as sound IDs.
- [x] **P18-09** Confirm source grades do not imply granted runtime permissions.
- [x] **P18-10** Confirm no secrets or outside symlinks appear in index outputs.
- [x] **P18-11** Check links from HOME through content MOCs and back.
- [x] **P18-12** Run test suite with summary and per-test failures.
- [x] **P18-13** Check ZIP/source import invariants if original data is available.
- [x] **P18-14** Count total notes by type and all verification-status categories.
- [x] **P18-15** Review a representative technical note for correctness and official references.
- [x] **P18-16** Review a representative horror design note for practical, accessible implementation.
- [x] **P18-17** Review a representative UI note on multiple viewport plans.
- [x] **P18-18** Check CLI usage and command examples in both Bash and PowerShell.
- [x] **P18-19** Confirm scripts do not rely on network access for normal search.
- [x] **P18-20** Run a clean-vault bootstrap test in a temporary folder.
- [x] **P18-21** Run a no-plugin Markdown navigation test.
- [x] **P18-22** Write `TEST_REPORT.md` with execution date, environment, actual results and open failures.
- [x] **P18-23** Write `NEXT_STEPS.md` with exact commands and the next three highest-value tasks.
- [x] **P18-24** Update `STATUS.md`, `CHANGELOG.md`, `ISSUES.md` and decisions.
- [x] **P18-25** Produce short release notes for a usable V1 milestone.
- [x] **P18-26** Clearly distinguish finished, working prototypes, manual-only tasks and future work.

**Acceptance gate P18:** Acceptance matrix has observed evidence; instructions let the next agent resume safely.

- [x] **GATE-P18** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

---

## Phase 19 — Optional extensions and long-term ideas (P2)

**Depends on:** 18.  **Deliverables:** backlog for opt-in future work.

**Phase goal:** Complete the concrete tasks below with real files, tests and an auditable status report.

- [ ] **P19-01** Explore embedding-based semantic retrieval only if lexical search is insufficient.
- [ ] **P19-02** Add an MCP-compatible read-only tool server if a concrete supported harness is identified.
- [ ] **P19-03** Build a VS Code or editor workflow that queries the vault during Roblox coding.
- [ ] **P19-04** Explore an optional local HTTP API that binds only to localhost and requires consent.
- [ ] **P19-05** Add incremental indexing/watch mode with explicit file-system permissions.
- [ ] **P19-06** Add opt-in screenshot/reference thumbnail management with licensing checks.
- [ ] **P19-07** Add richer asset preview sheets without auto-fetching copyrighted resources.
- [ ] **P19-08** Add project-specific dynamic context packs for different Roblox codebases.
- [ ] **P19-09** Add optional Luau lint integration with Selene and formatting with StyLua.
- [ ] **P19-10** Add optional Rojo project examples and automated smoke-test scaffolding.
- [ ] **P19-11** Add local metrics on knowledge usage without sending usage data to analytics services.
- [ ] **P19-12** Add a source freshness checker that only fetches pages when explicitly enabled.
- [ ] **P19-13** Add multi-vault / multi-repository mapping without copying confidential files.
- [ ] **P19-14** Add searchable design diagrams and asset dependency graphs.
- [ ] **P19-15** Add a game design ideation engine that combines existing cookbook patterns.
- [ ] **P19-16** Add lightweight offline fuzzy search when FTS5 is unavailable.
- [ ] **P19-17** Add controlled AI suggestions for merging duplicates and resolving stale notes.
- [ ] **P19-18** Add a curated starter pack for non-horror Roblox genres.
- [ ] **P19-19** Document safe export/sharing of selected notes with rights and secrets checks.
- [ ] **P19-20** Add multilingual note aliases as an opt-in enhancement.

**Acceptance gate P19:** No P2 feature compromises basic offline access, user ownership or evidence quality.

- [ ] **GATE-P19** Evidence recorded in `TEST_REPORT.md` or the phase-specific report; checklist and `STATUS.md` updated.

## Cross-cutting test matrix

| Test ID | Scenario | Required result | Evidence location |
|---|---|---|---|
| T01 | Open HOME in Obsidian or Markdown viewer | Categories and real notes reachable | `TEST_REPORT.md` |
| T02 | Re-run import with source present | Same asset count; no accidental duplicates | `IMPORT_REPORT.md` |
| T03 | Search `door creak` | Correct candidate IDs with path and caveats | `TEST_REPORT.md` |
| T04 | Search `server authoritative pickup` | Server-validation recipe is returned | `TEST_REPORT.md` |
| T05 | Search `button shifts when resizing` | Responsive/AnchorPoint note returned | `TEST_REPORT.md` |
| T06 | Query unknown asset ID | Clear not-found output; no invented ID | `TEST_REPORT.md` |
| T07 | Retrieve model/plugin | Type explicitly model/plugin, never SoundId | `TEST_REPORT.md` |
| T08 | Check source D asset | Listing evidence only; permission not inferred | `TEST_REPORT.md` |
| T09 | Put fake `.env` in fixtures | Secret not indexed or exposed | `TEST_REPORT.md` |
| T10 | Symlink fixture points outside vault | Outside file excluded; no modifications | `TEST_REPORT.md` |
| T11 | Malformed YAML fixture | Actionable validation error | `TEST_REPORT.md` |
| T12 | Two notes share stable ID | Duplicate-ID validation failure | `TEST_REPORT.md` |
| T13 | Broken wiki link | Listed in broken-link report | `TEST_REPORT.md` |
| T14 | FTS5 missing | Fallback search still returns meaningful results | `TEST_REPORT.md` |
| T15 | Offline CLI run | Search/index without external API | `TEST_REPORT.md` |
| T16 | Studio asset test | Only human-observed loads marked tested | `ASSET_VERIFICATION_REPORT.md` |
| T17 | Code snippet review | Client/server placement and known caveats stated | `TEST_REPORT.md` |
| T18 | Export to JSON/CSV | Exact string IDs and stable result ordering | `TEST_REPORT.md` |
| T19 | Rename a note safely | Stable ID preserved; links reported/fixed | `TEST_REPORT.md` |
| T20 | Crash/interrupted indexing | No corrupt silent results; next run recovers | `TEST_REPORT.md` |

## Content standards and target inventory (guidance, not a license to generate filler)

| Library | Initial V1 target | Quality rule |
|---|---:|---|
| Asset records | Actual source count, ~206 if source found | IDs and provenance unchanged, test status truthful |
| Roblox reference | 15–25 substantial notes | Official docs, clear client/server scope |
| Mechanics cookbook | 12–20 recipes | API, tests, caveats, example implementation |
| Horror design | 12–18 notes | Tension/pacing/accessibility and practical Roblox mapping |
| Enemy AI | 8–12 notes | FSM/perception/pathfinding and bounded cost |
| UI/UX & game feel | 12–18 notes | Screen-size matrix and reduced-motion alternatives |
| Level design / puzzles | 8–12 notes | Playable/specifiable layouts, solvable puzzles |
| AI rules and prompt packs | 10–15 notes | Citations, context scope and safe editing |
| Bug & experiment examples | 8–12 notes | Hypothetical examples explicitly labeled as such |
| Templates | 14+ reusable files | Fully valid frontmatter, no fake sources |

**No count gaming.** One deeply useful note with a runnable snippet is worth more than ten empty shells. If the source asset vault isn't found, don't fabricate 206 notes; accurately report zero imported and leave a clear import instruction.

## Minimum CLI contract

The following should be implemented and tested as milestones complete. A command not yet implemented must be marked as pending rather than silently falling back to misleading output.

```bash
python scripts/gamedev_kb.py doctor
python scripts/gamedev_kb.py validate
python scripts/gamedev_kb.py index
python scripts/gamedev_kb.py search "door creak" --type asset --limit 10 --json
python scripts/gamedev_kb.py context "server-authoritative pickup" --budget 6000
python scripts/gamedev_kb.py asset 9114145200
python scripts/gamedev_kb.py export --format json
python scripts/gamedev_kb.py export --format csv
python scripts/gamedev_kb.py report
```

Windows PowerShell and Linux/macOS shell instructions belong in `README.md`; avoid hardcoded username or operating-system-specific absolute paths. Tests must assert type, citations, risk flags and source status, not just that the program exits without errors.

## Required status/handoff format

Maintain this block in `STATUS.md` as real work progresses:

```markdown
# Current status
- Updated (ISO date/time):
- Current phase and last completed task ID:
- Vault root:
- Original asset import: found / not found / blocked
- Source IDs / normalized IDs / unresolved duplicates:
- Notes created by type:
- Commands tested with results:
- Roblox Studio tests: not_run / partially_run / passed, with evidence
- Risks, blockers and open questions:
- Last successful backup or revision:
- Next three exact actions:
```

## Phase exit and release checklist

- [x] All `P0` acceptance gates pass and source contents remain untouched.
- [ ] All required `P1` items completed or explicitly assigned as open issues.
- [x] At least one real search run demonstrated with source-path citations.
- [x] All high-impact warnings appear clearly in CLI and README.
- [x] No false permission, license, Roblox Studio or published-test claims.
- [x] No unmanaged plugin installs, source code execution from free models, or unexpected external data uploads.
- [x] README and NEXT_STEPS contain commands that work on detected system.
- [x] The next agent can continue from this roadmap and STATUS without asking for repeated context.

---

**Owner-facing reminder:** This is an implementation roadmap, not a promise that every Roblox asset will be available or that an AI model can test Roblox Studio on its own. Validation gates exist to protect the project from plausible-looking but incorrect generated documentation.


---

## Build log — 2026-11-01 (implementation session)

| Phase | State | Evidence |
|---|---|---|
| 00 Discovery & safeguards | complete | `PROJECT_CONFIG.md`, `DECISIONS.md`, local `imports/raw/SOURCE_MANIFEST.json`; sanitized public copy at `imports/SOURCE_MANIFEST_PUBLIC.json` |
| 01 Scaffold & navigation | complete | 14 libraries + MOCs generated from real files (`scripts/build_mocs.py`) |
| 02 Schema & templates | complete | `SCHEMA.md`, 16 templates, 8 fixtures asserted by `tests/test_kb.py` |
| 03 Import | complete | 206/206 IDs, 0 duplicates, 0 CSV/JSON mismatch, two runs idempotent, sources re-hashed |
| 04 Asset catalog | complete | 15 generated indexes, rubric, verification workflow, rejection log, `ASSET_VERIFICATION_REPORT` |
| 05 Roblox encyclopedia | complete | 24 engineering notes, 15 verified official sources |
| 06 Mechanisms cookbook | complete | 20 recipes with API, failure modes, test lists (all code labelled `Untested:`) |
| 07 Horror design | complete | 17 notes including the adaptive director spec + API contract |
| 08 Enemy AI | complete | 14 notes including a dependency-free FSM module |
| 09 UI/UX & feel | complete | 20 notes including the two responsive failure modes |
| 10 Level design | complete | 14 notes including a full worked blockout plan |
| 11 Agent rules | complete | `AGENTS.md`, 5 harness briefs, 8 prompts, 5 context packs, promotion rules |
| 12 CLI | complete | 8 commands, FTS5 + fallback, 31 tests green |
| 13 Provenance | complete | 15 `SRC-*` records fetched 2026-11-01, freshness dashboard |
| 14 Bug graveyard | complete | 9 labelled-hypothetical cases + 5 debug workflows |
| 15 Dashboards | complete | 5 generated dashboards; plugin guide states nothing is installed |
| 16 Project templates | complete | `_PROJECT_TEMPLATE` (16 files) + worked sample project |
| 17 Security & performance | complete | secret/symlink/traversal/corrupt-cache tests, `SECURITY_REVIEW.md`, measured timings |
| 18 Acceptance | complete | `TEST_REPORT.md`, `NEXT_STEPS.md`, `STATUS.md`, 31/31 tests |
| 19 Optional extensions | **not started** | intentionally deferred (see `ISSUES.md` I-14) |

**Totals:** 461 notes · 206 imported assets · 0 validation errors · 31 automated tests passing ·
**0 Roblox Studio tests run** (none were possible without opening a place; nothing claims otherwise).

---

## Phase 20 — Project workflow, references and evidence expansion (P1)

**Depends on:** 01–18. **Canonical vault:** this repository. **Deliverables:** integrated
project workflow, sourced Roblox DataStore examples and diagrams, new Creator Store candidates,
linked skill cards and updated validation/index evidence.

**Phase goal:** Add reusable project workflows and technical references without replacing the schema,
duplicating imported asset rows, or promoting project-specific examples as general facts. Keep each
game project as the source of truth for its own decisions and the shared library as the source for
reusable knowledge.

### 20A — Source comparison and merge boundary

- [x] **P20-01** Confirm the active vault root from its project configuration.
- [x] **P20-02** Inventory the source package and identify the actual reusable workflow and asset sources.
- [x] **P20-03** Confirm the 206-row source asset collection is already imported byte-exactly; do not
  import the same rows again.
- [ ] **P20-04** Record file hashes before any future source migration and preserve a rollback map.
- [x] **P20-05** Keep `imports/raw/` unchanged and retain source grades, unknown access/license status,
  and untested Studio status.
- [x] **P20-06** Define project-specific notes as project-owned; promote only generalized patterns with
  source provenance and truthful test labels.

### 20B — Project workflow integration

- [x] **P20-07** Add a graph guide that maps project session notes to shared reusable knowledge.
- [x] **P20-08** Add session-start, working-rules, timeline and open-questions templates.
- [x] **P20-09** Link the new guide and templates through the Start Here and Projects MOCs.
- [x] **P20-10** Create Obsidian graph bridge notes for the `roblox-core-loop` and
  `roblox-mcp-workflow` runtime skills without copying their external skill files.
- [x] **P20-11** Add a DataStore review prompt under the previously empty Prompts folder and link it
  to the persistence notes and skill bridges.
- [x] **P20-12** Audit every project starter link after copying the template into a fresh project folder. A 20-file clean copy was made under ignored exports, its project links were reviewed, then it was removed; see [[clean-workspace-review]].

### 20C — Official DataStore references and examples

- [x] **P20-13** Review current official DataStore docs for limits, error handling, in-memory profiles,
  `UpdateAsync`, session locking, purchase processing and shutdown saving.
- [x] **P20-14** Add a source record linking the official Creator Hub pages.
- [x] **P20-15** Add an untested server-side `UpdateAsync` example with a non-yielding transform and
  explicit limits; label all code honestly.
- [x] **P20-16** Add an autosave staggering example and a caveat that production profiles still need
  single-writer/session-lock, retries, idempotent purchases and shutdown handling.
- [x] **P20-17** Embed official Roblox architecture, session-lock and data-flow diagrams by source URL;
  do not claim the images or code were executed.
- [ ] **P20-18** Run the example against a separate unpublished/test experience and save evidence; do
  not enable live DataStore access for this task.

### 20D — Additional asset candidates and library coverage

- [x] **P20-19** Search official Creator Store pages for new asset candidates and check their IDs against
  existing notes before creating records.
- [x] **P20-20** Add only IDs not present in the imported dataset; preserve exact string IDs and set
  access/license/studio fields to unknown or untested until a human checks them.
- [x] **P20-21** Add a candidate index note linked to the existing verification workflow and Studio skill.
- [ ] **P20-22** Verify a selected candidate in a blank Studio review place, inspect model scripts, and
  record evidence before changing any verification fields.
- [x] **P20-23** Confirm every numbered library section has a substantive note or generated MOC; keep
  raw imports, test fixtures, settings and attachment staging folders purpose-specific.
- [x] **P20-24** Add usage instructions to non-content folders that were empty; leave `.obsidian/`
  settings untouched.

### 20E — Version transition and acceptance

- [x] **P20-25** Keep the integrated workflow material in the canonical shared vault without
  duplicating imported asset rows.
- [x] **P20-26** Update references, boundary notes, README and handoff for the configured vault root.
- [x] **P20-27** Run `python scripts/gamedev_kb.py validate` and `index`; record actual results.
- [x] **P20-28** Check generated MOCs, asset candidate graph links and that the raw source manifest still
  matches every imported file.
- [x] **P20-29** Record remaining Studio checks, source availability caveats and the next three exact actions.
- [ ] **GATE-P20** The merged vault opens from its final path, the validation/index output is recorded,
  new graph links resolve, and no asset/code evidence was upgraded without a real check.

**Current state:** Core integration is present and validation/index are recorded. The acceptance gate
remains open for a fresh-project template audit and Studio checks of the DataStore example and new
assets.

---

## Phase 22 — Onboarding, learning paths and release quality (P2)

**Depends on:** 11, 16, 18, 20 and 21. **Deliverables:** reusable project-context templates,
beginner-friendly learning paths, a fictional integration example, and a repeatable distribution
review.

**Phase goal:** Make the vault easier to adopt in a fresh workspace while keeping game-specific
context private, examples honestly labeled, and release archives consistent with the reviewed tree.

- [x] **P22-01** Write short onboarding examples for a new project, an existing project and skipping
  questions; confirm each path saves only facts the user has actually confirmed.
- [x] **P22-02** Add copyable project-profile and user-goal checklist templates that work outside this
  vault, with no sample owner, game name, place ID or personal path.
- [x] **P22-03** Test the project onboarding instructions in a clean sample workspace and check that an
  established project is not asked questions whose answers are already documented.
- [x] **P22-04** Add learning paths for gameplay scripting, UI, backend systems and horror design; link
  prerequisite notes and a small observable practice task for each path.
- [x] **P22-05** Build one original, fictional vertical-slice example that joins a server-authoritative
  mechanic, player data and UI. Keep it clearly untested until it runs in a separate Studio place.
- [x] **P22-06** Add a repeatable release audit for tracked files and generated archives. Check for
  private local folders, absolute machine paths, credentials and specific project references, with
  explicit documented exceptions for immutable source imports.
- [ ] **P22-07** Resolve the GitHub frontmatter rendering issue in [[ISSUES]] I-28 with a small
  representative migration trial before considering a whole-vault format change.
- [x] **P22-08** Add a freshness review queue for high-impact Roblox API notes, showing source date and
  next review status without fetching external pages unless explicitly requested.
- [ ] **P22-09** Recheck clean-clone quickstart instructions on Windows and Linux/macOS, including
  offline search, validation and generated dashboards. A fresh v1.2.0 clone passed doctor,
  validation, index and offline search on Windows; Linux/macOS execution remains open.

**Acceptance gate P22:** A fresh reader can follow an appropriate learning path, copy the project
context files without inheriting personal details, and reproduce a release audit with no unreviewed
privacy findings.

- [ ] **GATE-P22** Record the workspace, CLI and release-archive evidence; unresolved Studio checks
  remain labeled as manual follow-up.

---

## Phase 21 — UI pattern library and responsive review (P1)

**Depends on:** 09, 11, 20. **Deliverables:** reusable UI pattern notes, component recipes, a
template, fill-in Luau snippets and responsive QA follow-up. Project-specific hierarchy and media
identifiers remain in the game's own files, not in the shared download.

- [x] **P21-01** Define a read-only interface review workflow that distinguishes active UI from staged
  experiments and avoids editing the source project.
- [x] **P21-02** Add reusable patterns for collection grids, catalogs, modals, popups and themed layouts.
- [x] **P21-03** Keep game-specific image and sound identifiers out of the shared library; require
  per-project access and rights checks before reuse.
- [x] **P21-04** Add reusable UI component recipes for buttons, sliders, progress bars, collection cards,
  shop catalogs, and modal dialogs.
- [x] **P21-05** Add a provenance-first UI pattern note template and data-driven Luau snippets for button,
  slider, progress bar, item card, and modal components. Mark all snippets untested.
- [ ] **P21-06** Capture and review in-game screenshots across desktop, phone portrait/landscape, and
  gamepad focus. Verify safe areas, text scale, touch targets, and motion before promoting patterns.
- [ ] **GATE-P21** A human has reviewed the patterns and observed the relevant layouts in a runtime
  session; no project image or sound is represented as cleared for reuse without a separate rights check.
