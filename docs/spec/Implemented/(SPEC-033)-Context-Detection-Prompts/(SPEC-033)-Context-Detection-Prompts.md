---
title: "Context Detection Prompts"
artifact: SPEC-033
status: Implemented
author: cristos
created: 2026-03-12
last-updated: 2026-03-12
parent-epic: EPIC-011
linked-research: []
linked-adrs:
  - ADR-004
depends-on:
  - EPIC-002
  - EPIC-010
addresses:
  - "Architecture advisor treats every query as application-level, missing platform/ecosystem concerns"
evidence-pool: ""
swain-do: required
---

# Context Detection Prompts

## Problem Statement

The architecture-advisor skill treats every user query as an application-level concern. When a user asks about architecture for a multi-service platform or ecosystem, the skill recommends single-repo patterns (Layered, Modular Monolith, Hexagonal) instead of platform-appropriate patterns (Service-Based, Pipeline, Event-Driven choreography). The skill needs a lightweight context detection mechanism to determine whether the user's concern is application-centric, platform-centric, or hybrid, and gate subsequent steps accordingly.

## External Behavior

### Input

- User's initial architecture question and any follow-up conversation
- Signal taxonomy for classifying context from natural language

### Output

- Internal context classification: `application`, `platform`, or `hybrid`
- Subsequent steps (3-5) gated to the appropriate evidence pool and decision paths

### Preconditions

- Architecture-advisor skill exists (EPIC-002 Complete)
- Ecosystem evidence exists in the catalog (EPIC-010)

### Postconditions

- Step 1 includes a context detection sub-section with signal taxonomy and probing questions
- Steps 3-5 reference the detected context to select appropriate evidence and decision paths
- Context classification is internal (not announced to the user) and revisable mid-conversation

## Acceptance Criteria

- **Given** a user question containing platform indicators ("services", "deploy independently", "API contracts"), **when** the advisor processes the question, **then** it classifies the context as `platform` and uses ecosystem evidence in subsequent steps
- **Given** a user question containing application indicators ("my codebase", "module boundaries", "function calls"), **when** the advisor processes the question, **then** it classifies the context as `application` and uses single-repo evidence
- **Given** a user question with mixed signals, **when** the advisor cannot classify confidently, **then** it asks one of the defined probing questions to disambiguate
- **Given** a mid-conversation revelation that changes the context (e.g., "actually, these are separate repos"), **when** the advisor detects the shift, **then** it revises the classification and adjusts guidance

## Verification

| Criterion | Evidence | Result |
|-----------|----------|--------|
| Signal taxonomy table in Step 1 | SKILL.md Step 1 contains "Context Detection" sub-section with 5-signal taxonomy table (Scope, Boundary, Deployment, Communication, Team structure) | Pass |
| Probing questions defined | Three disambiguation questions present for mixed signals | Pass |
| Context gating documented | Step 1 specifies how application/platform/hybrid contexts gate Steps 3-5 | Pass |
| Classification is internal | Text explicitly states classification is not announced to user and is revisable | Pass |

## Scope & Constraints

### In scope

- Signal taxonomy table for context detection
- Probing questions for disambiguation
- Context gating rules for Steps 3-5
- Documentation in SKILL.md Step 1

### Out of scope

- Modifying the research priority tables (that is SPEC-034)
- Adding platform decision paths to the navigator (that is SPEC-035)
- Automated context detection from codebase analysis

## Implementation Approach

1. Add a "Context Detection" sub-section after the existing classification bullets in Step 1
2. Define the signal taxonomy table with platform and application indicators across 5 dimensions
3. Add 3 lightweight probing questions for mixed-signal disambiguation
4. Document context gating rules that reference Steps 3-5

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Implemented | 2026-03-12 | — | Signal taxonomy, probing questions, and context gating added to SKILL.md Step 1 |
