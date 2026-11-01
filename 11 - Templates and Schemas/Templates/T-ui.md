---
id: T-ui
type: template
title: Template — UI component with accessibility checks
status: reviewed
updated: 2026-11-01
tags: [template]
source_urls: []
confidence: medium
verification: design_only
---

# Template — UI component with accessibility checks

> **Template.** Copy the block below into a new note, replace every `{placehold}`, and delete these
> instructions. Every UI change ships with responsive and accessibility evidence, or an explicit not-run.

```markdown
---
id: N-{{slug}}
type: guide
title: {{Component}}
status: draft
updated: {{date}}
tags: [ui, component]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: [ "R-responsive-matrix", "R-ui-style-guide-tokens" ]
---

# {{Component}}

## Purpose
{{what it is for; where it appears}}

## Hierarchy
```text
ScreenGui (ResetOnSpawn=false, DisplayOrder={{n}})
└── {{Frame}}   Size={{udim2}}  AnchorPoint={{vector2}}
    ├── {{Label}}   TextSize={{n}}  TextWrapped=true
    └── {{Button}}  Size={{n}},{{n}}  (>44px touch)
```

## Tokens used
| Token | Value |
|---|---|
| {{space-4}} | 16 |

## Behaviour
{{open/close, focus, cancellation, sounds}}

## Code
```lua
-- Untested
{{code}}
```

## Accessibility
- [ ] Touch targets >= 44x44
- [ ] Text >= 16 px effective, contrast >= 4.5:1
- [ ] Controller focus in on open, restored on close
- [ ] Reduced motion honoured (no overshoot)
- [ ] Meaning not conveyed by colour alone

## Responsive evidence
| Viewport | Result | Evidence |
|---|---|---|
| 1920x1080 | {{pass/fail/not run}} | {{screenshot path}} |
| 667x375 | | |
| 375x667 | | |
```
