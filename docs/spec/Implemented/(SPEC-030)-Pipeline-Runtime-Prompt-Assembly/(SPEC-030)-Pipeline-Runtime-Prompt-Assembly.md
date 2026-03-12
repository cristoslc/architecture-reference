---
title: "Pipeline Runtime Prompt Assembly"
artifact: SPEC-030
status: Implemented
author: cristos
created: 2026-03-10
last-updated: 2026-03-10
parent-epic: EPIC-013
linked-research: []
linked-adrs:
  - ADR-005
depends-on:
  - SPEC-029
addresses: []
evidence-pool: ""
swain-do: required
---

# Pipeline Runtime Prompt Assembly

## Problem Statement

`classify-tooluse.sh` reads its system prompt from `pipeline/prompts/system-prompt-tooluse.md` — a standalone file maintained separately from the discover skill. ADR-005 requires all classification instructions to derive from the discover skill at invocation time. The pipeline script must be refactored to assemble its system prompt from the skill's `SKILL.md`, `references/styles.md`, and `references/catalog-entry.template.j2`, eliminating the standalone prompt as a source of drift.

## External Behavior

### Input

- `classify-tooluse.sh` invocation with `--repo` and `--name` flags (unchanged API)
- The discover skill files: `skills/discover-architecture/SKILL.md`, `references/styles.md`, `references/catalog-entry.template.j2`

### Output

- The model receives a system prompt assembled from discover skill content (not from `pipeline/prompts/system-prompt-tooluse.md`)
- Classification output follows the catalog-entry template schema
- The script's external interface (flags, exit codes, stdout behavior) is unchanged

### Preconditions

- SPEC-029 complete (catalog entry template validated, dual-output instructions in skill)
- `classify-tooluse.sh` exists and works with the current standalone prompt

### Postconditions

- `classify-tooluse.sh` reads the discover skill files at runtime
- The standalone prompt file is no longer read by any pipeline script
- Classifications are instruction-compatible with the discover skill methodology

## Acceptance Criteria

- **Given** the refactored `classify-tooluse.sh`, **when** run with `--dry-run`, **then** the assembled system prompt contains content from `SKILL.md`, `styles.md`, and `catalog-entry.template.j2`
- **Given** a classification run, **when** the model produces output, **then** the output conforms to the catalog-entry template schema (YAML frontmatter with the required fields)
- **Given** the discover skill's `styles.md` is updated (e.g., a style description changes), **when** `classify-tooluse.sh` runs next, **then** the system prompt reflects the update without any manual prompt file edits

### Constraints

- The `llm` CLI's `--functions` flag for tool definitions remains unchanged — `repo_tools.py` continues to provide the mechanical interface
- Model-specific thin wrappers (e.g., JSON-mode forcing) are acceptable as long as they layer on top of skill content, not replace it

## Verification

| Criterion | Evidence | Result |
|-----------|----------|--------|
| --show-prompt contains SKILL.md, styles.md, and template content | `classify-tooluse.sh --show-prompt` outputs 411-line prompt; grep confirms content from all three skill files | Pass |
| Output conforms to catalog-entry template schema | SPEC-031 reclassified 184 entries via this script; all produced valid catalog YAML | Pass |
| Skill file changes auto-propagate | `assemble_system_prompt()` reads files at runtime (lines 72-127); no cached/standalone prompt exists | Pass |

## Scope & Constraints

### In scope

- Refactoring `classify-tooluse.sh` to read discover skill files
- Building the system prompt assembly logic (concatenation + minimal framing)
- Adding `--dry-run` output showing the assembled prompt for debugging
- Testing with one real classification

### Out of scope

- Changing the tool definitions (`repo_tools.py`) — those remain as-is
- Running the full reclassification campaign (SPEC-031)
- Removing legacy files (SPEC-032 — after this spec proves they're unused)

## Implementation Approach

1. Add a prompt assembly function to `classify-tooluse.sh` that reads `SKILL.md` + `styles.md` + `catalog-entry.template.j2` and concatenates them with minimal framing for the `llm` CLI context
2. Replace the `SYSTEM_PROMPT_FILE` read with the assembled prompt
3. Add a `--show-prompt` flag to dump the assembled prompt for debugging
4. Test with `--dry-run` to verify the assembled prompt content
5. Run one real classification to validate output schema compliance

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-10 | 398ebe55 | Initial creation under EPIC-013 |
| Implemented | 2026-03-11 | a288b1da | Already implemented: classify-tooluse.sh assembles prompt from discover skill at runtime |
