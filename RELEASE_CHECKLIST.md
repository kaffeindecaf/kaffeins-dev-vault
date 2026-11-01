---
id: N-RELEASE-CHECKLIST
type: guide
title: Public release checklist
status: draft
updated: 2026-11-01
tags: [release, github, provenance, review]
source_urls: []
---

# Public release checklist

The maintainer confirmed permission to redistribute the imported research and adapted notes. This checklist records the remaining repository-preparation steps and the attribution details that were not present in the source files.

## Before making a repository public

- [x] Selected the CC0 1.0 Universal dedication for material the maintainer owns or is authorized to dedicate; see [LICENSE](LICENSE).
- [x] Confirmed redistribution permission with the maintainer for the 206 imported records, the three additional candidates, and the adapted system notes. This is a maintainer statement, not an independent rights audit.
- [x] Added [[CREDITS]] with source links and noted where names were absent rather than guessing them.
- [x] Kept the byte-exact raw files unchanged and created `imports/SOURCE_MANIFEST_PUBLIC.json`, which omits the local path embedded in the private raw manifest.
- [x] Confirmed `.obsidian/` contains no files.
- [x] Added `.gitignore` rules for the local index, exports, scratch imports, credentials, and editor noise.
- [ ] Audit notes and fixtures for any other personal information, private project details, or credentials.
- [ ] Review external links and hosted diagrams for availability.
- [ ] Confirm the README's counts and command examples against the release tree.
- [ ] Create a clean Git history and inspect the staged file list and diff before publishing.
- [ ] Run `python scripts/gamedev_kb.py validate`, `python scripts/gamedev_kb.py index`, and `python -m unittest discover -s tests -v`; record the actual output.
- [ ] Have a maintainer review this checklist and approve the release contents.

## Remaining checks

- Asset access and license status have not been verified in Studio.
- The vault has not been prepared as a Git repository.
- Creator names are absent from some source records; see [[CREDITS]].

The source URLs and CC0 dedication do not grant permission to use the linked Roblox assets themselves.
