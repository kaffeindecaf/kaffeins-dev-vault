---
id: WL-20261102-distribution-privacy-review
type: worklog
title: Distribution privacy review
status: draft
updated: 2026-11-02
tags: [worklog, privacy, release]
source_urls: []
agent: Codex
confidence: high
verification: tested_local
tested_at: 2026-11-02
test_evidence: worklog-2026-11-02-distribution-privacy-review.md
related: ["N-AGENTS", "N-CHANGELOG", "N-USER-CHECKLIST", "N-ISSUES"]
---

# Distribution privacy review

## Task and scope

Audit the distributable vault for named personal projects, private identifiers, personal paths and
owner-specific history that could confuse a new reader. Preserve byte-exact raw imports and retain
local source notes in the ignored archive.

## Files changed

| File / area | Change / purpose | Verification |
|---|---|---|
| `.private-project-notes/` | Kept detailed source audits and owner-specific work logs in a local ignored archive. | `git status --short`; ignored archive excluded from distributable tree |
| `01 - Asset Library/` | Replaced source-specific filesystem paths in 206 imported asset notes with a generic provenance pointer. | Targeted content search; raw imports untouched |
| `scripts/import_assets.py`, `scripts/build_asset_indexes.py` | Made import tooling locate the unique source JSON under `imports/raw/` and emit generic provenance, so future regeneration does not restore source-specific paths. | Python bytecode compilation |
| Reusable systems, templates, agent notes and navigation | Generalized source-derived notes and regenerated MOCs/dashboards so deleted local records no longer appear in navigation. | Targeted content search; report |
| `README.md`, `ROADMAP.md`, `STATUS.md`, `RELEASE_CHECKLIST.md`, `RELEASE-v1.0.0.md`, `DECISIONS.md`, `ISSUES.md`, `CHANGELOG.md`, `AGENTS.md`, `13 - Dashboards/G-optional-obsidian-enhancements.md` | Removed project-specific context, documented the privacy rule, generalized device/sync references and noted historical archive follow-up. | Manual content review; validation |
| `checklist.md` | Recorded the completed distributable-tree cleanup and linked the separate archive-history issue. | Manual content review |
| This work log | Recorded scope and verification. | Validation |

## Verification

`rtk proxy python scripts/build_mocs.py` regenerated 11 maps.

`rtk proxy python scripts/gamedev_kb.py report --write-dashboards` reported 538 content notes,
0 warnings and 0 broken links, then refreshed the dashboards.

`rtk proxy python scripts/gamedev_kb.py validate` checked 546 notes, with 0 errors and 0 warnings.

`rtk proxy python scripts/gamedev_kb.py index` indexed 546 notes with FTS5. The final index is rebuilt
after this entry is complete.

The raw import folder was not edited. The automated test suite was not run; this was a content and
documentation cleanup. Previously published Git history and release archives may retain older
content; see [[ISSUES]] R-06 for the separate release review.

## Decisions and assumptions

- Generalized reusable guidance stays in the shared tree; source-specific research and session
  records stay local and ignored.
- Asset-note provenance points to the immutable raw import and sanitized public manifest without
  repeating the original source directory name in every note.
- Historical published content is tracked separately and was not rewritten or republished.

## Open questions

- Earlier public release archives and history still need a separate maintainer review before they
  are replaced.

## Three logical next steps

1. Review previous release archives before a future distribution update; done when every offered
   archive matches the sanitized current tree.
2. Keep future project-specific audits in the ignored local archive; done when new shared notes
   contain only generalized findings.
3. Recheck privacy terms during future release review; done when targeted search finds no specific
   project names, private paths or personal identifiers in the distributable tree.
