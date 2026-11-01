---
id: T-horror
type: template
title: Template — horror direction / pacing pattern
status: reviewed
updated: 2026-11-01
tags: [template]
source_urls: []
confidence: medium
verification: design_only
---

# Template — horror direction / pacing pattern

> **Template.** Copy the block below into a new note, replace every `{placehold}`, and delete these
> instructions. For beats, cues and director changes: measured, accessible, honest about being a design.

```markdown
---
id: H-{{slug}}
type: principle
title: {{Pattern}}
status: draft
updated: {{date}}
tags: [horror, pacing]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: [ "H-tension-hierarchy" ]
---

# {{Pattern}}

## Intended effect
{{what the player should feel, in one sentence}}

## Mechanics
| Element | Value | Why |
|---|---|---|
| {{cue}} | {{timing}} | {{reason}} |

## Implementation
```lua
-- Untested
{{sketch}}
```

## Accessibility
- Intensity level affected: {{0-3}}
- Reduced-motion / reduced-flash behaviour: {{what changes}}
- Never: {{the unsafe version}}

## Measurement
| Metric | Target | How measured |
|---|---|---|
| {{cue to resolution}} | 8-20 s | {{log}} |

## Failure modes
| Mistake | Result |
|---|---|
| {{too frequent}} | {{desensitisation}} |
```
