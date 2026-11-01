---
id: T-experiment
type: template
title: Template — experiment
status: reviewed
updated: 2026-11-01
tags: [template]
source_urls: []
confidence: medium
verification: design_only
---

# Template — experiment

> **Template.** Copy the block below into a new note, replace every `{placehold}`, and delete these
> instructions. One question, one variable, one measurement. A guessed result is worse than a blank one.

```markdown
---
id: X-{{slug}}
type: experiment
title: {{question}}
status: draft
updated: {{date}}
tags: [experiment]
source_urls: []
confidence: low
verification: untested
client_server: both
code_blocks: 0
related: [ "X-experiments-index" ]
---

# {{Question}}

## Hypothesis
{{what you expect and why}}

## Variable
{{the single thing you change}}

## Method
1. {{step, with device and build}}
2. {{step}}

## Measure
{{the number and its unit}}

## Result
{{blank until observed. Write not run if not run.}}

## Conclusion
{{what you now do differently}}
```
