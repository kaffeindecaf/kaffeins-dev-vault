---
id: R-monochrome-icons
type: reference
title: Monochrome icon design and sourcing
status: reviewed
updated: 2026-11-01
tags: [ui, icons, assets]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "R-ui-image-9slice", "R-content-and-ownership", "R-ui-style-guide-tokens"
---

# Icons

One icon family, one weight, one optical size. Mixing families is the fastest way to look amateur.

## Specifications

| Property | Value |
|---|---|
| Grid | 24×24 |
| Stroke | 2 px, rounded caps |
| Optical size | designed at 24, exported at 48/96 (no upscaling) |
| Colour | single flat colour, tinted by token (`text-primary`, `accent`) |
| Padding | 2 px inside the 24 grid |

White-on-transparent PNGs tint cleanly with `ImageColor3`; multi-colour icons cannot be themed, which is
why monochrome is the right default for a HUD.

## Where to get them legitimately

- Draw them yourself (a 24×24 grid with 2 px strokes is genuinely fast).
- Use an openly licensed icon set with the licence recorded in `LICENSES_AND_SOURCES`.
- **Do not** trace a game's icons, and do not use a Creator Store icon pack without checking its licence —
  a listing is not a licence ([[R-content-and-ownership]]).

## Roblox specifics

- Upload as `Decal`/`Image`; set `ImageColor3` for tinting, `ScaleType = Slice` only with 9-slice art.
- `ImageLabel.ResampleMode = Default` is fine; `Pixelated` for pixel art only.
- Keep icons ≤ 128 px texture size unless shown large: texture memory is a real cost on phones.

## Consistency check

Screenshot every icon at 48 px side by side. Anything with a different stroke weight or optical centre is
the one to redraw.

