---
id: architecture-reference-repo-8ym.3
status: closed
deps: []
links: []
created: 2026-03-03T06:06:54Z
type: task
priority: 2
---
# Build extract-signals.sh script

Create scripts/extract-signals.sh — a shell script that scans a local repo and outputs a structured YAML signal report. Detects: package manifests (package.json, go.mod, pom.xml, etc.), container files (Dockerfile, docker-compose, k8s), IaC (Terraform, CloudFormation), messaging configs, API specs (OpenAPI, gRPC .proto), ADR directories, CI/CD configs, test structure, primary language. Output is a YAML signal report consumed by the agent for classification.


