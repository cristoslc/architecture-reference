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

## Active

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| SPEC-006 | Problem-Spaces Cross-Source Rewrite | Rewrite problem-spaces.md (1500+ lines) to classify problems from all 5 sources, expanding KataLog-only profiles to cross-source system profiles. | 2026-03-04 | ec39055 |
| SPEC-007 | Solution-Spaces Cross-Source Rewrite | Rewrite solution-spaces.md (528 lines) with production-weighted scoring methodology (20 pts per production system vs 1-4 pts per KataLog placement). | 2026-03-04 | ec39055 |

## Draft

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| SPEC-003 | Comparative Analysis Engine | Compare a user's repo architecture against the expanded catalog, generating evidence-grounded comparison reports. Depends on SPEC-002. | 2026-03-03 | b63f031 |
| SPEC-008 | Evidence Cross-Source Update | Rewrite evidence/by-architecture-style.md and evidence/by-quality-attribute.md (1025 lines) with cross-source evidence tables. | 2026-03-03 | 1032e4b |
| SPEC-009 | Synthesis Cross-Source Update | Rewrite problem-solution-matrix.md and decision-navigator.md (662 lines) with production-system evidence in all cells and paths. | 2026-03-03 | 1032e4b |
