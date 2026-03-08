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

*(Populated during Active phase.)*

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Planned | 2026-03-07 | — | Pre-execution gate for SPEC-024 tool selection |
