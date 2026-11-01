---
id: G-knowledge-promotion
type: guide
title: Knowledge promotion: idea → draft → reviewed → tested
status: reviewed
updated: 2026-11-01
tags: [agents, quality, process]
source_urls: []
confidence: medium
verification: reference_only
client_server: both
code_blocks: 0
related: "AGENTS", "G-citation-rules", "N-SCHEMA"
---

# Promotion

An agent's output is a draft until something else confirms it. This is the mechanism that keeps the vault from
becoming confident-sounding noise.

```text
idea → draft → reviewed → tested
                    ↘ deprecated (superseded, kept for history)
```

| Stage | `status` | Requires | Who sets it |
|---|---|---|---|
| idea | `idea` | a question or a request exists | anyone |
| draft | `draft` | the note exists with valid frontmatter | the agent |
| reviewed | `reviewed` | a human (or a second agent with a source) checked the claims and the sources resolve | human |
| tested | `tested` | executed, with `verification: tested_studio` + `test_evidence` | whoever ran it |
| deprecated | `deprecated` | a replacement note exists, linked in `related` | maintainer |

## Rules

1. **An agent may not promote its own work to `reviewed`.** That is the whole point of the gate.
2. **`verification` and `status` are different axes.** A note can be `reviewed` (well-checked) and
   `untested` (never executed). Do not conflate them.
3. **A `tested` note needs evidence a stranger can follow**: date, build/place, steps, observed result.
4. **Corrections are additive.** If the platform changed, add a dated "Changed" section; do not silently rewrite
   history.
5. **Deprecate, never delete**, so an old project's reference still resolves.

## Reviewing an AI-written note (checklist)

- [ ] Every factual claim either cites a source or says it is uncertain.
- [ ] No invented IDs, URLs, version numbers, or "we tested this" statements.
- [ ] Code blocks labelled `Tested:` / `Untested:` / `Pseudocode:`.
- [ ] Frontmatter passes `validate`.
- [ ] Claims about permissions/access are `unknown` unless evidenced.
- [ ] The note says something a reader could act on today.

