---
id: T-ai-state
type: template
title: Template — enemy behaviour / decision state
status: reviewed
updated: 2026-11-01
tags: [template]
source_urls: []
confidence: medium
verification: design_only
---

# Template — enemy behaviour / decision state

> **Template.** Copy the block below into a new note, replace every `{placehold}`, and delete these
> instructions. One note per archetype or state, with explicit guards, timeouts and observable output.

```markdown
---
id: R-{{slug}}
type: reference
title: {{Archetype or state}}
status: draft
updated: {{date}}
tags: [ai, npc]
source_urls: []
confidence: medium
verification: design_only
client_server: server
code_blocks: 1
related: [ "R-npc-state-machine" ]
---

# {{Archetype or state}}

## Purpose
{{what this behaviour is for, in one sentence}}

## Inputs
| Input | Source | Use |
|---|---|---|
| {{sight or hearing or memory}} | {{where}} | {{how}} |

## Transitions
| From | To | Guard | Timeout |
|---|---|---|---|
| {{state}} | {{state}} | {{condition}} | {{fallback after N s}} |

## Tunables
| Value | Default | Range |
|---|---|---|
| {{sightRange}} | 60 | 20-120 |

## Observability
- `model:SetAttribute("BrainState", ...)` so a test can read it
- Log line on every transition: `{{format}}`

## Test matrix
| Scenario | Expected |
|---|---|
| {{case}} | {{result}} |
```
