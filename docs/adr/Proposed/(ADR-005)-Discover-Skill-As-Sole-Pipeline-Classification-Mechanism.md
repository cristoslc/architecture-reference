---
title: "Discover Skill As Sole Pipeline Classification Mechanism"
artifact: ADR-005
status: Proposed
author: cristos
created: 2026-03-09
last-updated: 2026-03-09
linked-epics:
  - EPIC-012
linked-specs:
  - SPEC-024
depends-on:
  - ADR-002
  - ADR-003
---

# Discover Skill As Sole Pipeline Classification Mechanism

## Context

The pipeline currently maintains four separate mechanisms for architecture classification:

1. **Heuristic classifier** (`classify.py`) — filesystem signal counting with algorithmic rules. Already abandoned per ADR-002.
2. **Script-driven LLM multi-turn** (`llm-review.sh`) — bash mediates context assembly and `needs_info` escalation via the `llm` CLI. Already abandoned per ADR-003.
3. **Claude Code subagent classification** — native Claude agents (Sonnet/Opus) with full tool access exploring cloned repos. Proven highest quality (SPIKE-003 baseline).
4. **Native LLM tool-calling** (`classify-tooluse.sh` + `repo_tools.py`) — non-Anthropic models (GLM-5, GLM-4.7, Kimi K2.5) with function definitions via OpenRouter. Primary mechanism for SPEC-024 (173/184 entries classified via GLM-5).

Meanwhile, the `discover-architecture` skill (`skills/discover-architecture/SKILL.md`) already codifies the complete classification methodology: the 12 canonical styles, the 6-step analysis process (inventory → inspect → classify → scope → quality attributes → domain), evidence criteria, output format, and edge case handling. This is the same methodology the Claude subagents follow — the skill IS the specification.

The problem is that mechanisms 3 and 4 implement the same intellectual process through completely different code paths:

- **Claude subagents** receive the discover skill as their system prompt and use native Claude Code tools (Read, Grep, Glob, Bash). The skill specification directly governs their behavior.
- **Tool-calling models** receive a separate system prompt (`prompts/system-prompt-tooluse.md`) and use separately defined tools (`tools/repo_tools.py` with `read_file()`, `directory_tree()`, `find_files()`, `search_content()`, `shell_command()`). These tools approximate what the skill describes but are maintained independently.

This creates drift. When the skill's methodology evolves (new styles, refined evidence criteria, updated output format), both the tool-calling system prompt and the Claude subagent invocation must be updated separately. The discover skill is already the authoritative source — the pipeline scripts just don't use it yet.

## Decision

**Use the discover skill as the single specification for all pipeline classification, regardless of the underlying model or invocation method.**

Concretely:

1. **The discover skill's `SKILL.md` and `references/` are the sole source of truth** for classification methodology, canonical styles, evidence criteria, and output format. No parallel system prompts.

2. **For Claude Code subagents** (Sonnet, Opus): invoke the discover skill directly. This already works — the skill is designed for Claude Code agents. No change needed.

3. **For non-Anthropic models via `llm` CLI** (GLM-5, Gemini, Kimi, etc.): generate the system prompt from the discover skill's content at invocation time. The pipeline script reads `SKILL.md` + `references/styles.md` and assembles them into the system prompt passed to `llm -s`. Tool definitions (`repo_tools.py`) remain as the mechanical interface — but the classification instructions come from the skill, not from a separate prompt file.

4. **Retire `prompts/system-prompt-tooluse.md` and `prompts/system-prompt.md`** as independent documents. If model-specific adaptations are needed (e.g., output format adjustments for models that struggle with YAML), these are thin wrappers around the skill content, not standalone specifications.

5. **The `references/styles.md` taxonomy is shared.** Both Claude and non-Anthropic models classify against the same 12 styles with the same evidence criteria. Style definitions are maintained once, in the skill.

The key insight: the discover skill is not Claude-specific. Its methodology — read entrypoints, inspect dependency graphs, trace communication patterns, classify with evidence — is model-agnostic. Any LLM with tool access to a repository can follow these instructions. The skill happens to be packaged as a Claude Code skill, but its content is a classification specification that any capable model can execute.

## Alternatives Considered

1. **Maintain separate system prompts per model family.** Status quo. Each model gets its own tuned prompt. Rejected because: (a) the prompts already converge on the same methodology — the discover skill — they just express it differently; (b) maintaining N prompts that must stay synchronized with one specification is a liability; (c) SPIKE-004 showed that model quality differences come from reasoning depth, not prompt differences.

2. **Fork the discover skill into a "pipeline-discover" variant.** Create a stripped-down version optimized for batch pipeline use (no interactive output, machine-parseable only). Rejected because the skill already produces structured output (YAML catalog entries) and the 6-step process works in both interactive and batch contexts. A fork would immediately start drifting.

3. **Replace all non-Anthropic classification with Claude subagents.** Use only Claude Code agents and drop `llm` CLI entirely. Rejected because: (a) cost — Opus at $0.02-0.10/repo vs GLM-5 at $0.01-0.03/repo matters at 184+ entries; (b) vendor lock-in — the project benefits from model diversity for validation; (c) SPIKE-004 showed GLM-5 with tool-calling achieves 80% baseline agreement, sufficient for primary classification with Claude QA passes.

4. **Embed the skill content directly into `classify-tooluse.sh`.** Inline the methodology instead of reading it at runtime. Rejected because this recreates the drift problem — the embedded copy diverges from the skill as soon as either is edited.

## Consequences

**Positive:**
- Single source of truth for classification methodology — edit the skill, all pipeline paths update
- Non-Anthropic models benefit from skill improvements (new evidence criteria, refined style definitions) without separate prompt maintenance
- Pipeline scripts become thinner — they handle invocation mechanics (cloning, tool definitions, output parsing) while the skill handles classification logic
- Validates that the discover skill is genuinely model-agnostic, which strengthens its value as a distributable skill
- Reduces the surface area for methodology drift between Claude and non-Anthropic classification runs

**Negative:**
- The discover skill's `SKILL.md` is written for interactive Claude Code use — some framing ("Run these in parallel", "Read at least 2-3 entrypoint files") may need light adaptation for batch contexts without creating a fork
- Non-Anthropic models with weaker instruction-following may need thin model-specific wrappers (e.g., explicit YAML schema enforcement for GLM-5) on top of the skill content
- Runtime assembly of the system prompt from skill files adds a file-read step to pipeline invocation (negligible cost, but a new dependency)
- The skill becomes load-bearing infrastructure for the pipeline — changes to `SKILL.md` affect batch classification, not just interactive use

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-09 | — | Unify pipeline classification around discover skill |
