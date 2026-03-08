---
title: "Deep-Analysis Classification Campaign"
artifact: SPEC-024
status: Draft
author: cristos
created: 2026-03-07
last-updated: 2026-03-07
parent-epic: EPIC-012
depends-on:
  - SPEC-021
linked-adrs:
  - ADR-002
execution-tracking: required
---

# Deep-Analysis Classification Campaign

## Problem Statement

All 184 catalog entries require clean-slate deep-analysis classification. The previous SPEC-019 deep-validation was an anchored process — it showed the LLM the heuristic classification and asked it to verify or correct, introducing anchoring bias. Per ADR-002, deep-analysis is the sole classification method and must be performed independently, without prior classifications in the prompt.

All existing analysis has been stripped from the catalog. Every entry now has `architecture_styles: []` and `classification_status: pending`.

## External Behavior

**Input:** 184 catalog entries with no classification (clean slate).

**Tool selection (user chooses at scan start):**

| Option | Tool | Context |
|--------|------|---------|
| A | Claude Code subagents (Sonnet 4.6) | Interactive sessions |
| B | `llm` CLI | Batch runs, different model preference |

**Per-entry process:**
1. Clone the repository (shallow clone, cached)
2. Assemble deep context: directory structure (depth 4), key source files, config files (docker-compose, k8s, serverless, terraform), architecture docs, README
3. LLM analyzes source code from scratch — no prior classification in the prompt
4. Update catalog YAML with classification, rationale, and confidence

**Output:** 184 catalog entries with independent deep-analysis architecture style classifications, confidence scores, and classification rationale.

## Acceptance Criteria

1. All 184 entries have deep-analysis classification (`classification_status: classified`, no `pending` entries remain)
2. Each classification includes primary style, secondary styles (if applicable), confidence score, and brief rationale citing specific source code evidence
3. Indeterminate rate below 10% catalog-wide
4. No prior classification shown in the analysis prompt (clean-slate, no anchoring)
5. Catalog YAML files updated in place with new classifications
6. Classification method recorded as `deep-analysis` (not `deep-validation`)

## Scope & Constraints

- All 184 catalog entries — no exceptions, no grandfathering of prior analysis
- Clean-slate prompts only — the LLM sees repo context, not prior classifications
- Signal extraction metadata (language, domain) retained as catalog identity, not as classification input
- Budget: 184 LLM calls with full repo context

## Implementation Approach

1. All 184 entries start as `classification_status: pending`
2. User selects analysis tool (Claude Code subagents or `llm` CLI)
3. For each entry: clone repo, assemble context, run clean-slate deep-analysis, update catalog YAML
4. Batch in groups of 10-15 for manageable review
5. Mark each completed entry `classification_status: classified`
6. Verify Indeterminate rate and classification quality after each batch

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-07 | f2786ab4 | Initial creation per ADR-002 |
