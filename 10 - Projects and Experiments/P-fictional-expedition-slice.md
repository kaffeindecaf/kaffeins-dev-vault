---
id: P-FICTIONAL-EXPEDITION-SLICE
type: project
title: Fictional expedition vertical slice
status: draft
updated: 2026-11-02
tags: [example, project, vertical-slice]
source_urls: []
verification: design_only
confidence: medium
---

# Fictional expedition vertical slice

An original, fictional design example showing how a server-owned mechanic, player data and UI fit
together. This is a planning artifact; no code has been run in Roblox Studio.

## Slice

In a fictional cooperative expedition, a player approaches a survey beacon, requests a scan, and
receives a temporary discovery token. The server checks the request, records the discovery in the
player's in-memory session state, and returns a small result for the UI. On extraction, the server
persists the session through the project's selected profile system.

## Ownership and flow

1. Client sends a beacon identifier and request nonce. It does not send a reward amount or claim
   that the beacon is nearby.
2. Server validates type, rate, beacon existence, character state, and distance using server-known
   instances. It rejects duplicate nonces for the session.
3. Server updates the in-memory profile through one owner and emits a bounded result event.
4. Client displays scanning, success, duplicate and failure states. It treats server response as
   authoritative and does not locally grant the discovery.
5. The save owner persists the resulting profile at its normal checkpoint and shutdown flow. This
   example does not specify a production session-lock implementation.

## Data and UI contract

- Persist only a stable discovery key and schema version; derive display text and art locally.
- Do not write each scan directly to a DataStore. Use the chosen profile/session library's documented
  in-memory state and save lifecycle.
- UI states: unavailable, scanning, discovered, already recorded, and request failed. Disable repeat
  input while a request is pending, but retain server-side rate and duplicate checks.
- Never include credentials or real experience identifiers in this sample.

## Review questions

- What is the authoritative distance rule and how is the beacon registered?
- How does the selected profile library handle concurrent sessions and shutdown?
- Can a retry safely return the same result without granting a second reward?
- What happens when the client disconnects between request and response?

## Verification boundary

**Design only. Untested in Roblox Studio.** A Studio follow-up must use a separate unpublished test
experience, a mock profile first, and explicit failure/retry checks before any persistence claim is
upgraded. See [[T-backend-systems-catalog]] and [[G-game-vault-integration]].
