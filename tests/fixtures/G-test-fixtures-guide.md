---
id: G-test-fixtures-guide
type: guide
title: Test fixtures — synthetic data only
status: draft
updated: 2026-11-01
tags: [testing, fixtures, privacy]
source_urls: []
verification: design_only
related: [ "N-AGENTS", "N-SECURITY-REVIEW" ]
---

# Test fixtures

This folder is reserved for small synthetic fixtures used by the local validator and retrieval
tests. Keep the fixtures synthetic: do not copy real player data, secrets, live place files or
licensed Creator Store assets here. `tests/` currently contains the executable fixture definitions.
