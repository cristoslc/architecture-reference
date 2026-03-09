# Design: SPEC-022 Pipeline Run and Frequency Recomputation

**Date:** 2026-03-08
**Artifact:** SPEC-022
**Status:** Approved

## Goal

Recompute frequency rankings using only production-grade catalog entries with deep-analysis classifications, per ADR-001 (equal weighting) and ADR-002 (deep-analysis only). All 184 entries are now classified via SPEC-024.

## Architecture

One new script (`pipeline/recompute-frequencies.py`) plus re-runs of two existing scripts. All read-only against the catalog.

```
catalog/*.yaml (read-only input)
        │
        ├──→ recompute-frequencies.py (NEW)
        │       ├──→ source-analysis.md
        │       └──→ frequency-recomputation.md
        │
        ├──→ quality-report.py (existing)
        │       └──→ quality-report.md
        │
        └──→ generate-index.py (existing)
                └──→ _index.yaml
```

## `recompute-frequencies.py`

**Inputs:** All YAML files in `evidence-analysis/Discovered/docs/catalog/`

**Processing:**

1. Load all entries, filter to `use_type: production` (142 entries)
2. Count style occurrences across all `architecture_styles` lists (a project can have multiple styles)
3. Split by `scope` — compute platform-only and application-only frequency tables
4. Compute combined production frequency table
5. Load the existing `source-analysis.md` to extract "before" numbers
6. Generate before/after comparison showing rank changes

**Outputs:**

- `evidence-analysis/Discovered/docs/analysis/source-analysis.md` — rewritten with production-only frequencies, platform/application splits, language distribution, domain breakdown
- `evidence-analysis/Discovered/docs/analysis/frequency-recomputation.md` — before/after comparison document

**Flags:**

- `--catalog-dir` (default: `evidence-analysis/Discovered/docs/catalog/`)
- `--output-dir` (default: `evidence-analysis/Discovered/docs/analysis/`)
- `--dry-run` — print tables to stdout without writing files

## Existing script re-runs

- `python3 pipeline/quality-report.py` — regenerates `quality-report.md`
- `python3 pipeline/generate-index.py` — rebuilds `_index.yaml`

## Before/after comparison

The "before" baseline is the current `source-analysis.md` content (from the reverted SPEC-022 run with heuristic data). The script captures it before overwriting, extracts the old frequency table, and diffs against the new one.

## What this does NOT do

- No catalog modifications
- No LLM calls or classification
- No pipeline extraction or signal processing
- No reference library updates (that's SPEC-023)

## Tech stack

- Python 3 + PyYAML
- No new dependencies beyond what `quality-report.py` and `generate-index.py` already use
