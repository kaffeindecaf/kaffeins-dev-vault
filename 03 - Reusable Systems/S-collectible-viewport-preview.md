---
id: S-collectible-viewport-preview
type: system
title: Collectible model preview with visible bounds
status: draft
updated: 2026-11-02
tags: [ui, viewport, models, collectibles]
source_urls: []
confidence: medium
verification: design_only
client_server: client
roblox_services: [ReplicatedStorage]
code_blocks: 0
related: [ "S-ui-collection-card-component", "S-ui-shop-catalog-layout" ]
---

# Collectible model preview with visible bounds

Show a recognizable three-dimensional collectible in an index, sell screen or shop. For many cards, static thumbnails or lazy-loaded visible previews may be a better choice; measure memory and frame time before deciding.

Resolve a vetted model from a client-visible catalog, choose a defined fallback when it is missing,
remove the previous preview, clone only approved content, disable physics interactions, and frame its
visible bounds with a camera. Keep locked entries visually distinct without revealing content that
is meant to remain hidden. Test rendering and fallback behavior at runtime.

The untested `viewport-model-preview.luau` uses model bounding boxes; invisible geometry can distort
framing and non-square viewports can crop. Use an authored preview proxy or improve bounds and camera
framing if needed. The caller supplies a vetted, client-visible model, fallback icon and layout.
Destroy old previews and disconnect associated work. A ViewportFrame is presentation only: the
server validates ownership and purchases. Test missing models, transparency, aspect ratios,
accessibility labels, touch, keyboard/gamepad focus and low-end hardware.
