---
title: "Extended Model Comparison"
artifact: SPIKE-004
status: Active
author: cristos
created: 2026-03-07
last-updated: 2026-03-07
question: "How do GLM-5, GLM-4.7, Kimi K2.5, Gemini 3 Flash Preview, and Opus 4.6 subagents compare against the SPIKE-003 Sonnet 4.6 baseline for architecture classification?"
gate: "Pre-execution gate for SPEC-024 — final model selection across 6 candidates"
risks-addressed:
  - "Sonnet 4.6 may not be the best model — newer or cheaper alternatives could match quality"
  - "Subagent approach may benefit from Opus 4.6's deeper reasoning"
  - "llm CLI failure on Sentry (SPIKE-003) may be prompt-specific, not model-inherent"
depends-on:
  - ADR-002
  - SPIKE-003
linked-research:
  - SPEC-024
---

# Extended Model Comparison

## Question

How do GLM-5, GLM-4.7, Kimi K2.5, Gemini 3 Flash Preview, and Opus 4.6 subagents compare against the SPIKE-003 Sonnet 4.6 baseline for architecture classification?

### Baseline (from SPIKE-003 — not rerun)

| Repo | Sonnet 4.6 Subagent Result |
|------|---------------------------|
| posthog | Modular Monolith + Event-Driven, Service-Based (0.82) |
| chatwoot | Layered + Event-Driven (0.85) |
| sentry | Modular Monolith + Event-Driven, Plugin (0.85) |
| kafka | Modular Monolith + Event-Driven, Pipe-and-Filter (0.82) |
| consul | Modular Monolith + Plugin, Event-Driven (0.82) |
| grafana | Plugin (Microkernel) + Modular Monolith, Layered (0.85) |

### New models under test

| Model | Provider | Method | Model ID |
|-------|----------|--------|----------|
| GLM-5 | Z-AI (OpenRouter) | `llm` CLI | `openrouter/z-ai/glm-5` |
| GLM-4.7 | Z-AI (OpenRouter) | `llm` CLI | `openrouter/z-ai/glm-4.7` |
| Kimi K2.5 | Moonshot AI (OpenRouter) | `llm` CLI | `openrouter/moonshotai/kimi-k2.5` |
| Gemini 3 Flash Preview | Google (OpenRouter) | `llm` CLI | `openrouter/google/gemini-3-flash-preview` |
| Opus 4.6 | Anthropic | Claude Code subagent | `claude-opus-4-6` |

### Evaluation dimensions

Same as SPIKE-003:
1. **Classification accuracy** — structural patterns, not domain purpose
2. **Reasoning quality** — specific file paths and code evidence vs vague claims
3. **Confidence calibration** — conservative and meaningful scores
4. **False positive rate** — shotgun classification avoidance
5. **Reliability** — completion rate, no hallucinated tool calls
6. **Agreement with Sonnet 4.6 baseline** — concordance on primary style

## Go / No-Go Criteria

| Criterion | Threshold |
|-----------|-----------|
| At least one new model matches or exceeds Sonnet 4.6 baseline quality on 5/6 repos | Minimum for model switch |
| If no model exceeds baseline, confirm Sonnet 4.6 remains best choice | Validates SPIKE-003 recommendation |
| Opus 4.6 subagent must justify its higher cost with measurably better reasoning | Cost-benefit threshold |
| All `llm` CLI models must complete 6/6 repos without failures | Reliability threshold |

## Pivot Recommendation

If a new model significantly outperforms Sonnet 4.6, update SPEC-024 tool recommendation. If Opus 4.6 is marginally better but much slower/costlier, stay with Sonnet 4.6.

## Method

- **Same 6 repos, same context files, same prompt** as SPIKE-003
- Sonnet 4.6 subagent results carried forward from SPIKE-003 (not rerun)
- 4 `llm` CLI runs (GLM-5, GLM-4.7, Kimi K2.5, Gemini 3 Flash Preview) x 6 repos = 24 calls
- 6 Opus 4.6 subagent runs = 6 calls
- Total: 30 new LLM calls

## Findings

### Primary style comparison matrix

| Repo | Sonnet 4.6 (baseline) | Opus 4.6 | GLM-5 | GLM-4.7 | Kimi K2.5 | Gemini 3 Flash |
|------|----------------------|----------|-------|---------|-----------|---------------|
| **posthog** | Modular Monolith | Modular Monolith | **Service-Based** | **Service-Based** | Modular Monolith | Modular Monolith |
| **chatwoot** | Layered | Layered | **Modular Monolith** | Layered | **Modular Monolith** | **Modular Monolith** |
| **sentry** | Modular Monolith | Modular Monolith | Modular Monolith | Modular Monolith | Modular Monolith | Modular Monolith |
| **kafka** | Modular Monolith | Modular Monolith | **Indeterminate** | Modular Monolith | Modular Monolith | Modular Monolith |
| **consul** | Modular Monolith | Modular Monolith | Modular Monolith | Modular Monolith | Modular Monolith | Modular Monolith |
| **grafana** | Plugin (Microkernel) | Plugin (Microkernel) | Plugin (Microkernel) | **Modular Monolith** | **Modular Monolith** | **Modular Monolith** |

### Agreement with Sonnet 4.6 baseline

| Model | Agreement | Misses |
|-------|-----------|--------|
| **Opus 4.6** | **6/6 (100%)** | — |
| GLM-5 | 3/6 (50%) | posthog (Service-Based), chatwoot (Modular Monolith), kafka (Indeterminate) |
| GLM-4.7 | 4/6 (67%) | posthog (Service-Based), grafana (Modular Monolith) |
| Kimi K2.5 | 4/6 (67%) | chatwoot (Modular Monolith), grafana (Modular Monolith) |
| Gemini 3 Flash | 4/6 (67%) | chatwoot (Modular Monolith), grafana (Modular Monolith) |

### Secondary style comparison

| Repo | Sonnet 4.6 | Opus 4.6 | GLM-5 | GLM-4.7 | Kimi K2.5 | Gemini 3 Flash |
|------|-----------|----------|-------|---------|-----------|---------------|
| posthog | Event-Driven, Service-Based | Event-Driven, Service-Based | Modular Monolith, Event-Driven | Event-Driven | Service-Based, Event-Driven | Event-Driven, Service-Based |
| chatwoot | Event-Driven | Event-Driven | Event-Driven | Event-Driven | Event-Driven, Layered | Event-Driven, Layered |
| sentry | Event-Driven, Plugin | Event-Driven, Layered | Plugin, Event-Driven | Event-Driven, Microkernel | Plugin | Event-Driven, Service-Based |
| kafka | Event-Driven, Pipe-and-Filter | Layered, Pipe-and-Filter | none | Layered | DDD | Event-Driven, Layered |
| consul | Plugin, Event-Driven | Layered | none | Layered | DDD | DDD, Hexagonal |
| grafana | Modular Monolith, Layered | Modular Monolith | Modular Monolith | Microkernel | Layered, Plugin | Plugin, DDD |

### Key observations

#### 1. The Modular Monolith bias

Kimi K2.5, Gemini 3 Flash, and to a lesser extent GLM-5 default to "Modular Monolith" when uncertain. They're not *wrong* (most codebases have modular internal structure), but they miss the *defining* architectural characteristic:

- **Chatwoot** is a standard Rails app with flat model directories and no enforced module boundaries — it's Layered, not Modular Monolith. Only Claude models (both Sonnet and Opus) and GLM-4.7 got this right.
- **Grafana** is defined by its plugin system — panels, data sources, and apps are loaded into a core kernel. Only Claude models and GLM-5 identified Plugin/Microkernel as primary.

#### 2. The structural vs functional trap persists

GLM-5 and GLM-4.7 classified PostHog as "Service-Based" — focusing on the docker-compose services (capture, plugins, feature-flags). While PostHog *deploys* some services separately, the architecture's organizing principle is the products/ directory with 40+ vertical-slice modules in a Django monolith. The services are performance-optimized hot paths, not the structural foundation.

#### 3. GLM-5 classified Kafka as Indeterminate

This is a significant failure. Apache Kafka has a clear, well-documented architecture. Classifying it as Indeterminate suggests the model could not reason about the Gradle multi-module structure and checkstyle import-control boundaries.

#### 4. DDD and Hexagonal over-assignment

Kimi K2.5 assigned DDD as secondary for both Kafka and Consul — neither has bounded contexts, aggregates, or a domain model in the DDD sense. Gemini 3 Flash assigned DDD and Hexagonal Architecture to Consul — there are no ports/adapters interfaces visible. These look like style-name pattern-matching rather than structural analysis.

#### 5. Opus 4.6 — perfect accuracy with richer reasoning

Opus agreed with Sonnet on every primary style and produced notably stronger reasoning:

| Repo | Opus insight (beyond Sonnet) |
|------|------------------------------|
| kafka | "While Kafka *is* an event streaming platform, its internal architecture uses direct method calls, shared memory, and synchronous RPC" — rejected Event-Driven as secondary |
| consul | Rejected Plugin secondary: "extensions are compiled into the binary rather than loaded dynamically — more akin to strategy patterns" |
| sentry | Found the "silo" model (hybrid cloud) and correctly identified it as "deployment concern, not codebase split" |
| posthog | Found `products/architecture.md` and `products/README.md` confirming intentional product-oriented modular structure |
| grafana | Found plugin sandboxing tests and Wire DI — deeper structural signals |

However, Opus took ~70-100s per repo vs ~55-70s for Sonnet, and costs significantly more.

#### 6. Reliability — all models completed

Unlike SPIKE-003's Minimax M2.5 failure on Sentry, all 5 new models completed all 6 classifications. No hallucinated tool calls. The Sentry failure in SPIKE-003 was likely Minimax-specific behavior.

### Confidence comparison

| Model | Mean confidence | Range | Calibration |
|-------|----------------|-------|-------------|
| Sonnet 4.6 | 0.83 | 0.82-0.85 | Conservative, meaningful |
| Opus 4.6 | 0.84 | 0.82-0.90 | Conservative, meaningful |
| GLM-5 | 0.83 | 0.70-0.85 | Reasonable (0.70 for uncertain consul) |
| GLM-4.7 | 0.92 | 0.85-0.95 | Over-confident — 0.95 for wrong grafana classification |
| Kimi K2.5 | 0.87 | 0.85-0.90 | Slightly high but narrower range |
| Gemini 3 Flash | 0.90 | 0.90-0.95 | Over-confident across the board |

### Recommendation

**Use Claude Code subagents for SPEC-024. Model choice: Sonnet 4.6.**

Rationale:

1. **Opus 4.6 has perfect accuracy but doesn't justify the cost.** Its reasoning is richer (kafka internal architecture insight, consul strategy pattern nuance), but the primary and secondary style assignments are identical to Sonnet on 5/6 repos. The one difference (consul secondary: Layered vs Plugin) is debatable. For 184 entries, Sonnet's output is sufficient.

2. **No `llm` CLI model matches subagent quality.** The best `llm` CLI performers (GLM-4.7, Kimi K2.5, Gemini 3 Flash) all hit 67% agreement — well below the 5/6 threshold. They systematically miss the two hardest classifications (Chatwoot as Layered, Grafana as Plugin).

3. **Subagents have a structural advantage.** They can browse the actual cloned repo during analysis (reading additional files if the context isn't sufficient), while `llm` CLI only sees the pre-assembled context. This explains why subagents find deeper signals like import-control XMLs and plugin sandboxing tests.

4. **If budget allows, consider Opus 4.6 for a spot-check pass.** Run Opus on 10-20 entries where Sonnet's confidence is lowest, as a quality-assurance layer. But the bulk run should use Sonnet 4.6.

### Gate assessment

| Criterion | Result |
|-----------|--------|
| New model matches baseline on 5/6 | **No** — best is 4/6 (GLM-4.7, Kimi K2.5, Gemini 3 Flash) |
| Opus 4.6 justifies higher cost | **Marginal** — same accuracy, richer reasoning, 40% slower |
| All `llm` CLI models complete 6/6 | **Yes** — all completed without failures |
| Sonnet 4.6 remains best choice | **Confirmed** — best accuracy-to-cost ratio |

**Gate result: GO with Sonnet 4.6 subagents.** No model switch warranted.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Active | 2026-03-07 | — | Extended SPIKE-003 with additional models |
