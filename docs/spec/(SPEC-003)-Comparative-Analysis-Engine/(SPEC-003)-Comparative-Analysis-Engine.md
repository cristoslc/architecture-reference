---
title: "Comparative Analysis Engine"
artifact: SPEC-003
status: Implemented
author: cristos
created: 2026-03-03
last-updated: 2026-03-12
parent-epic: EPIC-003
linked-research: []
linked-adrs:
  - ADR-005
depends-on:
  - SPEC-002
  - ADR-005
  - EPIC-013
---

# Comparative Analysis Engine

## Problem Statement

Users want to ask "How does my architecture compare to successful projects in this domain?" The evidence base will have 200+ cataloged projects (after SPEC-002), but no automated way to find similar projects and generate comparison reports.

## External Behavior

### Input

A local repo path (same as SPEC-001) plus optional filters (domain, architecture style, quality attributes).

### Output

A markdown comparison report including:
- The user's repo classification (via SPEC-001)
- Similar projects from the catalog (matched by style, domain, or quality attributes)
- Statistical comparison: how the user's architecture signals compare to the dataset
- Strengths and gaps relative to similar successful projects
- Actionable recommendations grounded in evidence

### Preconditions

- SPEC-001 (Discovery Skill) is implemented
- SPEC-002 (Scaling Pipeline) has populated the catalog to n >= 200
- ADR-005 is adopted — catalog entries follow the discover skill's `catalog-entry.template.j2` schema, providing a uniform set of fields (`architecture_styles`, `domain`, `scope`, `use_type`, `quality_attributes`, `classification_confidence`) for matching

### Postconditions

- User receives a comparison report with citations to specific catalog entries
- No modifications to the evidence catalog or target repository

## Acceptance Criteria

- **Given** a microservices repo in the e-commerce domain, **when** comparison runs, **then** the report includes eShop and eShopOnContainers as reference comparisons
- **Given** any repo, **when** comparison runs, **then** all claims cite specific catalog entries with project names
- **Given** a repo with low ADR count, **when** comparison runs, **then** the report notes the gap relative to the dataset median and cites the ADR correlation evidence

## Scope & Constraints

### In scope

- Similarity matching across the catalog (by style, domain, technology, quality attributes)
- Statistical comparison (percentile ranking within the dataset)
- Evidence-grounded recommendations

### Out of scope

- Prescriptive architecture changes ("you should switch to X")
- Integration with the architecture-advisor skill (future work — could share the comparison engine)
- Interactive or web-based comparison interface

## Implementation Approach

With ADR-005 adopted, the catalog entry schema is standardized via the discover skill's `catalog-entry.template.j2`. This resolves the heterogeneity question — all entries share the same fields regardless of classification mechanism.

**Similarity matching.** Build a multi-axis similarity scorer against the catalog schema:
- **Style overlap** — Jaccard similarity on `architecture_styles` (primary + secondary). Weight primary styles higher.
- **Domain match** — exact or categorical match on `domain`. Group related domains (e.g., e-commerce/retail).
- **Scope/use-type alignment** — filter by `scope` (platform vs. application) and `use_type` to compare like-with-like per ADR-001.
- **Quality attribute overlap** — intersection on `quality_attributes` for projects that share the same operational priorities.
- **Confidence weighting** — down-weight comparisons against entries with low `classification_confidence`.

**Invocation.** Extend the discover skill (or compose with it): classify the user's repo via SPEC-001, then run the comparison against the catalog. Output is a single markdown report combining the user's classification with the comparison analysis.

**Open questions:**
- Whether to expose this as a standalone skill or integrate into the architecture-advisor skill (EPIC-011 may influence this)
- Minimum catalog size threshold — SPEC-002 targets 200+, but comparison may be useful at current scale (184 entries)

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-03 | b63f031 | Initial creation — depends on SPEC-001 and SPEC-002 |
| Approved | 2026-03-12 | — | All dependencies satisfied (SPEC-002 Implemented, ADR-005 Adopted, EPIC-013 Complete); approved for implementation |
| Implemented | 2026-03-12 | — | Compare-architecture skill created with catalog loader, similarity scorer, report generator |
