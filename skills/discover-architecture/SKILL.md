---
name: discover-architecture
description: Analyze a codebase to discover its architecture style(s) through direct source code inspection. Reads actual code structure, dependency graphs, module boundaries, and runtime patterns — no heuristics or filesystem signal counting. Produces a classification report with evidence citations. Use when the user says "what architecture is this", "analyze this repo", "discover architecture", "classify this codebase", "what patterns does this use", or points you at a repo and asks about its structure. Also triggers on "architecture review", "codebase analysis", or "how is this system structured".
license: MIT
allowed-tools: Bash, Read, Grep, Glob, Agent
metadata:
  short-description: Discover architecture styles through deep source code analysis
  version: 2.0.0
  author: cristos
  source-repo: https://github.com/cristoslc/architecture-reference-repo
---

# Discover Architecture

Analyze a codebase to identify its architecture style(s) by reading actual source code — not by counting filesystem signals or matching directory name patterns. Architecture is about structure and relationships: how modules communicate, where boundaries are enforced, what the dependency graph looks like. These things require reading code, not scanning for Dockerfiles.

## The 12 Canonical Styles

These are the only valid architecture style classifications. Read `references/styles.md` for full definitions, distinguishing characteristics, and production frequency data.

| Style | What to look for |
|-------|-----------------|
| **Microkernel** | Host application with plugin/extension registry. Core provides lifecycle management; plugins provide domain behavior. Extension point contracts, dynamic module loading. |
| **Layered** | Horizontal separation into layers (presentation/business/data). Strict dependency direction — upper layers depend on lower, never reverse. |
| **Modular Monolith** | Single deployable unit with well-defined module boundaries. Modules are logically independent but physically coupled. Module registries, feature toggles. |
| **Event-Driven** | Components communicate through events, not direct calls. Message brokers, event buses, pub/sub patterns, async handlers. |
| **Pipeline** | Data flows through ordered processing stages. Each stage transforms input to output. Middleware chains, filter pipelines, compiler passes. |
| **Microservices** | Independent services with own databases, deployed separately. Service mesh, API gateways, per-service CI/CD. |
| **Service-Based** | Coarse-grained services sharing infrastructure. Less distributed than microservices — shared databases, simpler communication. |
| **Hexagonal Architecture** | Core business logic isolated in center. External concerns connect through ports (interfaces) and adapters (implementations). Dependency inversion enforcement. |
| **Domain-Driven Design** | Code organized around business domains (bounded contexts). Aggregates, domain events, ubiquitous language, repository pattern. |
| **Multi-Agent** | Multiple autonomous agents with specialized capabilities collaborating through message passing or supervisor hierarchies. |
| **Space-Based** | In-memory distributed data grid with peer-to-peer replication. Masterless, eventual consistency. |
| **CQRS** | Separate read and write models. Command/query separation, event stores, projection builders. |

## How to Classify

### Step 1: Inventory the codebase

Get oriented quickly. Run these in parallel:

- `ls` the root directory and key subdirectories (src/, lib/, packages/, services/, internal/, cmd/)
- Read `README.md` (first 200 lines) — often states what the project IS
- Read any `ARCHITECTURE.md`, `docs/architecture/`, or `CONTRIBUTING.md`
- Check package metadata (`package.json` description, `pyproject.toml`, `pom.xml`, `Cargo.toml`, `go.mod`)
- Note the primary language(s) and framework(s)

### Step 2: Inspect code structure

This is where classification happens. Read actual source files — not just directory names.

**For each candidate style, look for structural evidence:**

- **Module boundaries**: How is code organized? Are there clear module interfaces, or is everything in one flat namespace?
- **Dependency direction**: Do dependencies flow in one direction? Is there dependency inversion?
- **Communication patterns**: How do components talk to each other? Direct function calls? Message passing? HTTP? Events?
- **Extension mechanisms**: Are there plugin registries, middleware chains, hook systems?
- **Data flow**: Does data flow through transformation stages, or is it request/response through layers?
- **Deployment topology**: Is this one deployable unit or many? How do you tell?

**Read at least:**
- 2-3 "entrypoint" files (main.go, app.py, Program.cs, index.ts, etc.)
- The dependency injection / wiring configuration (if any)
- 2-3 representative domain files showing the core architecture
- Any inter-module or inter-service communication code

### Step 3: Classify with evidence

Based on what you read, determine:

1. **Primary style(s)** — the dominant architectural pattern(s). Most production repos exhibit 2 styles (74% in the evidence base).
2. **Confidence** — how clear the evidence is (0.0-1.0)
3. **Evidence citations** — specific files, classes, and patterns that support each classification

**Classification principles:**

- **Classify what the repo IS, not what it enables.** A plugin framework IS Microkernel. A message broker IS Event-Driven infrastructure.
- **Multi-style composition is normal.** Don't force single-style classification. A system can be both Layered and Microkernel (layered internal structure with plugin extension).
- **Code trumps documentation.** If the README says "microservices" but the code is a monolith with a single database, classify based on code.
- **Distinguish style from technology.** Having Docker doesn't make it Microservices. Having Kafka doesn't make it Event-Driven. Look at how the architecture is actually structured.
- **If truly indeterminate**, say so and explain why. Don't guess.

### Step 4: Determine scope and use-type

**Scope** (per ADR-001):
- **Platform**: designed to be extended/built upon — plugin systems, API surfaces, infrastructure for other software (e.g., Kafka, Grafana, VS Code)
- **Application**: end-user facing, solves a specific problem (e.g., Mastodon, Ghostfolio)

**Use-type** (per ADR-001):
- **Production**: real system used in production or production-ready
- **Reference**: educational, demo, template, starter kit

### Step 5: Identify quality attributes

Only report quality attributes with direct evidence in code:

| QA | Evidence to look for |
|----|---------------------|
| Deployability | Container configs, CI/CD pipelines, deployment scripts |
| Modularity | Clear module boundaries, DI configuration, interface segregation |
| Scalability | Horizontal scaling configs, sharding, message queues |
| Fault Tolerance | Circuit breakers, retry policies, health checks, graceful degradation |
| Observability | Structured logging, metrics, tracing (OpenTelemetry, Prometheus) |
| Evolvability | Plugin systems, extension points, feature flags |

Do NOT report quality attributes you can't see in code (Performance, Security, Testability, etc.) — these are real but invisible in source analysis. Note this limitation in the report.

### Step 6: Infer domain

From README, package metadata, directory naming, and code content. Use specific domains when clear (E-Commerce, Developer Tools, Observability, etc.). Use "General Purpose" if unclear.

## Output Format

Produce a markdown report:

```markdown
# Architecture Analysis: <project name>

**Scope:** platform | application
**Use-type:** production | reference
**Primary language:** <language>
**Confidence:** <0.0-1.0>

## Architecture Styles

### <Style 1> (primary)

<2-3 sentences explaining WHY this classification, citing specific files and patterns>

### <Style 2> (secondary)

<Same format>

## Evidence Summary

| Style | Confidence | Key Evidence |
|-------|-----------|-------------|
| <style> | <0.0-1.0> | <specific files, patterns, classes cited> |

## Quality Attributes Detected

- **<QA>**: <evidence> (e.g., "Deployability: Dockerfile, GitHub Actions CI, Helm charts")

> **Detection limitation:** Quality attributes like Performance, Security, and Testability are architecturally significant but invisible in source code analysis.

## Domain

<domain> — <brief justification>

## Production Context

<How this repo's architecture compares to production evidence:>
- <Style> appears in N% of 142 production repos in the evidence base
- <Any notable patterns: "Microkernel + Layered is the most common combination">
- <Platform/application context if relevant>
```

If the user wants YAML catalog output (for the evidence base), also produce a YAML entry per the schema in `references/catalog-schema.yaml`.

The report structure follows the template at `references/report.template.j2`. When saving reports, use `docs/architecture-reports/<project-name>-<YYYY-MM-DD>.md`.

## Edge Cases

**Monorepo with multiple projects**: Note the monorepo structure. Classify the overall architecture, noting sub-projects if they have distinct styles.

**Trivial repos** (< 10 source files): Classification may not be meaningful. Say so.

**Libraries/frameworks** (consumed as dependencies, not deployed): These have no deployable architecture. Classify as what they ARE (a plugin framework is Microkernel), note they're libraries.

**Indeterminate**: If code is too flat, too small, or too unconventional to classify, say "Indeterminate" and explain what would help (more code, clearer boundaries, etc.).
