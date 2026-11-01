---
id: N-DECISIONS
type: decision
title: DECISIONS — architecture decision record
status: draft
updated: 2026-11-01
tags: [decisions, architecture]
source_urls: []
---

# DECISIONS

One entry per decision that would be expensive to reverse. Newest first.

## D-0001 — Keep one canonical knowledge vault

- **Date:** 2026-11-01
- **Decision:** Keep one canonical folder as the active knowledge vault.
- **Why:** duplicate full copies split updates and make it unclear which copy is authoritative.
- **Consequence:** project-specific facts stay in that project's own notes; this vault holds reusable
  development knowledge.

## D-0002 — Python stdlib only, no pip installs

- **Date:** 2026-11-01
- **Decision:** `gamedev_kb.py` uses only the standard library. Frontmatter is parsed by a
  restricted parser written here, not `PyYAML`.
- **Why:** the master prompt forbids automatic software installation, and a knowledge base that
  needs a venv is fragile on a machine that also runs Roblox Studio.
- **Consequence:** the YAML subset is limited by design — see D-0006.

## D-0003 — SQLite FTS5 primary, pure-Python fallback

- **Decision:** index into `config/index.sqlite` using FTS5 (present: SQLite 3.53.1). If FTS5 is
  unavailable, `index` writes a JSON keyword index and `search` uses the same tokenizer in Python.
- **Why:** FTS5 gives ranking and phrase search for free; the fallback keeps the vault usable on a
  machine with a stripped SQLite build. Both paths return identical result shapes, so tests assert
  on structure rather than on the engine.

## D-0004 — Wikipedia-style file names, ID-based identity

- **Decision:** identity is the frontmatter `id`; the file name is a stable human handle.
  Assets are `asset-<id>.md`, MOCs are `MOC-<library>.md`.
- **Why:** Obsidian resolves wikilinks by file name, so a globally unique file name is the only
  collision-safe link target on a case-insensitive filesystem. Numeric asset names as file names
  would be unreadable in the sidebar, so `asset-` prefixes them.

## D-0005 — Imported records keep their source row verbatim

- **Decision:** every imported asset note carries the original research row under `original:` and
  uses `verification: untested`. Grades, `studio_status` and `license_status` are passed through,
  never reinterpreted into a claim of access.
- **Why:** the roadmap's core integrity requirement. A `D` grade proves a listing existed on
  2026-11-01, not that the audio plays in someone else's game today.

## D-0006 — Restricted YAML subset

- **Decision:** frontmatter supports `key: scalar`, `key: [a, b]`, block lists (`- item`), one
  level of nested mapping, quoted strings, and `null`. No anchors, no multi-document, no deep
  nesting, no multiline scalars.
- **Why:** avoids a dependency while covering every note type defined in [[SCHEMA]].
- **Consequence:** a note using unsupported YAML fails loudly in `validate` (`yaml_unsupported`)
  instead of being silently mis-parsed. This is tested.

## D-0007 — No community plugins, no `.obsidian` writes

- **Decision:** ship with the core plugins' defaults only, and do not edit an existing `.obsidian`
  configuration without explicit approval. Optional plugin guides are documentation, not installs.
- **Why:** the roadmap forbids silent plugin installation, and plugin-dependent dashboards would
  break the "works in a plain Markdown viewer" requirement. All dashboards are generated static
  Markdown, so they refresh with `python scripts/gamedev_kb.py report --write-dashboards`.

## D-0008 — Keep the active knowledge base canonical and version the fused source package

- **Date:** 2026-11-01
- **Decision:** Keep `GameDev-Knowledge-Base` as the active destination, fuse reusable game-vault
  workflow material into its project templates and graph, and rename the source package to
  `kaffeins-dev-vault-v0.0.2`.
- **Why:** the active knowledge base already contains the schema, retrieval CLI, 206 imported asset
  records and reusable Roblox libraries. A second full copy would split updates and duplicate the
  same source records.
- **Consequence:** the original source package remains available under its new versioned name;
  project-specific facts stay in the game's own project notes, and imported raw asset records remain
  unchanged.

## D-0009 — Place the active knowledge vault inside the versioned Kaffeins folder

- **Date:** 2026-11-01
- **Decision:** Move the complete `GameDev-Knowledge-Base` folder into
  `kaffeins-dev-vault-v0.0.2`, preserving the nested vault name and its contents.
- **Why:** the owner requested a single parent location for the merged game-development vault.
- **Consequence:** the vault is nested under its versioned parent folder. The active root is the
  `GameDev-Knowledge-Base` directory; material outside it remains outside the writable root.

**Update 2026-11-01 (later the same day):** the nested directory was renamed to
`kaffeins-vault-v0.0.2`, so the active root is now
`Desktop/kaffeins-dev-vault-v0.0.2/kaffeins-vault-v0.0.2`. The decision itself is unchanged: one
active vault, inside the versioned parent. Recorded in
[[worklog-2026-11-01-worklog-templates]] because the earlier path is now wrong everywhere it is quoted.

## D-0010 — Agent work logs are a first-class note type

- **Date:** 2026-11-01
- **Decision:** add `worklog` to the controlled `type` list and the `WL` ID prefix
  (`schema_version` 2). Every session that changes the vault writes one dated entry in
  `09 - AI Agent Knowledge/Work Log/`, using [[T-worklog]]; unfinished work also gets a
  [[T-handoff]] brief.
- **Why:** the vault recorded what is known (library notes), what changed per release
  ([[CHANGELOG]]) and what is open ([[ISSUES]]), but not what the *last agent did* or what it would
  do next. The next session was reconstructing state from `git diff`, which loses intent.
- **Consequence:** an entry is cheap (one file, a change table, three next steps) and searchable
  (`search --type worklog`). Work logs stay `draft` and are never a home for knowledge — a reusable
  fact still has to land in a library note with its own verification label. Protocol:
  [[G-worklog-protocol]].
