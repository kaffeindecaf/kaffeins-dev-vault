---
id: T-decision
type: template
title: Template — architecture decision record
status: reviewed
updated: 2026-11-01
tags: [template]
source_urls: []
confidence: medium
verification: design_only
---

# Template — architecture decision record

> **Template.** Copy the block below into a new note, replace every `{placehold}`, and delete these
> instructions. Decisions that would be expensive to reverse. Short, dated, with consequences.

```markdown
---
id: D-{{number}}-{{slug}}
type: decision
title: {{decision}}
status: reviewed
updated: {{date}}
tags: [decisions]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: [ "DECISIONS" ]
---

# D-{{number}} - {{Decision}}

- **Date:** {{date}}
- **Status:** {{proposed|accepted|superseded by D-000X}}

## Context
{{what forces this decision}}

## Decision
{{what we will do}}

## Why
{{why this over the alternatives - name them}}

## Consequences
- Good: {{...}}
- Cost: {{...}}
- What would make us revisit this: {{trigger}}
```
