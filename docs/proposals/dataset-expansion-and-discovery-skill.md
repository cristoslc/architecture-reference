# Proposal: Dataset Expansion & Architecture Discovery Skill

## Status: Draft — For Discussion

---

## 1. Current State of the Repository

The Architecture Reference Library currently contains **78 team submissions** across **11 O'Reilly Architecture Kata seasons** (Fall 2020 – Winter 2025), cataloging 12 architecture styles with placement-weighted scoring across 10 problem dimensions. It is rigorous, evidence-based, and methodologically sound — but narrowly scoped to a single competition format.

### Key limitations of the current dataset

| Gap | Impact |
|-----|--------|
| Single source (O'Reilly Katas only) | Competition bias — teams optimize for judges, not production |
| Design-only submissions (no running code) | Cannot validate if proposed architectures actually work at scale |
| Small sample sizes for some styles | Modular Monolith n=6, CQRS n=3, Multi-Agent n=3 |
| No production metrics | No latency, throughput, cost, or incident data |
| No evolution data | Snapshots only; cannot study how architectures change over time |
| Limited technology coverage | Mostly cloud-native; sparse on embedded, mobile, ML-ops, data platforms |

---

## 2. Existing Datasets & Resources That Would Improve the Library

### Tier 1 — High-value, directly complementary

| Source | What it provides | How it improves the library |
|--------|------------------|-----------------------------|
| **[The Architecture of Open Source Applications (AOSA)](https://aosabook.org/en/)** | Detailed architectural descriptions of ~50 production open-source apps (NGINX, Git, Selenium, etc.) written by their creators | Adds real-world production architecture narratives to complement Kata design documents |
| **[Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/)** + [mspnp/cloud-design-patterns](https://github.com/mspnp/cloud-design-patterns) | 35+ cloud design patterns with reference implementations in code | Working code examples for patterns currently documented only as design proposals |
| **[Google Cloud Architecture Center](https://docs.cloud.google.com/architecture)** + [GCP-Architecture-Guides](https://github.com/GCP-Architecture-Guides) | Production-tested reference architectures with Terraform IaC | Vendor-specific but real-world validated patterns with deployment code |
| **[chanakaudaya/solution-architecture-patterns](https://github.com/chanakaudaya/solution-architecture-patterns)** | Vendor-neutral, industry-specific architecture patterns (telecom, healthcare, retail, automotive, etc.) | Fills the industry-vertical gap — current dataset lacks domain-specific pattern guidance |
| **[AWS Solutions Constructs](https://docs.aws.amazon.com/solutions/latest/constructs/welcome.html)** | Multi-service well-architected patterns as CDK constructs | Codified, tested patterns for common integration scenarios |

### Tier 2 — Curated collections for cross-referencing

| Source | What it provides |
|--------|------------------|
| **[mehdihadeli/awesome-software-architecture](https://github.com/mehdihadeli/awesome-software-architecture)** | Comprehensive curated list: articles, videos, repos organized by pattern (DDD, CQRS, microservices, modular monolith, event sourcing, etc.) |
| **[DovAmir/awesome-design-patterns](https://github.com/DovAmir/awesome-design-patterns)** | Cross-cutting design patterns list including cloud-specific patterns (AWS CDP, Azure), distributed systems, DevOps, and ML patterns |
| **[simskij/awesome-software-architecture](https://github.com/simskij/awesome-software-architecture)** | Focused on architectural decision-making: patterns, principles, methodologies |

### Tier 3 — Academic & empirical datasets

| Source | What it provides |
|--------|------------------|
| **[Microservices Project List (Taibi, Tampere University)](https://github.com/davidetaibi/Microservices_Project_List)** | **378 real-world microservice projects** — peer-reviewed, academically cited (Rahman et al. 2019, d'Aragona et al. MSR 2024). Most directly complementary: production microservice repos vs. our competition designs |
| **[Microservice Dependency Graph Dataset](https://github.com/clowee/MicroserviceDataset)** | GraphML dependency graphs + SVG visualizations for microservice projects. Enables structural comparison against Kata-proposed architectures |
| **[Kaggle: Software Architectural Styles Dataset](https://www.kaggle.com/datasets/qadeemkhan/dataset-of-software-architectural-styles)** | Architecture style classification dataset designed for statistical/data-mining analysis — closest public equivalent to what this repo is building |
| **[Libraries.io / Zenodo](https://zenodo.org/records/3626071)** | 311M+ rows of dependency metadata across 2.7M projects and 36 package managers (CC-BY-SA 4.0). Ecosystem-scale dependency architecture patterns |
| **[Software Heritage Graph Dataset](https://www.softwareheritage.org/)** | Largest public source code archive: 16B+ files from 250M+ projects as a deduplicated Merkle DAG. Available on AWS Open Data (Pietri et al., MSR 2019) |
| **[GHTorrent](https://www2.dmst.aueb.gr/dds/pubs/conf/2012-MSR-GitHub/html/github-mirror.html)** | Offline GitHub metadata mirror (commits, issues, PRs, social metadata). Most-cited GitHub dataset in academic literature (172+ studies) |
| **[Enterprise-Driven OSS Dataset (ACM MSR 2020)](https://dl.acm.org/doi/abs/10.1145/3379597.3387495)** | 17,264 enterprise-driven GitHub projects identified by domain mining — addresses the hobby-project bias in most OSS research |
| **[Software Architecture Styles Dataset (ResearchGate, 2017)](https://www.researchgate.net/publication/312596176)** | 18-attribute dataset of architecture styles designed for data mining/clustering analysis |
| **[Open-Source Developer Metrics Dataset (ScienceDirect, 2022)](https://www.sciencedirect.com/science/article/pii/S2352340922010459)** | 700+ developers across 17 OSS projects with 24 software architecture metrics at different granularities |

### Tier 3b — Architecture mining tools (for the discovery skill)

| Tool | What it does |
|------|--------------|
| **[code-maat](https://github.com/adamtornhill/code-maat)** (open source by CodeScene founder) | VCS mining tool that extracts evolutionary coupling, hotspots, and social patterns from git history |
| **[Code2DFD](https://github.com/)** | Generates data flow diagrams from source code; analyzes GitHub repos directly |
| **[EventCatalog](https://www.eventcatalog.dev/)** | Open-source architecture catalog for distributed systems. Documents domains, services, events, schemas. Pulls from OpenAPI/AsyncAPI. Used by Nike, AWS, GOV.UK |
| **[Architecture Recovery Tools (arXiv 2024)](https://arxiv.org/html/2412.08352v1)** | Comparative study of 13 static analysis architecture recovery tools for microservice applications — directly relevant to building the discovery skill |

### Tier 4 — Reference architecture implementations (working code)

| Source | Style demonstrated |
|--------|--------------------|
| **[dotnet-architecture/eShopOnContainers](https://github.com/dotnet-architecture/eShopOnContainers)** | Microservices + Event-Driven + DDD on .NET |
| **[kgrzybek/modular-monolith-with-ddd](https://github.com/kgrzybek/modular-monolith-with-ddd)** | Modular Monolith + DDD (validates the library's finding that modular monolith has highest avg placement) |
| **[jasontaylordev/CleanArchitecture](https://github.com/jasontaylordev/CleanArchitecture)** | Clean/Hexagonal Architecture + CQRS + MediatR |
| **[Azure-Samples/Serverless-microservices-reference-architecture](https://github.com/Azure-Samples/Serverless-microservices-reference-architecture)** | Serverless microservices on Azure |
| **[GoogleCloudPlatform/cloud-foundation-fabric](https://github.com/GoogleCloudPlatform/cloud-foundation-fabric)** | IaC-driven modular landing zone architecture |
| **[dotnet/eShop](https://github.com/dotnet/eShop)** | Active successor to eShopOnContainers — canonical .NET microservices reference |
| **[ThreeDotsLabs/wild-workouts-go-ddd-example](https://github.com/ThreeDotsLabs/wild-workouts-go-ddd-example)** | Production-ready Go DDD + Clean Architecture + CQRS + gRPC |
| **[thombergs/buckpal](https://github.com/thombergs/buckpal)** | Java/Spring Boot Hexagonal Architecture (book companion) |
| **[AWS reference architectures](https://github.com/aws-samples)** | Security (multi-account CloudFormation+Terraform), Analytics (CDK), ECS microservices, multi-tenant SaaS |

---

## 3. Should We Create an Architecture Discovery Skill?

**Yes — but with a carefully scoped design.** Here's the analysis:

### Why this is valuable

1. **The library's biggest gap is sample size.** n=78 from one competition is a start, but hundreds of real-world repos would make the statistical findings far more robust.
2. **Architecture patterns are discoverable from code.** Folder structure, dependency graphs, module boundaries, messaging patterns, and infrastructure-as-code files are all signals that can be extracted programmatically.
3. **Users want to compare.** "How does my repo's architecture compare to best practices?" is a natural use case that the current library cannot serve.
4. **The dataset should be living.** A discovery skill would allow the library to grow continuously rather than only when new Kata seasons occur.

### Proposed Skill: `/discover-architecture`

**Purpose:** Analyze a repository (local or remote) and produce a structured YAML catalog entry compatible with the existing evidence catalog format.

**What it would extract:**

```yaml
# Signals the skill would detect
architecture_signals:
  # Structural patterns
  - module_boundaries:        # top-level directory analysis, package structure
  - dependency_graph:          # import analysis, module coupling
  - layer_separation:          # controllers/services/repos pattern detection

  # Communication patterns
  - messaging_infrastructure:  # Kafka, RabbitMQ, NATS config files
  - api_gateway_presence:      # Kong, Envoy, API Gateway configs
  - event_schemas:             # Avro, Protobuf, JSON Schema definitions

  # Infrastructure patterns
  - container_orchestration:   # docker-compose, k8s manifests, Helm charts
  - iac_patterns:              # Terraform modules, CloudFormation, Pulumi
  - ci_cd_pipeline:            # GitHub Actions, Jenkins, GitLab CI

  # Architecture decision records
  - adr_presence:              # docs/adr/, docs/decisions/ directories
  - adr_count_and_topics:      # parse ADR titles and classify

  # Quality indicators
  - test_coverage_structure:   # test directory organization, test types
  - monitoring_observability:  # OpenTelemetry, Prometheus, logging patterns
  - documentation_completeness: # C4 diagrams, architecture docs presence
```

**How it would classify:**

```
Input repo → Signal extraction → Pattern matching → Classification

Classification output:
  primary_style:      "event-driven"
  secondary_styles:   ["microservices", "cqrs"]
  quality_attributes: ["scalability", "evolvability"]
  maturity_signals:   { adr_count: 12, has_c4: true, test_structure: "integration+unit" }
  confidence:         0.78
```

### Proposed Workflow

```
User runs: /discover-architecture [repo-path-or-url]

1. Clone/access the repository
2. Run static analysis:
   - Directory structure fingerprinting
   - Dependency graph extraction (package.json, go.mod, pom.xml, etc.)
   - Config file detection (docker-compose, k8s, terraform, etc.)
   - Communication pattern detection (message broker configs, API specs)
   - ADR detection and classification
   - Documentation artifact inventory
3. Generate a draft YAML catalog entry (matching existing schema)
4. Produce a human-readable architecture summary with:
   - Detected patterns and confidence levels
   - Comparison to similar repos in the existing dataset
   - Suggested improvements based on evidence (e.g., "winners tend to have 15+ ADRs")
5. Optionally: add the entry to the evidence catalog
```

### What this would NOT do (important boundaries)

- **Not a linter or code quality tool** — CodeScene and SonarQube already do that. This focuses on architectural pattern detection.
- **Not a prescriptive tool** — it classifies what IS, not what SHOULD BE. The existing reference library provides the "should."
- **Not fully automated classification** — outputs a draft for human review. Architecture involves judgment that resists full automation.

### Implementation considerations

| Aspect | Recommendation |
|--------|----------------|
| **Scope** | Start with the top 5 most common languages/ecosystems (JS/TS, Python, Java, Go, .NET) |
| **Detection approach** | Heuristic-based signal extraction (file patterns, config parsing) + LLM-assisted classification |
| **Output format** | YAML matching the existing `/evidence-analysis/TheKataLog/docs/catalog/*.yaml` schema |
| **Open-source repos** | Seed with well-known reference implementations (eShopOnContainers, etc.) to calibrate detection accuracy |
| **User repos** | Privacy-first — analysis runs locally, nothing uploaded unless user opts in |
| **Confidence scoring** | Each classification gets a confidence score; low-confidence results flagged for review |

---

## 4. Recommended Roadmap

### Phase 1: Enrich the existing dataset (no new tooling needed)
- Incorporate AOSA book architectures as a new evidence source alongside TheKataLog
- Add curated reference implementation repos as "validated examples" for each style
- Cross-reference cloud provider patterns (Azure, GCP, AWS) against existing style taxonomy
- Expand the `_index.yaml` schema to support non-Kata evidence sources

### Phase 2: Build the discovery skill (MVP)
- Implement `/discover-architecture` for local repos
- Focus on structural pattern detection (directory layout, dependency graph, config files)
- Output: YAML catalog entry + markdown summary
- Calibrate against known-architecture repos (the Tier 4 list above)

### Phase 3: Scale the dataset
- Run discovery against top open-source repos (by GitHub stars, by domain)
- Build a community contribution pipeline for user-submitted analyses
- Add evolutionary analysis (git history mining via code-maat patterns)
- Correlate with production metrics where available (GitHub issues, incident data)

### Phase 4: Comparative analysis
- "How does my architecture compare to successful repos in this domain?"
- Statistical analysis across the expanded dataset (n=500+ instead of n=78)
- Pattern evolution tracking: how do architectures change as projects scale?

---

## 5. Summary

| Question | Answer |
|----------|--------|
| Are there datasets that would improve the library? | **Yes, significantly.** AOSA books, cloud provider reference architectures, curated awesome-lists, academic datasets, and working reference implementations would address every major gap. |
| Should we build a discovery skill? | **Yes.** It's the highest-leverage way to scale the dataset beyond manual Kata-season additions, and it directly serves users who want to understand their own repos. |
| What's the risk? | Over-engineering the classifier. Start with heuristics + LLM, not ML models. The existing YAML schema is the right output target. |
| What should we do first? | Phase 1 (enriching existing data with known sources) is zero-risk and immediately valuable. Phase 2 (the skill) should be scoped to MVP before expanding. |
