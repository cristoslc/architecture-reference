# Discovered Source Analysis: Patterns Across 122 Open-Source Repositories

## Dataset Overview

This analysis covers **122 open-source repositories** automatically discovered via GitHub search and classified using structural signal extraction (extract-signals.sh) combined with multi-turn LLM validation for confidence scoring. Each entry represents a public repository that exhibits identifiable architectural patterns through filesystem signals (Docker configs, message queues, API specs, directory structure). The catalog was pruned from an initial 173 entries by removing ~51 unclassifiable libraries, frameworks, and SDKs that lacked identifiable architecture patterns.

The Discovered source is unique among the five evidence sources: it provides breadth (122 entries vs. 78 KataLog teams, 12 AOSA systems, 5 RealWorldASPNET apps, 8 ReferenceArchitectures) but with lower depth per entry compared to curated sources where each system has a detailed written case study.

| Discovery Method | Year | Repositories |
|-----------------|------|--------------|
| GitHub search + signal extraction | 2026 | 122 |
| Multi-turn validation + LLM review | 2026 | 122 |

---

## Architecture Style Distribution

Each project may exhibit multiple architecture styles. After normalization:

| Architecture Style | Count | Percentage |
|-------------------|-------|------------|
| **Modular Monolith** | 64 | 52% |
| **Event-Driven** | 63 | 52% |
| **Layered** | 29 | 24% |
| **Domain-Driven Design** | 27 | 22% |
| **Microservices** | 26 | 21% |
| **Pipe-and-Filter** | 19 | 16% |
| **CQRS** | 18 | 15% |
| **Hexagonal Architecture** | 16 | 13% |
| **Serverless** | 6 | 5% |
| **Multi-Agent** | 5 | 4% |
| **Space-Based** | 5 | 4% |
| **Service-Based** | 4 | 3% |

### Key Findings

1. **Modular Monolith leads the pruned catalog** (64 of 122, 52%) — a dramatic shift from the pre-pruning distribution where Event-Driven led. Removing unclassifiable libraries and SDKs left a population dominated by well-structured applications that exhibit modular boundaries within a single deployment unit. This is consistent with the KataLog finding that Modular Monolith has the highest win rate (83.3%).

2. **Event-Driven is co-dominant** (63 of 122, 52%) — reflecting the prominence of message brokers (Kafka, RabbitMQ) and async patterns in open-source ecosystems. Many projects layer Event-Driven with other styles (especially Modular Monolith and DDD).

3. **DDD appears in 27 projects (22%)** — substantially higher than KataLog (5%) and AOSA (0%). This suggests that directory structures explicitly naming domain concepts (`/domain/`, `/bounded-context/`, `/aggregates/`) are common signals in well-organized open-source projects.

4. **Microservices at 26 (21%)** — lower than Event-Driven or Modular Monolith. Many repos show service decomposition signals (multiple Docker Compose services, k8s manifests) but maintain a monorepo structure, resulting in Modular Monolith classification. The pruning removed many microservices tutorials and sample apps.

5. **Space-Based appears 5 times** — actor-model frameworks (Akka ports, Orleans clones, Proto.Actor). This pattern is invisible in competition data but present in production open-source.

6. **Multi-Agent appears 5 times** — agent frameworks and LLM orchestration libraries (AutoGen, LangChain agents, crewai). A newly emergent pattern not present in any other source.

---

## Language Distribution

| Language | Count | Percentage |
|----------|-------|------------|
| Java/Kotlin | 25 | 20% |
| Go | 23 | 19% |
| C# (.NET) | 20 | 16% |
| TypeScript | 17 | 14% |
| Python | 14 | 11% |
| Ruby | 9 | 7% |
| C/C++ | 4 | 3% |
| JavaScript | 4 | 3% |
| PHP | 3 | 2% |
| Rust | 1 | 1% |
| (unspecified) | 2 | 2% |

**Key insight:** Java/Kotlin leads the pruned catalog (25 repos), followed closely by Go (23). C# shows strong presence (20 repos) — substantially higher than AOSA (0), reflecting the .NET ecosystem's maturation since 2012.

---

## Quality Attributes Prioritized

| Quality Attribute | Count | Percentage |
|-------------------|-------|------------|
| **Deployability** | 108 | 89% |
| **Modularity** | 41 | 34% |
| **Scalability** | 33 | 27% |
| **Fault Tolerance** | 18 | 15% |
| **Observability** | 4 | 3% |
| **Evolvability** | 2 | 2% |

### Key Findings

1. **Deployability dominates** (89%) — driven by Docker/Kubernetes signals. This is a structural signal bias: container configs are easily detected, whereas runtime quality attributes (performance under load) require deeper analysis.

2. **Scalability at 27%** — projects with horizontal scaling infrastructure (k8s, message queues, load balancers) are readily classified.

3. **Observability at 3%** — low but growing. Projects with OpenTelemetry, Prometheus, or Grafana signals are increasingly common.

4. **Performance and Extensibility are absent** from the pruned catalog's detected QAs — these are detection gaps. Both attributes are difficult to infer from filesystem structure alone. The classifier correctly avoids false positives but under-reports these attributes.

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
- Docker/Kubernetes signals -> Microservices, Service-Based
- Message broker configs -> Event-Driven
- Domain directory names -> DDD, Modular Monolith

**Under-represented patterns:**
- Plugin architectures (runtime extension points invisible to filesystem)
- Pipeline patterns (data processing stages often in single codebases)
- Actor models (may appear as Space-Based only if explicit supervisor hierarchies)

---

## Confidence Distribution

| Confidence Range | Count | Percentage |
|-----------------|-------|------------|
| 0.90+ | 57 | 47% |
| 0.85-0.89 | 59 | 48% |
| 0.80-0.84 | 6 | 5% |
| < 0.80 | 0 | 0% |

**Key insight:** All 122 entries have confidence >= 0.82, with 95% scoring 0.85+. The pruning step removed low-quality entries, tightening the confidence range (was 0.75-1.00, now 0.82-1.00) while shifting the distribution to be more evenly split between the 0.85-0.89 and 0.90+ tiers.

---

## Multi-Style Composition

| Composition | Count |
|-------------|-------|
| Single style | 23 (19%) |
| 2 styles | 53 (43%) |
| 3 styles | 32 (26%) |
| 4 styles | 11 (9%) |
| 5 styles | 3 (2%) |

**Key insight:** 81% of Discovered repos use multi-style composition (up from 70% pre-pruning), with an average of 2.33 styles per entry. The increase reflects the pruning of single-pattern libraries and SDKs, leaving well-structured applications that naturally combine multiple architectural approaches.

---

## Domain Coverage

35 unique domains across 122 entries:

| Domain | Count | Domain | Count |
|--------|-------|--------|-------|
| Developer Tools | 36 | Observability | 3 |
| E-Commerce | 11 | Banking | 2 |
| Infrastructure | 7 | Customer Support | 2 |
| AI/ML | 6 | Database | 2 |
| Data Grid | 6 | Data Integration | 2 |
| Workflow Orchestration | 5 | Food Delivery | 2 |
| Data Processing | 5 | Finance | 2 |
| Messaging | 5 | 13 other domains | 1 each |
| CMS | 4 | | |
| Social Media | 4 | | |

---

## Summary: Discovered vs. Other Sources

| Metric | KataLog | AOSA | RealWorld | RefArch | Discovered |
|--------|---------|------|-----------|---------|------------|
| Count | 78 | 12 | 5 | 8 | 122 |
| Primary style | Event-Driven (56%) | Pipeline (42%) | Plugin Arch (60%) | Microservices (63%) | Modular Monolith (52%) |
| Multi-style | 73% | 67% | 80% | 75% | 81% |
| Top QA | Scalability (62%) | Performance (42%) | Extensibility (60%) | Testability (50%) | Deployability (89%) |
| Detection method | Competition | Case study | Case study | Teaching code | Automated |

The Discovered source provides breadth across 12 canonical styles, with at least 4 repos per style (Service-Based at 4 is the minimum). Eight styles meet the n >= 10 target; four fall short after pruning. This makes it valuable for benchmarking production practice against competition assumptions, with the caveat that thin styles (Serverless: 6, Multi-Agent: 5, Space-Based: 5, Service-Based: 4) have limited statistical power.
