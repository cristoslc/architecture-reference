---
id: ar-zs5p
status: closed
deps: [ar-r9mu]
links: []
created: 2026-03-13T05:20:36Z
type: task
priority: 2
assignee: Cristos L-C
parent: ar-nyz5
tags: [spec:SPEC-036]
---
# Remove signal YAML files and orphaned scripts

git rm evidence-analysis/Discovered/signals/ and scripts/spec020-cleanup.py (if dead). Verify no active code references remain.


## Notes

**2026-03-13T05:22:55Z**

Removed 184 signal YAML files from evidence-analysis/Discovered/signals/ and scripts/spec020-cleanup.py. AC-1: signals dir gone. AC-2: no active script references. AC-3: spec020-cleanup.py removed.
