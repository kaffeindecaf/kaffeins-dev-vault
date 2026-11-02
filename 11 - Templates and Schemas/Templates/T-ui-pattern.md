---
id: T-ui-pattern
type: template
title: Template — reusable UI pattern with provenance
status: draft
updated: 2026-11-02
tags: [template, ui, provenance]
source_urls: []
confidence: medium
verification: design_only
---

# Template — reusable UI pattern with provenance

Use this for a single reusable component or layout recipe extracted from a Roblox place or designed for a common interaction. Keep project observations distinct from generalized advice, include the exact Explorer path, and label all adapted code as untested until it runs.

````markdown
---
id: S-{{stable-slug}}
type: system
title: {{Component or layout pattern}}
status: draft
updated: {{YYYY-MM-DD}}
tags: [ui, component, {{kind}}]
source_urls: []
confidence: low
verification: design_only
client_server: {{client|server|both}}
code_blocks: 0
related: [ "R-responsive-matrix", "R-ui-style-guide-tokens" ]
---

# {{Component or layout pattern}}

## Purpose
{{Player task and what this component communicates}}

## Source evidence
{{Place name/id, exact Explorer path(s), mode, read-only/tested status, date}}

## Hierarchy and layout
```text
{{ScreenGui → panel → controls; include layout objects and key constraints}}
```

## Why it works
{{Explain the information order, feedback, and usability benefit}}

## When to choose it
{{Best fit, alternatives, and conditions where it becomes a poor fit}}

## Data/configuration contract
{{AI-fillable fields, value ranges, defaults, events, and server-owned facts}}

## Assets
| Role | Exact ID/value | Permission/access checked? |
|---|---|---|

## Snippet
{{Link a .luau file}} — **Untested:** {{what to run and observe}}

## Responsive and accessibility checks
- [ ] Phone portrait and landscape; safe areas and touch targets
- [ ] Keyboard/gamepad focus and visible selected state
- [ ] Text scale, localization, contrast, color-independent status
- [ ] Reduced motion and cancellation

## Known limits and verification
{{What was observed, what was not tested, and what needs human review}}
````

Before promoting a pattern, compare it with [[T-ui]], [[R-responsive-matrix]], and [[LICENSES_AND_SOURCES]].
