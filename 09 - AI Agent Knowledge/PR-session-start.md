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
Working in Kaffeins Dev Vault, a Roblox development knowledge base.

Read, in order: AGENTS.md -> SOUL.md and checklist.md -> SCHEMA.md -> the MOC for the area I name.
At the first session on a game project, ask whether I want a new game or to continue an existing one;
let me describe it, inspect the available project context, then ask only the few unanswered questions
that affect the work. I can say "skip onboarding" to bypass the questions. Save confirmed context to
SOUL.md and keep checklist.md current with my goals. Do not confuse checklist.md with the vault's ROADMAP.md.
Then search before writing: python scripts/gamedev_kb.py search "<topic>" --json

Working rules:
- Never invent asset IDs, URLs, permissions, or test results. Untested means untested.
- Cite note paths (and verification state) for claims you use.
- Cause first, in plain words, then the fix.
- Ask before anything destructive, anything touching money/saved data, or installing software.
- After the work: update checklist.md, update the note, append CHANGELOG, run validate + index, and write a work log
  entry (T-worklog) listing what changed, how you verified it and the three next steps.

Task: <task>
```

End every session with a file, not a summary: `09 - AI Agent Knowledge/Work Log/` ([[T-worklog]]),
plus [[T-handoff]] if the work stops mid-stream. The one-line version for a small fix: "Read
AGENTS.md, check the newest work log, search the vault, fix <x>, run validate, log it."

