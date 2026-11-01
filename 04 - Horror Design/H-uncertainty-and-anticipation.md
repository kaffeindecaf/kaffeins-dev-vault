---
id: H-uncertainty-and-anticipation
type: principle
title: Uncertainty, anticipation and event rarity
status: reviewed
updated: 2026-11-01
tags: [horror, pacing, psychology]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: []
code_blocks: 1
related: "H-cooldowns-and-rarity", "H-environmental-events-catalog", "H-tension-hierarchy"
---

# Uncertainty and anticipation

Fear is mostly *anticipation*, and anticipation needs uncertainty: the player must believe both
"something is there" and "maybe not".

## The three levers

1. **Incomplete information.** A sound without a source; a corridor whose end you cannot see; a light
   that does not reach the corner.
2. **Delayed resolution.** The cue comes, then nothing for 8–20 s. The wait is the scary part; resolve
   it too fast and you have spent the scare for nothing.
3. **Rarity.** A cue that fires every 20 s is furniture. A cue that fires once in ten minutes is an
   event.

## Concrete numbers to start from

| Lever | Start here | Adjust by |
|---|---|---|
| Cue → consequence gap | 8–20 s | shorter in the last third of a round |
| Distinct cues per 5 min | 4–6 | fewer in the first minute (establish calm) |
| Non-events (cue, then nothing) | 60–70% of cues | higher early, lower late |
| Visible-threat seconds per 10 min | 20–45 s | more only if the player can escape |

## The non-event is the technique

A cue that resolves into nothing is not a wasted beat — it is what teaches the player that cues are
*ambiguous*, which is what makes the 30% that do resolve terrifying. Games that always resolve become
predictable rhythm games; games that never resolve become noise.

## Failure modes

- Cue and threat in the same second → no anticipation, just a startle.
- Every cue leads to danger → the player stops exploring.
- Cue with no possibility of anything → the player learns the sound is fake and stops reacting.
- Too many cues → desensitisation inside 5 minutes.

## Test

Log cue → resolution deltas for a session. A healthy distribution has a median of 8–20 s and a large
cluster at "never resolved".

