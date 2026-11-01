---
id: N-TEST-REPORT
type: report
title: TEST_REPORT — what was actually executed
status: reviewed
updated: 2026-11-01
tags: [testing, evidence]
source_urls: []
confidence: high
verification: tested_local
client_server: both
code_blocks: 1
test_method: local execution (Python unittest + CLI runs on Windows 11, Python 3.14.7)
tested_at: 2026-11-01
test_evidence: "python -m unittest discover -s tests -v → Ran 31 tests ... OK; CLI commands run and output captured below"
related: [ "STATUS", "ISSUES" ]
---

# TEST_REPORT

Execution date: **2026-11-01**. Environment: Windows 11 (10.0.26300), Python 3.14.7, SQLite 3.53.1 with FTS5,
bash (MSYS). No network access was used by any test.

> **Scope rule for this file.** Only what ran is listed as passing. Nothing in this vault was tested in Roblox
> Studio — **no place was opened, no asset was played, no model was inspected**. Anything of that kind is listed
> under "Not run" and stays `untested` in the notes.

## 1. Test suite

```text
$ python -m unittest discover -s tests -v
Ran 31 tests in 10.108s

OK
```

All 31 tests pass. What each covers:

| Group | Tests | Covers |
|---|---|---|
| Schema validation | 8 | valid notes produce no errors · malformed frontmatter is actionable · unsupported YAML rejected · duplicate IDs fail · `asset_id` must be a string · a model cannot carry a sound URI · broken wikilinks reported · links inside code blocks ignored |
| Security boundaries | 3 | secrets (`.env`, `*.key`, `credentials*`) never walked or indexed · a symlink pointing outside the vault is not followed · a `--root` without `config/vault.json` is refused |
| Search and retrieval | 11 | search returns paths/types · title hits outrank body mentions · `--type` filter · exact string-preserving asset lookup (leading zero) · unknown ID is not invented · non-numeric ID refused · FTS5-missing fallback engine · corrupt-index recovery · index idempotency · budgeted context pack with citations · export json/csv stability and exact IDs |
| Real vault | 9 | vault validates with 0 errors (452 notes) · every `asset_id` stored as text · no model exposes a `rbxassetid://` URI · no imported asset claims a Studio test · `source_grade: D` never implies access · every `HOME.md` link resolves · "door creak" returns real asset records with caveats · the responsive-UI question finds the right note · the importer is idempotent |

## 2. CLI commands actually run

| Command | Result |
|---|---|
| `doctor` | vault root detected, Python 3.14.7, SQLite 3.53.1, **FTS5 yes**, 452 notes, 206 assets |
| `validate` | `452 notes checked (7 test fixtures excluded) · 0 errors · 4 warnings` |
| `index` | `indexed 452 notes … engine: fts5`; second run → **identical fingerprint** (`37565bde120c022f`) |
| `search "door creak" --limit 5` | 5 audio candidates, top = `Wood Door Creak Squeak 3` (`9120839174`), each carrying the untested caveat |
| `asset 7274920568` | `Night Forest Ambience Sound (audio, grade D)` → `01 - Asset Library/Audio/asset-7274920568.md` |
| `asset 999` | `exit 1` — `no asset with ID 999 in this vault. Not inventing one.` |
| `context "server authoritative pickup" --budget 6000` | cited pack with paths, ids and verification states; token count labelled approximate |
| `export --format json` / `--format csv` | 452 records, deterministic ordering, `asset_id` preserved as text |
| `report --write-dashboards` | 3 dashboards written to `13 - Dashboards/` |
| `import_assets.py` ×2 | first run `created=206`; second run `created=0 unchanged=206` |

## 3. Known warnings (4, all benign)

| Warning | Why it exists |
|---|---|
| `broken_wikilink → TEST_REPORT` (×3) | resolved by this file existing; re-run `validate` to confirm |
| `broken_wikilink → ASSET_VERIFICATION_REPORT` | resolved by that file existing |

Historical note: they were reported *before* those two notes existed, which is the validator doing its job.

## 4. Not run (do not read as passing)

| Area | State | Why |
|---|---|---|
| Roblox Studio: audio playback | **not run** | requires Studio and ears |
| Roblox Studio: animation load (`track.Length`) | **not run** | same |
| Roblox Studio: model/plugin script inspection | **not run** | requires a human reading code |
| Any recipe code block | **not run** | every block is labelled `Untested:` |
| Phone/gamepad input | **not run** | needs a device |
| Performance measurements | **not run** | no place, no device |
| Embeddings / MCP server | **not built** | roadmap P19, deliberately deferred |

## 5. Measured timings (real, this machine)

`python scripts/gamedev_kb.py …` on 459 notes, wall clock for the whole process (so interpreter startup
~200 ms is included). Median of 3–5 runs, 2026-11-01:

| Command | Time |
|---|---|
| `index` (full rebuild, FTS5) | **648 ms** |
| `search "door creak" --limit 10` | **257 ms** |
| `asset 7274920568` | **219 ms** |
| `validate` (459 notes) | **582 ms** |

Interpretation: at this size the tooling is interactive. A vault 10× larger would still index in single-digit
seconds; no caching layer is warranted yet (`exports/benchmarks.json` holds the raw numbers).

## 6. Import integrity (non-destructiveness)

After two importer runs, all **14** source files under `imports/raw/` were re-hashed against
`imports/raw/SOURCE_MANIFEST.json`: **0 mismatches**. The source research record is byte-identical to what was
copied in, which is the rollback guarantee (no import ever edits its input).

## 7. How to reproduce

```bash
cd "<vault root>"
python scripts/gamedev_kb.py doctor
python scripts/gamedev_kb.py validate
python scripts/gamedev_kb.py index
python -m unittest discover -s tests -v
python scripts/gamedev_kb.py report
```

All of the above are read-only except `index`, `export` and `report --write-dashboards`.
