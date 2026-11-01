---
id: T-system
type: template
title: Template — gameplay mechanic recipe
status: reviewed
updated: 2026-11-01
tags: [template]
source_urls: []
confidence: medium
verification: design_only
---

# Template — gameplay mechanic recipe

> **Template.** Copy the block below into a new note, replace every `{placehold}`, and delete these
> instructions. The shape used by every recipe in 03 - Reusable Systems.

```markdown
---
id: S-{{slug}}
type: system
title: {{Mechanic}}
status: draft
updated: {{date}}
tags: [systems, {{area}}]
source_urls: []
confidence: medium
verification: design_only
client_server: {{server|client|both}}
roblox_services: [ {{Service}} ]
dependencies: [ "{{note id}}" ]
code_blocks: 1
related: [ "{{related}}" ]
---

# {{Mechanic}}

{{one paragraph: what it does, and the failure it prevents.}}

## Server / client split

| Responsibility | Side |
|---|---|
| {{decide}} | server |
| {{render or request}} | client |

## API
```lua
{{contract}}
```

## Implementation
```lua
-- Untested
{{code}}
```

## Failure modes
| Failure | Consequence | Prevention |
|---|---|---|
| {{case}} | {{what breaks}} | {{guard}} |

## Test cases
1. {{normal path}}
2. {{two actors, one resource}}
3. {{out of range or invalid}}
4. {{disconnect or respawn}}
5. {{round reset}}
```
