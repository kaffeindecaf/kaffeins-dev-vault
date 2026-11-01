---
id: T-module
type: template
title: Template — Luau module and API contract
status: reviewed
updated: 2026-11-01
tags: [template]
source_urls: []
confidence: medium
verification: design_only
---

# Template — Luau module and API contract

> **Template.** Copy the block below into a new note, replace every `{placehold}`, and delete these
> instructions. For any reusable ModuleScript: the contract first, the implementation second.

```markdown
---
id: S-{{slug}}
type: system
title: {{ModuleName}} module
status: draft
updated: {{date}}
tags: [module, code]
source_urls: []
confidence: medium
verification: untested
client_server: {{server|client|both}}
dependencies: [ "{{note id}}" ]
code_blocks: 1
related: [ "{{related}}" ]
---

# {{ModuleName}}

{{one paragraph: the single responsibility. If it needs "and", split it.}}

## API

| Function | Returns | Mutates | Notes |
|---|---|---|---|
| `M.new(args)` | `M` | - | {{constructor contract}} |
| `M:method(x)` | `{{type}}` | {{what}} | {{preconditions}} |

## Contract rules
- {{invariant}}
- Never {{the thing that would break authority or state}}

## Implementation

```lua
-- {{Tested:|Untested:}} {{what was exercised}}
{{code}}
```

## Failure modes
| Failure | Result | Guard |
|---|---|---|
| {{case}} | {{what happens}} | {{guard}} |

## Tests
1. {{case}}
2. {{case}}
```
