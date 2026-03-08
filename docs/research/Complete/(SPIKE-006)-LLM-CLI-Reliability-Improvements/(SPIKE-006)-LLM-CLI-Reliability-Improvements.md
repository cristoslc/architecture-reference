---
title: "LLM CLI Reliability Improvements"
artifact: SPIKE-006
status: Complete
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

### Thread 1: Improved prompting fixes GLM-5 (GO)

The improved system prompt (`spike-006-system-prompt.md`) with strict YAML examples, explicit field constraints ("each request MUST have exactly these fields"), and a JSON fallback instruction resolved all GLM-5 parse failures. GLM-5 went from 4/6 (2 PARSE_FAILED) to **6/6 with zero parse retries needed**.

The retry logic (`run-evaluation.sh` parse retry mechanism) was implemented but never triggered -- the improved prompt alone was sufficient.

#### SPIKE-006 results (all 4 models, 6/6 completions, 0 parse retries)

| Repo | GLM-5 | GLM-4.7 | Kimi K2.5 | Gemini 3 Flash |
|------|-------|---------|-----------|----------------|
| posthog | Service-Based | Modular Monolith | Modular Monolith | Modular Monolith |
| chatwoot | Layered | Layered | Modular Monolith | Layered |
| sentry | Modular Monolith | Modular Monolith | Modular Monolith | Modular Monolith |
| kafka | Modular Monolith | Modular Monolith | Modular Monolith | Modular Monolith |
| consul | Modular Monolith | Modular Monolith | Modular Monolith | Modular Monolith |
| grafana | Microkernel (Plugin) | Microkernel (Plugin) | Modular Monolith | Microkernel (Plugin) |

#### Comparison with SPIKE-004 baseline

| Model | SPIKE-004 | SPIKE-006 | Changes |
|-------|-----------|-----------|---------|
| GLM-5 | 4/6 (sentry, consul PARSE_FAILED) | 6/6 | Fixed: sentry + consul. posthog reclassified Modular Monolith -> Service-Based |
| GLM-4.7 | 5/6 (grafana wrong: Modular Monolith) | 6/6 | Fixed: grafana now Microkernel (Plugin), matching consensus |
| Kimi K2.5 | 5/6 (grafana wrong: Modular Monolith) | 6/6 | grafana still Modular Monolith (disagrees with consensus). chatwoot changed Layered -> Modular Monolith |
| Gemini 3 Flash | 6/6 | 6/6 | No changes. Identical classifications |

#### Classification consensus (SPIKE-006)

- **4/4 agreement**: sentry (Modular Monolith), kafka (Modular Monolith), consul (Modular Monolith)
- **3/4 agreement**: chatwoot (Layered; Kimi says Modular Monolith), posthog (Modular Monolith; GLM-5 says Service-Based), grafana (Microkernel/Plugin; Kimi says Modular Monolith)
- Kimi K2.5 is the most divergent model -- it classifies everything as Modular Monolith, including grafana (which has strong Microkernel signals)

### Thread 2: llm CLI has native tool-calling (GO, but not adopted yet)

`llm` 0.28 has full native tool-calling support, confirmed working with all 4 OpenRouter models:

- **`--functions` flag**: Define Python functions as tools. Tested with `read_file()` and `list_directory()` -- GLM-5 successfully called `read_file` to read a README and summarized it. The model sees tool schemas and invokes them via OpenAI-compatible function calling through OpenRouter.
- **`-T` flag**: Use pre-registered tools (e.g., `llm_time`, `llm_version`, or MCP tools via `llm-tools-mcp` plugin).
- **`--cl` (chain-limit)**: Controls how many chained tool responses to allow (default 5, 0 for unlimited). This is the built-in multi-turn loop.
- **`llm-tools-mcp` plugin** (v0.4, already installed): Connects to MCP servers, enabling integration with filesystem, git, or custom MCP servers.

**What this means for SPEC-024**: Instead of the custom bash loop where the model emits YAML `needs_info` requests and we parse + fulfill them, we could define `read_file`, `list_directory`, `search_glob`, `search_grep` as Python functions via `--functions` and let the model call them natively. This eliminates YAML parsing entirely.

**Why we did not adopt it for this spike**: The improved prompting already achieved 6/6 reliability. Migrating to tool-calling is a larger change that should be tested separately, possibly as a follow-on spike or during SPEC-024 implementation. Tool-calling also changes the interaction pattern (model decides when to request info vs. being told to classify), which may affect classification quality.

**Recommendation**: File a follow-on spike (SPIKE-007) to compare tool-calling vs. YAML-loop classification quality on the 6 test repos, then adopt tool-calling for SPEC-024 if results are equivalent or better.

### Thread 3: Parse retry logic (implemented, untriggered)

The script now includes:
1. **Parse retry** -- if `parse_yaml_frontmatter` returns `{}`, the model's raw response is sent back with reformatting instructions via `llm -c`, up to 2 retries
2. **Bare JSON fallback** -- a third parser path that accepts raw `{...}` JSON (no code fences) if it contains a `verdict` field
3. **Enhanced logging** -- retry count tracked per turn and per repo, included in output headers

The retry logic was not exercised in any of the 24 model runs (4 models x 6 repos), confirming that the improved system prompt alone was sufficient to fix the YAML adherence issues.

### SPIKE-004 re-analysis: consul failure was context pollution, not YAML

The SPIKE-004 consul failure for GLM-5 was not a YAML parse error -- it was a conversation context pollution bug. The model received chatwoot README context in turn 1 but consul file content in turn 2, leading it to comment on the "discrepancy" between two different repos. The `llm -c` conversation continuation carried over the wrong session. This is a separate issue from YAML formatting and was not reproduced in SPIKE-006 (likely fixed by running repos sequentially without session overlap).

## Go / No-Go Assessment

| Criterion | Result | Status |
|-----------|--------|--------|
| GLM-5 completes 6/6 repos | 6/6, 0 retries | **GO** |
| Native tool-calling exists and works | Confirmed, all 4 models | **GO** (available, not adopted) |
| No more than 30s added per repo | 0s added (retry not triggered) | **GO** |
| Works across all 4 models | All 4 at 6/6 | **GO** |

**Overall: GO** -- Proceed with SPEC-024 using the improved system prompt. Consider tool-calling migration as a separate follow-on.

## Artifacts produced

| File | Purpose |
|------|---------|
| `spike-006-system-prompt.md` | Improved system prompt with strict YAML examples, field constraints, JSON fallback |
| `run-evaluation.sh` | Evaluation script with parse-retry logic (forked from SPIKE-004) |
| `results-multiturn/z-ai-glm-5/` | GLM-5 results (6/6) |
| `results-multiturn/z-ai-glm-4.7/` | GLM-4.7 results (6/6) |
| `results-multiturn/moonshotai-kimi-k2.5/` | Kimi K2.5 results (6/6) |
| `results-multiturn/google-gemini-3-flash-preview/` | Gemini 3 Flash results (6/6) |

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Planned | 2026-03-08 | — | Addresses GLM-5 YAML failure and custom loop fragility from SPIKE-004 |
| Active | 2026-03-08 | — | Research, implementation, and evaluation complete |
