---
title: "Architecture Discovery Skill"
artifact: SPEC-001
status: Approved
author: cristos
created: 2026-03-03
last-updated: 2026-03-03
parent-epic: EPIC-003
linked-research: []
linked-adrs: []
depends-on: []
---

# Architecture Discovery Skill

## Problem Statement

The evidence base currently contains 62 manually cataloged projects. Every entry was created by a human reading a repo, identifying patterns, and writing a YAML file. This does not scale. We need automated tooling that can analyze a repository and produce a structured catalog entry — the same output a human analyst would create, but faster and repeatable.

## External Behavior

### Input

A local filesystem path to a git repository.

```
/discover-architecture /path/to/repo
```

### Output

Two artifacts:

1. **YAML catalog entry** — Compatible with the existing evidence catalog schema. Fields:

```yaml
project_name: "<detected or derived from repo name>"
source: "Discovered"
source_url: "<git remote URL if available>"
project_url: "<git remote URL or local path>"
evidence_type: "automated-discovery"
discovered_at: "<ISO 8601 timestamp>"
domain: "<detected or 'Unknown'>"
language: "<primary language>"
architecture_styles:
  - "<style 1>"
  - "<style 2>"
key_technologies:
  - "<tech 1>"
quality_attributes:
  - "<attribute 1>"
notable_strengths:
  - "<strength 1>"
notable_gaps:
  - "<gap 1>"
one_line_summary: "<generated summary>"
discovery_metadata:
  confidence: <0.0-1.0>
  signals_detected: <count>
  signals_evaluated: <count>
  classification_method: "heuristic+llm"
```

2. **Markdown summary** — Human-readable report including detected signals, classification rationale, and confidence assessment.

### Preconditions

- Target path exists and is a git repository (or at minimum a directory with source code)
- The 12 canonical architecture styles from the reference library are available as classification targets

### Postconditions

- YAML file written to a specified output path (default: stdout)
- Markdown summary written to a specified output path (default: stdout)
- No modifications to the target repository

## Acceptance Criteria

- **Given** the `kgrzybek/modular-monolith-with-ddd` reference repo, **when** discovery runs, **then** the output includes "Modular Monolith" and "Domain-Driven Design" in `architecture_styles`
- **Given** the `dotnet/eShop` reference repo, **when** discovery runs, **then** the output includes "Microservices" and "Event-Driven" in `architecture_styles`
- **Given** the 8 reference architecture repos in `evidence-analysis/ReferenceArchitectures/`, **when** discovery runs against each, **then** at least 6 of 8 (75%) have their primary style correctly identified
- **Given** a repo with no recognizable architecture signals (e.g., a single-file script repo), **when** discovery runs, **then** confidence is < 0.3 and the summary notes insufficient signals
- **Given** any repo, **when** discovery runs, **then** the output YAML validates against the catalog schema and can be placed in `evidence-analysis/*/docs/catalog/`

## Scope & Constraints

### In scope

- **Signal extraction** from filesystem artifacts:
  - Package manifests: `package.json`, `go.mod`, `pom.xml`, `build.gradle`, `requirements.txt`, `Cargo.toml`, `*.csproj`
  - Container orchestration: `Dockerfile`, `docker-compose.yml`, k8s manifests, Helm charts
  - IaC: Terraform `.tf`, CloudFormation, Pulumi, Bicep
  - Messaging: Kafka, RabbitMQ, NATS, Redis config/connection patterns
  - API specs: OpenAPI/Swagger, AsyncAPI, gRPC `.proto` files
  - ADRs: `docs/adr/`, `docs/decisions/`, `adr/` directories
  - CI/CD: `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`
  - Directory structure: module boundaries, layer separation, service decomposition
- **Classification** via heuristic rules mapping detected signals to the 12 canonical architecture styles
- **LLM-assisted judgment** for ambiguous cases (the agent reading the skill uses its own reasoning)
- **Top 5 ecosystems**: JavaScript/TypeScript, Python, Java/Kotlin, Go, .NET

### Out of scope

- Remote repo cloning (caller handles that; skill operates on local paths)
- Runtime analysis or dynamic instrumentation
- ML model training or inference
- Modifying the target repository
- Deep code analysis (AST parsing, call graph extraction) — signal extraction is file-pattern-based

### Constraints

- Signal extraction should complete in under 60 seconds for repos up to 100k files
- No external service dependencies beyond git (must work offline after repo is local)

## Implementation Approach

The skill is implemented as a Claude skill at `skills/discover-architecture/`:

```
skills/discover-architecture/
  SKILL.md                    # Skill definition + classification rules
  scripts/
    extract-signals.sh        # Filesystem signal extraction (fast, mechanical)
  references/
    signal-rules.md           # Signal-to-style mapping rules
    catalog-schema.yaml       # Target output schema
```

### Signal extraction (`extract-signals.sh`)

A shell script that scans a repo and outputs a structured signal report:
- Glob for known file patterns (manifests, configs, IaC, API specs)
- Count and categorize matches
- Extract key metadata (primary language, service count, module count)
- Output as YAML for the agent to consume

### Classification (agent-driven, in SKILL.md)

The SKILL.md contains heuristic rules that map signal combinations to architecture styles:
- "If k8s manifests + multiple Dockerfiles + inter-service messaging config → Microservices"
- "If single deployable + well-defined module boundaries + internal event bus → Modular Monolith"
- "If message broker config + event schema definitions + async handlers → Event-Driven"
- Rules are ordered by specificity; multiple styles can match (multi-style composition)

The agent applies these rules, uses its own judgment for edge cases, and generates the YAML + markdown output.

### Calibration

Run against the 8 known reference architecture repos. Compare discovered `architecture_styles` against the ground-truth entries in `evidence-analysis/ReferenceArchitectures/docs/catalog/_index.yaml`. Report precision/recall.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Approved | 2026-03-03 | b63f031 | Skipped Draft/Review — design is well-established from EPIC-003 proposal |
