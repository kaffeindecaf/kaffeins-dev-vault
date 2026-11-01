---
id: N-CHANGELOG
type: changelog
title: CHANGELOG
status: draft
updated: 2026-11-01
tags: [changelog]
source_urls: []
---

# CHANGELOG

## 2026-11-01 — Agent work log templates (schema v2)

- Added `T-worklog` and `T-handoff` templates plus the `G-worklog-protocol` guide in
  `09 - AI Agent Knowledge/Work Log/`. Every session that changes the vault now leaves one dated
  entry: task and scope, a per-file change table, the commands that actually ran, open questions and
  three next steps; unfinished work also gets a handoff brief.
- Added `worklog` to the controlled note types and `WL` to the ID prefixes; `schema_version` is now 2.
  Recorded as D-0010 in [[DECISIONS]].
- First entry, `worklog-2026-11-01-worklog-templates`, records this session and doubles as the worked
  example.
- Wired the protocol into [[README]] (contributing and folder map), [[NEXT_STEPS]] (new step 0),
  [[SCHEMA]] (§11), the session-start prompt, and the generated maps; the MOC intro strings no longer
  hardcode a template count.
- Corrected the stale vault path in D-0009 after the folder was renamed to `kaffeins-vault-v0.0.2`.
- `AGENTS.md` still says nothing about the work log: the edit was refused by the write guard and is
  open as I-25 in [[ISSUES]].
- Verified: `validate` 0 errors, `index` rebuilt, 31 tests OK, 11 maps regenerated. Pushed to
  `kaffeins/@kaffeins-dev-vault` on GitHub; the rendered repository was checked in a browser.

## 2026-11-01 — GitHub release preparation

- Reworked the root README for GitHub with concise setup/search instructions, two Mermaid flowcharts,
  and a contribution guide.
- Added a public-release checklist and a root `.gitignore` for local caches, exports, scratch imports,
  credentials, and editor noise. Existing files were not deleted.
- Removed machine-specific filesystem details from the public-facing project and status notes.
- Recorded unresolved provenance, asset-rights, and license questions in [[ISSUES]] and
  [[RELEASE_CHECKLIST]]. The vault is still a working copy, not cleared for public release.
- Ran local validation and rebuilt the search index after these edits; see the session wrap-up output.

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

## 2026-11-01 — Vault fusion and research additions

- Kept `GameDev-Knowledge-Base` as the active destination and renamed the source package folder to
  `kaffeins-dev-vault-v0.0.2` at the owner's request. No `.obsidian/` settings were edited.
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

## 2026-11-01 — Move active vault into the versioned Kaffeins folder

- Moved the complete vault into `kaffeins-dev-vault-v0.0.2/GameDev-Knowledge-Base`.
- Verified all 524 files against the source copy by relative path and SHA-256 before removing source
  contents: 0 missing, 0 extra and 0 mismatches.
- The old top-level directory is empty. Windows prevented removal of that directory entry because a
  process still holds it; see [[ISSUES]] I-24.
- Updated the operational vault path in [[README]], [[PROJECT_CONFIG]], [[STATUS]] and [[AGENTS]],
  and recorded the move in [[DECISIONS]] D-0009.
