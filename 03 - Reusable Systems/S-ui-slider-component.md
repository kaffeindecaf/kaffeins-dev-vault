---
id: S-ui-slider-component
type: system
title: Accessible UI slider for bounded settings
status: draft
updated: 2026-11-02
tags: [ui, component, slider, settings, luau]
source_urls: []
confidence: low
verification: design_only
client_server: client
roblox_services: [UserInputService]
code_blocks: 0
related: [ "R-ui-patterns-ui-layout-project", "R-ui-style-guide-tokens", "R-controller-focus", "R-responsive-matrix" ]
---

# Accessible UI slider for bounded settings

## Purpose

A track and thumb for choosing a value within a meaningful range, such as music volume, camera sensitivity, or field of view. I did not find an existing slider in the inspected place; this is a new reusable component added because it is a common settings control, not an extracted project widget.

**Choose a slider** when the player needs to choose among many ordered values and immediate feedback is helpful. Choose discrete buttons, a dropdown, or a toggle when the values are few or exact values matter. Pair the slider with a visible value and accessible increment/decrement controls for gamepad or keyboard.

## Suggested hierarchy

```text
Frame (settings row)
├── TextLabel (setting name)
├── TextButton (minus; optional exact adjustment)
├── Frame (track, Active=true)
│   ├── Frame (fill)
│   └── ImageButton (thumb, Selectable=true)
├── TextButton (plus; optional exact adjustment)
└── TextLabel (formatted value, e.g. 65%)
```

Keep the visible track comfortable to drag, while using an oversized transparent input target if a thin visual track is desired. Never communicate value by color alone.

## Behaviour contract

The owning settings controller supplies `min`, `max`, `step`, initial value, formatter, and change callback. Clamp values, snap to `step`, update text and fill from one normalized value, and save through the caller's settings system. This component does not persist settings itself.

## Snippet

See `ui-slider.luau` in `11 - Templates and Schemas/Luau Snippets/`. It binds mouse/touch drag and returns a disconnect function. The snippet is a starter for pointer input; add keyboard/gamepad actions through the parent settings controller before calling the control accessible or complete.

## Review

- [ ] Current value is readable as text and has a stable unit.
- [ ] `min < max`; step divides the desired range or rounding behavior is documented.
- [ ] Dragging clamps exactly at both endpoints and does not lose tracking on release.
- [ ] A keyboard/gamepad user can adjust by one step in both directions.
- [ ] Touch target, focus outline, high contrast, and reduced motion are checked.
- [ ] Settings load/save behavior is owned by a separate settings layer.

## Verification

This is a library proposal without a slider in the source project's Explorer. The snippet is `Untested:` in Studio and needs pointer, touch, keyboard, and gamepad verification before reuse.
