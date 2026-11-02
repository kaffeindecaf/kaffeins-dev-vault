---
id: N-PROJECT-CONFIG
type: guide
title: PROJECT_CONFIG — settings, paths and scope boundaries
status: draft
updated: 2026-11-02
tags: [config, paths, scope]
source_urls: []
---

# PROJECT_CONFIG

## Release version

Current content release: **v1.0.0**. The canonical plain version is in `VERSION`;
`config/vault.json` mirrors it as `release_version`. The frontmatter schema remains
version 2 because this release does not change required note fields. Folder names
are historical local paths and do not determine release identity.

Machine-readable settings live in `config/vault.json`. This page explains them and the hard scope
boundaries. Both are the source of truth for the CLI and for any agent.

## Local environment (recorded 2026-11-01)

| Thing | Value |
|---|---|
| Vault root | The directory containing this file and `scripts/` |
| Platform used for the recorded local run | Windows; Python 3.14.7 |
| SQLite | 3.53.1 with **FTS5 available** (fallback is also implemented) |
| Git | Available; repository not initialized |
| Obsidian CLI | Not required; no plugin is required for anything here |
| Index | `config/index.sqlite` (git-ignoreable, regenerable) |

## Scope boundaries

**Allowed:** read/write inside the vault root only. Read the two import sources listed below.
Write `exports/` and `config/index.sqlite`.

**Read-only, never modified:** `imports/raw/**`. It is the research record — byte-exact copies,
hashes in `imports/raw/SOURCE_MANIFEST.json`. The public checkout uses the sanitized
`imports/SOURCE_MANIFEST_PUBLIC.json` because the original manifest contains a local path.

**Never touched by this project:** any other folder on the machine or any Roblox place unless
explicitly requested. The CLI refuses paths outside the
vault root and does not follow symlinks out of it.

**Never done automatically:** installing software or plugins, publishing, purchases, account or
permission changes, uploading anything, executing a script from an imported model.

## Secret handling

Excluded from walking and from the index by both directory rule and filename rule: `.env`,
`.env.*`, `*.key`, `*.pem`, `*.pfx`, `credentials*`, `secrets*`, `.git`, hidden app data,
`node_modules`, `__pycache__`, `imports/`, `exports/`. A fixture named like a secret is used to
prove the exclusion (see `tests/`). CLI output never prints file contents of an excluded path.

## Regeneration

Everything generated is reproducible:

```bash
python scripts/gamedev_kb.py index      # rebuilds config/index.sqlite
python scripts/gamedev_kb.py export --format json
python scripts/import_assets.py         # idempotent asset import
```

Deleting `config/index.sqlite` loses nothing — it is a cache, not a source.
