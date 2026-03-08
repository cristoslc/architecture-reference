---
title: "Final Model Validation"
artifact: SPIKE-007
status: Planned
author: cristos
created: 2026-03-08
last-updated: 2026-03-08
question: "After applying SPIKE-005 confidence calibration and SPIKE-006 reliability improvements, do the revised prompts and tooling maintain or improve SPIKE-004 accuracy, and which model+configuration is the final recommendation for SPEC-024?"
gate: "Final gate for SPEC-024 — confirms production-ready model configuration"
risks-addressed:
  - "SPIKE-005/006 prompt changes may regress classification accuracy while fixing confidence/reliability"
  - "Confidence calibration improvements may not survive at scale (6 repos vs 184)"
  - "Final model recommendation must account for accuracy, confidence calibration, reliability, and cost together — not in isolation"
depends-on:
  - SPIKE-005
  - SPIKE-006
linked-research:
  - SPEC-024
  - SPIKE-004
---

# Final Model Validation

## Question

After applying SPIKE-005 confidence calibration and SPIKE-006 reliability improvements, do the revised prompts and tooling maintain or improve SPIKE-004 accuracy, and which model+configuration is the final recommendation for SPEC-024?

### Context

SPIKE-004 established the baseline: Gemini 3 Flash achieves 6/6 primary-style agreement with Sonnet via multi-turn `llm` CLI, but assigns uniform 0.95 confidence. GLM-5 achieves 4/5 but fails on sentry due to malformed YAML. Opus produces the deepest reasoning but costs significantly more.

SPIKE-005 and SPIKE-006 address the two gaps — confidence calibration and reliability. This spike reruns the same 6-repo evaluation with the improved prompts/tooling and compares directly against SPIKE-004 to confirm no regressions and validate the improvements work together.

### What this spike tests

1. **Gemini 3 Flash with SPIKE-005 confidence prompt** — Does accuracy hold at 6/6? Does confidence now vary meaningfully?
2. **GLM-5 with SPIKE-006 reliability fixes** — Does it now complete 6/6? Does accuracy match or exceed SPIKE-004's 4/5?
3. **All models with any tooling changes from SPIKE-006** — If the multi-turn loop changed (native tool-calling, retry logic), revalidate all 4 `llm` CLI models
4. **Head-to-head comparison** — SPIKE-004 results vs SPIKE-007 results on same repos, same baseline

### Evaluation dimensions

Same as SPIKE-004, plus:
- **Confidence variation** — range, correlation with difficulty, usefulness for QA triage
- **Reliability improvement** — failure rate reduction from SPIKE-004

## Go / No-Go Criteria

| Criterion | Threshold |
|-----------|-----------|
| Gemini 3 Flash maintains 5+/6 accuracy with revised prompt | No accuracy regression |
| Gemini 3 Flash confidence range >= 0.15 across 6 repos | SPIKE-005 improvement validated |
| GLM-5 completes 6/6 with revised prompt/tooling | SPIKE-006 improvement validated |
| All `llm` CLI models maintain or improve SPIKE-004 agreement scores | No collateral regression |
| Final recommendation identifies a single primary model+configuration for SPEC-024 | Actionable output |

## Pivot Recommendation

If accuracy regresses:
1. Roll back to SPIKE-004 prompts for the affected model and accept the confidence/reliability limitations
2. Use a two-prompt strategy: SPIKE-004 prompt for classification, SPIKE-005 prompt for confidence-only assessment
3. If no single model meets all criteria, recommend a model-per-dimension approach (Gemini for accuracy, Sonnet/Opus for confidence)

## Findings

*To be populated during Active phase.*

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Planned | 2026-03-08 | — | Final validation gate after SPIKE-005 + SPIKE-006 improvements |
