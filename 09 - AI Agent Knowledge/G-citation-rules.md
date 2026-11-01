---
id: G-citation-rules
type: guide
title: Citation rules for agents
status: reviewed
updated: 2026-11-01
tags: [agents, sources, citations]
source_urls: []
confidence: medium
verification: reference_only
client_server: both
code_blocks: 0
related: "AGENTS", "G-knowledge-promotion", "MOC-sources"
---

# Citations

An answer without a path is an opinion. Every substantive answer from an agent includes citations in one shape.

## Required shape

```text
Claim. — `path/to/note.md` (id, verification)
```

Examples:

```text
Pickups must reserve the item before granting it. — `03 - Reusable Systems/S-pickup-server-authoritative.md` (S-pickup-server-authoritative, design_only)
That sound may not play in your game; audio is often experience-restricted. — `01 - Asset Library/Audio/asset-9114145200.md` (A-9114145200, untested, grade D)
```

## Rules

1. **Cite the note you used**, by path. Not "the vault says".
2. **Include the verification state.** `design_only` and `tested_studio` are different answers.
3. **Never cite a source you did not open.** If you are recalling it, say "from memory, unverified".
4. **Do not cite this vault as authority for Roblox platform behaviour.** Cite the platform docs
   ([[G-roblox-api-links]]); the vault is a summary.
5. **Asset claims carry the grade**: a `D` means a listing existed, not that the asset works.

## When there is no source

Say so, plainly: "I could not find this in the vault; the following is a general pattern, unchecked." A flagged
gap is useful; a confident fabrication is not.

