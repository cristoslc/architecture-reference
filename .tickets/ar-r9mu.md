---
id: ar-r9mu
status: closed
deps: []
links: []
created: 2026-03-13T05:20:36Z
type: task
priority: 2
assignee: Cristos L-C
parent: ar-nyz5
tags: [spec:SPEC-036]
---
# Verify spec020-cleanup.py is dead code

Read scripts/spec020-cleanup.py and determine if it serves any purpose beyond signal data. If dead, mark for removal.


## Notes

**2026-03-13T05:20:47Z**

spec020-cleanup.py is a one-shot migration script from SPEC-020 (catalog cleanup). Already executed. References SIGNALS_DIR. Dead code — safe to remove.
