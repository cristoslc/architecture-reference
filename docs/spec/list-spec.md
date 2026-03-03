# Agent Specs

## Implemented

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| SPEC-001 | Architecture Discovery Skill | Analyze a local repo via filesystem signal extraction and heuristic+LLM classification, producing a YAML catalog entry and markdown summary compatible with the evidence base. | 2026-03-03 | f07312f |

## Approved

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| SPEC-002 | Dataset Scaling Pipeline | Batch-run discovery across curated repo manifests, validate output, and integrate 200+ entries into the evidence catalog. Depends on SPEC-001. | 2026-03-03 | 6d61123 |

## Draft

| ID | Title | Summary | Last Updated | Commit |
|----|-------|---------|--------------|--------|
| SPEC-003 | Comparative Analysis Engine | Compare a user's repo architecture against the expanded catalog, generating evidence-grounded comparison reports. Depends on SPEC-002. | 2026-03-03 | b63f031 |
