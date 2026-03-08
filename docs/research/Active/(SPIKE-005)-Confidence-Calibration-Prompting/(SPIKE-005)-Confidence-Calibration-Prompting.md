---
title: "Confidence Calibration Prompting"
artifact: SPIKE-005
status: Active
author: cristos
created: 2026-03-08
last-updated: 2026-03-08
question: "Can we elicit meaningful, variable confidence scores from Gemini 3 Flash Preview instead of its current uniform 0.95, through revised prompting, structured scoring rubrics, or multi-dimensional confidence breakdowns?"
gate: "Pre-execution gate for SPEC-024 — confidence scores must be usable for QA triage"
risks-addressed:
  - "Gemini 3 Flash assigns uniform 0.95 confidence regardless of actual certainty — unusable for identifying entries needing QA"
  - "Without meaningful confidence variation, Opus QA pass cannot be targeted at genuinely uncertain entries"
  - "SPEC-024 workflow depends on confidence-based triage to control Opus costs"
depends-on:
  - SPIKE-004
linked-research:
  - SPEC-024
---

# Confidence Calibration Prompting

## Question

Can we elicit meaningful, variable confidence scores from Gemini 3 Flash Preview instead of its current uniform 0.95, through revised prompting, structured scoring rubrics, or multi-dimensional confidence breakdowns?

### Context

SPIKE-004 found that Gemini 3 Flash achieves perfect primary-style agreement (6/6) with the Sonnet baseline, making it the recommended primary model for SPEC-024. However, it assigns 0.95 confidence uniformly across all 6 repos — providing zero signal for QA triage.

The SPEC-024 workflow relies on confidence to route low-certainty entries to the Opus QA layer. Without variable confidence, every entry looks equally certain and the QA pass becomes either "run Opus on everything" (expensive) or "run Opus on nothing" (risky).

### Approaches to test

1. **Rubric-based scoring** — Instead of a single confidence number, ask the model to score on multiple dimensions (evidence strength, style ambiguity, completeness of exploration) and derive an aggregate score
2. **Calibration anchoring** — Provide examples of what 0.70, 0.80, 0.85, 0.90, and 0.95 confidence looks like in practice (e.g., "0.70 = two plausible primary styles, no discriminating evidence found")
3. **Forced ranking** — Ask the model to rank its certainty relative to other repos in the same batch, or to explicitly list what would change its classification
4. **Negative evidence prompting** — Ask "what evidence would change your classification?" and score confidence inversely to the plausibility of the counter-evidence
5. **Separate confidence pass** — Run classification first, then a second prompt asking just for confidence assessment given the reasoning

### Same 6 test repos

posthog, chatwoot, sentry, kafka, consul, grafana — same as SPIKE-003/004 for direct comparison.

## Go / No-Go Criteria

| Criterion | Threshold |
|-----------|-----------|
| At least one approach produces confidence range spanning >= 0.15 (e.g., 0.78-0.93) across the 6 repos | Minimum for meaningful triage |
| Confidence scores correlate with actual classification difficulty (grafana and consul should score lower than kafka and posthog) | Calibration validity |
| Approach does not degrade classification accuracy (still 5+/6 agreement with baseline) | No accuracy regression |
| Approach adds no more than one additional LLM call per entry | Cost-feasibility for 184 entries |

## Pivot Recommendation

If no prompting approach produces meaningful confidence variation from Gemini 3 Flash:
1. Use Sonnet or Opus (which naturally produce variable confidence) for a separate confidence-only pass after Gemini classifies
2. Derive confidence heuristically from the reasoning text (count hedging language, number of styles considered, evidence density)
3. Skip confidence-based triage and run Opus QA on a random sample instead

## Findings

**Verdict: NO-GO.** None of the three prompting approaches produced meaningful confidence variation from Gemini 3 Flash Preview. The model's confidence uniformity appears to be a fundamental behavioral trait, not a prompting deficiency.

### Baseline (SPIKE-004)

Gemini 3 Flash with the original prompt assigned 0.95 confidence to all 6 repos (spread = 0.00). Primary-style accuracy: 6/6 agreement with Sonnet baseline.

Sonnet baseline confidence for reference: posthog 0.90, chatwoot 0.82, sentry 0.90, kafka 0.92, consul 0.82, grafana 0.92 (spread = 0.10).

### Variant 1: Rubric-based scoring

Prompt asked the model to score three dimensions (evidence strength 0-1, style ambiguity 0-1, exploration completeness 0-1) then average them.

| Repo | Primary Style | Confidence | Evidence | Ambiguity | Completeness |
|------|--------------|------------|----------|-----------|--------------|
| posthog | Modular Monolith | 0.95 | 1.00 | 0.85 | 1.00 |
| chatwoot | Layered | 0.88 | 0.90 | 0.85 | 0.90 |
| sentry | Modular Monolith | 0.95 | 1.00 | 0.90 | 0.95 |
| kafka | Modular Monolith | 0.93 | 1.00 | 0.90 | 0.90 |
| consul | Modular Monolith | 0.93 | 0.95 | 0.90 | 0.95 |
| grafana | Microkernel (Plugin) | 0.93 | 0.95 | 0.90 | 0.95 |

- **Spread: 0.07** (0.88-0.95) -- below 0.15 threshold
- **Accuracy: 5/6** -- consul classified as Modular Monolith (baseline: Microkernel)
- **Difficulty correlation: Barely correct** (easy avg 0.940 vs hard avg 0.930, delta +0.010)
- The model maxed out evidence_strength at 1.0 for 3 repos and exploration_completeness at 1.0 for 1 repo, even after only 2 turns of exploration. The rubric's sub-dimensions did not produce the intended forcing function.

### Variant 2: Calibration anchoring

Prompt provided detailed anchor descriptions for each confidence range (0.65-0.70 through 0.93-0.97) with explicit instructions that 0.93+ should be rare and most repos warrant 0.80-0.88.

| Repo | Primary Style | Confidence |
|------|--------------|------------|
| posthog | Modular Monolith | 0.88 |
| chatwoot | Layered | 0.88 |
| sentry | Modular Monolith | 0.88 |
| kafka | Modular Monolith | 0.88 |
| consul | Modular Monolith | 0.92 |
| grafana | Microkernel (Plugin) | 0.88 |

- **Spread: 0.04** (0.88-0.92) -- below 0.15 threshold
- **Accuracy: 5/6** -- consul classified as Modular Monolith (baseline: Microkernel)
- **Difficulty correlation: Wrong** (easy avg 0.880 vs hard avg 0.900, delta -0.020)
- The model collapsed to the "most repositories fall in this range" anchor (0.83-0.87) and rounded up to 0.88 for 5 of 6 repos. The anchoring shifted the uniform value down from 0.95 to 0.88 but did not introduce variability. This is arguably worse than the baseline -- at least 0.95 was occasionally achievable as a true high-confidence signal.

### Variant 3: Negative evidence prompting

Prompt required the model to identify the strongest alternative style, describe what evidence would change its mind, rate the plausibility (low/medium/high), and derive confidence from that rating.

| Repo | Primary Style | Confidence | Alternative | Plausibility |
|------|--------------|------------|-------------|-------------|
| posthog | Modular Monolith | 0.88 | Microservices | medium |
| chatwoot | Layered | 0.92 | DDD | low |
| sentry | Modular Monolith | 0.88 | Microservices | low |
| kafka | Modular Monolith | 0.92 | Microservices | low |
| consul | Modular Monolith | 0.90 | Microservices | low |
| grafana | Microkernel (Plugin) | 0.92 | Microservices | low |

- **Spread: 0.04** (0.88-0.92) -- below 0.15 threshold
- **Accuracy: 5/6** -- consul classified as Modular Monolith (baseline: Microkernel)
- **Difficulty correlation: Wrong** (easy avg 0.900 vs hard avg 0.910, delta -0.010)
- The model rated counter-evidence plausibility as "low" for 5 of 6 repos, producing minimal variation. Only posthog received "medium" plausibility (for Microservices alternative), resulting in 0.88 instead of 0.92. The process did generate useful structured reasoning about alternatives, but the confidence scores remained tightly clustered.

### Summary

| Criterion | Rubric | Anchoring | Negative | Threshold |
|-----------|--------|-----------|----------|-----------|
| Confidence spread | 0.07 | 0.04 | 0.04 | >= 0.15 |
| Accuracy (vs baseline) | 5/6 | 5/6 | 5/6 | 5+/6 |
| Difficulty correlation | Barely | No | No | Yes |
| Extra LLM calls | 0 | 0 | 0 | <= 1 |

No variant meets the primary go/no-go criterion of >= 0.15 spread. All three shifted the uniform confidence value (from 0.95 down to 0.88-0.93) but did not introduce meaningful variability between repos. The model appears to treat confidence as a categorical rather than continuous signal.

All three variants also introduced a regression on consul (classified as Modular Monolith instead of Microkernel), which the baseline Gemini run correctly classified. This may be prompt-length related -- the longer confidence instructions may have displaced attention from classification.

### Recommendation

**Proceed with Pivot Option 2: Derive confidence heuristically from reasoning text.**

The Gemini reasoning prose does contain variable signals -- different numbers of alternative styles considered, different amounts of hedging language, different evidence density. A post-hoc text analysis pass (regex-based or lightweight LLM) could extract a synthetic confidence score from these signals without requiring Gemini to self-assess numerically.

Pivot Option 1 (Sonnet/Opus confidence pass) remains viable but adds per-entry cost. Pivot Option 3 (random QA sample) is the fallback if heuristic extraction also fails.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Planned | 2026-03-08 | — | Addresses Gemini confidence uniformity found in SPIKE-004 |
| Active | 2026-03-08 | — | Tested 3 prompt variants; NO-GO — recommend pivot to heuristic extraction |
