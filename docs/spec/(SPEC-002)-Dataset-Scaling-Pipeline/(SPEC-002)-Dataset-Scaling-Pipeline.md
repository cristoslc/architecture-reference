---
title: "Dataset Scaling Pipeline"
artifact: SPEC-002
status: Approved
author: cristos
created: 2026-03-03
last-updated: 2026-03-03
pipeline-dir: pipeline/
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

### Resolved decisions

1. **Repo selection**: Curate a YAML manifest of public GitHub repos covering all 12 architecture styles. Target 150+ repos to achieve 200+ catalog entries when combined with existing evidence sources. Focus on well-known, documented open-source projects.
2. **Confidence threshold**: 0.5 for automatic acceptance (per postconditions). Entries below 0.5 are still cataloged but flagged with `review_required: true`.
3. **Evolutionary analysis**: Deferred to a separate spec. This pipeline focuses on structural discovery via `extract-signals.sh`.

### Architecture

The pipeline is a shell-based batch orchestrator with Python helpers (stdlib only, no pip dependencies):

1. **Repo manifest** (`pipeline/manifest.yaml`) — YAML list of repos with `url`, `domain`, `expected_styles` (optional), and `priority`. Acts as the single source of truth for target repos.

2. **Batch orchestrator** (`pipeline/run-pipeline.sh`) — reads the manifest, shallow-clones repos to a temp directory (parallel, configurable concurrency), runs `extract-signals.sh` on each clone, pipes signals through the heuristic classifier, writes catalog entries to `evidence-analysis/Discovered/docs/catalog/`, and cleans up clones. Idempotent — re-running skips already-cataloged repos.

3. **Heuristic classifier** (`pipeline/classify.py`) — codifies the signal-to-style mapping rules from `skills/discover-architecture/references/signal-rules.md` into an algorithmic classifier. Accepts signal YAML on stdin, emits a catalog YAML entry on stdout conforming to `catalog-schema.yaml`. No LLM required.

4. **Index generator** (`pipeline/generate-index.py`) — scans all catalog entries in `evidence-analysis/Discovered/docs/catalog/` and builds `evidence-analysis/Discovered/_index.yaml` with aggregated statistics.

5. **Quality report** (`pipeline/quality-report.py`) — generates a markdown report: confidence distribution, per-style coverage (target: n >= 10 for all 12 styles), entries flagged for review, and coverage gaps.

### Key constraints

- Pipeline is idempotent — re-running skips already-cataloged repos
- No network calls during classification (signals are extracted from local clones)
- Python 3.9+ with only stdlib (PyYAML acceptable since it ships with most Python installs)
- Signal extraction reuses `skills/discover-architecture/scripts/extract-signals.sh` without modification

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-03 | b63f031 | Initial creation — will be refined after SPEC-001 implementation |
| Approved | 2026-03-03 | 6d61123 | Refined implementation approach — SPEC-001 implemented, decisions resolved |
