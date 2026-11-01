---
id: PR-secure-mechanic
type: prompt
title: Prompt — generate a secure server-authoritative mechanic
status: reviewed
updated: 2026-11-01
tags: [prompts, security, systems]
source_urls: []
confidence: medium
verification: reference_only
client_server: both
code_blocks: 0
related: "S-interaction-prompt", "G-server-authority-checklist", "T-system"
---

# Prompt: secure mechanic

```text
Task: implement <mechanic> in this vault's style, then write it up as a system note.

Requirements:
- Read AGENTS.md, then search for an existing recipe: python scripts/gamedev_kb.py search "<mechanic>" --type system
- If a recipe exists, extend it instead of creating a duplicate note.
- Server decides; the client only requests and renders. No client-supplied prices, distances or rewards.
- Per-player request budget for anything with a remote.
- Claims/occupancy written synchronously before any yield.
- List: API, server/client split, failure modes, and 3-5 test cases.

Output:
1. The code, every block labelled `Untested:` unless actually run.
2. A note created from 11 - Templates and Schemas/Templates/T-system.md with valid frontmatter.
3. `python scripts/gamedev_kb.py validate` output pasted verbatim.
```

## Refusal condition

If the mechanic requires Robux, saved-data changes, or deleting existing work, stop and ask — those are
approval gates in [[AGENTS]].

