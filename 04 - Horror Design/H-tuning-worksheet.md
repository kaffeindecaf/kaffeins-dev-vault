---
id: H-tuning-worksheet
type: guide
title: Intensity tuning worksheet and playtest observations
status: reviewed
updated: 2026-11-01
tags: [horror, playtest, tuning]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: []
code_blocks: 1
related: "H-intensity-config", "H-tension-hierarchy", "G-profiling-workflow"
---

# Tuning worksheet

Copy this into a project note and fill it from **observed** playtests. The vault's rule applies: a
number you did not observe stays blank.

## Per-session record

```text
Session:        date, player count, device
Duration:       minutes
Threats:        count        (target 2-4 per 10 min)
Cues:           count        (target 4-6 per 5 min)
Cue→resolution: median s     (target 8-20 s)
Silence beats:  count
Deaths:         count        (target 0-1 per 10 min for a first run)
Player quote:   a verbatim line, if any
```

## Per-state table (fill by observation)

| State | Intended | Observed | Fix |
|---|---|---|---|
| Calm | 30–90 s | | |
| Suggestion | 5–15 s | | |
| Buildup | 3–10 s | | |
| Threat | 5–30 s | | |
| Release | 2–5 s | | |
| Cooldown | 20–45 s | | |

## Questions to answer from the playtest

1. Did any player say "I knew it was coming"? → anticipation too legible, lengthen the gap or change the
   cue.
2. Did any player stop exploring? → too many threats, or a threat with no escape.
3. Did a player fail to notice a cue at all? → volume/position, not pacing.
4. Did the safe room get used longer than 40 s? → good release; if 0 s, it does not read as safe.
5. Did anyone mention photosensitivity or motion discomfort? → **stop tuning and fix settings first**
   ([[H-intensity-config]]).

## Anti-pattern: tuning by feel alone

Two designers will tune the same build in opposite directions. Record the numbers, compare sessions,
change one variable at a time.

