---
id: G-agent-brief-claude-code
type: guide
title: Agent brief — Claude Code
status: reviewed
updated: 2026-11-01
tags: [agents, claude, brief]
source_urls: []
confidence: medium
verification: reference_only
client_server: both
code_blocks: 0
related: "AGENTS", "G-agent-brief-hermes", "T-system"
---

# Claude Code brief

Claude Code reads files and runs commands in the project directory. The vault's own `CLAUDE.md` is deliberately
thin: point at `AGENTS.md` rather than duplicating rules.

## Setup

1. Open the vault root as the working directory.
2. Ensure a `CLAUDE.md` at the root contains, at minimum:

```markdown
Read AGENTS.md first. This is a documentation vault for Roblox development.
Never invent asset IDs, URLs, permissions or test results.
Search with: python scripts/gamedev_kb.py search "<topic>" --json
Validate before finishing: python scripts/gamedev_kb.py validate
```

3. Ask it to cite note paths in its answer.

## Useful prompts
- "Search the vault for the door interaction recipe; summarise its API and failure modes with paths."
- "Draft `S-<name>` from `11 - Templates and Schemas/Templates/T-system.md`; keep every code block labelled Untested."

## Guardrails
- It must not touch `imports/raw/**`.
- It must not "fix" a `verification: untested` note by claiming it works.
- Long sessions: have it write progress to `STATUS.md` before it stops.

