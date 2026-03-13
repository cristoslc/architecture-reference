---
id: architecture-reference-repo-gw8.4
status: closed
deps: []
links: []
created: 2026-03-03T07:08:43Z
type: task
priority: 2
assignee: Cristos L-C
---
# Build index generator (generate-index.py)

Python script that scans all YAML catalog entries in evidence-analysis/Discovered/docs/catalog/, aggregates them into evidence-analysis/Discovered/_index.yaml. Includes: generated timestamp, source metadata, total_projects count, project list, architecture_style_frequency distribution, language_coverage breakdown. Format matches existing _index.yaml in ReferenceArchitectures.


