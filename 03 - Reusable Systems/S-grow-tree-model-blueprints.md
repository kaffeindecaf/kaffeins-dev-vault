---
id: S-grow-tree-model-blueprints
type: system
title: Tree model variants and preview blueprints
status: draft
updated: 2026-11-02
tags: [models, trees, previews, organization]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: [ServerStorage, ReplicatedStorage]
code_blocks: 0
related: [ "R-grow-a-tree-pattern-audit", "S-tree-query-hitbox", "S-ui-shop-catalog-layout" ]
---

# Tree model variants and preview blueprints

## Source and intent

In the open Grow A Tree place, `ServerStorage.New Growth Trees.AppleTree` contains `Variation1`, `Variation2` and `Variation3` Models. Other species use similar groupings; `CorruptedTree` differs. `ReplicatedStorage.SeedShopPreviewModels`, `SeedPreviewModels` and `TreeIndexModels` are separate model folders. These are observed structures, not proof of which variants spawn or how previews are loaded. No original models were exported; ownership and rights are unknown.

For a reusable model library, use stable species and variant keys in a server-owned catalog, a consistent root/pivot and documented ground plane; keep visual variants interchangeable with the same gameplay contract. A client-facing preview can be a separate lightweight representation. `tree-model-placeholder.luau` creates an intentionally simple original placeholder model from configurable primitive sizes and colors; it is not the source game's art. `shop-stand-placeholder.luau` similarly builds an original shop blockout inspired by the existence of `Workspace.SeedShop` and `Workspace.UpgradeShop`, not their geometry. Neither contains an asset ID or extracts geometry. See [[T-grow-tree-snippet-catalog]].

## Assembly and tradeoffs

1. Keep authoritative templates in server-only storage and expose only appropriate preview assets; choose variants on the server when they affect gameplay.
2. Keep interaction geometry separate from decorative foliage if accurate and consistent interaction needs it. Validate distance and ownership server-side; see [[S-tree-query-hitbox]].
3. Document pivot, ground origin, collision, tags, attributes, and growth transitions for every variant. Test rotations and extreme size rolls. The tree placeholder initially puts its bottom at world origin, uses its trunk center as the PrimaryPart pivot, and has anchored, non-colliding primitives. The stand's PrimaryPart pivot is its base center and its parts retain default collision.
4. Audit instance count, streaming, material/mesh memory, preview rendering and device performance with measurements. Color, silhouettes and names should remain distinguishable; motion and flashing effects need accessible alternatives.

**Unverified:** the source models' full part structure, pivots, creator permissions, package identity, runtime selection, and all appearance/performance outcomes. No source model may be represented as a reusable licensed asset solely because it appears in the place.
