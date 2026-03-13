---
id: architecture-reference-repo-gw8.3
status: closed
deps: []
links: []
created: 2026-03-03T07:08:39Z
type: task
priority: 1
assignee: Cristos L-C
---
# Build batch orchestrator (run-pipeline.sh)

Shell script that reads pipeline/manifest.yaml, shallow-clones repos to a temp directory, runs extract-signals.sh on each, pipes through classify.py, writes catalog entries to evidence-analysis/Discovered/docs/catalog/. Supports configurable concurrency, idempotent (skips already-cataloged repos), handles clone failures gracefully, cleans up temp dirs.


