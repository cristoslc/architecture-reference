---
id: architecture-reference-repo-ace.3
status: closed
deps: []
links: []
created: 2026-03-05T20:58:58Z
type: task
priority: 1
---
# Rewrite SBA scorer in classify.py

Rewrite score_service_based() with 5+ signals and 0.8 max score. Add signals for shared database, coarse services, monorepo packages, deployment unit ratio. Widen service_projects range beyond 2-5. Currently only 2 signals with 0.4 max — needs parity with MS scorer.


