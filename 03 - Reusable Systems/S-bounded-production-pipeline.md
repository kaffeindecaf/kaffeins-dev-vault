---
id: S-bounded-production-pipeline
type: system
title: Bounded production pipeline and output backpressure
status: draft
updated: 2026-11-02
tags: [production, capacity, progression, systems]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: [Workspace]
code_blocks: 0
related: [ "S-plot-resource-deposit", "S-occupancy-state-machine" ]
---

# Bounded production pipeline and output backpressure

Turn a bounded input stock into visible output batches while making a full output buffer understandable. Pick this when players manage capacity and processing throughput; use a simpler instant exchange when waiting or inventory constraints add no meaningful choice.

Before processing, check input stock and output capacity, mark the job busy, reserve the required
resources, and make the completion or rollback path explicit. Do not consume input before a yield
unless a recoverable reservation exists, and confirm that output placement succeeds before reporting
completion.

For a reusable design, serialize each plot's jobs. Reserve input and an output slot in authoritative state, record a recoverable job, then commit output once or return the reservation on failure. Presentation should react to state, never decide rewards. `production-plan.luau` is an untested pure decision helper; it does not reserve, persist, lock, schedule, grant or repair anything. Use a reviewed persistence transaction if progress must survive crashes. Provide count, state and full-buffer text, not color alone; test touch, controller, timeouts, ownership change, reduced motion, many active plots and interruption. Measure effects and instance cost rather than assuming an optimization.
