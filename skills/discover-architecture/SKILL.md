---
name: discover-architecture
description: Analyze a local repository's filesystem to discover its architecture style(s), producing a YAML catalog entry and markdown summary. Uses heuristic signal extraction plus LLM-assisted classification against 12 canonical styles. Use when the user provides a repo path and wants to identify its architecture, or when batch-discovering architecture patterns for the evidence catalog.
license: MIT
allowed-tools: Bash, Read, Grep, Glob, Agent
metadata:
  short-description: Discover architecture styles from repository filesystem signals
  version: 1.0.0
  author: cristos
  source-repo: https://github.com/cristoslc/architecture-reference-repo
---

# Discover Architecture

Analyze a local repository and classify its architecture style(s) by extracting filesystem signals and applying heuristic rules. Produces two artifacts: a YAML catalog entry compatible with the evidence base, and a human-readable markdown summary.

## Activation

Triggers on: "discover architecture", "analyze this repo", "what architecture does this use", "classify architecture", "scan for architecture patterns", "generate catalog entry".

Input: a local filesystem path to a repository.

```
/discover-architecture /path/to/repo
```

## Step 1: Extract Signals

Run the signal extraction script against the target repository:

```bash
bash scripts/extract-signals.sh /path/to/repo
```

The script is located relative to this SKILL.md at `scripts/extract-signals.sh`. It scans the repo's filesystem for architecture signals across 10 categories and outputs a structured YAML report to stdout.

Capture the full YAML output — it is the input for classification.

If the script fails, check:
- The path exists and is a directory
- `bash`, `find`, `grep`, and `git` are available
- The path is not inside a bare git repo without a working tree

## Step 2: Classify Architecture Styles

Read the signal-to-style mapping rules at `references/signal-rules.md` (relative to this SKILL.md). Apply the classification rules to the signal report from Step 1.

### Classification procedure

For each of the 12 canonical architecture styles, compute a confidence score:

1. **Initialize** all style confidences to 0.0
2. **Match signals** from the report against the rules in `references/signal-rules.md`:
   - Strong signals add 0.3 to the style's confidence
   - Supporting signals add 0.1
3. **Apply thresholds** — a style is detected if its confidence meets or exceeds the threshold defined in the rules
4. **Resolve conflicts** using the conflict rules (e.g., Microservices vs. Modular Monolith)
5. **Order styles** by confidence, highest first

### The 12 canonical styles

These are the only valid values for `architecture_styles` in the output:

- Event-Driven
- Microservices
- Modular Monolith
- Service-Based
- Domain-Driven Design
- CQRS
- Space-Based
- Hexagonal Architecture
- Serverless
- Layered
- Pipe-and-Filter
- Multi-Agent

### LLM judgment for ambiguous cases

After applying the heuristic rules, use your own reasoning to refine the classification:

- **Directory structure inspection**: If the signal report shows interesting directory patterns (e.g., `services_dir: true` or `clean_layers: true`), read a few key directories to understand the actual organization. Use `ls` or `Glob` to inspect the top-level structure and one level deeper.
- **README and documentation**: Read the repo's README.md (if it exists) for explicit architecture descriptions. Developers often state their architecture choices.
- **Configuration files**: If messaging or IaC signals are detected, glance at the actual config files to confirm they are meaningful (not just boilerplate or examples).
- **Multi-style composition is normal**: 73% of winning architecture teams use 2+ styles. Do not force a single-style classification.

### Compute overall confidence

1. Overall confidence = max(per-style confidences)
2. If no style exceeds its threshold: overall confidence < 0.3, classify as "Indeterminate"
3. If only Layered matches: cap overall confidence at 0.5 (it is the default fallback)
4. Multi-style bonus: if 2+ styles exceed threshold, add 0.1 to overall confidence (capped at 1.0)

## Step 3: Infer Quality Attributes

Based on the detected signals, infer quality attributes using the mapping in `references/signal-rules.md` (section: "Quality attribute inference"). For example:

- Kubernetes manifests with replica configs → Scalability
- Circuit breaker patterns → Fault Tolerance
- Monitoring setup → Observability
- Multiple CI/CD environments → Deployability
- Cache layers → Performance

Only include quality attributes supported by actual signals — do not guess.

## Step 4: Determine Domain

Infer the project domain from available clues:

1. **README.md** — often states what the project does
2. **Package metadata** — `package.json` description, `pyproject.toml` description, Maven `<description>`
3. **Directory naming** — e.g., `orders/`, `payments/`, `users/` suggest e-commerce
4. **If unclear**: use "General Purpose" or "Unknown"

Common domains: E-Commerce, Developer Tools, Healthcare, FinTech, Social Platform, Content Management, IoT, Data Pipeline, Communication, Infrastructure.

## Step 5: Generate YAML Catalog Entry

Produce a YAML file conforming to the schema at `references/catalog-schema.yaml`. All required fields must be present.

```yaml
project_name: "<human-readable project name>"
source: "Discovered"
source_url: "<git remote URL from signal report, or empty>"
project_url: "<git remote URL or local path>"
evidence_type: "automated-discovery"
discovered_at: "<current ISO 8601 timestamp>"
discovered_by: "discover-architecture"
discovery_version: "1.0.0"
domain: "<inferred domain>"
language: "<primary language from signal report>"
languages:
  - "<language 1>"
  - "<language 2>"
architecture_styles:
  - "<style 1, highest confidence>"
  - "<style 2>"
key_technologies:
  - "<detected from manifests, configs, IaC>"
quality_attributes:
  - "<inferred from signals>"
notable_strengths:
  - "<positive signals: good documentation, comprehensive testing, clear module boundaries, etc.>"
notable_gaps:
  - "<missing signals: no tests, no CI/CD, no ADRs, no documentation, etc.>"
one_line_summary: "<concise architecture description>"
discovery_metadata:
  confidence: <0.0-1.0>
  signals_detected: <count of non-zero signal categories>
  signals_evaluated: 10
  classification_method: "heuristic+llm"
  primary_style_confidence: <confidence of first listed style>
  signal_breakdown:
    package_manifests: <count>
    container_orchestration: <count>
    infrastructure_as_code: <count>
    messaging: <count>
    api_specs: <count>
    adrs: <count>
    ci_cd: <count>
    test_structure: <count>
    documentation: <count>
    directory_structure: <count of true patterns>
```

### Key technologies detection

Derive `key_technologies` from the signal report:
- `package_json > 0` → check for framework signals (Next.js, Express, React, etc.) by reading `package.json`
- `go_mod > 0` → Go
- `pom_xml > 0` or `build_gradle > 0` → Java/Spring (check for Spring Boot markers)
- `terraform > 0` → Terraform
- `k8s_manifests > 0` → Kubernetes
- `helm_charts > 0` → Helm
- `dockerfiles > 0` → Docker
- `kafka = 1` → Apache Kafka
- `rabbitmq = 1` → RabbitMQ
- `proto_files > 0` → gRPC/Protocol Buffers

### Notable strengths and gaps

**Strengths** — include when the signal is present:
- ADR count > 5: "Mature architecture documentation with N ADRs"
- Integration tests present: "Integration test coverage"
- C4 diagrams present: "Architecture diagrams (C4/Structurizr)"
- Multi-style composition: "Thoughtful multi-style composition (N styles)"
- Contract tests: "Consumer-driven contract testing"

**Gaps** — include when the signal is absent and would normally be expected:
- No ADRs and repo has 10+ files: "No architecture decision records"
- No CI/CD: "No CI/CD pipeline detected"
- No tests: "No test structure detected"
- No documentation beyond README: "Minimal architecture documentation"
- Single ecosystem but 100+ files: "No clear module boundaries"

## Step 6: Generate Markdown Summary

Produce a human-readable markdown report:

```markdown
# Architecture Discovery: <project name>

**Discovered at:** <timestamp>
**Confidence:** <confidence> (<high/medium/low>)

## Architecture Styles

<For each detected style, explain what signals led to this classification>

## Signal Summary

| Category | Signals Found | Key Details |
|----------|--------------|-------------|
| Package Manifests | N | <languages, ecosystem count> |
| Container Orchestration | N | <dockerfiles, k8s, etc.> |
| ... | ... | ... |

## Quality Attributes

<Bulleted list of inferred quality attributes with supporting evidence>

## Classification Rationale

<2-3 paragraph explanation of why these styles were chosen, including:
- Which signals were strongest
- Any ambiguities and how they were resolved
- Confidence assessment and what would increase it>

## Recommendations

<If gaps were detected, suggest improvements:
- Missing ADRs → "Consider documenting key architecture decisions"
- No CI/CD → "Add a CI/CD pipeline for deployment automation"
- etc.>
```

## Edge Cases

### No signals detected (confidence < 0.3)

If the signal report shows `total_detected: 0` or very few signals:
- Set confidence to a value below 0.3
- Set `architecture_styles` to `["Indeterminate"]`
- In the markdown summary, note that insufficient signals were found
- Suggest what the user could add to make the architecture more discoverable

### Single-file or trivial repos

If the repo has fewer than 5 source files:
- Run the signal extraction but note the repo is trivially small
- Classification may not be meaningful — say so

### Monorepo with multiple projects

If the signal report shows multiple ecosystems, multiple Dockerfiles, and a `packages/` or `services/` directory:
- Consider whether to classify the monorepo as a whole or note that it contains sub-projects
- The YAML entry should describe the overall architecture, not individual sub-projects

## Output

By default, write both artifacts to stdout (YAML first, then markdown, separated by `---`).

If the user specifies an output path, write:
- `<output-path>/<project-name>.yaml` — the catalog entry
- `<output-path>/<project-name>.md` — the markdown summary
