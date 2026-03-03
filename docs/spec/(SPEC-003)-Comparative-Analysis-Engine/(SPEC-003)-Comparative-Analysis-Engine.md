---
title: "Comparative Analysis Engine"
artifact: SPEC-003
status: Draft
author: cristos
created: 2026-03-03
last-updated: 2026-03-03
parent-epic: EPIC-003
linked-research: []
linked-adrs: []
depends-on:
  - SPEC-002
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
- Catalog entries include sufficient metadata for meaningful comparison

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

_To be refined after SPEC-002 delivers the expanded catalog. Key questions:_
- Similarity metric (weighted combination of style overlap, domain match, technology overlap)
- How to handle the heterogeneous catalog (competition vs. production vs. discovered entries)
- Whether this is a standalone skill or an extension of the architecture-advisor skill

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-03 | b63f031 | Initial creation — depends on SPEC-001 and SPEC-002 |
