---
id: G-agent-brief-opencode
type: guide
title: Agent brief — OpenCode
status: reviewed
updated: 2026-11-01
tags: [agents, opencode, brief]
source_urls: []
confidence: medium
verification: reference_only
client_server: both
code_blocks: 0
related: "AGENTS", "N-README", "G-knowledge-promotion"
---

# OpenCode brief

OpenCode is a terminal coding agent; treat it like any other: a directory, a task, a check.

## Bootstrap
```bash
cd "<vault root>"
sed -n '1,80p' AGENTS.md
python scripts/gamedev_kb.py search "<topic>" --limit 5
```

## Working style
- One note per task, one template, one validation run.
- Prefer `patch`-style edits over whole-file rewrites; the vault's notes are hand-written.
- Run `python scripts/gamedev_kb.py index` after adding notes so search sees them.

## Boundaries
- Vault root only; no writes to `imports/raw/`, `.obsidian/`, or sibling projects.
- No dependency installation; the CLI is stdlib-only by decision ([[DECISIONS]] D-0002).
- No claiming a Roblox Studio test was run.

