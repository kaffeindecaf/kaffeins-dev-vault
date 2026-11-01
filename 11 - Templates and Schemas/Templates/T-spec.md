---
id: T-spec
type: template
title: Template — task specification with acceptance criteria
status: reviewed
updated: 2026-11-01
tags: [template]
source_urls: []
confidence: medium
verification: design_only
---

# Template — task specification with acceptance criteria

> **Template.** Copy the block below into a new note, replace every `{placehold}`, and delete these
> instructions. What a feature request looks like before code: scope, acceptance, out-of-scope.

```markdown
---
id: SP-{{slug}}
type: spec
title: Spec — {{feature}}
status: idea
updated: {{date}}
tags: [spec]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: [ "{{project}}" ]
---

# Spec — {{feature}}

## What I want
{{the feature, in the player's terms}}

## Must have
- {{observable requirement}}

## Must not change
- {{saved data schema / existing mechanic / UI the user styled}}

## Out of scope
- {{explicitly not this}}

## Acceptance criteria
1. {{testable statement}}
2. {{testable statement}}

## Questions already answered
- {{Q -> A}}

## How I will know it is done
{{the playtest, the number, the screenshot}}

## Report format
Cause -> change -> how tested -> what remains open.
```
