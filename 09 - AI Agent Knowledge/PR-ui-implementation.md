---
id: PR-ui-implementation
type: prompt
title: Prompt — UI implementation with responsive checks
status: reviewed
updated: 2026-11-01
tags: [prompts, ui]
source_urls: []
confidence: medium
verification: reference_only
client_server: both
code_blocks: 0
related: "R-responsive-matrix", "R-ui-style-guide-tokens", "R-reduced-motion-policy"
---

# Prompt: UI work

```text
Task: implement <panel> following this vault's UI rules.

Constraints:
- Tokens from R-ui-style-guide-tokens; no ad-hoc colours or sizes.
- Anchors/positions consistent per element (R-udim2-scale-vs-offset).
- Tap targets >= 44x44; nothing interactive in the bottom corners (R-mobile-safe-areas).
- Text: wrapped, with a UITextSizeConstraint; >= 16px effective (R-text-scaling-overflow).
- Transitions cancellable, <= 0.26s open (R-ui-transitions-tween).
- Focus: takes focus on open, restores to launcher on close (R-controller-focus).
- Reduced motion respected (R-reduced-motion-policy).

Deliver:
1. The hierarchy (instance tree) and where it parents.
2. The code, labelled Untested unless run.
3. The responsive check results for the 8 viewports in R-responsive-matrix (screenshots or "not run").
```

Never claim a viewport pass you did not screenshot.

