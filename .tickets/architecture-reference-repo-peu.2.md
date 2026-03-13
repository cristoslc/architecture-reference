---
id: architecture-reference-repo-peu.2
status: closed
deps: []
links: []
created: 2026-03-06T05:20:33Z
type: task
priority: 2
---
# Re-extract signals for all 122 repos

Run pipeline/run-pipeline.sh --force on all 122 repos from manifest.yaml. The --force flag re-processes already-cataloged repos. The updated extract-signals.sh (commits b71edbe, 4838395) adds service_based, plugin_microkernel, shared_library, and workspace_config signal sections, and fixes docker_compose_services extraction. Requires GITHUB_TOKEN and network access for shallow clones.

## Notes

Pipeline launched: PID 8002. 187 repos in manifest (up from 122 in spec — corpus grew). Running with --force -j 4. Log: /tmp/spec017-pipeline.log


