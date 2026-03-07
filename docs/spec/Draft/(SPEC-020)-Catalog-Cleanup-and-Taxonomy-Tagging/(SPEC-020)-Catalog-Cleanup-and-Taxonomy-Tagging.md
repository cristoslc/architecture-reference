---
title: "Catalog Cleanup and Taxonomy Tagging"
artifact: SPEC-020
status: Draft
author: cristos
created: 2026-03-06
last-updated: 2026-03-06
parent-epic: EPIC-012
linked-adrs:
  - ADR-001
linked-research:
  - SPIKE-001
execution-tracking: required
---

# Catalog Cleanup and Taxonomy Tagging

## Problem Statement

The Discovered catalog contains 43 entries that have no deployable architecture (36 libraries/frameworks + 7 non-software). These inflate style frequencies and muddy the signal. Additionally, no entry carries taxonomy metadata — you can't filter by scope (platform vs application) or use-type (production vs reference).

## External Behavior

**Input:** 163 catalog YAML files in `evidence-analysis/Discovered/docs/catalog/`, SPIKE-001 taxonomy classification in `docs/research/Complete/(SPIKE-001)-Ecosystem-Statistical-Modeling/taxonomy-classification.md`.

**Outputs:**

| Output | Description |
|--------|-------------|
| 43 catalog entries removed | Files deleted from `docs/catalog/`, corresponding signal files archived |
| 43 signal files archived | Moved to `signals-archive-removed/` for traceability |
| 120 entries tagged | Each remaining YAML gets `scope:` and `use_type:` fields |
| Manifest updated | `manifest.yaml` entries removed for deleted repos |
| Index rebuilt | `_index.yaml` regenerated from remaining entries |

## Acceptance Criteria

1. All 43 entries from the SPIKE-001 removal list are deleted from `docs/catalog/`
2. Corresponding signal files moved to `signals-archive-removed/` (not deleted)
3. All 120 remaining entries have `scope: platform` or `scope: application` field
4. All 120 remaining entries have `use_type: production` or `use_type: reference` field
5. Taxonomy assignments match SPIKE-001 classification (with reclassifications applied)
6. `_index.yaml` and `manifest.yaml` reflect the 120-entry catalog
7. No orphaned references to removed entries in analysis docs

## Implementation Approach

1. Parse SPIKE-001 taxonomy-classification.md to build removal and tagging lists
2. Archive signal files for removed entries
3. Delete catalog YAML files for removed entries
4. Add `scope:` and `use_type:` fields to each remaining entry
5. Update manifest.yaml
6. Regenerate `_index.yaml`
7. Grep for orphaned references to removed project names in analysis docs

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-06 | 23bed6f | Initial creation |
