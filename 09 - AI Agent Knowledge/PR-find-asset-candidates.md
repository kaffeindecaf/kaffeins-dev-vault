---
id: PR-find-asset-candidates
type: prompt
title: Prompt — find three asset candidates
status: reviewed
updated: 2026-11-01
tags: [prompts, assets, retrieval]
source_urls: []
confidence: medium
verification: reference_only
client_server: both
code_blocks: 0
related: "G-asset-verification-workflow", "MOC-asset-library", "G-citation-rules"
---

# Prompt: find three asset candidates

```text
Task: propose THREE candidate Roblox assets for <use case> from this vault's asset library.

Steps:
1. python scripts/gamedev_kb.py search "<keywords>" --type asset --limit 20 --json
2. Prefer higher source_grade (D/G/R) over I/S. Prefer a category that matches the use.
3. For each candidate report: name, asset ID (string, exact), type, category, grade, path, suggested use.

Rules:
- Do NOT claim the asset is accessible, licensed, or safe. Every record is `untested`.
- Quote the caveat that applies (audio restriction / animation ownership / model scripts).
- If fewer than three plausible candidates exist, say so instead of padding with models used as sounds.
- End with the exact Studio verification steps for the user (see G-asset-verification-workflow).
```

## Why it is shaped this way

The failure mode it prevents: an agent listing 206 IDs as "your sound options". Three candidates with honest
caveats is usable; a wall of IDs is noise.

