---
id: CP-asset-validation
type: guide
title: Context pack — third-party asset validation
status: reviewed
updated: 2026-11-01
tags: [context-pack, agents]
source_urls: []
confidence: high
verification: design_only
client_server: both
code_blocks: 0
related: [ "AGENTS", "G-citation-rules" ]
---

# Context pack — third-party asset validation

Hold this before recommending any Creator Store asset.

Paste this block (or the note paths) into the agent's context. The rules are the compressed form of the linked
notes — where they conflict, the note wins and this pack needs fixing.

```text
1. All 206 asset records are `untested`. A grade `D` means a listing existed, nothing more.
2. Type decides usage: audio/animation use `rbxassetid://`; models are inserted by ID and reviewed in a blank
   place; plugins are a code-execution decision.
3. Never present a model ID as a SoundId or an animation ID.
4. Access is per experience: audio privacy and animation sharing both silently produce silence/empty poses.
5. `track.Length == 0` and `Sound.TimeLength == 0` are the decisive diagnostics.
6. Rights are separate from access. `license_status: unknown` means unsuitable for commercial use until read.
7. Never install a plugin or run a model's scripts because an agent suggested it.
8. Record findings in the asset note (`access_status` + `access_evidence`) or do not claim them.
```

## Sources

- [[G-asset-verification-workflow]]
- [[SCHEMA]]
- [[LICENSES_AND_SOURCES]]
- [[G-studio-model-inspection]]
- [[R-content-and-ownership]]

## Using it

```bash
python scripts/gamedev_kb.py context "client server authority" --budget 4000 --out exports/cp-client-server.md
```

A pack is a starting point, not a substitute for reading the note when the answer matters.
