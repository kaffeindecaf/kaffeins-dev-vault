---
id: G-agent-brief-gemini-cli
type: guide
title: Agent brief — Gemini CLI
status: reviewed
updated: 2026-11-01
tags: [agents, gemini, brief]
source_urls: []
confidence: medium
verification: reference_only
client_server: both
code_blocks: 0
related: "AGENTS", "G-agent-brief-hermes", "G-knowledge-promotion"
---

# Gemini CLI brief

Gemini CLI is useful for long-context summarisation over the vault. Its configuration differs from other
harnesses, so this brief sticks to files and one CLI.

## Approach

Give it **paths**, not questions, and let it read:

```bash
cd "<vault root>"
python scripts/gamedev_kb.py context "<topic>" --budget 12000 --out exports/context-pack.md
```

Then hand it `exports/context-pack.md` plus `AGENTS.md` and ask for a plan that cites note paths.

## Why the context pack

A large-context model can read 30 notes and lose the thread. `context` produces cited excerpts with
verification states attached, which keeps the answer grounded and makes hallucinated references obvious.

## Rules
- Ask for citations as `path` + `id`; refuse answers without them.
- Anything it writes must pass `validate`.
- Do not let it summarise a `design_only` note as if it were tested behaviour.

