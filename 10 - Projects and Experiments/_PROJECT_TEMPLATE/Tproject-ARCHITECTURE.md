---
id: P-tpl-architecture
type: project
title: "PROJECT TEMPLATE — architecture"
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

# Architecture — {{Project Name}}

## Instance layout
```text
ServerScriptService/
  Systems/          orchestration
  Modules/          domain logic (PlayerData, Inventory, Economy)
ReplicatedStorage/
  Shared/           pure helpers
  Remotes/          remote instances only
  Config/           display copy of tunables
ServerStorage/
  Models/           rigs, templates, backups
StarterPlayer/StarterPlayerScripts/   client systems
StarterGui/                            authored UI (Jazerp edits these by hand)
```

## Systems and owners
| System | Where | Owner module | Notes |
|---|---|---|---|
| {{rounds}} | {{path}} | {{module}} | |

## Data
| Store | Key | Schema version | Writer |
|---|---|---|---|
| {{store}} | {{key}} | {{n}} | {{module}} — the ONLY writer |

## Dependency direction
`Systems -> Modules -> Shared`. No cycles; no client require of a server module.

## Deliberate limits
- {{what this architecture refuses to do, and why}}

