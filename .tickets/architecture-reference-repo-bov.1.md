---
id: architecture-reference-repo-bov.1
status: closed
deps: []
links: []
created: 2026-03-04T13:24:08Z
type: epic
priority: 2
external-ref: SPEC-010
---
# Implement SPEC-010: LLM Review Script

Core llm-review.sh script: scan catalog for review_required entries, assemble context (YAML + README + repo map + manifest), call llm CLI, parse JSON verdicts, route to apply-review.py. Supports --tier, --max-turns, --model, --dry-run, --limit.


