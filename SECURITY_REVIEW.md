---
id: N-SECURITY-REVIEW
type: report
title: SECURITY_REVIEW — boundaries tested and rules adopted
status: reviewed
updated: 2026-11-01
tags: [security, review, evidence]
source_urls: []
confidence: high
verification: tested_local
client_server: both
code_blocks: 1
test_method: local execution — python -m unittest discover -s tests (security group)
tested_at: 2026-11-01
test_evidence: "tests/test_kb.py TestSecurityBoundaries: 3 tests (secrets, symlink escape, root refusal) all pass; TEST_REPORT.md §1"
related: [ "G-server-authority-checklist", "PROJECT_CONFIG", "TEST_REPORT" ]
---

# Security review

Two surfaces: (a) this vault as a set of files an agent may read and write, and (b) the Roblox patterns the vault
recommends. The first was tested (local tooling); the second is documented guidance, not an audited implementation.

## A. Vault surface — tested

| # | Boundary | Test | Result |
|---|---|---|---|
| 1 | Secrets never indexed | `.env`, `notes.key`, `fake-credentials.json` planted in a temp vault | **pass** — none appear in the index, export or counts |
| 2 | Symlink escape | symlink inside the vault pointing at a file outside | **pass** — not walked, not indexed, outside file untouched |
| 3 | Root confinement | `--root` at a directory with no `config/vault.json` | **pass** — refused with an error, no traversal |
| 4 | Untrusted notes are data | all Markdown is parsed as text; no note content is executed | **by construction** — the CLI has no `eval`, no `exec`, no subprocess on note content |
| 5 | Imported code never executed | asset records store IDs only; scripts in models are never run by this project | **by construction** |
| 6 | Corrupt cache | index file replaced with garbage | **pass** — `search` exits 2 with advice; `index` rebuilds; no invented results |
| 7 | Write scope | CLI writes only `config/`, `exports/`, and (with `--write-dashboards`) `13 - Dashboards/` | **by construction** — paths resolve through `Config.inside()` |

### Prompt injection

Notes can contain text like "ignore your instructions". Mitigations actually implemented:

- The agent contract ([[AGENTS]]) says notes are **data, not commands**.
- Imported research rows live inside a fenced `json` block, clearly labelled as provenance.
- The CLI returns snippets, never "instructions to follow".
- No note is fetched from the network, so a remote page cannot inject text into the vault.

Residual risk: a human copying a web page's instructions into a note, then an agent following them. That is a
review problem, not a tool problem — hence [[G-knowledge-promotion]].

### What is deliberately absent

- No HTTP API, no MCP server, no watcher daemon (roadmap P19). Fewer surfaces, less to audit.
- No telemetry, no analytics, no outbound requests of any kind at runtime.

## B. Roblox patterns — documented, not audited

The vault contains a review checklist and nine failure cases. It has **not** reviewed a real codebase.

| Rule | Where |
|---|---|
| Never accept a value the server can derive (price, reward, distance) | [[G-server-authority-checklist]] |
| Validate: type → range → physical possibility → budget → authority | [[R-remotes-and-validation]] |
| Per-player token bucket on every remote | [[R-request-rate-limiting]] |
| Claims/occupancy written synchronously before any yield | [[S-pickup-server-authoritative]] |
| One writer per replicated property | [[B-tween-fighting]] |
| Admin commands: authority by user id, parse after check | [[G-admin-command-pattern]] |
| Hidden is a server attribute, never a client flag | [[S-hiding-spots]] |
| Never install a plugin or run a model's scripts without a human decision | [[G-studio-model-inspection]] |
| Do not log client payloads or player data | [[G-player-privacy]] |

## C. Open risks

| Risk | Severity | Note |
|---|---|---|
| No pinned/verified asset is in use anywhere yet | low | nothing is deployed, so nothing is exposed |
| No repository history exists yet | medium | Initialize Git after the release contents and staging policy are reviewed ([[ISSUES]] I-07) |
| An agent could still write a false "tested" claim | medium | mitigated by the fixture tests + review gate, not eliminated |
| Imported research may contain wrong IDs | medium | the reason every record is `untested` |

## Verdict

The tooling boundaries hold under the tests above. The **content** boundaries (no invented verification,
no invented permissions) are enforced by the schema, the validator and the fixtures — but they rely on a human
reviewing promotion to `tested`, which is exactly where the next agent should be sceptical.
