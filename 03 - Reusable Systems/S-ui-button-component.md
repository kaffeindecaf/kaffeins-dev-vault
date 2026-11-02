---
id: S-ui-button-component
type: system
title: Reusable UI button with explicit states
status: draft
updated: 2026-11-02
tags: [ui, component, button, luau]
source_urls: []
confidence: medium
verification: design_only
client_server: client
roblox_services: [TweenService, UserInputService]
code_blocks: 0
related: [ "R-ui-patterns-ui-layout-project", "R-ui-style-guide-tokens", "R-controller-focus", "R-mobile-safe-areas" ]
---

# Reusable UI button with explicit states

## Purpose

A reusable action control for a HUD or menu. The inspected `StarterGui.KrissyUI.MainFrame` uses distinct Index and Shop `TextButton`s with an icon, separate text label, rounded corners, a stroke, gradient, and aspect constraint. Its hierarchy makes each button's action readable and gives designers room to tune icon and label independently.

**Choose this design** for a primary or frequent destination that needs a label plus a recognizable icon. Use an icon-only control only when the symbol is established and an accessible text name is still supplied. For irreversible actions, use a confirm pattern rather than hover/click feedback alone.

## Suggested hierarchy

```text
TextButton (AutoButtonColor=false, Selectable=true, minimum 44x44 px touch target)
├── UICorner
├── UIStroke
├── UIGradient (optional)
├── UIScale
├── Icon (ImageLabel, optional)
└── Label (TextLabel, TextWrapped=true)
```

## State contract

| State | Visual treatment | Input |
|---|---|---|
| Idle | Base background and label | Available |
| Hover | Slight brighten or scale; short tween | Mouse hover only |
| Pressed | Brief smaller/darker state | Mouse, touch, or activation |
| Selected | Clear persistent outline/fill | Gamepad or keyboard focus |
| Disabled | Muted appearance plus disabled input | Action unavailable; include explanation nearby |

## Configuration to fill in

Supply label, optional icon asset value, colors, minimum size, corner radius, tween duration, sound policy, and callback. Keep action authority outside this presentation component; a button callback may request an action but must not claim a purchase succeeded.

## Snippet

See `ui-button.luau` in `11 - Templates and Schemas/Luau Snippets/` for the data-driven factory. The snippet accepts a `TextButton`, applies optional theme and reduced-motion behavior, and returns a cleanup function. Its UI interaction is client-side; connect `Activated` to an existing client controller or a server-validated remote.

## Why the project version is a useful reference

The project separates button action, icon, and text label and pairs them with a consistent rounded/stroked/gradient treatment. That lets one style work for two distinct destinations without hiding the action behind imagery. Rebuild with `Scale` positioning and verify thumb reach; the observed button child geometry is not a responsive layout specification.

## Accessibility and review

- [ ] Button is `Selectable` and has an intentional `SelectionOrder`/focus state.
- [ ] Touch target is at least 44×44 px (the project button is 78×74 px in the inspected properties).
- [ ] Text is legible without a gradient or color-only cue; icon image has a meaningful accessible name through nearby text.
- [ ] Disabled and error states explain why the action cannot run.
- [ ] Reduced motion skips scale/position tweens.
- [ ] Check desktop, phone portrait/landscape, gamepad focus, and long translated labels.

## Verification

The hierarchy and size observation come from Studio Edit mode. The standalone snippet is adapted for this library and is `Untested:` in Roblox Studio.
