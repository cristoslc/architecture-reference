---
title: "Signal Data Retirement"
artifact: SPEC-036
status: Implemented
type: enhancement
author: cristos
created: 2026-03-13
last-updated: 2026-03-13
parent-epic:
linked-adrs:
  - ADR-007
linked-research: []
depends-on: []
swain-do: required
evidence-pool: ""
---

# Signal Data Retirement

## Problem Statement

ADR-007 drops signal extraction entirely from the pipeline. SPEC-032 already retired the heuristic scripts (`classify.py`, `extract-signals.sh`, `llm-review.sh`), but 184 signal YAML files remain in `evidence-analysis/Discovered/signals/` (~488KB). These files have no downstream consumer — the active pipeline (`classify-tooluse.sh`) does not reference them.

## External Behavior

**Inputs:** Current repo state with dead signal data files.

**Outputs:** Signal data files removed; any references to the signals directory updated or removed.

**Preconditions:** ADR-007 adopted (signal extraction dropped).

**Postconditions:**
- `evidence-analysis/Discovered/signals/` directory removed
- No remaining code references to the signals directory (outside of historical artifact docs)
- `scripts/spec020-cleanup.py` retired if it has no other purpose

## Acceptance Criteria

| ID | Criterion | Verification |
|----|-----------|--------------|
| AC-1 | `evidence-analysis/Discovered/signals/` directory does not exist | `ls evidence-analysis/Discovered/signals/` returns error |
| AC-2 | No active scripts reference `Discovered/signals` | `grep -r 'Discovered/signals' pipeline/ scripts/ --include='*.py' --include='*.sh'` returns no hits |
| AC-3 | `scripts/spec020-cleanup.py` removed if dead | File does not exist or has been verified as still needed |

## Scope & Constraints

**In scope:**
- Remove signal YAML files
- Remove orphaned scripts that only existed to support signal data
- Update any active documentation references (not historical artifact docs)

**Out of scope:**
- Changing historical artifact documents (SPEC-004, EPIC-004) — these are records of what was done
- Pipeline script changes (already clean per SPEC-032)

## Verification

| AC | Result | Evidence |
|----|--------|----------|
| AC-1 | PASS | `ls evidence-analysis/Discovered/signals/` returns "No such file or directory" |
| AC-2 | PASS | `grep -r 'Discovered/signals' pipeline/ scripts/ --include='*.py' --include='*.sh'` returns no hits |
| AC-3 | PASS | `scripts/spec020-cleanup.py` removed; confirmed dead code (only consumer of signals directory) |

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-13 | — | Initial creation per ADR-007 |
| Implemented | 2026-03-13 | 4c2ce9ce | 184 signal YAML files + spec020-cleanup.py removed; all ACs pass |
