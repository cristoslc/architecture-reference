---
title: "Drop Signal Extraction — Deep-Analysis Only"
artifact: ADR-007
status: Adopted
author: cristos
created: 2026-03-13
last-updated: 2026-03-13
linked-epics: []
linked-specs: []
depends-on:
  - ADR-002
  - ADR-005
supersedes: ADR-002
evidence-pool: ""
---

# Drop Signal Extraction — Deep-Analysis Only

## Context

ADR-002 dropped heuristic classification as a *classification source* but retained signal extraction (`extract-signals.sh`, `classify.py`) for metadata collection — language detection, dependency inventory, infrastructure inventory — intended as context for the deep-analysis LLM prompt.

In practice, this metadata context layer has become dead weight:

1. **Deep-analysis doesn't need it.** The deep-analysis pipeline (ADR-005) clones the repo and inspects source code directly. The LLM reads actual files — it doesn't need a pre-computed signal summary to tell it a repo has Docker or uses gRPC. The signal extraction output duplicates what the LLM discovers on its own during source inspection.

2. **The heuristic scorers are fully dead code.** EPIC-008 improved SBA and Plugin/Microkernel scorers in `classify.py`, but ADR-002 already prohibited using their output for style assignment. The scorers run, produce scores, and the pipeline ignores them. This is confusing for anyone reading the pipeline code.

3. **Signal extraction adds pipeline complexity.** Every new repo must run `extract-signals.sh` before deep-analysis — an extra step that produces output nobody consumes. The signal extraction code also requires maintenance (EPIC-008 added 7 new signals) for a component that has no downstream consumer.

4. **ADR-005 made the discover skill the sole classification mechanism.** The pipeline reads the discover skill's content at runtime and assembles the system prompt. Signal extraction is not part of this path — it's a vestige of the pre-ADR-005 architecture.

## Decision

**Drop the signal extraction stage entirely.** The classification pipeline is now a single stage:

1. **Deep-analysis** — clone the repo and run LLM-based source code analysis via the discover skill (per ADR-005). No pre-processing, no signal extraction, no heuristic scoring.

The following pipeline components are dead code and should be retired:

| Component | Purpose | Status |
|-----------|---------|--------|
| `extract-signals.sh` | Filesystem signal extraction | Dead — deep-analysis inspects source directly |
| `classify.py` | Heuristic scoring from signals | Dead — ADR-002 already prohibited style assignment; now metadata use also dropped |
| Signal JSON files (`signals/*.json`) | Cached signal extraction output | Dead — no consumer |

**This supersedes ADR-002**, which retained signal extraction for metadata. The decision trajectory:

- ADR-002: heuristic scores don't count → signal extraction retained for metadata
- ADR-007 (this): signal extraction metadata is redundant → entire heuristic layer dropped

## Alternatives Considered

1. **Keep signal extraction as optional pre-filter.** Could run signals first to triage repos into "likely simple" vs. "likely complex" buckets, adjusting deep-analysis prompts accordingly. Rejected: the deep-analysis prompt already adapts based on what it finds in the source code. A pre-filter adds complexity without improving classification quality.

2. **Keep signal extraction for non-classification uses.** Signal data (language breakdown, dependency list, infrastructure inventory) could feed dashboards or catalog metadata fields. Rejected: this data is already captured by the deep-analysis output in the catalog entry YAML. Maintaining a parallel extraction path for the same data violates DRY.

3. **Retire scorers but keep `extract-signals.sh` for context.** The most conservative option — remove `classify.py` but keep signal extraction as LLM prompt context. Rejected: deep-analysis clones the repo and reads files directly. Pre-computed signal summaries are strictly less informative than the source code the LLM already has access to.

## Consequences

**Positive:**
- Pipeline is a single conceptual stage: clone + deep-analyze. No pre-processing.
- ~500 lines of scorer code (`classify.py`) and ~300 lines of signal extraction (`extract-signals.sh`) become candidates for removal.
- EPIC-008's signal improvements are acknowledged as historically useful (they informed the heuristic era) but no longer load-bearing.
- New contributors see one classification path, not two with a "don't use this one" caveat.

**Negative:**
- Cannot do cheap, offline classification without LLM access. Every classification requires cloning + LLM call.
- Lose the signal JSON files as a lightweight repo fingerprint. If fingerprinting is needed in the future, it would need to be rebuilt.
- EPIC-008's SBA/Plugin detection work (improved scorers, conflict resolution) has no surviving downstream consumer. The architectural insights from that work are preserved in the epic's documentation but the code is dead.

**Migration:**
- SPEC-032 (Legacy Pipeline Retirement) already retired deprecated prompts and parsers per ADR-002/003/005. A follow-up spec should retire `extract-signals.sh`, `classify.py`, and signal JSON files.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Adopted | 2026-03-13 | — | Supersedes ADR-002; signal extraction dropped entirely |
