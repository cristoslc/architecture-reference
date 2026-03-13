---
id: architecture-reference-repo-bov.1.3
status: closed
deps: []
links: []
created: 2026-03-04T13:24:20Z
type: task
priority: 2
assignee: Cristos L-C
---
# Implement llm-review.sh core script

Main script: CLI arg parsing (--tier, --max-turns, --model, --clone-dir, --dry-run, --limit), scan_entries(), assemble_context(), call_llm(), parse_response(), route_verdict(), ensure_clone(), generate_report(). Integrates with apply-review.py for classified verdicts.


