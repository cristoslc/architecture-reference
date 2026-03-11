---
title: "Full Catalog Reclassification"
artifact: SPEC-031
status: Draft
author: cristos
created: 2026-03-10
last-updated: 2026-03-10
parent-epic: EPIC-013
linked-research: []
linked-adrs:
  - ADR-005
depends-on:
  - SPEC-029
  - SPEC-030
addresses: []
evidence-pool: ""
swain-do: required
---

# Full Catalog Reclassification

## Problem Statement

The 184+ catalog entries were classified by SPEC-024 (GLM-5 tool-calling + Sonnet fallback) before ADR-005 was adopted. While the classifications themselves are valid (deep-analysis methodology), the output format doesn't conform to the unified catalog-entry template schema. Entries lack some fields SPEC-003 needs (`quality_attributes` is sparse, `domain` is inconsistent). All entries must be reclassified through the ADR-005-compliant pipeline to produce both markdown reports and standardized YAML catalog entries.

## External Behavior

### Input

- The full catalog manifest (184+ repos)
- The refactored `classify-tooluse.sh` (from SPEC-030) reading the discover skill at runtime
- The validated catalog-entry template (from SPEC-029)

### Output

- 184+ catalog entries in `evidence-analysis/Discovered/docs/catalog/` conforming to `catalog-entry.template.j2` schema
- 184+ markdown reports in `docs/architecture-reports/`
- A campaign report: success rate, failures/retries, field coverage stats, confidence distribution
- Updated `_index.yaml`

### Preconditions

- SPEC-029 complete (schema validated)
- SPEC-030 complete (pipeline reads from discover skill)
- Clone cache or network access to all cataloged repos

### Postconditions

- Every catalog entry validates against `catalog-schema.yaml`
- Every entry has all fields SPEC-003 requires for similarity matching
- Architecture reports directory contains per-repo markdown analyses
- No regressions in classification quality vs. SPEC-024 baseline

## Acceptance Criteria

- **Given** the full catalog manifest, **when** the reclassification campaign completes, **then** >= 95% of entries produce valid dual output (catalog entry + report)
- **Given** completed catalog entries, **when** validated against `catalog-schema.yaml`, **then** all pass with no missing required fields
- **Given** the reclassified catalog, **when** compared against SPEC-024 baseline classifications, **then** primary style agreement is >= 85% (regressions investigated and documented)
- **Given** the campaign report, **when** reviewed, **then** confidence distribution is documented and entries below 0.5 are flagged for review

## Verification

| Criterion | Evidence | Result |
|-----------|----------|--------|

## Scope & Constraints

### In scope

- Batch reclassification of all 184+ entries
- Dual output production (YAML + markdown)
- Quality comparison against SPEC-024 baseline
- Campaign reporting
- Index regeneration

### Out of scope

- Adding new repos beyond the current catalog (future scaling work)
- Changing the classification methodology or style taxonomy
- Reference library statistics updates (separate spec if needed)

## Implementation Approach

1. Build a batch orchestrator that iterates the catalog manifest and invokes the refactored `classify-tooluse.sh` for each entry
2. Run in parallel batches (configurable concurrency) to manage API costs and rate limits
3. Compare each result against the SPEC-024 baseline classification — flag regressions
4. Investigate and resolve regressions (re-run with higher chain limit or fallback to Sonnet)
5. Generate campaign report with coverage stats
6. Regenerate `_index.yaml`

### Cost management

- Primary model: GLM-5 via OpenRouter (~$0.01-0.03/repo)
- Fallback: Sonnet subagent for failures or regressions (~$0.05-0.10/repo)
- Estimated total: ~$5-15 for the full campaign

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-10 | — | Initial creation under EPIC-013 |
