---
title: "Legacy Pipeline Retirement"
artifact: SPEC-032
status: Draft
author: cristos
created: 2026-03-10
last-updated: 2026-03-10
parent-epic: EPIC-013
linked-research: []
linked-adrs:
  - ADR-005
  - ADR-002
  - ADR-003
depends-on:
  - SPEC-030
  - SPEC-031
addresses: []
evidence-pool: ""
swain-do: required
---

# Legacy Pipeline Retirement

## Problem Statement

ADR-005 makes the discover skill the single classification specification, ADR-002 abandoned heuristic classification, and ADR-003 abandoned script-driven LLM multi-turn. Multiple legacy files remain in the codebase that are no longer used by any active pipeline path. These should be removed to prevent confusion, reduce maintenance burden, and make the codebase reflect the current architecture.

## External Behavior

### Input

- Legacy files to remove:
  - `pipeline/prompts/system-prompt-tooluse.md` — standalone prompt (replaced by discover skill via SPEC-030)
  - `pipeline/prompts/system-prompt.md` — original llm-review prompt (abandoned per ADR-003)
  - `pipeline/prompts/response-schema.json` — response schema (replaced by `catalog-entry.template.j2`)
  - `pipeline/apply-review.py` — parser for llm-review output (abandoned per ADR-003)
  - `pipeline/apply-tooluse-result.py` — parser for tool-calling output (replaced by generic YAML loading)
  - `pipeline/llm-review.sh` — multi-turn llm review script (abandoned per ADR-003)
  - `pipeline/classify.py` — heuristic classifier (abandoned per ADR-002)
  - `pipeline/prompts/validation-prompt.md` — validation prompt (superseded by discover skill methodology)

### Output

- Listed files removed from the repository
- Any internal references to removed files updated or removed
- A brief CHANGELOG-style note documenting what was retired and why (ADR references)

### Preconditions

- SPEC-030 complete (pipeline no longer reads standalone prompts)
- No other script imports or sources the files being removed

### Postconditions

- Removed files are no longer in the working tree
- No broken references (scripts, docs, or specs pointing to removed files)
- Git history preserves the files for archaeology

## Acceptance Criteria

- **Given** the listed legacy files, **when** removed, **then** `classify-tooluse.sh` still runs successfully with the discover-skill-based prompt assembly
- **Given** the codebase after removal, **when** searched for references to removed filenames, **then** no live references exist (only historical references in ADRs and completed specs are acceptable)
- **Given** the retirement, **when** `pipeline/` is listed, **then** only active scripts and their supporting files remain

## Verification

| Criterion | Evidence | Result |
|-----------|----------|--------|

## Scope & Constraints

### In scope

- Removing the listed legacy files
- Updating any live references (scripts, active specs, EPIC docs)
- Documenting the retirement

### Out of scope

- Removing `pipeline/reports/` historical data (those are audit records)
- Removing `pipeline/gold-standard/` (still used for validation)
- Removing `pipeline/tools/repo_tools.py` (still used by classify-tooluse.sh)
- Archiving to a separate branch (git history suffices)

## Implementation Approach

1. Search for all references to each target file across the codebase (scripts, docs, specs)
2. Categorize references as "live" (in active code/scripts) vs. "historical" (in completed/abandoned specs, ADRs)
3. Update or remove live references
4. `git rm` all target files
5. Verify `classify-tooluse.sh --dry-run` still works
6. Commit with a clear message referencing ADR-002, ADR-003, and ADR-005

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-10 | 398ebe55 | Initial creation under EPIC-013 |
