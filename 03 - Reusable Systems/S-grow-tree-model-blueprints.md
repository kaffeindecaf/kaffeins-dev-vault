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
related: [ "T-garden-integration-patterns", "S-tree-query-hitbox", "S-ui-shop-catalog-layout" ]
---

# Tree model variants and preview blueprints

## Intent

For a reusable model library, use stable species and variant keys in a server-owned catalog, a
consistent root/pivot and documented ground plane; keep visual variants interchangeable with the
same gameplay contract. A client-facing preview can be a separate lightweight representation.
`tree-model-placeholder.luau` creates an original placeholder from configurable primitive sizes and
colors. `shop-stand-placeholder.luau` builds an original shop blockout. Neither contains an asset ID
or extracts existing geometry. See [[T-garden-integration-patterns]].

## Assembly and tradeoffs

1. Keep authoritative templates in server-only storage and expose only appropriate preview assets; choose variants on the server when they affect gameplay.
2. Keep interaction geometry separate from decorative foliage if accurate and consistent interaction needs it. Validate distance and ownership server-side; see [[S-tree-query-hitbox]].
3. Document pivot, ground origin, collision, tags, attributes, and growth transitions for every variant. Test rotations and extreme size rolls. The tree placeholder initially puts its bottom at world origin, uses its trunk center as the PrimaryPart pivot, and has anchored, non-colliding primitives. The stand's PrimaryPart pivot is its base center and its parts retain default collision.
4. Audit instance count, streaming, material/mesh memory, preview rendering and device performance with measurements. Color, silhouettes and names should remain distinguishable; motion and flashing effects need accessible alternatives.

**Unverified:** model structure, pivots, creator permissions, runtime selection, and appearance or
performance outcomes for any project-specific models. Do not represent a model as reusable or
licensed solely because it appears in a project.
