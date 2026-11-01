---
id: P-tpl-testplan
type: project
title: "PROJECT TEMPLATE — test plan and evidence log"
status: reviewed
updated: 2026-11-01
tags: [project-template]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: [ "MOC-projects" ]
---

# Test plan — {{Project Name}}

## Must pass before a playtest
| # | Test | Method | Result |
|---|---|---|---|
| 1 | Join, spawn, no console errors | Studio F5, read Output | |
| 2 | Core loop completes once | manual play | |
| 3 | Save/load survives rejoin | private server | |
| 4 | Remote spam does not break state | scripted client | |
| 5 | UI at 3 viewports | device emulator, screenshots | |

## Evidence log
| Date | Build | Test | Observed | Evidence |
|---|---|---|---|---|
| {{2026-xx-xx}} | {{place id / version}} | {{test}} | {{result}} | {{screenshot path}} |

## Not run
Anything without a row above is **not run**. Do not describe it as working.

