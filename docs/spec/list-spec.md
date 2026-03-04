# Agent Specs

## Implemented

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| SPEC-001 | Architecture Discovery Skill | Analyze a local repo via filesystem signal extraction and heuristic+LLM classification, producing a YAML catalog entry and markdown summary compatible with the evidence base. | 2026-03-03 | f07312f |
| SPEC-002 | Dataset Scaling Pipeline | Batch-run discovery across curated repo manifests, validate output, and integrate 200+ entries into the evidence catalog. Depends on SPEC-001. | 2026-03-03 | d4fef8e |

## Draft

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| SPEC-003 | Comparative Analysis Engine | Compare a user's repo architecture against the expanded catalog, generating evidence-grounded comparison reports. Depends on SPEC-002. | 2026-03-03 | b63f031 |
| SPEC-004 | Pipeline Signal Preservation | Rerun the dataset scaling pipeline to preserve raw signal extraction data for all 173 Discovered repos, creating an audit trail for classification decisions. | 2026-03-03 | 960504c |
| SPEC-005 | Cross-Source Reference Library Rewrites | Rewrite 6 core reference library documents (~3,700 lines) to integrate evidence from all 5 sources using production-weighted methodology. | 2026-03-03 | 960504c |
| SPEC-006 | Discovered Source Analysis Creation | Create source-analysis.md for the Discovered evidence source, synthesizing aggregate characteristics of 173 repos for cross-source comparison. | 2026-03-03 | 960504c |
