---
id: T-reference
type: template
title: Template — Roblox service / API reference note
status: reviewed
updated: 2026-11-01
tags: [template]
source_urls: []
confidence: medium
verification: design_only
---

# Template — Roblox service / API reference note

> **Template.** Copy the block below into a new note, replace every `{placehold}`, and delete these
> instructions. One page per API area, restating official docs with a stated scope.

```markdown
---
id: R-{{slug}}
type: reference
title: {{Topic}}
status: draft
updated: {{date}}
tags: [{{area}}]
source_urls: [ "https://create.roblox.com/docs/{{path}}" ]
confidence: medium
verification: reference_only
client_server: {{server|client|both}}
related: [ "{{related note}}" ]
---

# {{Topic}}

{{one paragraph: what this API does and when you reach for it}}

## Scope
- Runs on: {{server/client/both}}
- Needs: {{services, privileges, API access}}
- Not covered here: {{what this note ignores}}

## The API that matters

| Member | Use | Caveat |
|---|---|---|
| `{{Class.Method}}` | {{why}} | {{caveat}} |

## Pattern

```lua
-- {{Tested:|Untested:|Pseudocode:}} {{what it demonstrates}}
{{code}}
```

## Failure modes

| Failure | Symptom | Fix |
|---|---|---|
| {{cause}} | {{what the developer sees}} | {{fix}} |

## Budgets and limits
{{rate limits, quotas, memory, permissions}}

## Sources
{{official page(s), with access date}}
```
