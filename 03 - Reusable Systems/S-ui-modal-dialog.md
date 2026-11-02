---
id: S-ui-modal-dialog
type: system
title: Centered modal with clear open and close behaviour
status: draft
updated: 2026-11-02
tags: [ui, component, modal, luau]
source_urls: []
confidence: medium
verification: design_only
client_server: client
roblox_services: [TweenService, GuiService]
code_blocks: 0
related: [ "R-ui-patterns-ui-layout-project", "R-menu-patterns", "R-controller-focus", "R-reduced-motion-policy" ]
---

# Centered modal with clear open and close behaviour

## Purpose

Give a finite task focused attention while preserving a visible exit. The project's Index and Shop panels are centered with `AnchorPoint = (0.5, 0.5)`, scale position `(0.5, 0.5)`, aspect constraints, and separate close buttons. Its UI controller also coordinates the HUD, an optional overlay, blur, sound, and modal tweens.

**Choose a modal** for a focused task that should temporarily pause access to the rest of the HUD, such as inventory, collection, or a settings page. Use a toast for brief feedback, a tooltip for optional detail, or a docked panel if players must keep watching the world.

## Behaviour contract

On open: store the currently selected control, show the panel and backdrop, focus the first meaningful action, and animate only if motion is enabled. On close: hide the panel, clear the backdrop, restore the previous focus target if it still exists, and cancel any in-flight animation. Support close button, Escape/back, and gamepad cancel when appropriate. Never trap the player without an obvious exit.

## Layout

```text
ScreenGui (DisplayOrder above HUD)
├── Backdrop (optional, dismiss-on-click only if safe)
└── Modal (AnchorPoint 0.5,0.5; Position 0.5,0.5)
    ├── Header / title
    ├── Content (scroll if needed)
    └── CloseButton (large hit target, stable focus order)
```

Use a `UISizeConstraint` and/or `UIAspectRatioConstraint` thoughtfully; one cannot prove the other handles all target aspect ratios. Keep margins for device safe areas and let tall content scroll inside the panel.

## Snippet

See `ui-modal.luau` in `11 - Templates and Schemas/Luau Snippets/` for an open/close controller accepting a panel, backdrop, first focus target, and reduced-motion flag. It is a visual starter; wire Escape/back and gamepad cancellation through the owning UI controller.

## Review

- [ ] Panel remains on-screen at the smallest viewport and content can scroll.
- [ ] Focus enters, stays within the task if needed, and restores on close.
- [ ] Close button and back input both work; a backdrop click is never the only exit.
- [ ] Reduced motion skips blur, overshoot, and movement.
- [ ] Opening a second modal has a defined policy; modals do not stack unintentionally.
- [ ] Background dimming still leaves context readable when required.

## Verification

The modal placement and constraint evidence is read from the place in Studio Edit mode. The snippet is adapted, `Untested:` in Roblox Studio, and does not reproduce the source controller's complete state logic.
