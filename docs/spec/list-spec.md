# Agent Specs

## Implemented

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| SPEC-001 | Architecture Discovery Skill | Analyze a local repo via filesystem signal extraction and heuristic+LLM classification, producing a YAML catalog entry and markdown summary compatible with the evidence base. | 2026-03-03 | f07312f |
| SPEC-002 | Dataset Scaling Pipeline | Batch-run discovery across curated repo manifests, validate output, and integrate 200+ entries into the evidence catalog. Depends on SPEC-001. | 2026-03-03 | d4fef8e |
| SPEC-004 | Pipeline Signal Preservation | Rerun the dataset scaling pipeline to preserve raw signal extraction data for all 173 Discovered repos, creating an audit trail for classification decisions. | 2026-03-04 | 448deab |
| SPEC-005 | Discovered Source Analysis | Create source-analysis.md for the Discovered evidence source (173 repos), synthesizing architecture style distribution, QA priorities, and key findings. | 2026-03-04 | 10a003c |
| SPEC-010 | LLM Review Script | Core llm-review.sh script for automating Pass 2 LLM classification — system prompt, context assembly, response parsing, tier filtering. | 2026-03-04 | 707de32 |
| SPEC-011 | Multi-Turn Escalation Protocol | Structured info requests (file/tree/glob/grep), fulfillment logic, and conversation management for multi-turn LLM classification. | 2026-03-04 | 707de32 |
| SPEC-012 | Quality Validation | Gold standard curation, accuracy measurement (>=85%), confusion matrix, confidence calibration, and regression testing for LLM classifications. | 2026-03-04 | 707de32 |
| SPEC-013 | Deep-Context Validation Script | Re-run classification with cloned repos and deep context assembly (config files, source structure, architecture docs). Produces verification verdicts per entry. | 2026-03-05 | 761b204 |
| SPEC-017 | Pipeline Re-extraction and Re-classification | Re-run signal extraction on all 163 Discovered repos with new SBA/Plugin signals, full re-classify, produce comparison report. | 2026-03-06 | beb158f |
| SPEC-018 | Reference Library Statistics Update | Propagate deep-validated statistics from SPEC-019 into all 8 reference library and cross-source documents. | 2026-03-06 | 1467f16 |
| SPEC-019 | Deep-Context Re-validation Campaign | Re-run deep-context validation on all 163 repos post-SPEC-017, resolving 30 regressions and validating 41 new entries. Uses Claude Code subagents with Opus. | 2026-03-06 | beb158f |
| SPEC-020 | Catalog Cleanup and Taxonomy Tagging | Remove 43 library/framework/non-software entries, add scope and use_type taxonomy fields to all remaining 120 entries per ADR-001. | 2026-03-06 | ff77e90 |
| SPEC-021 | Catalog Expansion and Ecosystem Completion | Expand catalog with 30 applications across 10 domains, 19 ecosystem entries, triage 20 uncataloged repos. Production ratio 1.58:1. | 2026-03-07 | f64b466a |
| SPEC-022 | Pipeline Run and Frequency Recomputation | Recompute production-only frequency rankings with deep-analysis data, platform/application splits, normalized style names. | 2026-03-09 | dba13449 |
| SPEC-023 | Reference Library Rebalancing Update | Update all 8 reference library documents with production-only rankings and platform/application splits. Depends on SPEC-022. | 2026-03-10 | 13ed381c |
| SPEC-024 | Deep-Analysis Classification Campaign | All 184 catalog entries classified via clean-slate deep-analysis: 173 GLM-5 native tool-calling + 11 Sonnet subagent fallback. | 2026-03-08 | cdfd4ea7 |
| SPEC-025 | Ecosystem Catalog Schema | Ecosystem entry format + architecture_qualifiers + style-taxonomy.yaml. Foundation for EPIC-010. | 2026-03-10 | 7b733d0b |
| SPEC-026 | Ecosystem Curation | Curate 10+ ecosystems, add missing member repos, deep-validate emergent architecture. Depends on SPEC-025. | 2026-03-10 | 50b19d24 |
| SPEC-027 | Ecosystem Validation and Reporting | Validation, quality report, frequency analysis, and index updates for ecosystem entries. Pipeline classification mechanics deferred to ADR-005. Depends on SPEC-025. | 2026-03-10 | ddab6b42 |
| SPEC-028 | Reference Library Ecosystem Integration | Update reference docs with ecosystem evidence alongside single-repo evidence. Depends on SPEC-026, SPEC-027. | 2026-03-10 | 89b29a7c |

## Active

(No active specs.)

## Draft

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| SPEC-003 | Comparative Analysis Engine | Compare a user's repo architecture against the expanded catalog, generating evidence-grounded comparison reports. Depends on SPEC-002, ADR-005. | 2026-03-10 | — |
| SPEC-029 | Catalog Entry Schema Validation | Validate catalog-entry.template.j2 against SPEC-003 requirements, create machine-readable schema, test dual output. Parent: EPIC-013. | 2026-03-10 | — |
| SPEC-030 | Pipeline Runtime Prompt Assembly | Refactor classify-tooluse.sh to read discover skill files at runtime instead of standalone prompts. Depends on SPEC-029. Parent: EPIC-013. | 2026-03-10 | — |
| SPEC-031 | Full Catalog Reclassification | Reclassify all 184+ entries via ADR-005-compliant pipeline, produce dual output (report + catalog entry). Depends on SPEC-029, SPEC-030. Parent: EPIC-013. | 2026-03-10 | — |
| SPEC-032 | Legacy Pipeline Retirement | Remove deprecated prompts, parsers, and scripts per ADR-002/003/005. Depends on SPEC-030. Parent: EPIC-013. | 2026-03-10 | — |

## Abandoned

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| SPEC-006 | Problem-Spaces Cross-Source Rewrite | Rewrite problem-spaces.md (1500+ lines) to classify problems from all 5 sources. Superseded by EPIC-007 restructuring + SPEC-018 statistics update. | 2026-03-05 | fdc0ef9 |
| SPEC-007 | Solution-Spaces Cross-Source Rewrite | Rewrite solution-spaces.md (528 lines) with production-weighted scoring. Superseded by EPIC-007 restructuring + SPEC-018 statistics update. | 2026-03-05 | fdc0ef9 |
| SPEC-008 | Evidence Cross-Source Update | Rewrite evidence/by-architecture-style.md and evidence/by-quality-attribute.md with cross-source evidence tables. Superseded by EPIC-007 restructuring + SPEC-018 statistics update. | 2026-03-05 | fdc0ef9 |
| SPEC-009 | Synthesis Cross-Source Update | Rewrite problem-solution-matrix.md and decision-navigator.md with production-system evidence. Superseded by EPIC-007 restructuring + SPEC-018 statistics update. | 2026-03-05 | fdc0ef9 |
| SPEC-014 | Override Rules & Disagreement Report | Deterministic rules for when to accept deep-validation results over existing classifications, plus disagreement markdown report. Obsolete per ADR-002. | 2026-03-07 | — |
| SPEC-015 | Expanded Gold Standard & Three-Way Report | Expand gold standard from 17 to 40+ entries; three-way comparison across heuristic, llm-review, and deep-validation methods. Obsolete per ADR-002. | 2026-03-07 | — |
| SPEC-016 | Validation Run Execution | Operational run plan for deep-context validation across all four priority populations, with gate criteria, pilot run, and post-run review checklists. Obsolete per ADR-002. | 2026-03-07 | — |
