---
title: "Multi-Turn Escalation Protocol"
artifact: SPEC-011
status: Testing
author: cristos
created: 2026-03-04
last-updated: 2026-03-04
parent-epic: EPIC-005
depends-on:
  - SPEC-010
---

# Multi-Turn Escalation Protocol

## Problem Statement

When the LLM cannot classify a repo's architecture in a single pass, it needs to request additional context — specific files, directory trees, glob matches, or grep results. The pipeline must understand these structured requests, fulfill them from the repo's filesystem, and feed the results back to the LLM in subsequent turns until classification succeeds or a turn limit is reached. SPEC-010 handles the initial call and verdict routing; this spec owns the conversation loop, request fulfillment, and escalation logic.

## External Behavior

### Inputs

- **`needs_info` verdict** from SPEC-010's response parser — a JSON object containing an array of information requests
- **Repo clone path** — local filesystem path to the repo being classified
- **Previous conversation context** — accumulated prompt/response pairs from earlier turns
- **Max turns** — upper limit on LLM calls per repo (from `--max-turns` CLI flag)

### Request types

| Type | Fields | Fulfillment |
|------|--------|-------------|
| `file` | `path`, `reason` | Cat the file, truncated to 500 lines |
| `tree` | `path`, `depth`, `reason` | Directory tree at path/depth, with EPIC-005 exclusions applied |
| `glob` | `pattern`, `reason` | Glob match (e.g., `**/docker-compose*.yml`), list matching files and cat first match (500 lines) |
| `grep` | `pattern`, `path` (optional), `reason` | Search for regex pattern in repo (or subtree), return matching lines with context |

### Outputs

- **Fulfilled context payload** — assembled text of all fulfilled requests, ready to append to the next LLM call
- **Final verdict** — after subsequent turns, one of: `classified`, `unclassifiable`, or `escalation_failure` (max turns exceeded)
- **Turn log** — per-turn record of what was requested, what was fulfilled, and the LLM's response

### Preconditions

- SPEC-010's `call_llm()` has returned a `needs_info` verdict
- Repo clone is accessible on local filesystem
- `llm` CLI conversation continuation is available (via `-c` flag or equivalent)

### Postconditions

- Either a final classification is achieved (routed back to SPEC-010's `route_verdict()`), or the repo is logged as an escalation failure with `review_attempts` counter incremented

## Acceptance Criteria

- **Given** the LLM returns `needs_info` with a `file` request, **when** the file exists in the repo, **then** its content (up to 500 lines) is included in the next turn's context
- **Given** a `file` request for a path that doesn't exist, **when** fulfillment runs, **then** a "file not found" message is included in context (not a crash)
- **Given** the LLM returns `needs_info` with a `tree` request, **when** fulfillment runs, **then** the directory tree is generated with EPIC-005 exclusions applied and depth limited
- **Given** the LLM returns `needs_info` with a `grep` request, **when** fulfillment runs, **then** matching lines (up to 50) with surrounding context are included
- **Given** turn count reaches `max_turns` without classification, **when** the loop exits, **then** the repo is logged as `escalation_failure` with the turn count and last LLM response
- **Given** a repo classified on turn 2+, **when** the verdict is `classified`, **then** the result is routed to `apply-review.py` identically to a turn-1 classification
- **Given** conversation continuation across turns, **when** the LLM receives turn N+1, **then** it has access to all prior context (system prompt, initial context, all fulfilled requests, all prior responses)

## Scope & Constraints

### In scope

- Request fulfillment functions for all four request types (`file`, `tree`, `glob`, `grep`)
- Conversation loop: iterate turns until classification or max turns
- `llm` CLI conversation management (using `-c` flag or conversation ID)
- Graceful handling of unfulfillable requests (missing files, empty grep results)
- `review_attempts` counter on catalog entries to track escalation history
- Turn-level logging for debugging

### Out of scope

- Initial context assembly (SPEC-010)
- System prompt design (SPEC-010)
- Quality validation of multi-turn results (SPEC-012)
- Modifying the LLM response schema (defined in EPIC-005)

### Constraints

- Max 4 turns per repo (configurable) to control API costs
- File content truncated to 500 lines per request
- Grep results limited to 50 matching lines
- Must reuse the same `llm` conversation context across turns (not start fresh each time)

## Implementation Approach

### Functions

1. **`fulfill_requests(requests[], clone_path)`** — iterate over request array, call the appropriate fulfillment function for each, return assembled text block
2. **`fulfill_file(path, clone_path)`** — cat file, truncate to 500 lines, handle missing files
3. **`fulfill_tree(path, depth, clone_path)`** — `find` with exclusion list, format as indented tree
4. **`fulfill_glob(pattern, clone_path)`** — expand glob, list matches, cat first match
5. **`fulfill_grep(pattern, path, clone_path)`** — `grep -rn` with context, limit output
6. **`escalation_loop(initial_response, context, clone_path, max_turns)`** — main loop:
   - Parse `needs_info` response
   - Call `fulfill_requests()`
   - Append fulfilled context to conversation
   - Call `llm` with `-c` (continue conversation)
   - Parse response → if `classified`/`unclassifiable`, return; if `needs_info`, loop
   - If max turns reached, return `escalation_failure`
7. **`increment_review_attempts(entry_path)`** — bump `review_attempts` counter in catalog YAML

### Conversation management

Use `llm`'s built-in conversation continuation:
```bash
# Turn 1 (from SPEC-010)
llm -m $MODEL -s "$(cat system-prompt.md)" "$(cat context.txt)" > response1.json

# Turn 2+ (this spec)
llm -c "Here is the additional information you requested:
$(cat fulfilled_requests.txt)

Please classify this repository now." > response2.json
```

The `-c` flag continues the most recent conversation, maintaining full context.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-04 | 334cf4a | Initial creation under EPIC-005, depends on SPEC-010 |
| Approved | 2026-03-04 | b442221 | Implemented within llm-review.sh (fulfill_requests + process_entry loop) |
| Testing | 2026-03-04 | b5da2cd | Multi-turn verified: all 3 pilot entries used 2 turns |
