---
id: N-CHANGELOG
type: changelog
title: CHANGELOG
status: draft
updated: 2026-11-02
tags: [changelog]
source_urls: []
---

# CHANGELOG

## 2026-11-02 — Remove project-specific content from the shared tree

- Moved detailed source audits and owner-specific work logs to a local-only ignored archive.
- Removed project names, place IDs, personal paths and source-hierarchy details from the shared
  notes and generated asset provenance; rewrote reusable patterns and templates in project-neutral terms.
- Regenerated navigation and dashboards. Earlier public commits and release archives still need
  separate review before they can be replaced; see [[ISSUES]] R-06.

## 2026-11-02 — Project onboarding and user goal checklist

- Added [[SOUL]] with a first-project flow for choosing a new or existing game, describing it,
  reviewing known context, asking only material follow-up questions, saving confirmed decisions,
  and skipping the interview when requested.
- Added [[checklist]] as a user-goal ledger separate from the vault's [[ROADMAP]], and wired both
  files into [[AGENTS]], the session-start prompt, and [[HOME]].

## v1.0.0 — 2026-11-02 — Reusable backend systems

- Added all ten requested systems as original ModuleScripts: integrity/shadow guard, cross-server
  currency and unique-item gifts, lifecycle leak suspects, remote telemetry/dashboard, rolling replay,
  room FSM/orchestrator, proximity culling/interest routing, retention, purchase fulfillment and quests/UI.
- Added 17 implementation files, three test files, ten system contracts, the integration catalog,
  primary-source record, Studio report and desktop UI preview.
- Studio Play final result: 11 cases passed, 0 failed, including 34 mock economy fault checks and FIFO contention;
  client replay passed four checks. A missing closing end in the optional webhook adapter was
  found in the first load pass, corrected and covered by an explicit module-load test.
- Rewrote README, linked HOME and older related recipes, and set VERSION plus
  config/vault.json release_version to 1.0.0. Note schema stays at 2; folder paths remain stable.
- Corrected overbroad guarantees: transfers are durable recovery sagas, byte counts are estimates,
  leak reports identify suspects, and cosmetic culling complements engine streaming.
- Corrected the older MemoryStore/MessagingService reference and source record: message delivery
  is best effort, not guaranteed at least once; a lease alone cannot fence stale profile saves.
- Rebuilt maps/index and ran local validation/CLI tests; exact output, including the initial
  missing release-note link, is recorded in the local release verification report.
- Temporary Studio roots and preview instances were removed and the session returned to Edit.
  Live persistence/purchases/webhooks and the remaining integration checks are tracked as I-31–I-33.

## 2026-11-02 — Practical community-inspired snippets

Added original, untested cleanup scope, request token bucket and zone membership diff modules, with integration examples and test cases.

## 2026-11-02 — Roblox community libraries research

Added a sourced overview of discovery lists, Knit, Janitor, Maid, ProfileStore, ReplicaService, Replica, ZonePlus, Blink and ByteNet, with adoption and verification caveats.

## 2026-11-02 — Reusable game patterns and UI components

Added generalized route, plot-production, vehicle-progression, garden, session-reward, hitbox and UI
patterns with original `Untested:` helpers. Project-specific source audits, identifiers and session
logs are kept in a local-only archive and are excluded from the downloadable tree. The shared notes
contain reusable guidance and state their remaining verification needs.

## 2026-11-01 — Agent work log templates (schema v2)

- Added `T-worklog` and `T-handoff` templates plus the `G-worklog-protocol` guide in
  `09 - AI Agent Knowledge/Work Log/`. Every session that changes the vault now leaves one dated
  entry: task and scope, a per-file change table, the commands that actually ran, open questions and
  three next steps; unfinished work also gets a handoff brief.
- Added `worklog` to the controlled note types and `WL` to the ID prefixes; `schema_version` is now 2.
  Recorded as D-0010 in [[DECISIONS]].
- Wired the protocol into [[README]] (contributing and folder map), [[NEXT_STEPS]] (new step 0),
  [[SCHEMA]] (§11), the session-start prompt, and the generated maps; the MOC intro strings no longer
  hardcode a template count.
- Verified the schema, validator, index and generated maps; exact current checks are recorded in
  the release and status reports.

## 2026-11-01 — GitHub release preparation

- Reworked the root README for GitHub with concise setup/search instructions, two Mermaid flowcharts,
  and a contribution guide.
- Added a public-release checklist and a root `.gitignore` for local caches, exports, scratch imports,
  credentials, and editor noise. Existing files were not deleted.
- Removed machine-specific filesystem details from the public-facing project and status notes.
- Recorded unresolved provenance, asset-rights, and license questions in [[ISSUES]] and
  [[RELEASE_CHECKLIST]]. The vault is still a working copy, not cleared for public release.
- Ran local validation and rebuilt the search index after these edits; current counts are recorded in [[STATUS]].

## 2026-11-01 — V1 build

**Scaffold and safety**
- Created the canonical `GameDev-Knowledge-Base` vault with 14 numbered libraries, `imports/`,
  `exports/`, `scripts/`, `tests/`, `config/`.
- Copied the research collection byte-exact into `imports/raw/` and recorded SHA-256 for all 14 files
  (`imports/raw/SOURCE_MANIFEST.json`). Nothing under `imports/` is ever edited.
- Wrote [[SCHEMA]], [[PROJECT_CONFIG]] (scope + secret rules), [[DECISIONS]] (7 ADRs),
  [[LICENSES_AND_SOURCES]].

**Import**
- `scripts/import_assets.py` imports 206 source rows → 206 notes, 206 distinct IDs, 0 duplicates.
  Second run: `unchanged=206` (idempotent). Human-edited notes are preserved by fingerprint.
- [[IMPORT_REPORT]] records reconciliation, caveats and the honest "not verified" statement.

**Tooling**
- `scripts/gamedev_kb.py`: `doctor`, `validate`, `index` (FTS5 + fallback), `search`, `context`,
  `asset`, `export`, `report --write-dashboards`. Stdlib only. Path confinement and secret exclusion
  are enforced in the walker, not just documented.
- Fixed a snippet bug where results echoed the note's H1 instead of the matching sentence.

**Content**
- 24 Roblox engineering notes, 20 mechanic recipes, 16 horror-design notes, 12 enemy-AI notes,
  20 UI/game-feel notes, 14 level-design notes, 9 labelled-hypothetical bug notes,
  9 source records, 7 agent prompts, 4 context packs, 5 per-harness briefs, 16 templates.
- Replaced the placeholder "Pizza Rush"-style example with real content; every count above was
  produced by `report`, not typed from memory.

**Verification**
- `python -m unittest discover -s tests` — see [[TEST_REPORT]] for the real transcript.
- `validate`: 0 errors. `index`: stable fingerprint across runs.

**Dashboards and evidence**
- Added generated `DB-projects` and `DB-sources` (freshness, 180-day `needs-review` flag) alongside
  `DB-asset-status`, `DB-health` and `DB-recent`.
- Measured, not guessed: index 648 ms, search 257 ms, asset 219 ms, validate 582 ms on 461 notes;
  small-vs-large fixture benchmark recorded in `exports/benchmarks.json`.
- Wrote [[TEST_REPORT]], [[ASSET_VERIFICATION_REPORT]], [[SECURITY_REVIEW]].
- CLI fixes found by testing: `--json`/`--root` now parse either side of the subcommand; `export --json` emits
  machine output; corrupt index exits 2 with advice instead of a traceback; `report` excludes test fixtures;
  added `tested_local` to the verification enum so tool tests are not mislabelled as Studio tests.

## 2026-11-01 — Extraction pass (second session)

**Read from a live place (read-only, Edit mode, no playtest, no writes)**
- 7 server scripts of a shipped Roblox experience, 92 KB total, via the Studio MCP: round state, persistence,
  speed guard, noise bus, interaction guard, carry system, hiding spot. Plus function/byte indexes for the
  48 KB AI module and 14 KB AI config (structure only).

**Added to `03 - Reusable Systems/` (9 notes)**
- [[S-round-phase-machine]] · [[S-delta-save-queue]] · [[S-speed-guard]] · [[S-noise-bus]] ·
  [[S-interaction-guard]] · [[S-world-object-validation]] · [[S-occupancy-state-machine]] ·
  [[S-config-derivation]] · [[G-extraction-log]]
- Every code block is labelled `Untested in this vault`: the code ran in its source place, the adapted version
  has not run anywhere. Provenance fields record the place and date.

**Added skill inventory**
- [[G-skills-inventory]] maps the four universal Roblox skills against the game-specific ones still in use.

**Not done (on purpose)**
- No Roblox Studio test, no audio playback, no model inspection, no plugin install, no publish.
- No embeddings/MCP server (roadmap P19 stays unbuilt until lexical search is proven insufficient).

## 2026-11-01 — Project workflow and research additions

- Added a reusable project-session workflow and templates to connect game-specific source-of-truth
  files with this shared knowledge base. No `.obsidian/` settings were edited.
- Added [[G-game-vault-integration]] and four project templates for session start, working rules,
  timeline and open questions. The guidance keeps project-specific facts in each game's own source
  of truth and promotes only generalized patterns to the shared libraries.
- Added [[SRC-roblox-data-store-player-profile]] with official Creator Hub references and hosted
  architecture/session-lock/save diagrams; added [[S-datastore-player-profile]] with two server-side
  examples, both labeled `Untested:` and linked to the `roblox-core-loop` and `roblox-mcp-workflow`
  skill bridge notes. Updated the older DataStore note to remove outdated budget/Studio claims.
- Added three new, distinct Creator Store candidates: Horror Ambience, Door Creak Open and Flashlight.
  Their access, license, safety and Studio status remain unknown/untested. The original 206-row raw
  import was not changed.
- Added a manual candidate index, connected it to the generated asset MOC, and updated the asset
  verification report to 209 total candidate notes.
- Added instructions to the empty Prompts, attachments, staging and fixture folders; left the empty
  `.obsidian/` folder untouched. Regenerated MOCs and asset indexes.
- Validation/index output is recorded in [[STATUS]] after the final run; no new automated or Roblox
  Studio tests were run.

