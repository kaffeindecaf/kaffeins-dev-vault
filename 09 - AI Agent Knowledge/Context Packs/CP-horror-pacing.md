---
id: CP-horror-pacing
type: guide
title: Context pack — horror pacing and accessibility
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

# Context pack — horror pacing and accessibility

Hold this before tuning scares, lights or audio.

Paste this block (or the note paths) into the agent's context. The rules are the compressed form of the linked
notes — where they conflict, the note wins and this pack needs fixing.

```text
1. Six states: calm -> suggestion -> buildup -> threat -> release -> cooldown. Never threat -> threat.
2. Cue-to-consequence gap 8-20 s; 60-70% of cues resolve into nothing.
3. Threat cooldown 60-120 s; per-beat cooldown 45-180 s; max ~6 beats per 5 minutes.
4. Silence is an authored layer, not the absence of one.
5. No flicker above 3 Hz; no full-screen luminance flash; reducedFlash replaces flashes with dims.
6. Intensity is a named level (0-3), default 1, cap = the minimum across players in the server.
7. Safe rooms: no threat, ever; the director suspends beats inside them.
8. Every pacing claim needs a measured log, not a feeling.
```

## Sources

- [[H-tension-hierarchy]]
- [[H-adaptive-director]]
- [[H-intensity-config]]
- [[H-flicker-safety]]
- [[H-cooldowns-and-rarity]]

## Using it

```bash
python scripts/gamedev_kb.py context "client server authority" --budget 4000 --out exports/cp-client-server.md
```

A pack is a starting point, not a substitute for reading the note when the answer matters.
