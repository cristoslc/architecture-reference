---
title: "Discovered Source Analysis Creation"
artifact: SPEC-006
status: Draft
author: cristos
created: 2026-03-03
last-updated: 2026-03-03
parent-epic: EPIC-004
linked-research: []
linked-adrs: []
depends-on:
  - SPEC-004
addresses: []
---

# Discovered Source Analysis Creation

## Problem Statement

The Discovered evidence source (173 repos) is the only source in the evidence base without a `source-analysis.md` file. Every other source has one:
- `evidence-analysis/AOSA/docs/analysis/source-analysis.md` — synthesizes 12 AOSA systems
- `evidence-analysis/RealWorld/docs/analysis/source-analysis.md` — synthesizes 5 RealWorld apps
- `evidence-analysis/RefArch/docs/analysis/source-analysis.md` — synthesizes 8 reference implementations

The absence of a Discovered source analysis makes it impossible to understand the aggregate characteristics of this 173-entry corpus without manually reading all catalog files. Practitioners and reviewers have no quick reference for questions like:
- What's the language distribution across Discovered repos?
- Which styles dominate?
- What patterns are most common?
- How does Discovered compare to AOSA/RealWorld/RefArch?

## External Behavior

**Inputs:**
- 173 catalog YAML files in `evidence-analysis/Discovered/catalog/`
- Signal files in `evidence-analysis/Discovered/signals/` (from SPEC-004)
- Existing source analysis templates from AOSA/RealWorld/RefArch

**Outputs:**
- `evidence-analysis/Discovered/docs/analysis/source-analysis.md` containing:
  - Source overview (173 repos, discovery methodology)
  - Style distribution table (counts per style)
  - Language distribution table
  - Pattern frequency analysis
  - Quality attribute prevalence
  - Notable architectural insights
  - Cross-source comparison (how Discovered differs from AOSA/RealWorld/RefArch)

**Preconditions:**
- All 173 Discovered catalog YAMLs exist
- Signal files exist (SPEC-004 complete)

**Postconditions:**
- Discovered has a source analysis file matching the format of other sources
- Cross-source comparisons in reference library files can cite the Discovered analysis
- Practitioners can understand Discovered corpus characteristics without reading 173 catalog files

## Acceptance Criteria

- **Given** I navigate to `evidence-analysis/Discovered/docs/analysis/`
  **When** I list the files
  **Then** I see `source-analysis.md` present

- **Given** the Discovered source analysis
  **When** I read the style distribution section
  **Then** I see counts for all 13+ architectural styles reflecting the 173 catalog entries

- **Given** the source analysis
  **When** I read the cross-source comparison section
  **Then** I see at least 3 insights contrasting Discovered with AOSA/RealWorld/RefArch (e.g., "Discovered has 47 Pipeline repos vs 0 in KataLog")

- **Given** all 5 sources
  **When** I check for source-analysis.md in each
  **Then** all 5 sources (AOSA, RealWorld, RefArch, KataLog, Discovered) have one

## Scope & Constraints

**In scope:**
- Aggregating style/language/pattern distributions from 173 catalog YAMLs
- Creating `source-analysis.md` following existing source analysis format
- Cross-source comparison insights
- Notable architectural findings (e.g., Pipeline dominance in Discovered)

**Out of scope:**
- Modifying existing source analyses (AOSA/RealWorld/RefArch)
- Re-classification of Discovered repos
- Deep architectural assessments (keep analysis high-level)
- Comparative analysis tooling (EPIC-003 Phase 3)

**Token budget:** ~20K tokens for aggregating data, drafting analysis, and cross-source comparisons.

## Implementation Approach

1. **Read existing source analyses** — examine AOSA/RealWorld/RefArch for format consistency
2. **Aggregate Discovered data** — parse 173 catalog YAMLs to compute:
   - Style distribution (count per style)
   - Language distribution (top 10 languages)
   - Pattern frequency (count per pattern)
   - Quality attribute prevalence (count per QA)
3. **Draft source-analysis.md** — following the format:
   - **Overview** — 173 repos, discovery methodology (filesystem signal extraction)
   - **Style Distribution** — table with counts per style
   - **Language Distribution** — table with top languages
   - **Pattern Frequency** — table with most common patterns
   - **Quality Attributes** — prevalence analysis
   - **Notable Insights** — 3-5 key findings (e.g., Pipeline/Event-Driven dominance)
   - **Cross-Source Comparison** — how Discovered differs from AOSA/RealWorld/RefArch
4. **Create directory structure** — `mkdir -p evidence-analysis/Discovered/docs/analysis/`
5. **Commit source analysis** — with descriptive message linking to EPIC-004

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-03 | 960504c | Initial creation for EPIC-004 implementation |
