---
id: T-vfx
type: template
title: Template — VFX / lighting recipe with a performance budget
status: reviewed
updated: 2026-11-01
tags: [template]
source_urls: []
confidence: medium
verification: design_only
---

# Template — VFX / lighting recipe with a performance budget

> **Template.** Copy the block below into a new note, replace every `{placehold}`, and delete these
> instructions. Atmosphere is expensive; the budget column is not optional.

```markdown
---
id: N-{{slug}}
type: guide
title: {{Effect}}
status: draft
updated: {{date}}
tags: [vfx, lighting, performance]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: [ "H-profiling-budgets", "R-reduced-motion-policy" ]
---

# {{Effect}}

## Look
{{one paragraph, then the intended mood}}

## Build
| Layer | Instance | Property | Value |
|---|---|---|---|
| {{bloom}} | `BloomEffect` | `Intensity` | 0.4 |

## Performance budget
| Cost | Estimate | Ceiling |
|---|---|---|
| Draw calls | {{n}} | {{n}} |
| Full-screen passes | {{n}} | 2 |
| Particles per emitter | {{n}} | {{n}} |

## Accessibility
{{reduced-motion behaviour; flash limits per H-flicker-safety}}

## Code
```lua
-- Untested
{{code}}
```

## Measured
| Device | Frame time before | after | Date |
|---|---|---|---|
| {{device}} | {{ms}} | {{ms}} | {{date}} |
```
