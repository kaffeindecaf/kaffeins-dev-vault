---
id: R-ui-image-9slice
type: reference
title: 9-slice images, ScaleType and texture memory
status: reviewed
updated: 2026-11-01
tags: [ui, images, performance]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "R-monochrome-icons", "R-horror-hud", "H-profiling-budgets"
---

# 9-slice

A 9-slice image scales by stretching the middle edges and keeping corners fixed — one small texture serves
every panel size, which is both crisp and cheap.

## Settings

| Property | Value |
|---|---|
| `ScaleType` | `Slice` |
| `SliceCenter` | `Rect.new(left, top, width - right, height - bottom)` in **texture pixels** |
| `SliceScale` | 1 (changes the corner size; use for DPI) |
| `TileSize` | irrelevant unless `ScaleType = Tile` |

## The rule for corners

`SliceCenter` must enclose a region **larger than the corner art**, or the corner will squash. For a 64×64
button texture with 12 px rounded corners: `Rect.new(12, 12, 52, 52)`.

```lua
-- Untested
img.ScaleType = Enum.ScaleType.Slice
img.SliceCenter = Rect.new(12, 12, 52, 52)
img.SliceScale = 1
img.ImageColor3 = Tokens.color.bgRaised
```

## When not to 9-slice

- Art with gradients along an edge (stretches reveal banding).
- Icons and portraits (`ScaleType = Stretch` with an aspect constraint, or `Fit`).
- Anything with a drop shadow baked in — the shadow smears.

## Texture memory

| Texture | Memory at 1024×1024 RGBA | Note |
|---|---|---|
| 1024² | ~4 MB uncompressed | avoid full-screen art at this size |
| 512² | ~1 MB | fine for a panel |
| 256² | ~256 KB | fine for icons |

On mobile, a HUD with ten 1024² images is 40 MB of texture — comparable to a chunk of the map. Downscale.

