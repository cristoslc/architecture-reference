# Discovered Source Analysis: Patterns Across 173 Open-Source Repositories

## Dataset Overview

This analysis covers **173 open-source repositories** automatically discovered via GitHub search and classified using structural signal extraction (extract-signals.sh) combined with LLM review for confidence scoring. Each entry represents a public repository that exhibits identifiable architectural patterns through filesystem signals (Docker configs, message queues, API specs, directory structure).

The Discovered source is unique among the five evidence sources: it provides breadth (173 entries vs. 78 KataLog teams, 12 AOSA systems, 5 RealWorldASPNET apps, 8 ReferenceArchitectures) but with lower depth per entry compared to curated sources where each system has a detailed written case study.

| Discovery Method | Year | Repositories |
|-----------------|------|--------------|
| GitHub search + signal extraction | 2026 | 173 |
| Heuristic classification + LLM review | 2026 | 173 |

---

## Architecture Style Distribution

Each project may exhibit multiple architecture styles. After normalization:

| Architecture Style | Count | Percentage |
|-------------------|-------|------------|
| **Event-Driven** | 89 | 51% |
| **Microservices** | 51 | 29% |
| **Domain-Driven Design** | 49 | 28% |
| **Pipe-and-Filter** | 35 | 20% |
| **Layered Architecture** | 29 | 17% |
| **CQRS** | 27 | 16% |
| **Modular Monolith** | 26 | 15% |
| **Hexagonal Architecture** | 14 | 8% |
| **Service-Based** | 10 | 6% |
| **Space-Based** | 8 | 5% |
| **Serverless** | 8 | 5% |
| **Multi-Agent** | 7 | 4% |

### Key Findings

1. **Event-Driven dominates Discovered** (89 of 173, 51%) — similar to KataLog (56%) but higher absolute count. This reflects the prominence of message brokers (Kafka, RabbitMQ) and async patterns in open-source ecosystems. Many projects layer Event-Driven with other styles (especially DDD and Microservices).

2. **DDD appears in 49 projects (28%)** — substantially higher than KataLog (5%) and AOSA (0%). This suggests that directory structures explicitly naming domain concepts (`/domain/`, `/bounded-context/`, `/aggregates/`) are common signals in well-organized open-source projects.

3. **CQRS appears in 27 projects (16%)** — a pattern almost absent from competition entries. Discovered repos with event sourcing infrastructure (event stores, command/query separation in code organization) readily reveal this pattern through filesystem signals.

4. **Microservices at 51 (29%)** — interestingly, this is lower than Event-Driven. Many repos show service decomposition signals (multiple Docker Compose services, k8s manifests) but maintain a monorepo structure, resulting in Modular Monolith classification.

5. **Space-Based appears 8 times** — all actor-model frameworks (Akka ports, Orleans clones, Proto.Actor). This pattern is invisible in competition data but clearly present in production open-source.

6. **Multi-Agent appears 7 times** — agent frameworks and LLM orchestration libraries (AutoGen, LangChain agents,crewai). This is a newly emergent pattern not present in any other source.

---

## Language Distribution

| Language | Count | Percentage |
|----------|-------|------------|
| Java/Kotlin | 32 | 18% |
| Python | 29 | 17% |
| C# (.NET) | 35 | 20% |
| Go | 24 | 14% |
| TypeScript | 23 | 13% |
| Ruby | 10 | 6% |
| JavaScript | 6 | 3% |
| C/C++ | 5 | 3% |
| PHP | 4 | 2% |

**Key insight:** .NET shows strong presence (35 repos) — substantially higher than AOSA (0). The ecosystem has matured significantly since 2012.

---

## Quality Attributes Prioritized

| Quality Attribute | Count | Percentage |
|-------------------|-------|------------|
| **Deployability** | 106 | 61% |
| **Modularity** | 41 | 24% |
| **Scalability** | 37 | 21% |
| **Fault Tolerance** | 23 | 13% |
| **Observability** | 7 | 4% |
| **Performance** | 5 | 3% |
| **Extensibility** | 5 | 3% |

### Key Findings

1. **Deployability dominates** (61%) — driven by Docker/Kubernetes signals. This is a structural signal bias: container configs are easily detected, whereas runtime quality attributes (performance under load) require deeper analysis.

2. **Scalability at 21%** — higher than AOSA (33%) and comparable to KataLog (62%). Projects with horizontal scaling infrastructure (k8s, message queues, load balancers) are readily classified.

3. **Performance appears only 5 times** — this is a detection gap. Performance is difficult to infer from filesystem structure alone. The classifier correctly avoids false positives but under-reports this attribute.

4. **Observability at 4%** — low but growing. Projects with OpenTelemetry, Prometheus, or Grafana signals are increasingly common.

---

## Structural Signal Analysis

The classifier evaluates 10 signal categories:

| Signal Category | Avg Count per Repo | Coverage |
|-----------------|-------------------|----------|
| Package manifests | 47 | 100% |
| Container orchestration | 3.2 | 72% |
| Messaging | 2.1 | 58% |
| CI/CD | 2.8 | 65% |
| Test structure | 3.4 | 78% |
| API specs | 1.1 | 34% |
| Directory patterns | 2.6 | 61% |
| ADRs | 0.2 | 8% |
| Infrastructure as code | 1.4 | 42% |
| Documentation | 1.8 | 51% |

### Detection Biases

**Over-represented patterns:**
- Docker/Kubernetes signals → Microservices, Service-Based
- Message broker configs → Event-Driven
- Domain directory names → DDD, Modular Monolith

**Under-represented patterns:**
- Plugin architectures (runtime extension points invisible to filesystem)
- Pipeline patterns (data processing stages often in single codebases)
- Actor models (may appear as Space-Based only if explicit supervisor hierarchies)

---

## Confidence Distribution

| Confidence Range | Count | Percentage |
|-----------------|-------|------------|
| 0.90+ | 142 | 82% |
| 0.70-0.89 | 22 | 13% |
| 0.50-0.69 | 9 | 5% |
| < 0.50 | 0 | 0% |

**Key insight:** 82% of entries have high confidence (0.90+), indicating strong structural signals. The 9 medium-confidence entries (0.50-0.69) all required LLM review to finalize classification.

---

## Multi-Style Composition

| Composition | Count |
|-------------|-------|
| Single style | 52 (30%) |
| 2 styles | 67 (39%) |
| 3 styles | 38 (22%) |
| 4+ styles | 16 (9%) |

**Key insight:** 70% of Discovered repos use multi-style composition, consistent with KataLog (73%) and reflecting real-world architectural evolution.

---

## Summary: Discovered vs. Other Sources

| Metric | KataLog | AOSA | RealWorld | RefArch | Discovered |
|--------|---------|------|-----------|---------|------------|
| Count | 78 | 12 | 5 | 8 | 173 |
| Primary style | Event-Driven (56%) | Pipeline (42%) | Service-Based (40%) | Microservices (63%) | Event-Driven (51%) |
| Multi-style | 73% | 67% | 80% | 75% | 70% |
| Top QA | Scalability (62%) | Performance (42%) | Performance (60%) | Testability (50%) | Deployability (61%) |
| Detection method | Competition | Case study | Case study | Teaching code | Automated |

The Discovered source provides breadth across 12 canonical styles, with at least 7 repos per style (Space-Based at 8, Multi-Agent at 7). This makes it valuable for benchmarking production practice against competition assumptions.