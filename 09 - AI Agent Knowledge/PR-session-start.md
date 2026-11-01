---
id: PR-session-start
type: prompt
title: Prompt — start a session on this vault
status: reviewed
updated: 2026-11-01
tags: [prompts, workflow]
source_urls: []
confidence: medium
verification: reference_only
client_server: both
code_blocks: 0
related: "AGENTS", "N-README", "T-session-wrapup"
---

# Prompt: session start

Paste at the beginning of a session, or let the harness inject it:

```text
Working in the GameDev-Knowledge-Base vault (Roblox development knowledge base).

Read, in order: AGENTS.md -> SCHEMA.md -> the MOC for the area I name.
Then search before writing: python scripts/gamedev_kb.py search "<topic>" --json

Rules I care about:
- Never invent asset IDs, URLs, permissions, or test results. Untested means untested.
- Cite note paths (and verification state) for claims you use.
- Cause first, in plain words, then the fix.
- Ask before anything destructive, anything touching money/saved data, or installing software.
- After the work: update the note, append CHANGELOG, and run validate + index.

My task: <task>
```

The one-line version for a small fix: "Read AGENTS.md, search the vault, fix <x>, run validate."

