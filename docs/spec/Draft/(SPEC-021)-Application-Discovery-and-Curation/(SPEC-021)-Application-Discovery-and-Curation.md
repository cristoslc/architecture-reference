---
title: "Application Discovery and Curation"
artifact: SPEC-021
status: Draft
author: cristos
created: 2026-03-06
last-updated: 2026-03-06
parent-epic: EPIC-012
depends-on:
  - SPEC-020
linked-adrs:
  - ADR-001
execution-tracking: required
---

# Application Discovery and Curation

## Problem Statement

After removing 43 non-architecture entries, the catalog has 65 production platforms vs 19 production applications (3.4:1 ratio). This skew means frequency rankings disproportionately reflect platform architectures (Plugin/Microkernel, Pipe-and-Filter) rather than application architectures — but application architects are the primary audience.

## External Behavior

**Input:** Curated candidate list of production-grade applications from GitHub search, awesome-lists, and domain-specific directories.

**Outputs:**

| Output | Description |
|--------|-------------|
| 30+ new manifest entries | Added to `manifest.yaml` with repo URLs |
| 30+ new catalog entries | YAML files in `docs/catalog/` with `scope: application`, `use_type: production` |
| 30+ signal files | Extracted via `extract-signals.sh` |
| 30+ classifications | Heuristic + LLM review + deep-validation |
| Discovery log | Rationale for inclusion/exclusion of candidate repos |

**Selection criteria:**
- >1k GitHub stars (ensures active community and enough code to classify)
- Active maintenance (commits within last 12 months)
- Classifiable architecture (not a CLI tool, browser extension, or static site)
- Scope = application (end-user facing, not infrastructure)
- Domain diversity (target underrepresented: healthcare, fintech, logistics, education, government, productivity)

## Acceptance Criteria

1. At least 30 new production-grade application entries added to catalog
2. Platform-to-application ratio no worse than 2:1 after additions
3. At least 5 domains represented among new entries
4. All new entries have full pipeline classification (signals + heuristic + LLM review + deep-validation)
5. All new entries tagged with `scope: application`, `use_type: production`
6. Discovery log documents why each candidate was included or rejected

## Implementation Approach

1. Search GitHub for production applications in underrepresented domains
2. Filter candidates by selection criteria
3. Add to manifest.yaml
4. Run full pipeline: clone → extract signals → heuristic classify → LLM review → deep-validate
5. Review classifications and tag taxonomy fields
6. Document discovery rationale

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-06 | 23bed6f | Initial creation |
