---
title: "Abandon Script-Driven Batch Classification with Gemini Flash"
artifact: ADR-003
status: Adopted
author: cristos
created: 2026-03-08
last-updated: 2026-03-08
linked-epics:
  - EPIC-012
linked-specs:
  - SPEC-024
depends-on:
  - ADR-007
---

# Abandon Script-Driven Batch Classification with Gemini Flash

## Context

SPEC-024 used Gemini 3 Flash via the `llm` CLI to classify all 184 Discovered catalog entries. The pipeline (`llm-review.sh`) implemented script-driven multi-turn escalation where the model could request files, trees, globs, and greps from cloned repos — but the bash script mediated every interaction, assembling context blobs and parsing YAML responses. Six gating spikes (SPIKE-003 through SPIKE-007) evaluated models, prompts, and reliability improvements before the full run.

The classification completed — all 184 entries received styles, reasoning, and confidence scores. However, post-hoc analysis via Sonnet confidence calibration (SPIKE-005 pivot) revealed systemic quality problems with Gemini Flash in this script-driven mode:

1. **Over-labeling.** Gemini assigned 2-3 styles to every entry. Zero single-style classifications. Microkernel (Plugin) appeared in 45% of entries as primary or secondary — implausible for real-world codebases. Event-Driven appeared as secondary in 44% of entries but primary in only 1.6% — used as a hedge, not a discriminating signal.

2. **Shallow reasoning.** The weakest calibration dimension was "alternatives dismissed" (0.634 avg) — Gemini rarely considered why a repo is NOT some other style. Evidence strength averaged 0.767 — often citing directory names rather than actual code or configuration values.

3. **Uniform confidence.** Gemini assigned 0.88-0.95 confidence to almost every entry regardless of reasoning quality (SPIKE-005 NO-GO finding). A separate Sonnet pass was required to produce meaningful confidence spread (0.43 vs ~0.08 original). This two-model pipeline adds cost and complexity without solving the root cause.

4. **Pattern matching, not architecture analysis.** Gemini sees a `plugins/` directory and calls it Microkernel. It sees any async code and adds Event-Driven. It doesn't reason about module boundaries, deployment topology, or dependency enforcement — the actual signals of architectural style.

5. **60% flagged.** Sonnet's calibration flagged 111/184 entries (60%) with specific quality concerns — classification style contestable, evidence shallow, alternatives not dismissed.

The core problem is the combination of **(a) Gemini Flash's shallow reasoning** and **(b) the script-driven multi-turn approach** where a bash script mediates all repo exploration. The model receives pre-assembled context blobs and produces a classification. The `verdict: needs_info` escalation approximates interactivity but is limited to pre-formatted requests parsed by bash — the model cannot follow import chains, inspect build outputs, or adapt its investigation based on what it finds in real time.

## Decision

**Abandon the Gemini Flash + script-driven multi-turn approach for architecture classification.** The pipeline scripts (`llm-review.sh`, `calibrate-confidence.sh`) are retained as historical artifacts but should not be used for future classification runs.

**The replacement approach should use native LLM multi-turn with tool-calling** — a model that can directly explore a cloned repository using shell commands, file reads, glob searches, and grep patterns via its native tool-use capability. This may still use the `llm` CLI if the model and plugin support native tool-calling, or it may use direct API calls with tool definitions. The key change is:

- **Before (script-driven):** Bash script assembles context → model classifies from static blob → script parses response → script fulfills `needs_info` requests → repeat
- **After (native tool-calling):** Model receives system prompt + repo path → model drives its own investigation via tool calls → model classifies when it has sufficient evidence

SPIKE-008 will evaluate this approach using GLM-5, which has strong native tool-use capabilities and competitive reasoning depth.

**Existing SPEC-024 classifications are treated as provisional.** The 54 entries with calibrated confidence >= 0.80 are likely directionally correct. The 130 entries below 0.80 or flagged by Sonnet should be reclassified when the replacement approach is validated.

## Alternatives Considered

1. **Re-run the bottom 45 entries through Opus via the same script-driven pipeline.** Addresses the weak tail but doesn't fix the systemic over-labeling and shallow reasoning inherent in the script-mediated approach.

2. **Keep Gemini Flash + Sonnet calibration as the production pipeline.** Two models to get one answer is architecturally unsound. The calibration layer partially compensates for Gemini's weaknesses but cannot fix fundamentally wrong classifications — it can only flag them.

3. **Improve the system prompt further.** SPIKE-006 already improved YAML adherence significantly. But the prompt cannot fix a model's tendency to pattern-match rather than reason about architecture. The problem is the depth of analysis, not the instructions.

4. **Use Claude Code subagents (Sonnet 4.6) as in SPIKE-003 baseline.** Proven quality but expensive and slow for 184 entries. The subagent approach already uses native tool-calling — SPIKE-008 tests whether GLM-5 can achieve comparable quality at lower cost.

## Consequences

**Positive:**
- Acknowledges that script-mediated classification produces unreliable results for architectural analysis
- Opens the door to native tool-calling classification where the model drives its own investigation
- Existing calibration data (111 flagged entries) provides a ready-made validation set for the replacement approach
- Pipeline scripts and system prompt retained as reference for prompt engineering patterns
- The `llm` CLI itself is not abandoned — it may still be the execution vehicle if the model supports native tool-use

**Negative:**
- 184 classifications from SPEC-024 are provisional — most of the catalog needs reclassification
- Investment in `llm-review.sh`, `calibrate-confidence.sh`, and SPIKE-003-007 is partially sunk cost (though the system prompt and taxonomy are reusable)
- The replacement approach (SPIKE-008) is unproven — if it also fails, we fall back to Claude Code subagents (expensive but proven)

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Adopted | 2026-03-08 | — | Script-driven Gemini Flash classification abandoned; native tool-calling approach recommended |
