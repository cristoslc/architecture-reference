---
id: architecture-reference-repo-gw8.7
status: closed
deps: []
links: []
created: 2026-03-03T07:08:53Z
type: task
priority: 1
assignee: Cristos L-C
---
# Integration test: run pipeline on 5-10 repo subset

Validate end-to-end pipeline by running on a small subset of 5-10 repos. Verify: extract-signals.sh produces valid signal YAML, classify.py produces valid catalog entries, catalog entries conform to catalog-schema.yaml, _index.yaml is generated correctly, quality report is generated. Fix issues found. Acceptance: at least 80% of repos produce valid entries.


