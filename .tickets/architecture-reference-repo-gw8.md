---
id: architecture-reference-repo-gw8
status: closed
deps: []
links: []
created: 2026-03-03T07:08:26Z
type: epic
priority: 2
external-ref: SPEC-002
---
# Implement SPEC-002: Dataset Scaling Pipeline

Batch pipeline for scaling the evidence catalog from 62 to 200+ projects. Shallow-clones repos from a curated manifest, runs extract-signals.sh, classifies via heuristic rules, writes catalog entries, generates _index.yaml, and produces a quality report.


