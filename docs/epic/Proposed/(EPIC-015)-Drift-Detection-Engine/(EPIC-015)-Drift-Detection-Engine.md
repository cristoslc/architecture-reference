---
title: "Drift Detection Engine"
artifact: EPIC-015
status: Proposed
author: cristos
created: 2026-03-14
last-updated: 2026-03-14
parent-vision: VISION-002
success-criteria:
  - Engine accepts discover-architecture classification output and constraint baselines, and produces structured drift findings
  - Each finding cites a specific constraint violation or statistical deviation with evidence
  - Findings include confidence scores distinguishing clear violations from stylistic anomalies
  - False positive rate is low enough that findings are actionable without heavy manual filtering
depends-on:
  - EPIC-014
addresses: []
evidence-pool: ""
---

# Drift Detection Engine

## Goal / Objective

Build the core analysis engine that compares a codebase's actual structure (as reported by discover-architecture) against the constraint baselines (from EPIC-014). The engine identifies where reality diverges from the expected architecture: boundary breaches, unexpected coupling patterns, shared-state antipatterns, and structural inconsistencies. Each finding is grounded in evidence — citing either a violated architectural constraint or a statistical deviation from the baseline.

## Scope Boundaries

**In scope:**
- Comparison logic: discovered structure vs. constraint baselines
- Finding generation with evidence citations, confidence scores, and severity levels
- Detection of: boundary violations, dependency direction errors, coupling anomalies, shared-state misuse, communication pattern mismatches
- Structured output format consumable by the review skill's report generator

**Out of scope:**
- Repo scanning and classification (handled by discover-architecture)
- Baseline computation (EPIC-014)
- Report formatting and skill packaging (EPIC-016)
- Automated remediation suggestions
- Static analysis tool integration (future concern)

## Child Specs

_Updated as Agent Specs are created under this epic._

## Key Dependencies

- EPIC-014 (constraint baselines) must be complete — the engine needs baselines to compare against
- discover-architecture skill output format defines the input contract

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-14 | b88a076c | Initial creation |
