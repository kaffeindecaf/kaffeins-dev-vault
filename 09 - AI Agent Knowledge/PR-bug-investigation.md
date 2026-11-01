---
id: PR-bug-investigation
type: prompt
title: Prompt — investigate a bug against the bug bank
status: reviewed
updated: 2026-11-01
tags: [prompts, bugs, debugging]
source_urls: []
confidence: medium
verification: reference_only
client_server: both
code_blocks: 0
related: "MOC-bugs", "G-replication-debugging", "G-knowledge-promotion"
---

# Prompt: bug investigation

```text
Symptom: <what the user sees>

Steps:
1. python scripts/gamedev_kb.py search "<symptom keywords>" --type bug
2. If a case matches, follow its diagnostic order; say which step ruled out what.
3. If none matches, use G-replication-debugging / G-profiling-workflow as the frame.
4. State the CAUSE in plain words before proposing a fix (this vault's rule: cause first).
5. Propose the smallest fix at the source, not a workaround at the symptom.

Output:
- Cause (with evidence: what you checked, what you saw).
- Fix.
- How to verify (exact steps).
- Regression prevention.

Do not edit files until I approve. Do not mark anything tested that was not run.
```

If the cause is not yet known, say "not yet known" — a guess labelled as a cause is the worst outcome.

