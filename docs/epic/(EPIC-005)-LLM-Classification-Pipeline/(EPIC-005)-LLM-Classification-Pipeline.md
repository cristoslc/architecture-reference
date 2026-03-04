---
title: "LLM Classification Pipeline"
artifact: EPIC-005
status: Active
author: cristos
created: 2026-03-04
last-updated: 2026-03-04
parent-vision: VISION-001
success-criteria:
  - All Indeterminate catalog entries (currently 120) processed through the LLM review pipeline
  - Multi-turn escalation resolves repos that single-pass review cannot classify
  - Pipeline is idempotent and re-runnable — always targets any entry with review_required=true
  - Classification accuracy >= 85% when validated against manually reviewed samples
  - Integrates with existing apply-review.py without breaking the catalog schema
depends-on:
  - EPIC-003
---

# LLM Classification Pipeline

## Goal / Objective

Automate Pass 2 (LLM review) of the architecture classification pipeline using the `llm` CLI. The current pipeline has a working heuristic classifier (Pass 1) but no automated LLM review. 120 of 163 catalog entries sit at `Indeterminate` with `review_required: true` because their heuristic confidence fell below 0.85. Today, reviewing these requires an agent to manually inspect each repo — this epic replaces that with a scripted, multi-turn `llm` pipeline that can run unattended.

The pipeline must handle ambiguous repos gracefully: when the LLM cannot classify a repo in a single pass, it returns structured information requests (e.g., "need to see the docker-compose.yml" or "need the top-level directory tree"), and the pipeline fulfills those requests in subsequent passes until classification succeeds or the repo is marked as genuinely unclassifiable.

## Scope Boundaries

### In scope

- **`llm`-based review script** that processes individual catalog entries through the `llm` CLI
- **Multi-turn conversation loop** per repo — the LLM can request additional context, and the pipeline provides it
- **Structured escalation protocol** — JSON schema for LLM responses that distinguishes "here's my classification" from "I need more information"
- **Context assembly** — building the prompt payload from: catalog YAML (signals, heuristic candidates), README excerpt, repo map (directory tree), and any additional files the LLM requests
- **Integration with `apply-review.py`** — script output feeds directly into the existing review application tooling
- **Idempotent execution** — pipeline scans for `review_required: true` entries and processes them; safe to run repeatedly
- **Pilot tier strategy** — configurable confidence-band targeting for incremental rollout (0.70-0.84 first, then lower bands)
- **Run log and reporting** — structured output showing what was classified, what escalated, what remains unresolved

### Out of scope

- Changes to the heuristic classifier (`classify.py`) — this epic adds a second pass, not a replacement
- Training custom models — uses `llm` CLI with existing foundation models
- Modifying the catalog YAML schema (the `apply-review.py` contract is stable)
- Cloning repos at review time — relies on context already extractable from the shallow clone made during signal extraction (or a fresh shallow clone if needed)

## Pipeline Design

### Architecture

```
┌─────────────────────────────────────────────────────────┐
│  llm-review.sh                                          │
│                                                         │
│  1. Scan catalog for review_required: true              │
│  2. For each entry:                                     │
│     ┌──────────────────────────────────────────────┐    │
│     │  Context Assembly                            │    │
│     │  - catalog YAML (signals, heuristic scores)  │    │
│     │  - README (first 300 lines)                  │    │
│     │  - repo map (directory tree, depth 3)        │    │
│     │  - manifest.yaml metadata (domain, priority) │    │
│     └──────────────┬───────────────────────────────┘    │
│                    ▼                                    │
│     ┌──────────────────────────────────────────────┐    │
│     │  llm CLI call (turn N)                       │    │
│     │  System prompt + assembled context           │    │
│     │  → JSON response                             │    │
│     └──────────────┬───────────────────────────────┘    │
│                    ▼                                    │
│     ┌──────────────────────────────────────────────┐    │
│     │  Response Router                             │    │
│     │                                              │    │
│     │  verdict == "classified"                     │    │
│     │    → apply-review.py                         │    │
│     │                                              │    │
│     │  verdict == "needs_info"                     │    │
│     │    → fulfill requests → loop to turn N+1     │    │
│     │                                              │    │
│     │  verdict == "unclassifiable"                 │    │
│     │    → log reason, mark reviewed but keep      │    │
│     │      Indeterminate                           │    │
│     │                                              │    │
│     │  Max turns exceeded                          │    │
│     │    → log as escalation failure               │    │
│     └──────────────────────────────────────────────┘    │
│                                                         │
│  3. Generate run report                                 │
└─────────────────────────────────────────────────────────┘
```

### LLM Response Schema

Every `llm` call must return JSON conforming to one of three verdict types:

```json
{
  "verdict": "classified",
  "styles": ["Event-Driven", "Microservices"],
  "confidence": 0.90,
  "summary": "One-line description of what the system does and how",
  "notes": "Evidence citations: docker-compose.yml shows RabbitMQ + 4 service containers...",
  "entry_type": "repo"
}
```

```json
{
  "verdict": "needs_info",
  "requests": [
    {
      "type": "file",
      "path": "docker-compose.yml",
      "reason": "Need to see service definitions to distinguish Microservices from Modular Monolith"
    },
    {
      "type": "tree",
      "path": "src/",
      "depth": 2,
      "reason": "Need to see module boundaries"
    },
    {
      "type": "file",
      "path": "ARCHITECTURE.md",
      "reason": "Project may self-document its architecture"
    }
  ]
}
```

```json
{
  "verdict": "unclassifiable",
  "reason": "Repository is a data-only dataset (no application code). Not an architecture exemplar.",
  "confidence": 0.95,
  "notes": "Contains only CSV files and a Jupyter notebook for analysis."
}
```

### Context Assembly Strategy

**Turn 1 (always provided):**

| Source | Content | Size limit |
|--------|---------|------------|
| Catalog YAML | Full entry including signal_breakdown, heuristic_candidates | Full |
| README | First 300 lines of README.md (or README.rst, README.txt) | ~300 lines |
| Repo map | `find` tree of repo root, depth 3, excluding dependency/build/VCS directories (see exclusion list below) | ~200 lines |
| Manifest metadata | domain, priority, expected_styles from manifest.yaml | Few lines |

**Repo map exclusion list** (directories pruned from `find` tree):

| Category | Excluded directories |
|----------|---------------------|
| VCS | `.git`, `.svn`, `.hg` |
| Node.js | `node_modules` |
| Python | `__pycache__`, `.venv`, `venv`, `.tox`, `.eggs`, `*.egg-info` |
| Java/Kotlin | `target`, `.gradle`, `build`, `.mvn` |
| .NET/C# | `bin`, `obj`, `packages` |
| Go | `vendor` |
| Rust | `target` |
| Ruby | `.bundle`, `vendor/bundle` |
| PHP | `vendor` |
| Elixir | `_build`, `deps` |
| Swift/Xcode | `.build`, `DerivedData`, `Pods` |
| General build | `dist`, `out`, `.next`, `.nuxt`, `.output` |
| IDE/tooling | `.idea`, `.vs`, `.vscode`, `.eclipse` |
| Misc | `.cache`, `.tmp`, `coverage`, `.nyc_output`, `__snapshots__` |

**Turn 2+ (on `needs_info` response):**

The pipeline fulfills each request object:
- `type: "file"` — cat the requested file (truncated to 500 lines)
- `type: "tree"` — directory tree at the requested path and depth
- `type: "glob"` — glob pattern match (e.g., `**/docker-compose*.yml`)
- `type: "grep"` — search for a pattern in the repo (e.g., `@EventHandler`)

Fulfilled content is appended to the conversation context for the next `llm` call.

### Multi-Turn Protocol

- **Max turns per repo:** 4 (configurable via `--max-turns`)
- **Turn 1:** System prompt + initial context → LLM responds
- **Turn 2-4:** Previous context + fulfilled info requests → LLM responds
- **If max turns exceeded with no classification:** Log as `escalation_failure`, keep `review_required: true` with a `review_attempts` counter so future runs can skip or re-attempt with different strategy
- **Conversation continuity:** Use `llm`'s conversation/continuation features (or `-c` flag) to maintain context across turns

### Repo Access Strategy

The pipeline needs repo file access for context assembly and `needs_info` fulfillment. Two modes:

1. **Cached clone** — If the repo was already shallow-cloned during signal extraction and still exists in the pipeline's work directory, use it directly
2. **On-demand clone** — If no cached clone exists, do a fresh `git clone --depth 1` into a temp directory, use it for all turns, then clean up

The script should accept a `--clone-dir` flag to specify where cached clones live.

### Pilot Tier Strategy

The `--tier` flag controls which confidence band to process:

| Tier | Confidence range | Rationale |
|------|-----------------|-----------|
| 1 | 0.70 – 0.84 | Closest to threshold; likely need minimal LLM help |
| 2 | 0.50 – 0.69 | Medium ambiguity; may need multi-turn |
| 3 | 0.30 – 0.49 | High ambiguity; structural signals weak |
| all | 0.00 – 0.84 | Full run (default for production) |

Without `--tier`, the pipeline processes all `review_required: true` entries regardless of confidence band.

### Integration Points

```bash
# Typical invocation
pipeline/llm-review.sh --tier 1 --max-turns 3 --model claude-sonnet-4-6

# Full run (all indeterminate entries)
pipeline/llm-review.sh

# Dry run (show what would be processed)
pipeline/llm-review.sh --dry-run

# Output feeds into existing tooling:
# llm-review.sh calls apply-review.py per classified repo
python3 pipeline/apply-review.py \
  --entry evidence-analysis/Discovered/docs/catalog/some-repo.yaml \
  --styles "Event-Driven,Microservices" \
  --confidence 0.92 \
  --summary "..." \
  --notes "..."
```

### System Prompt Design

The LLM system prompt must include:

1. The 13 canonical architecture styles with their defining structural characteristics
2. The evidence-based signal rules from `skills/discover-architecture/references/signal-rules.md`
3. Instructions to respond ONLY in the JSON schema above
4. Guidance on when to request more info vs. making a judgment call
5. Instruction to cite specific files/directories as evidence (not just "it looks like")
6. The confidence scale calibration: 0.85+ = high confidence, 0.70-0.84 = moderate, below 0.70 = low

### Run Reporting

Each run produces a JSON report:

```json
{
  "run_id": "2026-03-04T14:30:00Z",
  "model": "claude-sonnet-4-6",
  "tier": "1",
  "max_turns": 3,
  "entries_processed": 28,
  "classified": 22,
  "needs_manual_review": 3,
  "unclassifiable": 2,
  "escalation_failures": 1,
  "total_llm_calls": 38,
  "results": [
    {
      "entry": "some-repo.yaml",
      "verdict": "classified",
      "turns": 2,
      "styles": ["Event-Driven"],
      "confidence": 0.90
    }
  ]
}
```

## Child Specs

| ID | Title | Status |
|----|-------|--------|
| [SPEC-010](../../spec/(SPEC-010)-LLM-Review-Script/(SPEC-010)-LLM-Review-Script.md) | LLM Review Script | Draft |
| [SPEC-011](../../spec/(SPEC-011)-Multi-Turn-Escalation-Protocol/(SPEC-011)-Multi-Turn-Escalation-Protocol.md) | Multi-Turn Escalation Protocol | Draft |
| [SPEC-012](../../spec/(SPEC-012)-Quality-Validation/(SPEC-012)-Quality-Validation.md) | Quality Validation | Draft |

## Key Dependencies

- **EPIC-003** — The discovery pipeline and catalog schema this builds on
- **`llm` CLI** — Must be installed and configured with API access (e.g., `llm -m claude-sonnet-4-6`)
- **`apply-review.py`** — Existing integration point (no changes needed)
- **Repo access** — Cached shallow clones or ability to clone on-demand

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-04 | 5b2e916 | 120 Indeterminate entries awaiting automated LLM review |
| Active | 2026-03-04 | 6db2360 | Child specs SPEC-010/011/012 being created |
