---
title: "Extended Model Comparison"
artifact: SPIKE-004
status: Complete
author: cristos
created: 2026-03-07
last-updated: 2026-03-08
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

- **Same 6 repos, same system prompt** as SPIKE-003
- Sonnet 4.6 subagent results carried forward from SPIKE-003 (not rerun)
- `llm` CLI models tested with **multi-turn SPEC-011 escalation protocol** — models can request files, trees, globs, and greps from cloned repos across up to 6 turns via `llm -c`
- Opus 4.6 tested as Claude Code subagent with full repo browsing
- Response format: YAML frontmatter (structured fields) + free-text prose reasoning
- Evaluation script: `run-evaluation.sh` (forked from `pipeline/llm-review.sh`)

### Runs

- 4 `llm` CLI multi-turn runs (GLM-5, GLM-4.7, Kimi K2.5, Gemini 3 Flash Preview) x 6 repos = 24 LLM conversations
- 6 Opus 4.6 subagent runs = 6 subagent sessions (24-43 tool calls each)
- Total: 30 new evaluation sessions

## Findings

### Primary style comparison matrix

| Repo | Sonnet 4.6 (baseline) | Opus 4.6 | GLM-5 | GLM-4.7 | Kimi K2.5 | Gemini 3 Flash |
|------|----------------------|----------|-------|---------|-----------|---------------|
| **posthog** | Modular Monolith | Modular Monolith | Modular Monolith | Modular Monolith | Modular Monolith | Modular Monolith |
| **chatwoot** | Layered | Layered | Layered | Layered | Layered | Layered |
| **sentry** | Modular Monolith | Modular Monolith | **FAILED** | Modular Monolith | Modular Monolith | Modular Monolith |
| **kafka** | Modular Monolith | Modular Monolith | Modular Monolith | Modular Monolith | Modular Monolith | Modular Monolith |
| **consul** | Modular Monolith | **Microkernel (Plugin)** | Modular Monolith | Modular Monolith | Modular Monolith | Modular Monolith |
| **grafana** | Plugin (Microkernel) | Plugin (Microkernel) | Plugin (Microkernel) | **Modular Monolith** | **Modular Monolith** | Plugin (Microkernel) |

### Agreement with Sonnet 4.6 baseline

| Model | Agreement | Misses | Multi-turn usage |
|-------|-----------|--------|-----------------|
| **Gemini 3 Flash** | **6/6 (100%)** | — | 4/6 repos used turn 2 |
| **Opus 4.6** | **5/6 (83%)** | consul (Microkernel instead of Modular Monolith) | 24-43 tool calls per repo |
| **GLM-4.7** | **5/6 (83%)** | grafana (Modular Monolith) | 2/6 repos used turn 2 |
| **Kimi K2.5** | **5/6 (83%)** | grafana (Modular Monolith) | 2/6 repos used turn 2 |
| **GLM-5** | **4/5 (80%)** | sentry (malformed YAML failure) | 4/5 completed repos used turns 2-3 |

### Improvement from one-shot to multi-turn

| Model | One-shot (SPIKE-004 v1) | Multi-turn | Change |
|-------|------------------------|------------|--------|
| GLM-5 | 3/6 (50%) | 4/5 (80%) | Fixed posthog, chatwoot, kafka; sentry now fails differently |
| GLM-4.7 | 4/6 (67%) | 5/6 (83%) | Fixed posthog |
| Kimi K2.5 | 4/6 (67%) | 5/6 (83%) | Fixed chatwoot |
| Gemini 3 Flash | 4/6 (67%) | **6/6 (100%)** | Fixed chatwoot and grafana |

Multi-turn exploration improved every `llm` CLI model. The biggest winner is Gemini 3 Flash, which went from 67% to perfect agreement.

### Secondary style comparison

| Repo | Sonnet 4.6 | Opus 4.6 | GLM-5 | GLM-4.7 | Kimi K2.5 | Gemini 3 Flash |
|------|-----------|----------|-------|---------|-----------|---------------|
| posthog | Event-Driven, Service-Based | Event-Driven, Plugin | Plugin, Event-Driven | DDD, Event-Driven | Service-Based, Event-Driven, DDD | Event-Driven, Plugin |
| chatwoot | Event-Driven | Event-Driven, Plugin | Event-Driven | Event-Driven | Event-Driven, DDD | Event-Driven |
| sentry | Event-Driven, Plugin | Plugin, Event-Driven | *(failed)* | Event-Driven, Microkernel | Event-Driven, Layered | Event-Driven, Plugin |
| kafka | Event-Driven, Pipe-and-Filter | Plugin, Layered | Layered | none | Layered, Event-Driven | Plugin, Event-Driven |
| consul | Plugin, Event-Driven | Event-Driven | none | DDD | Plugin | DDD, Event-Driven |
| grafana | Modular Monolith, Layered | Modular Monolith | Modular Monolith | Plugin | Microkernel, DDD | Modular Monolith, Layered |

### Key observations

#### 1. Multi-turn closes the accuracy gap

The most important finding: **multi-turn exploration dramatically improves `llm` CLI model accuracy.** The one-shot results in SPIKE-004 v1 showed 50-67% agreement; with multi-turn, all models reach 80-100%. This confirms the hypothesis from SPIKE-003 that the accuracy gap was partly methodological, not purely model-quality.

Gemini 3 Flash, in particular, went from 4/6 to 6/6 — matching the Sonnet baseline perfectly. It used multi-turn on 4 repos (posthog, sentry, consul, grafana), requesting files like `docker-compose.yml`, `pyproject.toml`, `pkg/` trees, and `plugins-bundled/` structures.

#### 2. The grafana test remains the hardest discriminator

GLM-4.7 and Kimi K2.5 still classify Grafana as Modular Monolith even with multi-turn. They recognize the plugin system but rate it as secondary. Gemini 3 Flash and GLM-5 correctly identify Plugin/Microkernel as primary — the defining architectural characteristic.

The key signal: Grafana uses HashiCorp's `go-plugin` library for gRPC-based plugin isolation, has a staged plugin lifecycle pipeline (Discovery → Bootstrap → Validation → Initialization → Termination), and frontend plugin sandboxing. These are Microkernel signals, not just "has plugins."

#### 3. Opus disagrees with Sonnet on Consul

This is the most interesting disagreement. Opus classified Consul as **Microkernel (Plugin)** primary, while Sonnet said **Modular Monolith** with Plugin as secondary. Opus found extensive plugin infrastructure:

- Agent delegate pattern (`*consul.Server` or `*consul.Client` plugged into the same kernel)
- CA Provider plugin interface with Vault and AWS implementations
- Envoy extension registry with enterprise extension points
- Resource type registry with pluggable validation/mutation/ACL hooks
- Kubernetes-style controller framework for reconciling resource types
- Command registry with CE vs Enterprise command sets

This is a legitimate architectural judgment call, not an error. Both models see the same signals — they weigh them differently. Opus made 29 tool calls and read plugin contract code; Sonnet may not have explored as deeply.

#### 4. DDD over-assignment persists in some models

Kimi K2.5 assigns DDD as secondary on 3 repos (posthog, chatwoot, consul) and GLM-4.7 assigns it on 2 (posthog, consul). Neither repo has bounded contexts, aggregates, or domain events in the DDD sense. This appears to be pattern-name matching ("has domain-organized directories") rather than structural analysis of DDD-specific constructs.

#### 5. Opus produces the richest reasoning

Opus made 24-43 tool calls per repo (vs 1-3 turns for `llm` CLI models) and found signals that other models missed entirely:

| Repo | Opus insight (beyond other models) |
|------|-------------------------------------|
| posthog | Found `tach.toml` — a 334-line import boundary enforcement config with explicit `depends_on` relationships and `interfaces` between product modules |
| chatwoot | Found `enterprise/` plugin overlay using `prepend_mod_with` injection — identified Microkernel as secondary |
| sentry | Found silo system with `@control_silo_endpoint` (176 occurrences) and `@region_silo_model` (282 occurrences) — enforced module boundaries |
| kafka | Found Kafka Connect's full classloader-based plugin system (`PluginClassLoader`, `DelegatingClassLoader`) — identified Plugin as strong secondary |
| consul | Found 7 distinct plugin registries — reclassified from Modular Monolith to Microkernel primary |
| grafana | Found gRPC-based plugin isolation, staged lifecycle pipeline, frontend sandboxing, Wire DI, and dskit module system |

#### 6. Reliability

| Model | Completed | Failures |
|-------|-----------|----------|
| Opus 4.6 | 6/6 | — |
| Gemini 3 Flash | 6/6 | — |
| GLM-4.7 | 6/6 | — |
| Kimi K2.5 | 6/6 | — |
| GLM-5 | 5/6 | Sentry: emitted malformed YAML (`type: type: file`) in needs_info request, breaking the multi-turn loop |

### Confidence comparison

| Model | Mean confidence | Range | Calibration |
|-------|----------------|-------|-------------|
| Sonnet 4.6 | 0.83 | 0.82-0.85 | Conservative, meaningful |
| Opus 4.6 | 0.88 | 0.82-0.92 | Conservative, meaningful |
| GLM-5 | 0.89 | 0.80-0.95 | Reasonable range |
| GLM-4.7 | 0.89 | 0.85-0.95 | Slightly high — 0.90 for wrong grafana classification |
| Kimi K2.5 | 0.88 | 0.85-0.92 | Slightly high — 0.85 for wrong grafana classification |
| Gemini 3 Flash | 0.95 | 0.95-0.95 | Over-confident — uniform 0.95 for all repos |

Gemini 3 Flash assigns 0.95 confidence uniformly, which provides no signal about which classifications the model is less certain about. Claude models (Sonnet and Opus) provide the most meaningful confidence variation.

### Recommendation

**Gemini 3 Flash via `llm` CLI with multi-turn is a viable alternative to Sonnet subagents for SPEC-024.** This changes the SPIKE-003 recommendation.

1. **Gemini 3 Flash matched the Sonnet baseline perfectly (6/6)** with multi-turn exploration, at lower cost and faster execution (~5s per turn vs ~80s per subagent session).

2. **Opus 4.6 produces the deepest reasoning** — finding signals that no other model detected (tach.toml, silo decorators, plugin classloaders). It disagrees with Sonnet on Consul, and the disagreement is defensible. However, Opus costs significantly more and takes 80-100s per repo.

3. **All `llm` CLI models improved significantly with multi-turn.** The SPIKE-003 recommendation to avoid `llm` CLI was based on one-shot testing, which handicapped the models. With SPEC-011 escalation, `llm` CLI models approach or match subagent quality.

4. **For 184 entries, the practical recommendation is:**
   - **Primary: Gemini 3 Flash via `llm` CLI multi-turn** — matches Sonnet accuracy, faster, cheaper
   - **QA layer: Opus 4.6 subagent on low-confidence entries** — deeper reasoning catches edge cases
   - **Fallback: Sonnet 4.6 subagent** — proven baseline if `llm` CLI has reliability issues at scale

5. **Confidence calibration caveat:** Gemini's uniform 0.95 scores are not meaningful for triage. Post-process confidence from the reasoning text or use a separate confidence assessment pass.

### Gate assessment

| Criterion | Result |
|-----------|--------|
| New model matches baseline on 5/6 | **Yes** — Gemini 3 Flash: 6/6, GLM-4.7: 5/6, Kimi K2.5: 5/6 |
| Opus 4.6 justifies higher cost | **Yes, for QA** — found structural signals others missed, defensible consul reclassification |
| All `llm` CLI models complete 6/6 | **No** — GLM-5 failed on sentry (malformed YAML). Others: 6/6. |
| Sonnet 4.6 remains best choice | **No longer sole recommendation** — Gemini 3 Flash matches accuracy at lower cost |
| Multi-turn `llm` CLI tested | **Yes** — dramatically improved results, validates SPEC-011 protocol |

**Gate result: GO with Gemini 3 Flash via `llm` CLI multi-turn as primary, Opus 4.6 subagent as QA layer.** Update SPEC-024 tool recommendation accordingly.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Active | 2026-03-07 | — | Extended SPIKE-003 with additional models |
