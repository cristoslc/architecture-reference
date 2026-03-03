---
title: "Dataset Scaling Pipeline"
artifact: SPEC-002
status: Draft
author: cristos
created: 2026-03-03
last-updated: 2026-03-03
parent-epic: EPIC-003
linked-research: []
linked-adrs: []
depends-on:
  - SPEC-001
---

# Dataset Scaling Pipeline

## Problem Statement

The discovery skill (SPEC-001) produces catalog entries for individual repos. To scale the evidence base from 62 to 200+ projects, we need a pipeline that runs discovery across a curated list of repositories, validates the output, and integrates results into the evidence catalog.

## External Behavior

### Input

A manifest of target repositories (YAML list of repo URLs with metadata: domain, expected styles, priority).

### Output

- New YAML catalog entries in `evidence-analysis/Discovered/docs/catalog/`
- A `_index.yaml` aggregating all discovered projects
- A quality report showing classification confidence distribution, flagged entries needing human review, and coverage gaps

### Preconditions

- SPEC-001 (Architecture Discovery Skill) is implemented and calibrated
- Target repos are accessible (public GitHub repos or locally cloned)

### Postconditions

- Evidence catalog grows by the number of successfully classified repos
- All entries with confidence < 0.5 are flagged for human review
- Cross-source analysis documents are updated to include the "Discovered" source

## Acceptance Criteria

- **Given** a manifest of 50 repos, **when** the pipeline runs, **then** at least 40 (80%) produce valid catalog entries
- **Given** completed pipeline output, **when** entries are added to the catalog, **then** `_index.yaml` is auto-generated and consistent
- **Given** the expanded catalog, **when** the reference library is regenerated, **then** all 12 architecture styles have n >= 10 samples

## Scope & Constraints

### In scope

- Batch discovery across a curated repo manifest
- Quality gating (confidence thresholds, human review flags)
- Integration into evidence-analysis/ directory structure
- Evolutionary analysis via git history mining (code-maat patterns)

### Out of scope

- Community contribution pipeline (user-submitted repos)
- Continuous/scheduled discovery (one-shot batch, not a daemon)
- Automatic reference library regeneration (that remains a manual analytical step)

## Implementation Approach

_To be refined after SPEC-001 is implemented and calibrated. Key decisions deferred:_
- Repo selection criteria and manifest curation
- Confidence threshold for automatic vs. human-reviewed entries
- Whether evolutionary analysis (git history) is in this spec or a separate one

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-03 | b63f031 | Initial creation — will be refined after SPEC-001 implementation |
