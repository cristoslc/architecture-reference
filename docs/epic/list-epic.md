# Epics

## Proposed

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| EPIC-011 | Platform-Aware Architecture Advising | Enhance the architecture-advisor skill to detect whether the user's context is platform/ecosystem-centric or application-centric, and tailor guidance, trade-off analysis, and style recommendations accordingly. | 2026-03-06 | — |

## Active

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| EPIC-003 | Architecture Discovery and Scaling | Build automated discovery tooling to classify architecture patterns from repos, then scale the evidence base from 62 to 200+ projects with comparative analysis. | 2026-03-03 | b63f031 |
| EPIC-013 | ADR-005 Pipeline Unification | Implement ADR-005: make the discover skill the single specification for all pipeline classification. SPEC-031 implemented; 3 child specs remain. | 2026-03-11 | — |

## Complete

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| EPIC-001 | Dataset Expansion and Evidence Enrichment | Expanded the evidence base from 1 source (78 Kata submissions) to 4 sources (62 cataloged projects) with cross-source analysis. | 2026-03-03 | f0ae265 |
| EPIC-002 | Architecture Advisor Skill | Built a remote-installable agent skill exposing the evidence library as an AI-consumable capability, with sparse-clone data fetching, progressive disclosure, and smoke tests. | 2026-03-03 | 3bc4437 |
| EPIC-004 | Cross-Source Reference Library Integration | Rewrite 6 core reference library documents to synthesize evidence from all 5 sources (276 entries) instead of reflecting only KataLog competition data. Cross-source integration complete; remaining specs superseded by EPIC-007. | 2026-03-05 | fdc0ef9 |
| EPIC-005 | LLM Classification Pipeline | Automates Pass 2 LLM review of 120 Indeterminate catalog entries via multi-turn llm CLI pipeline with structured escalation. | 2026-03-04 | 707de32 |
| EPIC-007 | Discovered-First Evidence Hierarchy | Restructured all 6 reference library documents to lead with Discovered corpus statistical analysis as primary evidence. KataLog demoted to supplementary qualitative evidence. | 2026-03-05 | fdc0ef9 |
| EPIC-006 | Deep-Context Classification Validation | Re-validate all catalog classifications by cloning repos and feeding deep context (source files, configs, architecture docs) to the LLM. SPEC-013/019 Implemented, SPEC-014/015/016 Abandoned per ADR-002. Superseded by SPEC-024 clean-slate campaign. | 2026-03-08 | 30f1cca3 |
| EPIC-008 | Service-Based Architecture Detection | Fix the two largest detection blind spots in the Discovered pipeline: Service-Based Architecture (4 detected vs. 23 expected) and Plugin/Microkernel (0 detected vs. 6+ production-validated). New signals, improved scorers, conflict resolution, and re-classification. | 2026-03-06 | 2dee9a7 |
| EPIC-010 | Ecosystem-Level Architecture Classification | Extend the catalog to capture cross-repo architectural patterns (ELK stack, *arr media stack, Grafana LGTM, etc.) that are invisible at the single-repo level. Curate 10+ ecosystems, add missing member repos, define ecosystem entry format. | 2026-03-10 | 0a9373bc |
| EPIC-012 | Catalog Rebalancing and Application Expansion | Removed 43 library/non-software entries, tagged all entries with scope/use-type taxonomy (ADR-001), added 30+ production applications to fix 3.4:1→1.58:1 platform-to-application skew, recomputed production-only rankings. | 2026-03-10 | 13ed381c |

## Abandoned

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| EPIC-009 | Heuristic Pipeline Improvements | Improve the heuristic classification pipeline based on SPEC-019 findings: add 9 missing style detectors, fix Microservices/Service-Based false positives, add library detection, improve confidence calibration. Target: 60%+ agreement with deep-validation (currently 14.7%). Obsolete per ADR-002. | 2026-03-07 | — |
