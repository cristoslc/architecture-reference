---
id: architecture-reference-repo-ace.7
status: blocked
deps: []
links: []
created: 2026-03-05T20:59:20Z
type: task
priority: 1
---
# Re-run pipeline on all 122 repos

Re-extract signals and re-classify all 122 Discovered repos with updated scorers. Compare before/after classifications. Validate against manifest.yaml expected styles. Target: SBA 4→15+, Plugin 0→5+. Flag any regressions in MS/MM/EDA detection.

## Notes

Blocked: existing signal files lack new service_based/plugin_microkernel sections and have inflated docker_compose_services. Re-extraction from cloned repos required. Splitting into: (a) sample validation test (5 repos), (b) full re-run spec for later.
Sample test passed (5 repos cloned+re-extracted): shopware SBA=0.7, temporal SBA=0.6, mastodon SBA=0.7, medusa SBA=0.6, backstage Plugin=0.5. SPEC-017 created to spec the full re-run. Widened monorepo_packages from 2-8 to 2+.


