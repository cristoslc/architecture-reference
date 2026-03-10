---
title: "Reference Library Ecosystem Integration"
artifact: SPEC-028
status: Draft
author: cristos
created: 2026-03-10
last-updated: 2026-03-10
parent-epic: EPIC-010
linked-research:
  - SPIKE-001
  - SPIKE-002
linked-adrs:
  - ADR-001
  - ADR-004
  - ADR-006
depends-on:
  - SPEC-026
  - SPEC-027
addresses: []
evidence-pool: ""
swain-do: required
---

# Reference Library Ecosystem Integration

## Problem Statement

The reference library documents (per-style evidence pages in `evidence-analysis/ReferenceArchitectures/docs/`) currently synthesize evidence from single-repo sources only. Ecosystem entries provide a new class of evidence — cross-repo composition patterns that demonstrate architectural styles at a different scale. This evidence must be integrated into reference library documents, particularly for underrepresented styles like Service-Based and Pipe-and-Filter where ecosystem evidence is strongest.

## External Behavior

**Inputs:**
- Curated ecosystem entries from SPEC-026 (at least 10 ecosystems)
- Updated frequency tables from SPEC-027 (including ecosystem-scope frequencies)
- Existing reference library documents (per-style evidence pages)
- ADR-004 Discovered-First Evidence Hierarchy

**Outputs:**
1. Updated reference library documents that include ecosystem evidence sections alongside single-repo evidence
2. Frequency tables in reference docs that show both single-repo and ecosystem-scope breakdowns
3. Ecosystem case studies for styles where ecosystem evidence is particularly illuminating (Service-Based, Pipe-and-Filter, Event-Driven)

**Preconditions:**
- SPEC-026 is Implemented (ecosystem entries curated and validated)
- SPEC-027 is Implemented (pipeline can generate ecosystem-aware frequency tables)

**Postconditions:**
- Every reference library style page that has ecosystem evidence includes it
- Evidence hierarchy follows ADR-004 (Discovered-first) with ecosystem evidence as a distinct subsection
- Frequency tables distinguish single-repo vs ecosystem scope per SPIKE-001 findings

## Acceptance Criteria

1. **Given** a style with ecosystem evidence (e.g., Service-Based), **when** viewing the reference library page, **then** an "Ecosystem Evidence" section appears with ecosystem names, member repos, and composition pattern descriptions.

2. **Given** Service-Based architecture's reference page, **when** ecosystem evidence is included, **then** at least 3 ecosystem examples are cited (e.g., *arr stack, HashiCorp, Grafana LGTM).

3. **Given** Pipe-and-Filter architecture's reference page, **when** ecosystem evidence is included, **then** at least 2 ecosystem examples are cited (e.g., ELK stack, Apache data ecosystem).

4. **Given** any reference library style page with ecosystem evidence, **when** reading the frequency section, **then** single-repo and ecosystem frequencies are reported separately (not combined into a single number).

5. **Given** the reference library as a whole, **when** reviewing all style pages, **then** the evidence hierarchy follows ADR-004 with ecosystem evidence as a subsection within the Discovered evidence tier.

## Verification

| Criterion | Evidence | Result |
|-----------|----------|--------|

## Scope & Constraints

- Ecosystem evidence is additive — it supplements single-repo evidence, does not replace it
- Follow ADR-004's evidence hierarchy (Discovered > KataLog > AOSA > Reference Architectures) with ecosystem as a subsection within Discovered
- Do not combine ecosystem and single-repo frequency counts in the same table (per SPIKE-001: scope axis drives table structure)
- Focus on styles where ecosystem evidence is most impactful: Service-Based, Pipe-and-Filter, Event-Driven, Microservices
- Out of scope: rewriting the reference library generation pipeline (use existing tools, add ecosystem data manually or via simple script extensions)

## Implementation Approach

1. **Template update** — add "Ecosystem Evidence" section to the reference library page template
2. **Service-Based page** — integrate ecosystem evidence (highest impact, most underrepresented)
3. **Pipe-and-Filter page** — integrate ecosystem evidence (ELK, Apache data ecosystem)
4. **Other style pages** — add ecosystem evidence where available
5. **Frequency tables** — update to show dual-scope breakdowns
6. **Review** — ensure ADR-004 hierarchy compliance across all updated pages

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-10 | 46ab06b | Initial creation from EPIC-010 decomposition |
