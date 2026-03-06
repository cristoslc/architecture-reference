---
title: "Reference Library Statistics Update"
artifact: SPEC-018
status: Implemented
author: cristos
created: 2026-03-05
last-updated: 2026-03-05
parent-epic: EPIC-008
depends-on:
  - SPEC-017
  - SPEC-019
---

# Reference Library Statistics Update

## Problem Statement

SPEC-019 deep-validated all 163 Discovered repos, producing ground-truth classifications that differ dramatically from the heuristic pipeline. The 6 reference library documents and 2 cross-source evidence documents still show pre-deep-validation statistics. These documents were restructured by EPIC-007 to lead with Discovered statistics as primary evidence — stale numbers in the primary ranking tables directly mislead readers.

Key statistics changes (deep-validation ground truth):
- Modular Monolith: largest style at 65 repos (was underrepresented)
- Event-Driven: 47 repos (secondary style in most cases)
- Plugin/Microkernel: 33 repos (was 0)
- Microservices: 16 repos (was 45 — heuristic over-classified by 3x)
- Service-Based: 11 repos (was 43 — heuristic over-classified by 4x)
- 9 styles now detected that were previously invisible to the pipeline

### Why this is a separate spec

SPEC-017 produces corrected evidence data in `evidence-analysis/Discovered/`. This spec consumes that data and propagates it into the user-facing reference library. Keeping them separate means SPEC-017 can be validated independently (are the new classifications correct?) before committing to rewriting documentation that readers depend on.

## External Behavior

**Input:** Deep-validated statistics from SPEC-019 (which builds on SPEC-017's re-extraction):
- `evidence-analysis/Discovered/_index.yaml` (updated style/QA distributions)
- `evidence-analysis/Discovered/docs/analysis/reclassification-comparison.md` (what changed and why)
- `evidence-analysis/Discovered/quality-report.md` (recomputed statistics)

**Outputs** (all under `docs/reference-library/`):

| Document | What changes |
|----------|-------------|
| `solution-spaces.md` | Discovered Frequency Scoreboard table, per-style frequency stats, SBA and Plugin profiles |
| `problem-spaces.md` | Domain-style distribution tables, SBA/Plugin domain coverage |
| `evidence/by-architecture-style.md` | Discovered Frequency Rankings table, SBA and Plugin evidence sections |
| `evidence/by-quality-attribute.md` | QA detection frequency tables (if QA distribution shifted) |
| `problem-solution-matrix.md` | Domain-Style Matrix cells for SBA and Plugin columns |
| `decision-navigator.md` | Statistical basis paragraphs, Quick Reference Card rankings |
| `evidence/cross-source-reference.md` | Discovered column in Combined Weighted Scoreboard |
| `evidence/cross-source-analysis.md` | Discovered counts in tier tables |

## Acceptance Criteria

1. All 8 documents reflect the corrected SBA and Plugin/Microkernel counts from SPEC-017
2. SBA appears in the Discovered Frequency Scoreboard at its new rank (not 3% / rank 12)
3. Plugin/Microkernel appears as a new row in style tables (was absent entirely)
4. No statistical inconsistencies between documents — all cite the same counts for each style
5. Detection bias caveats updated if SBA/Plugin bias notes change
6. Each changed document passes the 6 prose clarity heuristics from EPIC-007
7. When citing or defining architectural styles, include notable real-world projects as examples — selected by GitHub star count or industry recognition to give readers immediate concrete referents (e.g., "Service-Based: Shopware (3.2k stars), Medusa (27k stars)" rather than abstract descriptions alone)

## Scope & Constraints

### In scope

- Updating statistics, tables, rankings, and prose in the 8 documents listed above
- Adding new SBA and Plugin/Microkernel profile sections where they didn't exist
- Correcting any cross-references to old SBA/Plugin counts

### Out of scope

- Structural changes to document organization (EPIC-007 already did that)
- Adding new evidence sources
- Changes to the evidence-analysis layer (that's SPEC-017)

## Implementation Approach

### Step 1: Extract updated statistics

Read `_index.yaml` and `reclassification-comparison.md` from SPEC-017 outputs. Compute:
- New style frequency table (count and percentage per style)
- New style rank order
- SBA and Plugin-specific statistics (which repos, which domains, co-occurring styles)
- QA distribution changes (if any)

### Step 1b: Identify notable projects per style

For each architectural style, select 2-4 notable projects from the Discovered catalog to use as concrete examples when citing the style. Selection criteria:
- **Primary:** GitHub star count (prefer projects with 5k+ stars for reader recognition)
- **Secondary:** Industry recognition, adoption breadth, or domain diversity
- Source star counts from `_index.yaml` metadata or live GitHub API queries

These project names and star counts will be embedded in style profiles, evidence tables, and decision navigator paths — giving readers immediate real-world referents instead of abstract style descriptions.

### Step 2: Update documents (parallelizable)

Three parallel agents, matching the layer structure from EPIC-007:

| Agent | Documents | Key changes |
|-------|-----------|-------------|
| Layer 1 | `solution-spaces.md`, `problem-spaces.md` | Frequency scoreboard, domain distribution, new style profiles |
| Layer 2 | `by-architecture-style.md`, `by-quality-attribute.md` | Frequency rankings, SBA/Plugin evidence sections |
| Layer 3 | `problem-solution-matrix.md`, `decision-navigator.md`, `cross-source-reference.md`, `cross-source-analysis.md` | Matrix cells, decision paths, scoreboard columns |

Each agent receives the updated statistics and the EPIC-007 prose clarity heuristics as context.

### Step 3: Cross-document consistency check

Grep all 8 documents for SBA and Plugin count references. Verify they all cite the same numbers. Flag any discrepancies.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-05 | 5a8fd36 | Initial creation |
| Implemented | 2026-03-06 | — | All 8 documents updated with SPEC-019 deep-validated statistics. Cross-document consistency verified. |
