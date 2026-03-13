---
title: "Cross-Source Reference Library Integration"
artifact: EPIC-004
status: Complete
author: cristos
created: 2026-03-03
last-updated: 2026-03-04
parent-vision: VISION-001
success-criteria:
  - All 6 reference library documents cite evidence from the full 5-source evidence pool (276 entries)
  - Evidence citations span 3+ distinct sources per claim, not single-source dominance
  - Style scoreboard methodology applies production-weighted scoring (20 pts per production system, 20 pts per Discovered real-world repo, 1-4 pts per KataLog placement, 1-2 pts per reference implementation)
  - Discovered source has a source-analysis.md synthesizing evidence from all 173 catalog entries
  - Pipeline preserves raw signal extraction data in evidence-analysis/Discovered/signals/ for full evidence trail
  - No stale single-source references remain (grep for "62 manually", "103 ", "four sources" returns no hits)
depends-on:
  - EPIC-001
---

# Cross-Source Reference Library Integration

## Goal / Objective

Rewrite the 6 core reference library documents to synthesize evidence from all 5 sources (276 entries) rather than reflecting only KataLog competition data. The evidence base expanded from 78 single-source entries to 276 five-source entries through EPIC-001 and EPIC-003, but the reference library files that practitioners actually read were never updated to reflect this. Six documents totaling ~3,700 lines remain 85-98% KataLog-only, presenting competition-derived findings as if they were the complete picture.

Additionally, the Discovered evidence source (173 repos) has no source analysis document — making it the only source without one — and the pipeline discards raw signal data, leaving no evidence trail for how repos were classified.

## Scope Boundaries

### In scope

- **Full cross-source rewrite** of 6 reference library documents:
  - `problem-spaces.md` (1500+ lines, 98% KataLog) — classify problems from all sources, not just KataLog kata challenges
  - `solution-spaces.md` (528 lines, 95% KataLog) — recompute style scoreboard with production-weighted methodology
  - `evidence/by-architecture-style.md` (487 lines, 92% KataLog) — replace team evidence tables with cross-source evidence
  - `evidence/by-quality-attribute.md` (538 lines, 90% KataLog) — triangulate quality attributes across all 5 sources
  - `problem-solution-matrix.md` (248 lines, 85% KataLog) — rebuild every evidence cell with cross-source citations
  - `decision-navigator.md` (414 lines, 90% KataLog) — rewrite all 10 decision paths with production-system evidence
- **Create Discovered source analysis:** `evidence-analysis/Discovered/docs/analysis/source-analysis.md`
- **Pipeline signal preservation:** save raw signals to `evidence-analysis/Discovered/signals/`
- **Fix stale references:** update counts in discover-architecture SKILL.md, add superseded note to dataset-expansion proposal
- **Template cross-source footers:** add evidence scope context to adr-guide.md, kata-checklist.md, fitness-functions-guide.md

### Out of scope

- New evidence source integration (no new sources added)
- Schema changes to catalog YAMLs
- Architecture advisor skill updates beyond stale count fixes
- Comparative analysis features (EPIC-003 Phase 3)

## Rewrite Strategy

### Framework preservation

All 6 files have reusable structural frameworks (section templates, dimension definitions, table structures, navigation logic). The rewrite preserves these and replaces data:

| File | Framework Reuse | Data Replacement |
|------|----------------|-----------------|
| problem-spaces.md | 10 dimension definitions, per-profile template, similarity matrix structure | KataLog-only profiles -> cross-source system profiles from all sources |
| solution-spaces.md | Per-style profile template, pattern tables, anti-pattern structure | All scores/rankings recomputed with production weighting |
| by-architecture-style.md | Per-style section structure, evidence table template | KataLog team rows -> cross-source evidence rows |
| by-quality-attribute.md | 10 QA sections, per-QA sub-structure | Rankings recomputed, all team references -> cross-source |
| problem-solution-matrix.md | 8 dimension tables, compound mappings, flowchart | All evidence cells replaced, domain rows expanded |
| decision-navigator.md | 8 questions, 10 paths, QA validation table | Evidence tables and "why this works" narratives |

### Scoring methodology change

The single most impactful change. Current: KataLog-only (1st=4, 2nd=3, 3rd=2, Runner-up=1). New: production-weighted (AOSA/RealWorld/Discovered=20 pts each, KataLog=1-4 pts, RefArch=1-2 pts). Rankings will be computed from the full 276-entry evidence pool — the epic validates that methodology is applied correctly, not pre-determines which styles will rank where.

### Implementation order

Bottom-up to maintain consistency across the dependency chain:

```
Layer 1 (foundational):  Discovered source-analysis.md, problem-spaces.md
Layer 2 (evidence):      solution-spaces.md, by-architecture-style.md, by-quality-attribute.md
Layer 3 (synthesis):     problem-solution-matrix.md, decision-navigator.md
Layer 4 (infrastructure): pipeline signals, stale refs, template footers
```

## Key Data Points

All cross-source analysis data points will be determined by running the pipeline on the full evidence pool. The rewritten documents will contain validated synthesis from all 5 sources (276 entries). Specific counts, rankings, and insights will emerge from the analysis — the epic validates that synthesis occurs, not pre-determines its outcomes.

## Child Specs

To be created as the epic is broken into implementable units.

## Key Dependencies

No blocking dependencies. EPIC-001 (Complete) and EPIC-003 (Active) have already produced the evidence data this epic integrates into the reference library. The 276 catalog entries exist; this epic writes the synthesis.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-03 | — | Created from implementation plan for full cross-source reference library integration |
| Active | 2026-03-04 | 37376eb | Epic commenced - all child specs have implementation plans and ready tasks |
| Complete | 2026-03-05 | fdc0ef9 | All child specs implemented or superseded; cross-source integration complete |
