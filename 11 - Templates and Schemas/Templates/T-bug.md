---
id: T-bug
type: template
title: Template — bug with reproduction and verified fix
status: reviewed
updated: 2026-11-01
tags: [template]
source_urls: []
confidence: medium
verification: design_only
---

# Template — bug with reproduction and verified fix

> **Template.** Copy the block below into a new note, replace every `{placehold}`, and delete these
> instructions. Cause before fix. The regression section is what stops it coming back.

```markdown
---
id: B-{{slug}}
type: bug
title: {{symptom as the player sees it}}
status: draft
updated: {{date}}
tags: [bug, {{system}}]
source_urls: []
confidence: medium
verification: untested
severity: {{critical|high|medium|low}}
hypothetical: {{true|false}}
client_server: both
code_blocks: 1
related: [ "{{related}}" ]
---

# {{Symptom}}

## Observed
{{what happens, with numbers where possible}}

## Reproduction
1. {{step}}
2. {{step}}
3. {{step}}

## Evidence
{{log line, screenshot path, measurement}} - or "none captured yet"

## Diagnosis
| Check | Finding |
|---|---|
| {{probe}} | {{result}} |

## Cause
{{plain words. "Not yet known" is acceptable; a guess presented as a cause is not.}}

## Fix
```lua
-- the smallest change at the source
{{code}}
```

## Verification
{{exact steps that now pass, and what you observed}}

## Regression prevention
{{test, checklist rule, or guard}}
```
