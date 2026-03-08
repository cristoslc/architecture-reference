---
title: "LLM CLI Reliability Improvements"
artifact: SPIKE-006
status: Active
author: cristos
created: 2026-03-08
last-updated: 2026-03-08
question: "Can we improve GLM-5's YAML adherence through revised prompting, and can we replace the custom multi-turn bash loop with llm's native tool-calling or agent capabilities for more robust model-driven exploration?"
gate: "Pre-execution gate for SPEC-024 — reliability must reach 6/6 for production use"
risks-addressed:
  - "GLM-5 emitted malformed YAML (`type: type: file`) breaking the multi-turn loop — 1/6 failure rate is unacceptable for 184 entries"
  - "Custom bash multi-turn loop is fragile — regex parsing of model output, no error recovery, no retry on malformed responses"
  - "llm CLI may have native tool-calling or agent modes that would eliminate the need for custom multi-turn orchestration"
depends-on:
  - SPIKE-004
linked-research:
  - SPEC-024
---

# LLM CLI Reliability Improvements

## Question

Can we improve GLM-5's YAML adherence through revised prompting, and can we replace the custom multi-turn bash loop with `llm`'s native tool-calling or agent capabilities for more robust model-driven exploration?

### Context

SPIKE-004's multi-turn evaluation script (`run-evaluation.sh`) uses a custom bash loop: the model emits YAML frontmatter with `verdict: needs_info` and file/tree/glob/grep requests, the script fulfills them, and continues the conversation via `llm -c`. This works but is fragile:

- GLM-5 emitted `type: type: file` (doubled key) in its YAML, breaking the parser and losing the sentry classification entirely
- The bash regex for YAML frontmatter required two bug fixes (leading whitespace, `sys.exit` fallback) during SPIKE-004
- No retry logic — a single malformed response ends the evaluation for that repo
- The model has no awareness that its output is being parsed — it's just writing text that happens to be YAML

### Investigation threads

#### Thread 1: YAML adherence improvements for GLM-5

1. **Strict format examples** — Add 2-3 complete YAML examples in the system prompt showing exact expected output
2. **JSON fallback** — Allow models to respond in JSON if YAML is malformed, parse both
3. **Schema validation prompt** — Include the YAML schema inline and ask the model to validate before responding
4. **Retry on parse failure** — If YAML parsing fails, send the model its malformed output and ask it to fix the formatting
5. **Model-specific prompt tuning** — Some models may need different formatting instructions (e.g., "respond with exactly this structure, no variations")

#### Thread 2: llm CLI native capabilities

1. **`llm` tool-calling support** — Does `llm` support OpenAI-style function calling / tool use? If so, we could define `read_file`, `list_directory`, `search_grep` as tools and let the model call them natively instead of emitting YAML requests
2. **`llm` agent mode** — The `llm` CLI ecosystem may have agent plugins (e.g., `llm-agent`) that provide autonomous multi-turn loops with tool registration
3. **OpenRouter tool calling** — OpenRouter passes through tool/function calling for supported models. If `llm` supports this, the multi-turn protocol becomes model-native rather than prompt-engineered
4. **`llm` plugins for file access** — Check if `llm-files` or similar plugins exist that give the model direct file access from the cloned repo

#### Thread 3: Robustness improvements to custom loop

If native tool-calling isn't available, harden the existing bash loop:
1. **Parse retry** — On YAML parse failure, send the malformed output back to the model asking for a corrected version
2. **Timeout handling** — Add per-turn timeouts with graceful degradation
3. **Structured output validation** — Use Python to validate the YAML structure against a schema before fulfilling requests
4. **Multiple response format support** — Accept YAML frontmatter, JSON in code blocks, or raw JSON — whichever the model produces

## Go / No-Go Criteria

| Criterion | Threshold |
|-----------|-----------|
| GLM-5 completes 6/6 repos with at least one improvement approach | Minimum reliability |
| If native tool-calling exists, it produces equivalent or better results than custom loop on 6 test repos | Functional equivalence |
| Solution adds no more than 30s per repo in wall-clock time | Performance feasibility |
| Solution works across all 4 `llm` CLI models (GLM-5, GLM-4.7, Kimi K2.5, Gemini 3 Flash) | Generalizability |

## Pivot Recommendation

If GLM-5 cannot be made reliable:
1. Drop GLM-5 from the SPEC-024 model set — Gemini 3 Flash already achieves 6/6 agreement
2. Keep GLM-5 as an optional secondary model for diversity but don't block on its failures
3. If native tool-calling exists and works well, migrate all `llm` CLI models to tool-calling mode regardless of GLM-5 outcome

## Findings

*To be populated during Active phase.*

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Planned | 2026-03-08 | — | Addresses GLM-5 YAML failure and custom loop fragility from SPIKE-004 |
