---
title: "Deep-Analysis Classification Campaign"
artifact: SPEC-024
status: Implemented
author: cristos
created: 2026-03-07
last-updated: 2026-03-08
parent-epic: EPIC-012
depends-on:
  - SPEC-021
  - SPIKE-003
  - SPIKE-004
  - SPIKE-007
linked-adrs:
  - ADR-002
  - ADR-003
linked-research:
  - SPIKE-003
  - SPIKE-004
  - SPIKE-005
  - SPIKE-006
  - SPIKE-007
execution-tracking: required
---

# Deep-Analysis Classification Campaign

## Problem Statement

All 184 catalog entries require clean-slate deep-analysis classification. The previous SPEC-019 deep-validation was an anchored process — it showed the LLM the heuristic classification and asked it to verify or correct, introducing anchoring bias. Per ADR-002, deep-analysis is the sole classification method and must be performed independently, without prior classifications in the prompt.

All existing analysis has been stripped from the catalog. Every entry now has `architecture_styles: []` and `classification_status: pending`.

## External Behavior

**Input:** 184 catalog entries with no classification (clean slate).

**Tool selection (per SPIKE-004 findings):**

| Tier | Tool | Model | When |
|------|------|-------|------|
| Primary | `llm` CLI multi-turn | Gemini 3 Flash Preview | Batch classification — 6/6 baseline agreement, fastest, cheapest |
| QA | Claude Code subagent | Opus 4.6 | Spot-check low-confidence entries — deepest reasoning, finds signals others miss |
| Fallback | Claude Code subagent | Sonnet 4.6 | If `llm` CLI has reliability issues at scale — proven SPIKE-003 baseline |

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
7. Actual classification method is `deep-analysis-tooluse` (GLM-5) and `deep-analysis-subagent` (Sonnet 4.6 fallback) rather than the originally planned Gemini Flash approach — ADR-003 and SPIKE-008 redirected the tool selection

## Catalog YAML output format

Each classified entry will include these fields (per SPIKE-003 findings):

```yaml
architecture_styles:
  - <primary style>
  - <secondary style(s)>
classification_status: classified
classification_method: deep-analysis
classification_confidence: 0.85
classification_model: google/gemini-3-flash-preview
classification_date: '2026-03-07T12:00:00Z'
classification_reasoning: |
  <Full LLM reasoning text citing specific source code evidence.
  References file paths, directory structures, config files,
  and architectural patterns. Explains WHY each style applies.>
```

Fields:
- `architecture_styles` — ordered list, primary first. From the 14-style taxonomy.
- `classification_method` — always `deep-analysis` per ADR-002.
- `classification_confidence` — 0.0-1.0, model's self-assessed certainty.
- `classification_model` — model identifier used for this analysis.
- `classification_date` — ISO 8601 timestamp of the analysis.
- `classification_reasoning` — full reasoning preserved, not just results. Must cite specific file paths, directory structures, or code patterns as evidence.

## Scope & Constraints

- All 184 catalog entries — no exceptions, no grandfathering of prior analysis
- Clean-slate prompts only — the LLM sees repo context, not prior classifications
- Signal extraction metadata (language, domain) retained as catalog identity, not as classification input
- Budget: 184 LLM calls with full repo context

## Implementation Approach

1. All 184 entries start as `classification_status: pending`
2. Primary pass: Gemini 3 Flash via `llm` CLI with multi-turn SPEC-011 escalation (model requests files/trees/globs/greps from cloned repos)
3. For each entry: clone repo, assemble context, run clean-slate deep-analysis, update catalog YAML
4. Batch in groups of 10-15 for manageable review
5. Mark each completed entry `classification_status: classified`
6. QA pass: run Opus 4.6 subagent on entries with confidence below 0.80 or where Gemini assigned uniform 0.95 confidence — its deeper reasoning catches edge cases
7. Verify Indeterminate rate and classification quality after each batch

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-07 | f2786ab4 | Initial creation per ADR-002 |
| Implemented | 2026-03-08 | cdfd4ea7 | All 184 entries classified: 173 GLM-5 native tool-calling + 11 Sonnet subagent fallback |
