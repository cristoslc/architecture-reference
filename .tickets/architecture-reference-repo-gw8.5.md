---
id: architecture-reference-repo-gw8.5
status: closed
deps: []
links: []
created: 2026-03-03T07:08:46Z
type: task
priority: 2
assignee: Cristos L-C
---
# Build quality report generator (quality-report.py)

Python script that generates a markdown quality report from the catalog. Shows: confidence distribution (histogram buckets), per-style coverage (count per style, target n>=10 for all 12), entries flagged for human review (confidence < 0.5), coverage gaps (styles below target). Output written to evidence-analysis/Discovered/quality-report.md.


