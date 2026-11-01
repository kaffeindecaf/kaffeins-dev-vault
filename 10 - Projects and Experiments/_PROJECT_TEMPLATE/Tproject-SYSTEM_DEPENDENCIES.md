---
id: P-tpl-deps
type: project
title: "PROJECT TEMPLATE — system dependencies and input map"
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

# System dependencies — {{Project Name}}

## Module graph
```text
RoundController -> PlayerData -> Config
RoundController -> NpcController -> Perception -> Config
InteractionServer -> Inventory -> PlayerData
```

## Input map (one owner per key)
| Input | Action | Context | Owner |
|---|---|---|---|
| `E` / prompt | interact | world | {{script}} |
| `C` | crouch | world | {{script}} |
| `F` | flashlight | world | {{script}} |
| `LeftShift` / touch | sprint | world | {{script}} |

**Before adding a binding:** grep the key code. Duplicate bindings are the most common bug in a project that
grows by copy-paste.

## Remotes
| Remote | Direction | Purpose | Budget |
|---|---|---|---|
| {{Interact}} | client -> server | {{...}} | {{6/4 s}} |

