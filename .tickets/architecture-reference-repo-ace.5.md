---
id: architecture-reference-repo-ace.5
status: closed
deps: []
links: []
created: 2026-03-05T20:59:08Z
type: task
priority: 1
---
# Add SBA vs MS conflict resolution

When both SBA and MS score above threshold, apply discriminating heuristics: Dockerfile count <8 + shared database → favor SBA; fewer than 3 separate CI deploy targets → favor SBA; service dir count 2-5 → favor SBA, 6+ → favor MS. Add service granularity signal (avg lines per service dir).


