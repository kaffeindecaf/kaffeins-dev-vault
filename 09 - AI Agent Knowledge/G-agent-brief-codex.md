---
id: G-agent-brief-codex
type: guide
title: Agent brief — OpenAI Codex CLI
status: reviewed
updated: 2026-11-01
tags: [agents, codex, brief]
source_urls: []
confidence: medium
verification: reference_only
client_server: both
code_blocks: 0
related: "AGENTS", "G-knowledge-promotion", "N-ROADMAP"
---

# Codex brief

Codex works best when it is pointed at a directory and given an explicit, verifiable task. Nothing here assumes
a Codex-specific integration.

## Bootstrap

```bash
cd "<vault root>"
cat AGENTS.md            # the contract
python scripts/gamedev_kb.py doctor
python scripts/gamedev_kb.py search "<topic>" --json
```

There is no `codex.json` for this project and none is needed: the vault is plain files plus one CLI.

## Task shape that works

Give it a bounded scope and an acceptance test:

> "Add a note `R-sound-groups` under `02 - Roblox Development/Services and APIs/`, following `SCHEMA.md`.
> `source_urls` must point at `create.roblox.com/docs/...`; `verification: reference_only`. Then run
> `python scripts/gamedev_kb.py validate` and report the output."

## Rules
- Do not let it rewrite generated dashboards by hand — run `report --write-dashboards`.
- Do not let it edit `ROADMAP.md` checkboxes without evidence; checkboxes are the ledger.
- Confirm diffs (`git diff` is unavailable until `git init`; use `diff` on a copy).

