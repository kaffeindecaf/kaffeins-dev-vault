---
id: PR-datastore-review
type: prompt
title: Prompt — review a Roblox player-data change
status: draft
updated: 2026-11-01
tags: [prompt, datastore, review, persistence]
source_urls: []
confidence: medium
verification: design_only
related: [ "G-skill-roblox-core-loop", "G-skill-roblox-mcp-workflow", "S-datastore-player-profile", "R-datastore-safety" ]
---

# Prompt — review a Roblox player-data change

Use this prompt with a concrete code diff and the relevant project source-of-truth notes.

```text
Review this Roblox player-data change. First identify the data owner and the server/client boundary.
Then trace load, in-memory mutation, save, retries, session locking, PlayerRemoving, BindToClose,
schema migration, and developer-product idempotency where relevant. Check that read failure cannot
become a default-profile overwrite, that UpdateAsync transforms do not yield or perform side
effects, and that requests remain within the documented budget. Separate findings from assumptions.
For each finding, cite the changed file and line, describe a reproducible failure case, and propose
the narrowest fix. Do not claim Studio or live verification unless the run and evidence are supplied.
Read [[S-datastore-player-profile]], [[S-save-load-migration]], [[R-datastore-safety]], and use the
`roblox-core-loop` skill. For Studio verification, also use the `roblox-mcp-workflow` skill and record
the observed evidence path.
```

Related graph nodes: [[S-datastore-player-profile]] · [[G-skill-roblox-core-loop]] ·
[[G-skill-roblox-mcp-workflow]].
