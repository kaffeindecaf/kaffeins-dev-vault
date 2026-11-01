---
id: N-fixture-yaml
type: guide
title: Fixture — unsupported YAML
status: draft
updated: 2026-11-01
tags: [fixture]
fixture: true
source_urls: []
description: |
  A block scalar is outside the supported subset.
---

# Fixture — unsupported YAML

The restricted parser must reject `description: |` with `yaml_block_scalar_unsupported` instead of silently
mis-parsing it (DECISIONS D-0006).
