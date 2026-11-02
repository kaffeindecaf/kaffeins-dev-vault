---
id: H-ui-horror-overlay-composition
type: reference
title: Horror UI overlay built from restrained image layers
status: draft
updated: 2026-11-02
tags: [horror, ui, composition, assets]
source_urls: []
confidence: low
verification: design_only
client_server: client
code_blocks: 0
related: [ "R-ui-patterns-ui-layout-project", "R-horror-hud", "R-ui-image-9slice", "R-reduced-motion-policy" ]
---

# Horror UI overlay built from restrained image layers

## Observed source

The project has `Workspace.meatyhorrorUIbackground.StarterGUI.ScreenGui.BackgroundFrame`, a centered, partially transparent frame around 447×343 px. Its named children combine a rust panel, flesh and vein overlays, gear, a drip accent, a shape layer, and two image buttons named `TeethButton` and `HeartButton`. The source includes scripts under some image objects and a separate vignette ScreenGui folder.

These items are stored under `Workspace` in this place, not `StarterGui`; treat them as a staged visual experiment until deliberately copied and reviewed. No runtime screenshot or behavior test was performed.

## Why layered art can work in horror

One large texture establishes material and genre, while a few small foreground accents create depth and a sense that the interface belongs in the world. Keeping the control silhouettes separate from decorative layers preserves click targets and gives motion to only the parts that need it. This approach is useful for a title screen, a special event panel, or a diegetic machine interface.

## When to use it

- Use a limited layer stack for a deliberate focal surface that should feel physical or unsettling.
- Use a quieter, flatter HUD for persistent health, inventory, and objective information that must be read during play.
- Keep edge decoration outside text safe zones and reserve negative space for the action labels.
- Use authored image assets with documented permission; asset IDs read from a project do not prove reuse rights.

## Project image values read in Studio

These are observed property values only; access, ownership, licensing, and moderation are unchecked.

| Instance | Image value |
|---|---|
| FleshOverlay | `rbxassetid://106007764806678` |
| RustPanel | `rbxassetid://130978676698587` |
| VeinOverlay | `rbxassetid://74696688473613` |
| GearCluster | `rbxassetid://83649906888158` |
| GooDrip | `rbxassetid://5401154786` |
| meaty texture shape | `rbxassetid://6423018614` |
| TeethButton / HeartButton | `rbxassetid://7712114605` / `rbxassetid://7516199736` |
| Vignette images in the sibling experiment | `rbxassetid://18416679214`, `rbxassetid://4576475446` |

## Accessibility and safety checks

- [ ] Text and active controls meet contrast on every texture layer and remain readable with reduced graphics quality.
- [ ] No flashing, rapid zoom, or high-frequency pulsing; provide a reduced-motion setting.
- [ ] Focus outline and button hitbox remain distinct from decorative imagery.
- [ ] Text is not embedded only in a raster image; support localization and text scaling.
- [ ] A calmer alternative is available for players sensitive to gore-like textures.
- [ ] Review embedded scripts and all image rights before moving staged objects into a live ScreenGui.

## Verification

Explorer properties and asset IDs were read in Edit mode. The image design itself was not captured as an in-game screenshot, and the assets were not opened or checked for rights. This is a low-confidence design reference pending visual review.
