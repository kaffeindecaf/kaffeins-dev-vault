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
related: [ "R-drive-catch-pattern-audit", "S-ui-collection-card-component", "S-ui-shop-catalog-layout" ]
---

# Collectible model preview with visible bounds

Show a recognizable three-dimensional collectible in an index, sell screen or shop. For many cards, static thumbnails or lazy-loaded visible previews may be a better choice; measure memory and frame time before deciding.

In `ReplicatedStorage.BrainrotViewport.Show`, the place resolves mutation folder and item name, falls back to Normal, removes a previous preview, clones the model, anchors and disables collisions/query/touch on parts, removes scripts and LayerCollectors, and frames visible-part bounds with a Camera. `StarterPlayer.StarterPlayerScripts.Modules.Controllers.IndexController` builds an ordered index and treats locked previews differently. See [[R-drive-catch-pattern-audit]]. These are Edit-mode source observations; neither rendering nor fallback was exercised. Duplicate model names require catalog review.

The untested `viewport-model-preview.luau` is a smaller, adapted helper using model bounding boxes rather than the source's visible-corner calculation. Invisible geometry can distort framing and non-square viewports can crop; use an authored preview proxy or improve bounds and camera framing if needed. The caller supplies a vetted, client-visible model, fallback icon and layout. Destroy old previews and disconnect associated work. A ViewportFrame is presentation only: the server validates ownership and purchases. Test missing models, transparency, aspect ratios, accessibility labels, touch, keyboard/gamepad focus and low-end hardware. IDs in the source do not grant reuse rights.
