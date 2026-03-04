---
title: "Pipeline Signal Preservation"
artifact: SPEC-004
status: Draft
author: cristos
created: 2026-03-03
last-updated: 2026-03-03
parent-epic: EPIC-004
linked-research: []
linked-adrs: []
depends-on: []
addresses: []
---

# Pipeline Signal Preservation

## Problem Statement

The dataset scaling pipeline (SPEC-002) currently discards raw signal extraction data immediately after classification, leaving no evidence trail for how repositories were classified. When practitioners or reviewers want to understand *why* a repo was classified as "Event-Driven" or "Pipeline," they have no access to the signals that drove that decision. This opacity undermines trustworthiness of the expanded catalog.

The Discovered evidence source (173 repos) needs persistent signals stored in `evidence-analysis/Discovered/signals/` following the same pattern established for AOSA, RealWorld, and RefArch sources.

## External Behavior

**Inputs:**
- Existing discovery pipeline code from SPEC-002
- 173 Discovered repo catalog entries in `evidence-analysis/Discovered/catalog/`

**Outputs:**
- Raw signal JSON files in `evidence-analysis/Discovered/signals/<repo-name>.signals.json`
- Each signal file contains:
  - File tree structure
  - Language distribution
  - Architectural indicator counts
  - Heuristic classification scores
  - LLM classification reasoning (if applicable)

**Preconditions:**
- SPEC-002 pipeline is operational
- Discovered catalog entries exist

**Postconditions:**
- Every repo in the Discovered catalog has a corresponding signals file
- Signals files are committed to git for auditability
- Pipeline continues to save signals for future discovery runs

## Acceptance Criteria

- **Given** a repo that has been discovered and cataloged
  **When** I navigate to `evidence-analysis/Discovered/signals/<repo-name>.signals.json`
  **Then** I can see the raw signals (file counts, indicator matches, classification reasoning) that led to its catalog entry

- **Given** the complete Discovered catalog (173 repos)
  **When** I run `ls evidence-analysis/Discovered/signals/ | wc -l`
  **Then** I see 173 signal files

- **Given** a practitioner who wants to audit a classification
  **When** they read the signals file
  **Then** they can trace the decision path from raw indicators to final style label

## Scope & Constraints

**In scope:**
- Modify SPEC-002 pipeline to preserve signals
- Rerun pipeline on all 173 Discovered repos to generate signals retroactively
- Commit signals to git
- Document signal file format

**Out of scope:**
- Signal file format changes (use existing structure from SPEC-001)
- Re-classification of repos (maintain existing labels)
- UI/tooling for signal visualization
- Signals for other sources (AOSA/RealWorld/RefArch already have them)

**Token budget:** Rerunning 173 repos through signal extraction is high-volume but requires no LLM calls if heuristic classification is sufficient. Budget ~10K tokens for orchestration and verification.

## Implementation Approach

1. **Audit existing signals structure** — examine `evidence-analysis/AOSA/signals/`, `evidence-analysis/RealWorld/signals/` for format consistency
2. **Modify pipeline save logic** — update SPEC-002 code to write signals to disk before or after classification
3. **Create signals directory** — `mkdir -p evidence-analysis/Discovered/signals/`
4. **Rerun pipeline** — batch process all 173 Discovered repos with signal preservation enabled
5. **Validate output** — verify all 173 signal files exist and contain expected structure
6. **Commit signals** — add and commit all signals files with a descriptive message
7. **Update pipeline documentation** — note that signals are now preserved by default

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-03 | 960504c | Initial creation for EPIC-004 implementation |
