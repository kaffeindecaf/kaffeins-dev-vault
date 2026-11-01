---
id: PR-luau-code-review
type: prompt
title: Prompt — Luau and remote-security review
status: reviewed
updated: 2026-11-01
tags: [prompts, review, security]
source_urls: []
confidence: medium
verification: reference_only
client_server: both
code_blocks: 0
related: "G-server-authority-checklist", "R-janitor-cleanup", "G-citation-rules"
---

# Prompt: code review

```text
Review this Luau for: correctness, client/server placement, remote safety, and cleanup.

Report as a table:
| Finding | Severity (critical/high/medium/low) | Why | Fix |
|---------|------------------------------------|-----|-----|

Check specifically:
- Any remote taking a value the server can derive (price, reward, distance) -> critical.
- Missing type/range validation on remote arguments.
- No per-player rate limit.
- State mutated on the client that the server also owns.
- Connections not cleaned on death/leave (janitor).
- Per-frame loops for non-visual work.
- `Humanoid.Health`/`WalkSpeed` written in more than one place.
- Duplicate input bindings for the same key.
- Debug tracing enabled.

Do not rewrite the file. Report first; change only what I approve.
```

Cross-check against [[G-server-authority-checklist]] and [[G-luau-code-review-checklist]].

