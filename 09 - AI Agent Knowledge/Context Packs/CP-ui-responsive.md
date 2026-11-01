---
id: CP-ui-responsive
type: guide
title: Context pack — responsive UI
status: reviewed
updated: 2026-11-01
tags: [context-pack, agents]
source_urls: []
confidence: high
verification: design_only
client_server: both
code_blocks: 0
related: [ "AGENTS", "G-citation-rules" ]
---

# Context pack — responsive UI

Hold this before touching any ScreenGui.

Paste this block (or the note paths) into the agent's context. The rules are the compressed form of the linked
notes — where they conflict, the note wins and this pack needs fixing.

```text
1. One axis system per element: offset size -> offset position from an anchored corner; scale size -> scale position.
2. A scale `Position` needs a matching `AnchorPoint`, or the element is shifted by half its own size.
3. Tap targets >= 44x44 px; nothing interactive in the bottom-left/bottom-right 45% (thumbs).
4. `ScreenInsets = DeviceSafeInsets`; do not place UI under the notch or the top bar.
5. Text: `TextWrapped` + `UITextSizeConstraint` (a `MaxTextSize`), >= 16 px effective, contrast >= 4.5:1.
6. `RelativeYY` `SizeConstraint` or a `UIAspectRatioConstraint` (with a deliberate `DominantAxis`) for panels.
7. Transitions <= 0.26 s, cancellable, and reduced-motion replaces them with instant.
8. Verify at 8 viewports (R-responsive-matrix) or do not claim responsive.
```

## Sources

- [[R-udim2-scale-vs-offset]]
- [[R-anchorpoint-and-insets]]
- [[R-responsive-matrix]]
- [[G-ui-buttons-drift]]
- [[R-ui-style-guide-tokens]]

## Using it

```bash
python scripts/gamedev_kb.py context "client server authority" --budget 4000 --out exports/cp-client-server.md
```

A pack is a starting point, not a substitute for reading the note when the answer matters.
