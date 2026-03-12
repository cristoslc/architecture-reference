---
title: "Platform Architecture Decision Paths"
artifact: SPEC-035
status: Implemented
author: cristos
created: 2026-03-12
last-updated: 2026-03-12
parent-epic: EPIC-011
linked-research: []
linked-adrs: []
depends-on:
  - SPEC-033
  - SPEC-034
  - EPIC-010
addresses:
  - "Decision navigator has no platform-scale decision paths; Q1-Q8 and paths A-J are application-centric"
evidence-pool: ""
swain-do: required
---

# Platform Architecture Decision Paths

## Problem Statement

The architecture decision navigator (`docs/reference-library/decision-navigator.md`) contains 8 classification questions (Q1-Q8) and 10 decision paths (A-J), all designed for application-centric architecture decisions. When a user's context is platform/ecosystem (detected by SPEC-033), the navigator has no classification questions for platform dimensions (component count, communication mechanism, team ownership, API evolution) and no decision paths grounded in ecosystem evidence.

## External Behavior

### Input

- Context classification from SPEC-033 (`platform` or `hybrid`)
- User's platform architecture question

### Output

- Platform classification via P1-P6 questions
- One of four platform decision paths (P-A through P-D) with ecosystem-grounded recommendations

### Preconditions

- SPEC-033 context detection is implemented
- Ecosystem catalog entries exist (EPIC-010)
- SPEC-034 dual-scale evidence retrieval is implemented

### Postconditions

- Decision navigator has a context gate routing users to application (Q1-Q8) or platform (P1-P6) questions
- 6 platform classification questions (P1-P6) cover component count, stack homogeneity, communication, team structure, API evolution, and shared infrastructure
- 4 platform decision paths (P-A through P-D) with statistical basis from 11 ecosystems, production validation, cross-repo concerns checklists, and anti-patterns

## Acceptance Criteria

- **Given** a platform context, **when** the user enters the decision navigator, **then** the context gate directs them to P1-P6 classification questions
- **Given** P1-P6 answers matching hub-and-spoke profile (2-5 components, same team, REST, shared infra), **when** navigating to a decision path, **then** Path P-A (Service-Based Hub-and-Spoke) is recommended with *arr Media Stack and Grafana LGTM as production validation
- **Given** P1-P6 answers matching pipeline profile (data pipeline, message queue, stage-oriented), **when** navigating, **then** Path P-B (Pipeline with Event Backbone) is recommended with ELK Stack and Apache Data Ecosystem as validation
- **Given** P1-P6 answers matching choreography profile (5+ components, multiple teams, message queue), **when** navigating, **then** Path P-C (Event-Driven Choreography) is recommended with Fediverse and Temporal as validation
- **Given** P1-P6 answers matching microservices profile (10+ components, heterogeneous, open ecosystem), **when** navigating, **then** Path P-D (Microservices with API Gateway) is recommended with Istio/Envoy, Sentry, and Supabase as validation
- **Given** a hybrid context, **when** entering the navigator, **then** the context gate offers both question sets with guidance on when to use each

## Verification

| Criterion | Evidence | Result |
|-----------|----------|--------|
| Context gate present | Decision navigator has "Context Gate" section before Q1, routing to application/platform/hybrid flows | Pass |
| P1-P6 questions defined | "Step 1P: Classify Your Platform" section with 6 questions covering component count, stack, communication, team, API, infrastructure | Pass |
| Path P-A defined | Service-Based Hub-and-Spoke path with 45% statistical basis, *arr/Grafana/HashiCorp validation, cross-repo checklist, anti-patterns | Pass |
| Path P-B defined | Pipeline with Event Backbone path with 18% statistical basis, ELK/Apache validation, cross-repo checklist, anti-patterns | Pass |
| Path P-C defined | Event-Driven Choreography path with 9% statistical basis, Fediverse/Temporal validation, cross-repo checklist, anti-patterns | Pass |
| Path P-D defined | Microservices with API Gateway path with 27% statistical basis, Istio/Sentry/Supabase validation, cross-repo checklist, anti-patterns | Pass |
| Existing content preserved | Q1-Q8 and paths A-J unchanged | Pass |

## Scope & Constraints

### In scope

- Context gate in the decision navigator
- 6 platform classification questions (P1-P6)
- 4 platform decision paths (P-A through P-D)
- Cross-repo concerns checklists and anti-patterns for each path

### Out of scope

- Context detection logic (that is SPEC-033)
- Evidence retrieval prioritization (that is SPEC-034)
- Quick reference card updates for platform paths (future enhancement)

## Implementation Approach

1. Add context gate section after the navigator introduction, before Q1
2. Add "Step 1P: Classify Your Platform" section with P1-P6 after the existing Q1-Q8 section
3. Rename "Step 2" to "Step 2: Follow Your Path (Application Context)" for clarity
4. Add "Step 2P: Follow Your Path (Platform Context)" section with paths P-A through P-D after the existing application paths
5. Update the navigator generation date and evidence source note

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Implemented | 2026-03-12 | — | Context gate, P1-P6, paths P-A through P-D added to decision-navigator.md |
