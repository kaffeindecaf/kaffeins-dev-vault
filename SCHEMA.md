---
id: N-SCHEMA
type: guide
title: SCHEMA — metadata, identity and conventions
status: reviewed
updated: 2026-11-01
tags: [schema, conventions, metadata]
source_urls: []
---

# SCHEMA — metadata, identity and conventions

Canonical rules for every note in this vault. The CLI validates against this file
(`python scripts/gamedev_kb.py validate`). If a rule here changes, bump `schema_version` in
`config/vault.json` and record it in [[DECISIONS]].

Migration/provenance rules: [[LICENSES_AND_SOURCES]]. Templates: [[MOC-templates]].

## 1. Identity — stable IDs

Every note has an `id` in frontmatter: `PREFIX-NNN` or `PREFIX-slug`.

| Prefix | Note type | Example |
|---|---|---|
| `A` | asset (candidate) | `A-7274920568` |
| `S` | reusable system / mechanic recipe | `S-door-system` |
| `B` | bug record | `B-ui-button-drift` |
| `P` | project | `P-sample-horror-house` |
| `SRC` | source record | `SRC-creator-hub-datastores` |
| `PR` | agent prompt | `PR-secure-mechanic` |
| `R` | reference / encyclopedia note | `R-remote-validation` |
| `H` | horror design note | `H-tension-hierarchy` |
| `X` | experiment | `X-anchorpoint-scale` |
| `D` | architecture decision | `D-0003-sqlite-fts5` |
| `MOC` | map of content | `MOC-asset-library` |
| `G` | guide / how-to | `G-obsidian-setup` |
| `SP` | spec | `SP-adaptive-director` |
| `T` | template | `T-asset` |
| `DB` | generated dashboard | `DB-status` |
| `WL` | agent work log / handoff brief | `WL-20261101-worklog-templates` |
| `N` | plain note | `N-SCHEMA` |

Rules:

- **Asset IDs are strings.** `asset_id: "7274920568"` — never a number. YAML/JSON ints lose
  precision above 2^53 and strip leading/trailing characters; a string also survives a re-parse.
- **IDs are stable.** Renaming a file or title never changes the `id`. Links to a note use its
  file name (`[[note-filename]]`), so file renames are the only breaking change.
- **IDs are unique vault-wide.** Duplicates are a validation failure (`duplicate_id`).
- **Never invent an ID** for something you did not create.

## 2. Required frontmatter (all notes)

```yaml
---
id: A-1234567890               # stable, see table above
type: asset                    # controlled value, see §3
title: Night Forest Ambience   # human title, may differ from file name
status: draft                  # idea | draft | reviewed | tested | deprecated
updated: 2026-11-01            # ISO 8601 date, YYYY-MM-DD
tags: [audio, ambience]        # list, lowercase
source_urls: []                # list of absolute URLs; [] is honest, not missing
---
```

Optional but common: `created`, `confidence` (`low|medium|high`), `verification`
(§4), `related` (list of note **IDs**), `category`, `client_server`, `roblox_services`.

## 3. Controlled values

`type`: asset, system, bug, project, source, prompt, reference, principle, experiment, decision,
moc, guide, spec, template, dashboard, changelog, report, worklog.

`status` (authoring lifecycle, not evidence): idea → draft → reviewed → tested. `deprecated` means
superseded; keep the note and link the replacement.

`confidence`: `low` (single weak or second-hand source), `medium` (official doc but unexercised
here, or one community source), `high` (official doc **and** exercised/verified here).

## 4. Verification (evidence, not intent)

| `verification` | Means |
|---|---|
| `untested` | written but never executed or checked against the real thing |
| `design_only` | a design/architecture note; nothing to execute |
| `reference_only` | restates official documentation; not exercised locally |
| `tested_local` | executed by the vault's own tooling/tests (CLI, validator) — **not** Roblox Studio |
| `tested_studio` | executed in Roblox Studio; evidence path recorded in `test_evidence` |
| `tested_published` | observed in a published experience |
| `failed` | was tested and failed — the note must say how |

`test_status`, `test_method`, `tested_at`, `reviewed_by`, `test_evidence` are only used when a
test actually happened. **Default is `untested`.** A `D` source grade is listing evidence and is
never a permission, licence or playback guarantee.

## 5. Asset-record fields

```yaml
asset_id: "7274920568"     # string, exact digits, no truncation
asset_type: audio          # audio|animation|model|decal|image|mesh|plugin|unknown
usage_uri: "rbxassetid://7274920568"   # present only when the URI form is correct for the type
source_grade: D            # original research evidence: D G R F I S (see §6), passthrough
listing_status: listed     # listed | not_listed | unknown
access_status: unknown     # unknown | shared | restricted | blocked   (never inferred)
license_status: unknown    # unknown | documented | needs_review | unclear
safety_status: uninspected # uninspected | scripts_reviewed | rejected
studio_status: not_tested  # not_tested | tested_studio | tested_published | failed
original: { ... }          # verbatim source record, unmodified
```

Rules: a model or plugin record is **never** presented as a SoundId or animation ID. Type decides
the usage form — `audio`/`animation` use `rbxassetid://`, models/plugins are inserted from Creator
Store by ID after review, never auto-executed.

## 6. Source grades (imported verbatim from the 2026-11-01 research)

| Grade | What the original research saw |
|---|---|
| `D` | individual asset page on the official Creator Store |
| `G` | numeric ID in Roblox's official animation documentation |
| `R` | audio ID in an official Roblox audio tutorial |
| `F` | numeric default animation ID from a DevForum reference (historical) |
| `I` | audio ID indexed by an independent third-party index (robloxidshub) |
| `S` | secondary listing; lead only |

The grade describes where the ID came from. It says nothing about quality, price, copyright,
malicious code or current access. Do not upgrade a grade — add a *new* verification field instead.

## 7. Technical-recipe fields

```yaml
client_server: server          # server | client | both
roblox_services: [PathfindingService, CollectionService]
dependencies: [S-janitor]      # note IDs
code_blocks: 2                 # number of executable blocks (for the tested/untested split)
```

Every code block carries a label line immediately above it: `Tested:` / `Untested:` / `Pseudocode:`.

## 8. Naming and links

- File names: `kebab-case`, no spaces in note file names, unique vault-wide (Windows is
  case-insensitive — `Door.md` and `door.md` collide).
- Assets: `asset-<asset_id>.md`. Templates: `template-<kind>.md`. MOCs: `MOC-<library>.md`.
- Link style: `[[file-name]]` or `[[file-name|display text]]`. **No path links** — Obsidian
  resolves by file name, and paths break when a folder moves.
- A link to a note that does not exist is a validation **warning** (`broken_wikilink`), not an
  error, because MOCs are allowed to point at planned notes. `dangling` links are listed by
  `validate` so they never silently rot.

## 9. Provenance on imported records

Every imported asset keeps the untouched source row under `original:` and a pointer to its source
file under `provenance:`. Never edit `original:`; add your own findings as new fields.

## 10. What the validator enforces

Errors: missing/invalid required fields, unknown `type`/`status`/`verification`, duplicate `id`,
non-string `asset_id`, `asset_id` that is not 1–20 digits, `usage_uri` whose scheme does not match
`asset_type`, malformed ISO date.
Warnings: broken wikilink, missing `source_urls` on a `reference` note, `tested_*` verification
without `test_evidence`, an asset claiming `access_status` other than `unknown` with no evidence.

## 11. Agent work logs (`schema_version: 2`)

Every session that changes the vault leaves one work log entry in
`09 - AI Agent Knowledge/Work Log/`. It is the handoff record: what the agent did, which files it
changed and why, what it actually ran, and the three logical next steps.

```yaml
id: WL-20261101-worklog-templates   # WL-YYYYMMDD-<slug>, handoff: ...-handoff
type: worklog
status: draft                        # stays draft; a human may set reviewed
agent: Hermes Agent (deepseek-flash) # harness and model, so provenance is visible
verification: tested_local           # tested_local only if the CLI really ran; never tested_studio
related: [ "T-worklog", "T-handoff" ]
```

Rules:

- File name `worklog-YYYY-MM-DD-<slug>.md`; one file per session, never one growing diary.
- Entries are append-only. To correct an earlier entry, write a new dated entry that supersedes it
  and link back — do not rewrite history.
- A work log is **not** knowledge. Anything reusable belongs in the proper library note with its own
  verification label; the log only points at it.
- No secrets, tokens or machine-specific absolute paths in an entry — the vault is published.
- Protocol: [[G-worklog-protocol]]. Templates: [[T-worklog]] and [[T-handoff]].
