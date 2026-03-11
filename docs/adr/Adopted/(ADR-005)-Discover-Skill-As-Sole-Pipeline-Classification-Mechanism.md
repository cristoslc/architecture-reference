---
title: "Discover Skill As Sole Pipeline Classification Mechanism"
artifact: ADR-005
status: Adopted
author: cristos
created: 2026-03-09
last-updated: 2026-03-10
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

There is also an **output format gap**. The discover skill produces a markdown report (`report.template.j2`) with lightweight YAML frontmatter (project, date, styles, confidence). The pipeline expects structured YAML catalog entries with fields like `classification_status`, `classification_method`, `classification_model`, `classification_reasoning`, `classification_date`, and `classification_confidence`. The skill's `SKILL.md` references `references/catalog-entry.template.j2` for YAML catalog output — but this file does not exist. The two output worlds (human-readable report vs. machine-consumable catalog entry) are disconnected, with parsing scripts (`apply-review.py`, `apply-tooluse-result.py`) each implementing their own extraction logic to bridge the gap.

## Decision

**Use the discover skill as the single specification for all pipeline classification, regardless of the underlying model or invocation method.**

Concretely:

1. **The discover skill's `SKILL.md` and `references/` are the sole source of truth** for classification methodology, canonical styles, evidence criteria, and output format. No parallel system prompts.

2. **The discover skill produces dual output: a markdown report AND a structured YAML catalog entry.** Every classification — interactive or batch — yields both artifacts:
   - **Report** (`report.template.j2`): human-readable markdown with style rationales, evidence citations, quality attributes. Saved to `docs/architecture-reports/`.
   - **Catalog entry** (`references/catalog-entry.template.j2`): machine-consumable YAML with the fields the pipeline requires — `project_name`, `architecture_styles`, `classification_status`, `classification_confidence`, `classification_model`, `classification_method`, `classification_date`, `classification_reasoning`, `domain`, `scope`, `use_type`, `quality_attributes`. Both templates share the same variable namespace — one classification pass populates both. The catalog template is defined once in the skill and becomes the contract between classification and catalog ingestion.

   The report is the authoritative analysis; the catalog entry is a structured projection of it. Both are produced from the same classification pass — no separate extraction or parsing step.

3. **For Claude Code subagents** (Sonnet, Opus): invoke the discover skill directly. The skill instructions tell the agent to produce both outputs. This already works for reports; the catalog entry output is new but follows the same pattern.

4. **For non-Anthropic models via `llm` CLI** (GLM-5, Gemini, Kimi, etc.): generate the system prompt from the discover skill's content at invocation time. The pipeline script reads `SKILL.md` + `references/styles.md` + `references/catalog-entry.template.j2` and assembles them into the system prompt passed to `llm -s`. The model is instructed to return the catalog YAML as frontmatter and the report as body — one response, both outputs. Tool definitions (`repo_tools.py`) remain as the mechanical interface, but the classification instructions and output schema come from the skill, not from separate prompt files.

5. **Retire `prompts/system-prompt-tooluse.md`, `prompts/system-prompt.md`, and `prompts/response-schema.json`** as independent documents. The skill's catalog entry template replaces the response schema. If model-specific adaptations are needed (e.g., explicit JSON-mode forcing for models that struggle with YAML), these are thin wrappers around the skill content, not standalone specifications.

6. **Retire `apply-review.py` and `apply-tooluse-result.py`** as bespoke parsing scripts. Since the model outputs catalog YAML directly (per the skill's schema), the pipeline only needs a generic YAML loader to ingest results — no per-mechanism parsing logic.

7. **The `references/styles.md` taxonomy is shared.** Both Claude and non-Anthropic models classify against the same 12 styles with the same evidence criteria. Style definitions are maintained once, in the skill.

The key insight: the discover skill is not Claude-specific. Its methodology — read entrypoints, inspect dependency graphs, trace communication patterns, classify with evidence — is model-agnostic. Any LLM with tool access to a repository can follow these instructions. The skill happens to be packaged as a Claude Code skill, but its content is a classification specification that any capable model can execute. The dual-output requirement makes this explicit: the skill defines not just how to classify, but what the classification output looks like in both human and machine contexts.

## Alternatives Considered

1. **Maintain separate system prompts per model family.** Status quo. Each model gets its own tuned prompt. Rejected because: (a) the prompts already converge on the same methodology — the discover skill — they just express it differently; (b) maintaining N prompts that must stay synchronized with one specification is a liability; (c) SPIKE-004 showed that model quality differences come from reasoning depth, not prompt differences.

2. **Fork the discover skill into a "pipeline-discover" variant.** Create a stripped-down version optimized for batch pipeline use (structured output only, no human-readable report). Rejected because both outputs serve real needs — the report for review and audit, the catalog entry for ingestion — and maintaining a fork would immediately start drifting.

3. **Replace all non-Anthropic classification with Claude subagents.** Use only Claude Code agents and drop `llm` CLI entirely. Rejected because: (a) cost — Opus at $0.02-0.10/repo vs GLM-5 at $0.01-0.03/repo matters at 184+ entries; (b) vendor lock-in — the project benefits from model diversity for validation; (c) SPIKE-004 showed GLM-5 with tool-calling achieves 80% baseline agreement, sufficient for primary classification with Claude QA passes.

4. **Embed the skill content directly into `classify-tooluse.sh`.** Inline the methodology instead of reading it at runtime. Rejected because this recreates the drift problem — the embedded copy diverges from the skill as soon as either is edited.

## Consequences

**Positive:**
- Single source of truth for classification methodology — edit the skill, all pipeline paths update
- Single output template (`catalog-entry.template.j2`) replaces three bespoke parsing paths (`response-schema.json` → `apply-review.py`, freeform text → `apply-tooluse-result.py`, native agent → manual extraction)
- Non-Anthropic models benefit from skill improvements (new evidence criteria, refined style definitions, schema changes) without separate prompt or parser maintenance
- Pipeline scripts become thinner — they handle invocation mechanics (cloning, tool definitions, YAML loading) while the skill handles classification logic and output format
- Validates that the discover skill is genuinely model-agnostic, which strengthens its value as a distributable skill
- Dual output means interactive users get reports and the pipeline gets catalog entries from the same classification pass — no re-classification or post-hoc extraction

**Negative:**
- The discover skill's `SKILL.md` is written for interactive Claude Code use — some framing ("Run these in parallel", "Read at least 2-3 entrypoint files") may need light adaptation for batch contexts without creating a fork
- Non-Anthropic models with weaker instruction-following may need thin model-specific wrappers (e.g., explicit JSON-mode forcing for models that can't reliably produce YAML frontmatter) on top of the skill content
- The catalog entry template must be maintained in the skill alongside the report template — though the fields are well-established from the existing catalog entries
- Runtime assembly of the system prompt from skill files adds a file-read step to pipeline invocation (negligible cost, but a new dependency)
- The skill becomes load-bearing infrastructure for the pipeline — changes to `SKILL.md` or either template affect batch classification, not just interactive use

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-09 | — | Unify pipeline classification around discover skill |
| Adopted | 2026-03-10 | 97bb2c00 | Decision adopted — all pipeline classification via discover skill |
