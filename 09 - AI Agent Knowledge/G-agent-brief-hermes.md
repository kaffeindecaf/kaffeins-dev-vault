---
id: G-agent-brief-hermes
type: guide
title: Agent brief — Hermes Agent
status: reviewed
updated: 2026-11-01
tags: [agents, hermes, brief]
source_urls: []
confidence: medium
verification: reference_only
client_server: both
code_blocks: 0
related: "AGENTS", "N-README", "G-knowledge-promotion"
---

# Hermes brief

Hermes is the harness this vault was built with. Use filesystem and shell access; no special integration is
required.

## Read order
1. [[AGENTS]] — the contract.
2. [[SCHEMA]] — frontmatter rules before you write a note.
3. The relevant MOC ([[MOC-start-here]] indexes them).
4. `python scripts/gamedev_kb.py search "<topic>" --json` before inventing anything.

## Commands

```bash
cd "<vault root>"
python scripts/gamedev_kb.py doctor
python scripts/gamedev_kb.py search "server authoritative pickup" --json
python scripts/gamedev_kb.py context "inventory replication" --budget 6000 --out exports/pack.md
python scripts/gamedev_kb.py asset 9114145200
python scripts/gamedev_kb.py validate && python scripts/gamedev_kb.py index
```

## Habits that matter in this harness
- Batch independent reads/searches; don't serialise one tool call per note.
- Write files with the file tools, not shell heredocs.
- Report real command output; never describe a test you did not run.
- Keep the vault root as the working directory for CLI calls so relative paths resolve.

## Never
- Never edit `imports/raw/**`, `.obsidian/`, or anything outside the vault root without explicit approval.
- Never mark `verification: tested_*` without a real Studio run and an evidence path.

