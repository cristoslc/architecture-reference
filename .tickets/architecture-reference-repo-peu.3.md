---
id: architecture-reference-repo-peu.3
status: closed
deps: []
links: []
created: 2026-03-06T05:20:33Z
type: task
priority: 2
---
# Run heuristic classification on new signals

After signal re-extraction, run classify.py on all 122 signal files. The updated classifier (b71edbe, 81f6835, 4838395) has the 5-signal SBA scorer (0.8 max), Plugin/Microkernel scorer (0.7 max), SBA-vs-MS conflict resolution, and shared_library/workspace_config signals. Note: run-pipeline.sh handles both extraction and classification in a single pass, so this may be combined with the extraction task.


