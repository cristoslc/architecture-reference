---
id: architecture-reference-repo-gw8.2
status: closed
deps: []
links: []
created: 2026-03-03T07:08:36Z
type: task
priority: 1
assignee: Cristos L-C
---
# Build heuristic classifier (classify.py)

Python script that codifies signal-rules.md into an algorithmic classifier. Reads signal YAML from stdin (extract-signals.sh output), applies scoring rules (strong +0.3, supporting +0.1, thresholds, conflict rules), outputs catalog YAML conforming to catalog-schema.yaml. Stdlib only (+ PyYAML). Must handle: multi-style composition, confidence capping, Indeterminate classification, quality attribute inference.


