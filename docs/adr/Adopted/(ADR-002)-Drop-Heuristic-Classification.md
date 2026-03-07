---
title: "Drop Heuristic Classification — Deep-Analysis Only"
artifact: ADR-002
status: Adopted
author: cristos
created: 2026-03-07
last-updated: 2026-03-07
linked-epics:
  - EPIC-012
linked-specs:
  - SPEC-022
  - SPEC-023
depends-on:
  - ADR-001
---

# Drop Heuristic Classification — Deep-Analysis Only

## Context

The classification pipeline has three stages: (1) signal extraction + heuristic rules, (2) LLM review of signals, (3) deep-validation via repo cloning + LLM source analysis. After SPEC-021 added 45 new catalog entries, the heuristic stage classified 30 as Indeterminate and assigned 5-6 overlapping styles to most of the rest (e.g., posthog got Service-Based, Event-Driven, CQRS, Plugin/Microkernel, DDD, and Pipe-and-Filter simultaneously).

The heuristic classifier detects infrastructure presence (has Docker, has message queues, has domain directories), not architectural patterns. Filesystem signals are weak proxies for architecture — the same signals appear in almost every modern codebase regardless of actual pattern. Architecture is about structure and relationships (how modules communicate, where boundaries are enforced, what the dependency graph looks like), which cannot be inferred from file presence alone.

The intermediate LLM review stage (SPEC-010/011) was designed to improve on heuristics by reasoning about signals, but deep-validation (SPEC-013/019) supersedes it entirely — it clones the repo and inspects actual source code, producing the highest-quality classifications in one pass.

The SPEC-022 frequency recomputation demonstrated the problem: production-only frequency tables showed 29.6% Indeterminate because new entries had only heuristic classification. These numbers are too noisy for the reference library (SPEC-023).

## Decision

**Drop heuristic classification as a classification source.** The pipeline classification path is now:

1. **Signal extraction** — retained for metadata collection (language detection, dependency inventory, infrastructure inventory) but not used for style assignment.
2. **Deep-analysis** — clone the repo and run LLM-based source code analysis to determine architecture styles. This is the sole classification source.

**Deep-analysis tool selection is user-determined at scan start:**

| Option | Tool | When to use |
|--------|------|-------------|
| A | Claude Code subagents (Sonnet 4.6) | Interactive sessions, when the user is present and can monitor |
| B | `llm` CLI | Batch runs, CI pipelines, or when a different model is preferred |

The user chooses at the outset of each scan. The choice applies to all entries in that scan run.

**Heuristic output is not counted in frequency rankings.** Entries that have only heuristic classification are treated as unclassified until deep-analysis runs. Signal extraction data is preserved as input context for the deep-analysis LLM prompt.

## Alternatives Considered

1. **Improve heuristics with language-specific detectors.** Would require a large labeled dataset (which deep-validation produces), ongoing maintenance as framework conventions evolve, and the ceiling is still "rough pre-filter." The ROI is low when deep-analysis already works.

2. **Keep the three-stage pipeline (heuristic → LLM review → deep-validation).** The intermediate LLM review stage adds latency and cost without adding quality — deep-validation subsumes everything it does. Running two LLM stages when one suffices is wasted work.

3. **Use heuristics for triage only (prioritize which entries to deep-validate first).** This is the one defensible use of heuristics, but in practice we deep-validate everything, so triage ordering doesn't matter.

## Consequences

**Positive:**
- Single source of truth for classifications — no mixing of heuristic-quality and deep-validated data
- Simpler pipeline: extract signals → deep-analyze. Two stages instead of four.
- Frequency rankings are reliable as soon as they're computed — no "29.6% Indeterminate" contamination
- Signal extraction remains useful as context for the LLM prompt (infrastructure inventory, dependency list)

**Negative:**
- Every new entry requires an LLM call (no cheap pre-filter). At ~45 entries, this is ~45 LLM calls with cloned repo context — roughly 30-60 minutes of processing depending on tool choice.
- Cannot classify without network access (need to clone repos) or LLM access.
- The `classify.py` heuristic script and `llm-review.sh` become dead code in the pipeline's classification path. They may be retained for signal metadata but should not produce style assignments.

**Migration:**
- SPEC-022 reverts to Draft until deep-analysis runs on all new entries
- SPEC-023 remains blocked on SPEC-022
- Existing deep-validated entries (from SPEC-019) retain their classifications — no rework needed
- ~45 new entries from SPEC-021 need deep-analysis before frequency recomputation

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Adopted | 2026-03-07 | — | Heuristic classification dropped; deep-analysis is sole classification source |
