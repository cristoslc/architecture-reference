# Epics

## Proposed

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| EPIC-006 | Deep-Context Classification Validation | Re-validate all catalog classifications by cloning repos and feeding deep context (source files, configs, architecture docs) to the LLM. Produces verification verdicts, override rules, and expanded gold standard. | 2026-03-04 | — |

## Active

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| EPIC-003 | Architecture Discovery and Scaling | Build automated discovery tooling to classify architecture patterns from repos, then scale the evidence base from 62 to 200+ projects with comparative analysis. | 2026-03-03 | b63f031 |
| EPIC-008 | Service-Based Architecture Detection | Fix the two largest detection blind spots in the Discovered pipeline: Service-Based Architecture (4 detected vs. 23 expected) and Plugin/Microkernel (0 detected vs. 6+ production-validated). New signals, improved scorers, conflict resolution, and re-classification. | 2026-03-05 | a0bcc15 |

## Complete

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| EPIC-001 | Dataset Expansion and Evidence Enrichment | Expanded the evidence base from 1 source (78 Kata submissions) to 4 sources (62 cataloged projects) with cross-source analysis. | 2026-03-03 | f0ae265 |
| EPIC-002 | Architecture Advisor Skill | Built a remote-installable agent skill exposing the evidence library as an AI-consumable capability, with sparse-clone data fetching, progressive disclosure, and smoke tests. | 2026-03-03 | 3bc4437 |
| EPIC-004 | Cross-Source Reference Library Integration | Rewrite 6 core reference library documents to synthesize evidence from all 5 sources (276 entries) instead of reflecting only KataLog competition data. Cross-source integration complete; remaining specs superseded by EPIC-007. | 2026-03-05 | fdc0ef9 |
| EPIC-005 | LLM Classification Pipeline | Automates Pass 2 LLM review of 120 Indeterminate catalog entries via multi-turn llm CLI pipeline with structured escalation. | 2026-03-04 | 707de32 |
| EPIC-007 | Discovered-First Evidence Hierarchy | Restructured all 6 reference library documents to lead with Discovered corpus statistical analysis as primary evidence. KataLog demoted to supplementary qualitative evidence. | 2026-03-05 | fdc0ef9 |
