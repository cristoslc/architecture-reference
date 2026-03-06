---
title: "Heuristic Pipeline Improvements"
artifact: EPIC-009
status: Proposed
author: cristos
created: 2026-03-06
last-updated: 2026-03-06
parent-vision: VISION-001
success-criteria:
  - Heuristic pipeline detects all 14 architecture styles (currently detects 5)
  - Heuristic-to-deep-validation agreement rate >= 60% (currently 14.7%)
  - Microservices false-positive rate reduced by >= 50% (currently 30 false positives out of 45 heuristic Microservices)
  - Service-Based false-positive rate reduced by >= 50% (currently 35 false positives out of 43)
  - Library/framework repos correctly classified as Indeterminate (currently 21 of 24 misclassified)
depends-on:
  - SPEC-019
---

# Heuristic Pipeline Improvements

## Goal / Objective

Bring the heuristic classification pipeline (extract-signals.sh + classify.py) to a level where it provides useful first-pass classifications, reducing the deep-validation reclassification rate from 85% to under 40%. SPEC-019's side-by-side comparison of heuristic vs deep-validation results across 163 repos provides the training data; this epic uses those findings to add missing style detectors, fix false-positive patterns, and improve confidence calibration.

## Scope Boundaries

### In scope

- Adding scorer rules for the 9 undetectable styles (Pipe-and-Filter, Hexagonal Architecture, Multi-Agent, Layered, Space-Based, CQRS, Serverless, Domain-Driven Design, and improving the existing Plugin/Microkernel and Modular Monolith scorers)
- Fixing Microservices false-positive logic (Docker/k8s presence alone should not trigger Microservices)
- Fixing Service-Based false-positive logic (monorepo packages are not services)
- Adding library/framework detection (no application architecture = Indeterminate)
- Improving confidence calibration so heuristic confidence correlates with accuracy
- Adding secondary style output (top 2-3 styles, not just primary)
- Validation against deep-validation ground truth in signal files (`deep_validation:` blocks)

### Out of scope

- Changes to deep-validation workflow (SPEC-013, SPEC-019)
- Changes to LLM review pipeline (SPEC-010, SPEC-011)
- Reference library document updates (SPEC-018)
- New signal extraction (extract-signals.sh changes beyond what's needed for new scorers)

## Evidence Base

SPEC-019's verification report (`pipeline/reports/validation-deep-20260306.md`) documents every reclassification with root cause analysis. Key data:

| Failure Mode | Repos Affected | Fix Category |
|-------------|---------------|--------------|
| Missing style detectors (9 styles) | 80 repos | New scorers |
| Microservices false positives (Docker/k8s) | 30 repos | Rule rewrite |
| Service-Based false positives (monorepo) | 35 repos | Rule rewrite |
| Library/framework misclassification | 21 repos | New detector |
| Confidence over-estimation | ~50 repos | Calibration |

All 163 signal files contain both `classification:` (heuristic) and `deep_validation:` (ground truth) blocks, providing a complete training/validation dataset.

## Child Specs

| ID | Title | Status | Focus |
|----|-------|--------|-------|
| — | TBD: Missing Style Scorers | — | Add detection rules for 9 missing styles |
| — | TBD: False-Positive Reduction | — | Fix Microservices and Service-Based over-detection |
| — | TBD: Library/Framework Detector | — | Distinguish libraries from applications |
| — | TBD: Confidence Calibration | — | Align heuristic confidence with accuracy |

Specs will be decomposed when this epic is activated.

## Key Dependencies

- **SPEC-019** (Implemented): Provides the ground truth dataset (163 repos with side-by-side heuristic vs deep-validation classifications)
- **classify.py**: The heuristic scorer implementation to be improved
- **extract-signals.sh**: May need minor additions for new signal types (e.g., agent directory patterns)

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-06 | — | Initial creation based on SPEC-019 findings |
