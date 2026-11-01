---
id: R-controller-focus
type: reference
title: Controller focus, navigation and keyboard-only support
status: reviewed
updated: 2026-11-01
tags: [ui, input, accessibility]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "R-menu-patterns", "R-inventory-slots-tooltips", "R-responsive-matrix"
---

# Controller and keyboard navigation

Roblox's `GuiObject.Selectable` + `SelectionOrder`/`NextSelection` handle gamepad and keyboard focus — if
you configure them. Otherwise a controller user is stuck on a screen with a mouse they do not have.

## Enable it properly

| Property | Value | Why |
|---|---|---|
| `ScreenGui.Enabled` | true | trivial, but a disabled screen still captures nothing |
| Each button `Selectable` | true | focusable |
| `SelectionOrder` | explicit ints | deterministic tab order |
| `NextSelectionUp/Down/Left/Right` | wired | spatial navigation |
| `GuiService.SelectedObject` | set on open | focuses the first sensible control |

## Modal focus pattern

```lua
-- Untested: focus in on open, restore on close
local GuiService = game:GetService("GuiService")
local previous

local function openModal(modal, firstButton)
    previous = GuiService.SelectedObject
    modal.Enabled = true
    GuiService.SelectedObject = firstButton
end

local function closeModal(modal, launcher)
    modal.Enabled = false
    GuiService.SelectedObject = previous or launcher
end
```

Restoring focus to the **launcher** is what stops the "closed the shop and can't move" bug on console.

## Rules

1. **Never trap focus**: `Tab`/D-pad must always be able to leave a panel.
2. **A modal takes focus, a toast does not.**
3. **Escape/Back closes.** `GuiService:AddSelectionParent` helps scope navigation per modal.
4. **Scrollable lists need focus-follow-camera**: keep the selected item on screen.
5. **Test with the Controller Emulator**, and with the keyboard only.

## Accessibility overlap

Keyboard-only users are a real minority on Roblox (most use touch or controller), but a keyboard-only
path is also how most QA happens. If it does not work with only `Tab`/`Enter`, your own testing will be
slower.

See [[R-menu-patterns]] · [[R-responsive-matrix]].

