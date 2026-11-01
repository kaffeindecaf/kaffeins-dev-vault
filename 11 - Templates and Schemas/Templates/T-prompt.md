---
id: T-prompt
type: template
title: Template — agent prompt
status: reviewed
updated: 2026-11-01
tags: [template]
source_urls: []
confidence: medium
verification: design_only
---

# Template — agent prompt

> **Template.** Copy the block below into a new note, replace every `{placehold}`, and delete these
> instructions. Prompts are notes: cited, versioned, shaped so a wrong answer is obvious.

```markdown
---
id: PR-{{slug}}
type: prompt
title: Prompt — {{task}}
status: reviewed
updated: {{date}}
tags: [prompts]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 0
related: [ "MOC-agent-knowledge", "AGENTS" ]
---

# Prompt — {{task}}

```text
Task: {{one sentence}}

Read first: AGENTS.md, then {{MOC or note}}.
Search: python scripts/gamedev_kb.py search "{{query}}" --json

Constraints:
- {{the rule that prevents the known failure}}
- Never claim {{untested thing}} was verified.

Deliver:
1. {{artifact 1}}
2. {{artifact 2}}
3. {{the check}} (validate or test output, verbatim)
```

## Why it is shaped this way
{{the failure mode this prompt prevents}}
```
