---
title: "Classification Method Comparison"
artifact: SPIKE-003
status: Active
author: cristos
created: 2026-03-07
last-updated: 2026-03-07
question: "Which classification tool produces better architecture style classifications — Claude Code subagents (Sonnet 4.6) or `llm` CLI (Minimax M2.5) — and should SPEC-024 use one, the other, or both?"
gate: "Pre-execution gate for SPEC-024 — tool selection affects all 184 entries"
risks-addressed:
  - "Wrong tool choice wastes 184 LLM calls on inferior classifications"
  - "Single-tool approach may miss edge cases the other tool catches"
  - "Classification reasoning may not be captured if not designed into the prompt"
depends-on:
  - ADR-002
linked-research:
  - SPEC-024
---

# Classification Method Comparison

## Question

Which classification tool produces better architecture style classifications — Claude Code subagents (Sonnet 4.6) or `llm` CLI (Minimax M2.5) — and should SPEC-024 use one, the other, or both?

### Test subjects

| Entry | Type | Domain | Language | Why selected |
|-------|------|--------|----------|-------------|
| posthog | Application | Analytics | Python | Complex multi-service app, previously got 6 heuristic styles |
| chatwoot | Application | Customer Support | Ruby | Rails app with potential multi-style composition |
| sentry | Application | Observability | Python | Large codebase, known complex architecture |
| kafka | Platform | Messaging | Java | Well-known architecture, good baseline test |
| consul | Platform | Infrastructure | Go | Service mesh + KV store, multi-concern platform |
| grafana | Platform | Observability | Go | Plugin architecture, well-documented |

### Evaluation dimensions

1. **Classification accuracy** — Do the styles assigned match what a human expert would say?
2. **Reasoning quality** — Does the model cite specific source code evidence, or make vague claims?
3. **Confidence calibration** — Are confidence scores meaningful? Does the model know when it's uncertain?
4. **False positive rate** — Does the model over-assign styles (shotgun classification)?
5. **Indeterminate handling** — When should a repo be Indeterminate vs classified?
6. **Practical factors** — Speed, cost, ease of batching, error recovery

## Go / No-Go Criteria

| Criterion | Threshold | Measurement |
|-----------|-----------|-------------|
| At least one tool produces classifications that agree with known architecture for 5/6 test subjects | Minimum acceptable accuracy | Manual expert review of results |
| Reasoning cites specific file paths, directory structures, or code patterns | Not just "this looks like X" | Count concrete evidence citations per classification |
| Agreement between tools on primary style | >= 4/6 subjects agree | Direct comparison |
| If tools disagree, one is clearly better on the disagreement cases | Reviewer can identify which is correct | Manual adjudication of disagreements |

## Pivot Recommendation

If neither tool meets the accuracy threshold, consider:
1. A two-pass approach: one tool classifies, the other validates
2. A different model entirely (e.g., Claude Opus for complex cases)
3. Revised prompting strategy before re-testing

## Method

### Prompt design (same prompt for both tools)

The classification prompt must:
- Provide repo context (directory structure, key source files, config files, architecture docs, README)
- NOT include any prior classification — clean slate per ADR-002
- Ask for: primary style, secondary styles (if applicable), confidence (0.0-1.0), and detailed reasoning citing specific source code evidence
- Use the same 14-style taxonomy from the catalog

### Tool A: Claude Code subagents (Sonnet 4.6)

For each test subject:
1. Clone the repo (shallow, `--depth 1`)
2. Assemble context in the subagent prompt
3. Subagent analyzes and returns structured classification
4. Capture full reasoning output

### Tool B: `llm` CLI (Minimax M2.5)

For each test subject:
1. Clone the repo (shallow, `--depth 1`)
2. Assemble same context as Tool A
3. Pipe context to `llm` with classification prompt
4. Capture full reasoning output

### Comparison

Side-by-side table for each test subject showing both tools' results with reasoning excerpts.

## Findings

### Side-by-side comparison

| Repo | Subagent (Sonnet 4.6) | `llm` CLI (Minimax M2.5) | Agree on primary? |
|------|----------------------|--------------------------|-------------------|
| **posthog** | Modular Monolith + Event-Driven, Service-Based (0.82) | Modular Monolith + Service-Based, Event-Driven (0.90) | **Yes** |
| **chatwoot** | **Layered** + Event-Driven (0.85) | **Modular Monolith** + Event-Driven (0.90) | **No** |
| **sentry** | Modular Monolith + Event-Driven, Plugin (0.85) | *(FAILED — tried to invoke tools instead of analyzing)* | **N/A** |
| **kafka** | **Modular Monolith** + Event-Driven, Pipe-and-Filter (0.82) | **Event-Driven** + Modular Monolith (0.95) | **No** |
| **consul** | Modular Monolith + Plugin, Event-Driven (0.82) | Modular Monolith + Event-Driven, DDD (0.90) | **Yes** |
| **grafana** | **Plugin (Microkernel)** + Modular Monolith, Layered (0.85) | **Modular Monolith** + Plugin, DDD (0.85) | **No** |

**Agreement on primary style: 2/5** (excluding sentry failure) — below the 4/6 threshold.

### Detailed analysis of disagreements

#### Chatwoot: Layered (subagent) vs Modular Monolith (llm CLI)

The subagent argued: "flat model directory with 50+ freely cross-referencing ActiveRecord models rules out Modular Monolith and DDD bounded contexts." This is a sharper, more defensible argument. A Rails app with `app/models/`, `app/controllers/`, `app/views/` follows the Layered pattern by default. Calling it "Modular Monolith" requires evidence of deliberate module boundaries, which Chatwoot lacks — its "modules" are just Rails service objects, not enforced boundaries.

**Winner: Subagent.** The Layered classification is more accurate for a standard Rails app.

#### Kafka: Modular Monolith (subagent) vs Event-Driven (llm CLI)

The subagent found import-control XML files (`checkstyle/import-control-server.xml`, etc.) enforcing hard dependency boundaries between modules — a strong signal of intentional modular monolith design. The `llm` CLI classified based on what Kafka *does* (event streaming) rather than how Kafka *is built* (single deployable with internal module boundaries).

For our catalog, we classify **how the codebase is structured**, not what domain it serves. A messaging platform's architecture is not necessarily Event-Driven — that describes its purpose, not its internal organization.

**Winner: Subagent.** Modular Monolith as primary with Event-Driven secondary correctly separates structure from domain.

#### Grafana: Plugin (subagent) vs Modular Monolith (llm CLI)

The subagent argued Plugin/Microkernel is the *dominant* pattern: "Grafana's entire value proposition revolves around a core platform that hosts pluggable panels, data sources, and apps." The `llm` CLI acknowledged Plugin as secondary but chose Modular Monolith as primary.

The subagent's classification is more insightful — Grafana's architecture is *defined* by its plugin system. The modular monolith structure is a means of organizing the core, but the plugin boundary is the primary architectural decision.

**Winner: Subagent.** Plugin/Microkernel better captures Grafana's defining architectural characteristic.

#### Sentry: Subagent succeeded vs llm CLI failed

The `llm` CLI output for Sentry was not a classification at all — Minimax M2.5 attempted to invoke filesystem tools (`filesystem_list_allowed_directories`, `filesystem_directory_tree`) instead of analyzing the context provided in the prompt. This is a reliability failure: the model hallucinated tool invocations that don't exist in its environment.

The subagent produced a well-evidenced classification (Modular Monolith + Event-Driven + Plugin) with specific findings like the `src/sentry_plugins/` package and the "silo" architecture hints.

**Winner: Subagent.** The `llm` CLI failed entirely on this input.

### Evaluation by dimension

| Dimension | Subagent (Sonnet 4.6) | `llm` CLI (Minimax M2.5) |
|-----------|----------------------|--------------------------|
| **Classification accuracy** | 6/6 plausible, with sharper distinctions | 4/5 plausible (1 failure), tends toward "Modular Monolith" default |
| **Reasoning quality** | Cites specific file paths, directory structures, config files, build system evidence | Cites evidence but sometimes argues from domain purpose rather than code structure |
| **Confidence calibration** | Conservative (0.82-0.85), reflects genuine uncertainty | Higher confidence (0.85-0.95) even when less accurate |
| **False positive rate** | Low — conservative secondary style assignment, explicit "why not" reasoning | Low but DDD assigned twice as secondary without strong structural evidence |
| **Reliability** | 6/6 completed successfully | 5/6 — one complete failure (Sentry) |
| **Evidence depth** | Found import-control XMLs (Kafka), plugin CA providers (Consul), silo architecture hints (Sentry) — deep structural signals | Relied more on README descriptions and docker-compose service lists |
| **Speed** | ~55-70s per repo | ~30-45s per repo (faster) |

### Key insight: structural vs functional classification

The most important finding is a systematic difference in *what* each tool classifies:

- **Subagent (Sonnet 4.6)** classifies **how the codebase is structured** — module boundaries, deployment units, dependency enforcement, plugin contracts
- **`llm` CLI (Minimax M2.5)** tends to classify **what the system does** — Kafka is "Event-Driven" because it's a messaging platform, Chatwoot is "Modular Monolith" because it has service objects

For our catalog's purpose — understanding architectural patterns in codebases — the structural perspective is correct. We want to know how components are organized and communicate, not what business domain they serve.

### Methodological limitation: one-shot vs multi-turn

**The `llm` CLI tests were not a fair comparison.** Subagents made 5-10 tool calls each, browsing the actual cloned repo and reading additional files when initial context was insufficient. The `llm` CLI models received a single pre-assembled context dump with no ability to explore further.

The pipeline already has a multi-turn protocol for `llm` CLI (`llm-review.sh` with SPEC-011 escalation): the model can request files, directory trees, globs, and greps from the cloned repo across up to 4-8 turns via `llm -c`. This gives the `llm`-called model the same iterative exploration capability that subagents have natively.

**The SPIKE-003 tests bypassed this entirely.** The `llm` CLI models were handicapped — they could not request additional context when the pre-assembled dump was insufficient. The subagents' advantage in finding deep structural signals (import-control XMLs, plugin sandboxing tests, silo architecture hints) may be partially or fully explained by their ability to explore beyond the initial context.

**Implication:** The accuracy gap between subagents and `llm` CLI is real but may be smaller than measured. A fair retest would use the multi-turn loop for `llm` CLI models. See SPIKE-004 for extended comparison with the same limitation noted.

### Recommendation

**Subagents (Sonnet 4.6) remain the recommendation for SPEC-024**, but with caveats:

1. **Higher accuracy** — won every disagreement case on closer examination
2. **Better evidence** — finds deep structural signals, though partly due to multi-turn exploration advantage
3. **100% reliability** — no failures vs 1/6 failure rate for `llm` CLI
4. **Correct framing** — classifies structure, not domain
5. **Conservative confidence** — doesn't over-claim

The `llm` CLI with multi-turn escalation (SPEC-011) was not tested and may close the gap. If a future spike tests this, the recommendation may change.

### SPEC-024 output format update

Based on this spike, each classification should capture:
- `architecture_styles`: list of styles (primary first)
- `classification_method`: `deep-analysis` (per ADR-002)
- `classification_confidence`: 0.0-1.0
- `classification_reasoning`: full LLM reasoning text citing specific evidence
- `classification_date`: ISO timestamp
- `classification_model`: model identifier (e.g., `claude-sonnet-4-6`)

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Planned | 2026-03-07 | — | Pre-execution gate for SPEC-024 tool selection |
