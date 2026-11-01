---
id: PR-horror-director-improvement
type: prompt
title: Prompt — improve the horror director with testable outcomes
status: reviewed
updated: 2026-11-01
tags: [prompts, horror, ai]
source_urls: []
confidence: medium
verification: reference_only
client_server: both
code_blocks: 0
related: "H-adaptive-director", "H-director-api", "H-intensity-config"
---

# Prompt: director tuning

```text
Task: change <aspect> of the adaptive horror director.

Constraints:
- Every decision must be deterministic given a seed (R-seeded-generation).
- Any pacing change must be expressed as a number in config, not a magic constant.
- Accessibility caps win over intensity goals, always (H-intensity-config).

Deliver:
1. The rule you are changing, before and after (a table of inputs -> output).
2. A simulation test: 1000 simulated minutes with a fake clock, asserting the invariants
   (no two threats inside cooldown, release after every threat, no beat repeat inside its window).
3. What a player should notice differently, in one sentence.

Do not add a new beat type without a cost, a cooldown and a "must not do" note.
```

See [[H-adaptive-director]], [[H-director-api]], [[H-cooldowns-and-rarity]].

