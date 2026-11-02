---
id: S-ui-progress-bar-component
type: system
title: UI progress bar with a textual value
status: draft
updated: 2026-11-02
tags: [ui, component, progress, luau]
source_urls: []
confidence: medium
verification: design_only
client_server: client
roblox_services: [TweenService]
code_blocks: 0
related: [ "R-ui-style-guide-tokens", "R-reduced-motion-policy", "S-objective-tracker" ]
---

# UI progress bar with a textual value

## Purpose

Show progress toward a known target, such as a collection count, objective or production cycle.

**Choose this pattern** when players can act toward a finite goal and the current numerator / total is meaningful. Use an indeterminate pulse only when the duration is genuinely unknown; never imply a known amount of progress that the system cannot calculate.

## Suggested hierarchy

```text
Frame (transparent wrapper)
├── Frame (track, ClipsDescendants=true)
│   ├── UICorner
│   └── Frame (fill, left anchored, width = normalized value)
│       └── UICorner
└── TextLabel (e.g. "12 / 50 found")
```

## Value and animation rules

Normalize with `clamp((value - min) / (max - min), 0, 1)`. Update the fill width with X.Scale while keeping Y at 1. Use a short tween for meaningful milestones, but set immediately when the screen opens or under reduced motion. The text value is the authoritative readable representation; color and length are secondary cues.

## Snippet

See `ui-progress-bar.luau` in `11 - Templates and Schemas/Luau Snippets/`. It updates a supplied fill and optional text label, clamps edge cases, and accepts a `reducedMotion` setting.

## Accessibility and review

- [ ] Text states current progress and target, not only a percentage.
- [ ] The fill and track remain distinguishable in grayscale/high contrast.
- [ ] Reduced motion uses an immediate size update.
- [ ] Unknown/zero maximum has a defined display instead of divide-by-zero.
- [ ] Test large values and localization of number separators.

## Verification

The hierarchy is a reusable design suggestion; the library snippet is `Untested:` in Studio.
