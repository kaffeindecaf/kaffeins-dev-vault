---
id: S-world-space-menu-camera
type: system
title: World-space menu with camera anchors
status: draft
updated: 2026-11-02
tags: [ui, camera, menu, accessibility]
source_urls: []
confidence: medium
verification: design_only
client_server: client
roblox_services: [TweenService, Workspace]
code_blocks: 0
related: [ "R-menu-patterns", "R-controller-focus", "R-reduced-motion-policy" ]
---

# World-space menu with camera anchors

Use authored camera anchors and world-space surfaces to give a menu a sense of place. Prefer a
conventional 2D panel when text clarity, accessibility or quick navigation outweighs the visual
tour. Treat a camera tour as one explicit UI state with a clear enter, transition, cancel and exit
path.

Design one client camera owner with explicit enter, transition, cancel and exit states. Save and restore camera type, subject and relevant GUI states; cancel prior tweens and prevent stale completions from reviving motion after exit. Do not assume the old camera or character survives respawn. Provide a reduced-motion instant transition and a 2D accessible alternative, `Activated` actions, explicit keyboard/gamepad focus and readable labels. Do not destroy shared world geometry merely to close a menu. The `camera-menu-transition.luau` helper is an untested adaptation, not the source code or a complete menu. Test focus, rapid switching, respawn, camera replacement, small screens and all input modes.
