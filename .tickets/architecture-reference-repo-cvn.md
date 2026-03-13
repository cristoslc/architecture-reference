---
id: architecture-reference-repo-cvn
status: closed
deps: []
links: []
created: 2026-03-09T02:47:16Z
type: epic
priority: 2
external-ref: SPEC-022
---
# SPEC-022: Pipeline Run and Frequency Recomputation

Ingested from docs/plans/2026-03-08-spec022-frequency-recomputation.md. Goal: Recompute frequency rankings from production-only catalog entries now that all 184 entries have deep-analysis classifications (SPEC-024 complete, zero Indeterminate).. Architecture: One new read-only script (`pipeline/recompute-frequencies.py`) computes production-only frequency tables with platform/application splits and before/after comparison. Two existing scripts (`quality-report.py`, `generate-index.py`) are re-run to regenerate their respective artifacts. All scripts read catalog YAML files and write analysis markdown/YAML — no catalog modifications..


