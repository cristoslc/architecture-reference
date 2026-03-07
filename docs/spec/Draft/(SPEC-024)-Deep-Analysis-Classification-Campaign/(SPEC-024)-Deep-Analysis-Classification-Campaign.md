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

SPEC-021 added 45 new catalog entries (30 applications, 15 ecosystem/other) that have only heuristic classification. Per ADR-002, heuristic classification is no longer a trusted classification source — deep-analysis via LLM source code inspection is the sole method. These entries must be deep-analyzed before SPEC-022 can recompute frequency rankings.

## External Behavior

**Input:** ~45 catalog entries with heuristic-only classification (no deep-validation).

**Tool selection (user chooses at scan start):**

| Option | Tool | Context |
|--------|------|---------|
| A | Claude Code subagents (Sonnet 4.6) | Interactive sessions |
| B | `llm` CLI | Batch runs, different model preference |

**Per-entry process:**
1. Clone the repository (or use existing clone from pipeline)
2. Assemble deep context: directory structure, key source files, config files, architecture docs, README
3. LLM analyzes source code and assigns architecture styles with rationale
4. Update catalog YAML with deep-validated classification

**Output:** ~45 catalog entries with deep-validated architecture style classifications, confidence scores, and classification rationale.

## Acceptance Criteria

1. All ~45 new entries have deep-analysis classification (no heuristic-only entries remain)
2. Each classification includes primary style, secondary styles, and brief rationale
3. Indeterminate rate for new entries drops below 10% (from current ~49% in applications)
4. Classification quality matches SPEC-019 standard (source-code-inspected, not signal-inferred)
5. Signal extraction data preserved as context input, not as classification source
6. Catalog YAML files updated in place with new classifications

## Scope & Constraints

- Only entries added in SPEC-021 (those without prior deep-validation)
- Existing SPEC-019 deep-validated entries are not re-analyzed
- Signal extraction remains for metadata (language, dependencies, infrastructure) per ADR-002
- Budget: ~45 LLM calls with full repo context, estimated 30-60 minutes

## Implementation Approach

1. Identify all catalog entries lacking deep-validation (heuristic-only or Indeterminate)
2. User selects analysis tool (Claude Code subagents or `llm` CLI)
3. For each entry: clone repo, assemble context, run deep-analysis, update catalog YAML
4. Batch in groups of 5-10 for manageable review
5. Verify Indeterminate rate and classification quality

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-07 | f2786ab4 | Initial creation per ADR-002 |
