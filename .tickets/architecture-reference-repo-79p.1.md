---
id: architecture-reference-repo-79p.1
status: closed
deps: []
links: []
created: 2026-03-06T12:33:20Z
type: task
priority: 2
---
# Build subagent-based deep-validation orchestrator

Create a Python orchestrator script that replaces llm CLI calls with Claude Code Agent tool invocations. Reuses llm-validate.sh's context assembly (clone, deep context files, repo map, source structure), validation prompt, override rules, and apply-review.py integration. The orchestrator prepares context per repo and delegates classification to subagents.


