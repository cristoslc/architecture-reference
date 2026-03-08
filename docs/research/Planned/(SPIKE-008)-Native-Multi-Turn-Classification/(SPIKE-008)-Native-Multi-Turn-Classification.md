---
title: "Native Multi-Turn Classification with GLM-5"
artifact: SPIKE-008
status: Planned
author: cristos
created: 2026-03-08
last-updated: 2026-03-08
question: "Can an LLM with native tool-calling (shell, file read, glob, grep) produce higher-quality architecture classifications than the batch llm CLI approach, and does GLM-5 offer the best cost/quality tradeoff for this?"
gate: Pre-execution gate for SPEC-024 reclassification
risks-addressed:
  - Over-labeling (Microkernel in 45% of entries via Gemini batch)
  - Shallow reasoning (alternatives not dismissed, directory-name-level evidence)
  - Uniform confidence (model cannot self-calibrate)
depends-on:
  - ADR-003
---

# Native Multi-Turn Classification with GLM-5

## Question

Can an LLM with native tool-calling (shell commands, file reads, glob searches, grep patterns) produce higher-quality architecture classifications than the batch `llm` CLI approach? Specifically:

1. Does interactive repo exploration produce deeper evidence (actual code patterns, import chains, config values) vs. the static context blob used by `llm` CLI?
2. Does GLM-5 produce discriminating classifications (fewer styles per entry, meaningful confidence spread) without a separate calibration model?
3. What is the cost/quality tradeoff vs. Claude Code subagents (Sonnet 4.6), which are proven but expensive?

## Go / No-Go Criteria

Run on a 10-entry validation set (5 high-confidence entries from SPEC-024 as anchors, 5 low-confidence/flagged entries as challenges).

| Criterion | Threshold | Measurement |
|-----------|-----------|-------------|
| Style precision | Mean styles per entry <= 1.8 | Count of architecture_styles per entry |
| Evidence depth | Evidence dimension >= 0.85 (Sonnet calibration) | Run calibrate-confidence.sh on results |
| Alternatives dismissed | Alternatives dimension >= 0.75 (Sonnet calibration) | Run calibrate-confidence.sh on results |
| Confidence spread | Native spread >= 0.25 without calibration model | Range of self-reported confidence scores |
| Anchor agreement | >= 4/5 high-confidence entries match SPEC-024 primary style | Compare primary styles |
| Challenge improvement | >= 3/5 flagged entries have calibrated confidence > their SPEC-024 calibrated score | Compare calibration results |

**GO** if >= 5/6 criteria pass. **NO-GO** if < 4/6 pass.

## Pivot Recommendation

If GLM-5 native tool-calling fails:

1. **Try Claude Code subagents with Sonnet 4.6** — proven in SPIKE-003 baseline, known quality, higher cost. Use for the ~130 entries needing reclassification per ADR-003.
2. **Try Opus 4.6 subagents on flagged entries only** — highest quality, highest cost. Use only for the 15 entries below 0.60 calibrated confidence.
3. **Accept SPEC-024 provisional classifications** with calibration flags as the best available data, and move on to reference library construction (SPEC-022/023).

## Approach

### Tool-calling setup

Use the model's native function-calling / tool-use capability to give it direct access to a cloned repository:

| Tool | Purpose |
|------|---------|
| `shell` | Run arbitrary commands (ls, find, wc, head) |
| `read_file` | Read file contents with line numbers |
| `glob` | Find files by pattern |
| `grep` | Search file contents by regex |

The model drives the investigation — it decides what to look at based on what it finds, rather than receiving a pre-assembled context blob.

### Model candidates

| Model | Why consider |
|-------|-------------|
| GLM-5 | Strong tool-use, competitive reasoning, good cost profile |
| Gemini 2.5 Pro | Proven reasoning, native tool-use, but higher cost than Flash |
| Claude Sonnet 4.6 | SPIKE-003 baseline, proven quality, known cost |

Primary evaluation: GLM-5. Compare against Sonnet 4.6 baseline on the same 10 entries.

### Validation set

Select from SPEC-024 results:

**Anchors (high-confidence, likely correct):**
- 5 entries with calibrated confidence >= 0.82 and no flags

**Challenges (low-confidence or flagged):**
- 5 entries with calibrated confidence <= 0.60 or strong flags from Sonnet

### Evaluation protocol

For each entry:
1. Clone repo (use existing .clone-cache/)
2. Give model tool access to the cloned repo
3. Use the same system prompt (pipeline/prompts/system-prompt.md) but allow interactive exploration instead of static context
4. Record: styles assigned, confidence, reasoning length, tool calls made, evidence specificity
5. Run Sonnet calibration on the reasoning text for comparable dimension scores

### Implementation options

| Option | Mechanism | Pros | Cons |
|--------|-----------|------|------|
| Claude Code subagent | `Agent` tool with repo access | Native tool-calling, proven infra | Locked to Claude models |
| OpenRouter API | Direct API calls with tool definitions | Any model, including GLM-5 | Need to implement tool dispatch loop |
| `llm` CLI with tools plugin | `llm` tool-use support | Familiar CLI | Tool support varies by model/plugin |

Likely approach: OpenRouter API with a thin Python tool-dispatch wrapper, so we can test GLM-5 and Sonnet on identical infrastructure.

## Findings

_To be populated during Active phase._

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Planned | 2026-03-08 | — | Initial creation per ADR-003 |
