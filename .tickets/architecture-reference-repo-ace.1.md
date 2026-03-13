---
id: architecture-reference-repo-ace.1
status: closed
deps: []
links: []
created: 2026-03-05T20:58:47Z
type: task
priority: 1
assignee: Cristos L-C
---
# Add SBA signals to extract-signals.sh

Add new filesystem signals for SBA detection: shared_database_configs (connection string count), service_avg_size (avg LOC per service dir), deployment_units (Docker Compose service count), monorepo_packages (top-level package/app/service dir count). These signals feed the improved SBA scorer.


