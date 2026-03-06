# Discovered Source Analysis: Patterns Across 163 Open-Source Repositories

## Dataset Overview

This analysis covers **163 open-source repositories** automatically discovered via GitHub search and classified using structural signal extraction (extract-signals.sh) combined with multi-turn LLM validation for confidence scoring. Each entry represents a public repository that exhibits identifiable architectural patterns through filesystem signals (Docker configs, message queues, API specs, directory structure).

The Discovered source is unique among the five evidence sources: it provides breadth (163 entries vs. 78 KataLog teams, 12 AOSA systems, 5 RealWorldASPNET apps, 8 ReferenceArchitectures) but with lower depth per entry compared to curated sources where each system has a detailed written case study.

| Discovery Method | Year | Repositories |
|-----------------|------|--------------|
| GitHub search + signal extraction | 2026 | 163 |
| Multi-turn validation + LLM review | 2026 | 163 |

---

## Architecture Style Distribution

Each project may exhibit multiple architecture styles. After normalization:

| Architecture Style | Count | Percentage |
|-------------------|-------|------------|
| **Event-Driven** | 78 | 48% |
| **Modular Monolith** | 60 | 37% |
| **Domain-Driven Design** | 51 | 31% |
| **Microservices** | 43 | 26% |
| **Pipe-and-Filter** | 42 | 26% |
| **Layered** | 35 | 21% |
| **Hexagonal Architecture** | 25 | 15% |
| **CQRS** | 24 | 15% |
| **Indeterminate** | 20 | 12% |
| **Service-Based** | 19 | 12% |
| **Multi-Agent** | 11 | 7% |
| **Serverless** | 8 | 5% |
| **Plugin/Microkernel** | 5 | 3% |
| **Space-Based** | 4 | 2% |

### Key Findings

1. **Event-Driven leads the expanded catalog** (78 of 163, 48%) — reflecting the prominence of message brokers (Kafka, RabbitMQ) and async patterns in open-source ecosystems. The addition of 41 new entries since the last analysis shifted Event-Driven back to the top position, consistent with the pervasiveness of async messaging infrastructure across modern repositories.

2. **Modular Monolith remains strong** (60 of 163, 37%) — many well-structured applications exhibit modular boundaries within a single deployment unit. While no longer the plurality leader, it remains the second most common style, consistent with the KataLog finding that Modular Monolith has the highest win rate (83.3%).

3. **DDD appears in 51 projects (31%)** — substantially higher than KataLog (5%) and AOSA (0%). This suggests that directory structures explicitly naming domain concepts (`/domain/`, `/bounded-context/`, `/aggregates/`) are common signals in well-organized open-source projects. The expanded catalog shows even stronger DDD representation than the previous 122-entry analysis (22%).

4. **Microservices at 43 (26%)** — service decomposition signals (multiple Docker Compose services, k8s manifests) are well-represented. Many repos maintain a monorepo structure alongside microservice deployment.

5. **Indeterminate at 20 (12%)** — entries where the classifier could not assign a confident primary style. These represent repositories with ambiguous structural signals that don't clearly map to a canonical pattern.

6. **Multi-Agent appears 11 times (7%)** — agent frameworks and LLM orchestration libraries (AutoGen, crewAI, Anthropic Cookbook). This emerging pattern has more than doubled since the 122-entry catalog, reflecting rapid growth in the AI agent ecosystem.

7. **Space-Based appears 4 times** — actor-model frameworks (Akka, Hazelcast, Geode, Ignite). This pattern is invisible in competition data but present in production open-source.

---

## Language Distribution

| Language | Count | Percentage |
|----------|-------|------------|
| Python | 30 | 18% |
| Java/Kotlin | 30 | 18% |
| C# | 27 | 17% |
| Go | 24 | 15% |
| TypeScript | 24 | 15% |
| Ruby | 10 | 6% |
| C/C++ | 5 | 3% |
| JavaScript | 5 | 3% |
| (unspecified) | 4 | 2% |
| Rust | 2 | 1% |
| PHP | 2 | 1% |

**Key insight:** Python and Java/Kotlin are co-leaders (30 repos each, 18%), followed closely by C# (27, 17%). Python's rise to co-leader reflects the influx of AI/ML and data processing repositories in the expanded catalog. Go (24) and TypeScript (24) round out the top five. C# shows strong presence — substantially higher than AOSA (0), reflecting the .NET ecosystem's maturation since 2012.

---

## Quality Attributes Prioritized

| Quality Attribute | Count | Percentage |
|-------------------|-------|------------|
| **Deployability** | 144 | 88% |
| **Modularity** | 43 | 26% |
| **Scalability** | 37 | 23% |
| **Fault Tolerance** | 23 | 14% |
| **Observability** | 6 | 4% |
| **Evolvability** | 3 | 2% |

### Key Findings

1. **Deployability dominates** (88%) — driven by Docker/Kubernetes signals. This is a structural signal bias: container configs are easily detected, whereas runtime quality attributes (performance under load) require deeper analysis.

2. **Scalability at 23%** — projects with horizontal scaling infrastructure (k8s, message queues, load balancers) are readily classified.

3. **Observability at 4%** — low but growing. Projects with OpenTelemetry, Prometheus, or Grafana signals are increasingly common.

4. **Performance and Extensibility are absent** from the catalog's detected QAs — these are detection gaps. Both attributes are difficult to infer from filesystem structure alone. The classifier correctly avoids false positives but under-reports these attributes.

---

## Structural Signal Analysis

The classifier evaluates 10 signal categories:

| Signal Category | Avg Count per Repo | Coverage |
|-----------------|-------------------|----------|
| Package manifests | 59.0 | 97% |
| Container orchestration | 16.9 | 77% |
| Messaging | 12.6 | 66% |
| CI/CD | 13.9 | 88% |
| Test structure | 1.6 | 88% |
| API specs | 22.1 | 45% |
| Directory patterns | 1.9 | 73% |
| ADRs | 1.4 | 2% |
| Infrastructure as code | 13.3 | 20% |
| Documentation | 1.5 | 16% |

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
| 0.90+ | 72 | 44% |
| 0.85-0.89 | 41 | 25% |
| 0.80-0.84 | 28 | 17% |
| < 0.80 | 22 | 13% |

**Key insight:** The expanded 163-entry catalog has a wider confidence distribution than the previous pruned set. 69% of entries score 0.85+, with 44% at 0.90+. The 22 entries below 0.80 include newly added repositories with ambiguous structural signals or the Indeterminate style classification. The confidence range spans 0.00-1.00, reflecting the inclusion of entries that were previously excluded by the pruning threshold.

---

## Multi-Style Composition

| Composition | Count |
|-------------|-------|
| Single style | 36 (22%) |
| 2 styles | 43 (26%) |
| 3 styles | 52 (32%) |
| 4 styles | 16 (10%) |
| 5 styles | 13 (8%) |
| 6 styles | 3 (2%) |

**Key insight:** 78% of Discovered repos use multi-style composition, with an average of 2.61 styles per entry. The 3-style combination is the most common (32%), suggesting that production-grade open-source applications naturally combine multiple architectural approaches. Projects with 5-6 styles (10% combined) tend to be large platforms (e.g., Backstage, GitLab, eShop) where scale demands multiple complementary patterns.

---

## Domain Coverage

40 unique domains across 163 entries:

| Domain | Count | Domain | Count |
|--------|-------|--------|-------|
| Developer Tools | 53 | Banking | 2 |
| AI/ML | 16 | Customer Support | 2 |
| E-Commerce | 12 | Database | 2 |
| Data Processing | 8 | Data Integration | 2 |
| Infrastructure | 7 | Caching | 2 |
| Data Grid | 6 | Food Delivery | 2 |
| Messaging | 6 | Finance | 2 |
| Workflow Orchestration | 5 | Bioinformatics | 2 |
| Social Media | 5 | Veterinary | 2 |
| CMS | 4 | 21 other domains | 1 each |
| Observability | 3 | | |

---

## Summary: Discovered vs. Other Sources

| Metric | KataLog | AOSA | RealWorld | RefArch | Discovered |
|--------|---------|------|-----------|---------|------------|
| Count | 78 | 12 | 5 | 8 | 163 |
| Primary style | Event-Driven (56%) | Pipeline (42%) | Plugin Arch (60%) | Microservices (63%) | Event-Driven (48%) |
| Multi-style | 73% | 67% | 80% | 75% | 78% |
| Top QA | Scalability (62%) | Performance (42%) | Extensibility (60%) | Testability (50%) | Deployability (88%) |
| Detection method | Competition | Case study | Case study | Teaching code | Automated |

The Discovered source provides breadth across 14 identified styles (including Indeterminate), with at least 4 repos per concrete style (Space-Based at 4 is the minimum). Nine styles meet the n >= 10 target; five fall short. This makes it valuable for benchmarking production practice against competition assumptions, with the caveat that thin styles (Serverless: 8, Plugin/Microkernel: 5, Space-Based: 4) have limited statistical power. The expanded catalog also introduces 20 Indeterminate entries, providing a useful control group for evaluating classifier precision.
