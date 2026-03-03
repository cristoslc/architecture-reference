# Cross-Source Architecture Evidence Reference

Maps the library's architecture styles to weighted evidence across all five sources. Production evidence from real-world applications is weighted most heavily; automated discovery from 173 open-source repositories adds code-level breadth.

Generated: 2026-03-03

---

## Evidence Weighting Methodology

Not all evidence is equal. A pattern proven at production scale is stronger evidence than a competition design that was never built, which is in turn stronger than a template with a sample domain. The weighting reflects this hierarchy.

### Evidence Point Values

| Source | Entry Type | Points | Rationale |
|--------|-----------|--------|-----------|
| **AOSA** | Production system described by creator | **20** | Built, deployed, operated at scale. Architecture validated by years of real-world use. A single production system outweighs an entire Kata competition. |
| **RealWorldASPNET** | Production application (active) | **20** | Deployed production software with real users. Same confidence as AOSA. |
| **TheKataLog** | 1st place competition winner | 4 | Expert-judged best design for a specific problem, but never built |
| **TheKataLog** | 2nd place | 3 | Strong validated design |
| **TheKataLog** | 3rd place | 2 | Recognized quality |
| **TheKataLog** | Runner-up | 1 | Participated, design not distinguished by judges |
| **Reference Impl** | Active/maintained repo | 2 | Working code with community validation, but sample domain — not production-tested at scale |
| **Reference Impl** | Archived repo | 1 | Working code, but no longer maintained |

### Why this weighting

- **A single production system (20 pts) outweighs an entire Kata competition (~13 pts across all placements).** NGINX serving 30% of the internet is categorically stronger evidence than all teams in any single Kata season combined. Code running in production under real conditions is a different class of evidence from a design proposal that was never built.
- **Competition winners (4 pts) outweigh templates (2 pts).** Expert judges evaluated trade-offs against a real problem statement; a template demonstrates a pattern in a to-do app.
- **Production evidence now dominates the rankings.** Patterns like Pipeline (100% production) and Plugin/Microkernel (97% production) surge to the top, while competition-popular patterns like Microservices (0% production) and Serverless (0% production) drop. This corrects the competition bias where teams default to trendy patterns without production validation.

### Discovered evidence: breadth, not depth

The Discovered source (173 open-source repositories classified by automated signal detection with LLM review) is not included in the Combined Weighted Scoreboard. These are working codebases on GitHub, but the classification is automated, the quality varies (production systems mixed with tutorials and samples), and we cannot verify production deployment. Rather than assign an arbitrary point weight that would distort the curated scoreboard, Discovered entry counts are shown as a separate column for breadth context.

The Discovered column answers: *"How many open-source codebases exhibit this pattern?"* The Combined score answers: *"How strong is the expert-validated evidence for this pattern?"* Both questions matter; they measure different things.

---

## Combined Weighted Scoreboard

| Rank | Style | KataLog | AOSA | RealWorld | Ref Impls | Combined | Entries | Discovered | vs KataLog-only |
|------|-------|---------|------|-----------|-----------|----------|---------|------------|-----------------|
| 1 | **Event-Driven** | 94 | 60 | 40 | 9 | **203** | 57 | 100 | -- |
| 2 | **Plugin/Microkernel** | 4 | 60 | 60 | 0 | **124** | 8 | 0 | **+9** (was #11) |
| 3 | **Pipeline** | 0 | 100 | 20 | 0 | **120** | 6 | 47 | **NEW** |
| 4 | **Service-Based** | 43 | 40 | 20 | 2 | **105** | 29 | 10 | -1 (was #3) |
| 5 | **Microservices** | 67 | 0 | 0 | 9 | **76** | 44 | 54 | -3 (was #2) |
| 6 | **Modular Monolith** | 18 | 0 | 20 | 2 | **40** | 8 | 42 | -2 (was #4) |
| 7 | **CQRS/Event Sourcing** | 8 | 0 | 20 | 5 | **33** | 7 | 30 | **+1** (was #8) |
| 8 | **Space-Based** | 4 | 20 | 0 | 0 | **24** | 3 | 10 | +2 (was #10) |
| 9 | **Layered Architecture** | 0 | 0 | 20 | 0 | **20** | 1 | 44 | **NEW** |
| 10 | **Domain-Driven Design** | 11 | 0 | 0 | 5 | **16** | 7 | 51 | -4 (was #6) |
| 11 | **Hexagonal/Clean** | 10 | 0 | 0 | 6 | **16** | 7 | 15 | -4 (was #7) |
| 12 | **Serverless** | 12 | 0 | 0 | 2 | **14** | 9 | 10 | -7 (was #5) |
| 13 | **Multi-Agent** | 8 | 0 | 0 | 0 | **8** | 3 | 10 | -4 (was #9) |

### What changed with production-weighted scoring (20 pts)

With production systems at 20 pts each (up from 6), a single production system now outweighs an entire Kata competition season. This dramatically reshapes the rankings:

1. **Plugin/Microkernel surges to #2 (was #11).** Six production systems (LLVM, SQLAlchemy, GStreamer, Jellyfin, Orchard Core, nopCommerce) across compilers, ORMs, multimedia, media servers, CMS, and e-commerce make this the largest rank correction in the dataset. 97% of its score comes from production evidence. Only 2 Kata teams ever used this pattern — competition data alone made it nearly invisible.

2. **Pipeline rises to #3 (was invisible in KataLog).** Five AOSA projects (NGINX, LLVM, ZeroMQ, Graphite, GStreamer) plus Jellyfin give Pipeline 120 points — all from production. Zero Kata teams proposed pipeline as a primary style, yet it underpins some of the most successful production systems ever built.

3. **Microservices drops to #5 (was #2).** Still the second-most popular Kata style (39 teams, 67 pts), but zero production evidence across all sources. Every point comes from competition designs and reference templates. This is the sharpest signal that competition popularity does not equal production adoption.

4. **Service-Based rises to #4 (was #3).** Selenium, Graphite, and Bitwarden provide 60 pts of production evidence (57% of total), reinforcing its competition showing.

5. **CQRS/Event Sourcing climbs to #7 (was #8).** Squidex provides the first production CQRS/ES evidence (61% of score). Every content change stored as an immutable event, with MongoDB as event store.

6. **Serverless drops to #12 (was #5).** Still zero production evidence across all sources. 8 KataLog teams and 1 reference implementation, but no AOSA or RealWorldASPNET projects use serverless as a primary style. The gap between competition popularity and production adoption is second only to Microservices.

7. **Layered Architecture enters at #9.** nopCommerce's four-layer architecture (20 pts, 100% production) places it above DDD, Hexagonal/Clean, Serverless, and Multi-Agent — all of which lack any production backing.

### What the Discovered column reveals

The Discovered column adds 173 open-source repositories classified from structural signals (Docker configs, message queues, API specs, directory structure). Comparing code-level breadth against the curated scoreboard exposes several patterns:

1. **Code popularity diverges from curated evidence.** DDD has the 4th-highest Discovered count (51 repos) but ranks #10 in the curated scoreboard (16 pts, 0% production). Layered has the 5th-highest (44 repos) but ranks #9 (20 pts, single production exemplar). These patterns are widely implemented in open-source code but lack expert validation at multiple lifecycle stages.

2. **Pipeline/Pipe-and-Filter is confirmed.** 47 Discovered repos (data processing pipelines, ETL systems, stream processors) reinforce AOSA's production evidence. This is the style where code-level breadth and production-level depth converge most strongly.

3. **Plugin/Microkernel has zero Discovered entries.** The #2 curated style (124 pts, 97% production) is structurally undetectable by automated discovery because plugin architectures are defined by runtime extension points and host-plugin contracts, not by directory structure or container orchestration. This is a blind spot in signal-based classification.

4. **Microservices dominates code but not production.** 54 Discovered repos (31% of all discoveries) vs. 0 production systems. The design-production gap is even wider when code-level evidence is included: many teams build microservices tutorials and sample apps, but no microservices system in the evidence base has production validation.

5. **Event-Driven's breadth is proportional to its depth.** 100 Discovered repos (58% of all discoveries) aligns with Event-Driven's #1 curated ranking. Unlike Microservices, where code breadth outpaces production evidence, Event-Driven is consistently the most common pattern at every evidence tier.

### Production Evidence Share

Percentage of each style's combined score from production sources (AOSA + RealWorldASPNET):

| Style | Production % | Production Sources |
|-------|-------------|-------------------|
| Pipeline | **100%** | NGINX, LLVM, ZeroMQ, Graphite, GStreamer, Jellyfin |
| Layered | **100%** | nopCommerce |
| Plugin/Microkernel | **97%** | LLVM, SQLAlchemy, GStreamer, Jellyfin, Orchard Core, nopCommerce |
| Space-Based | **83%** | Riak |
| CQRS/Event Sourcing | **61%** | Squidex |
| Service-Based | **57%** | Selenium, Graphite, Bitwarden |
| Modular Monolith | **50%** | Orchard Core |
| Event-Driven | **49%** | NGINX, Twisted, ZeroMQ, Squidex, Bitwarden |
| Microservices | 0% | (no production evidence) |
| DDD | 0% | (no production evidence) |
| Hexagonal/Clean | 0% | (no production evidence) |
| Serverless | 0% | (no production evidence) |
| Multi-Agent | 0% | (no production evidence) |

**Remaining gaps:** Five styles have zero production evidence: Microservices, DDD, Hexagonal/Clean, Serverless, and Multi-Agent. Discovered evidence shows all five have active open-source implementations (54, 51, 15, 10, and 10 repos respectively), confirming they are widely *built* but not yet *validated at production scale* within this evidence base. Microservices (54 Discovered repos, #2 in KataLog) has the widest gap between code popularity and production adoption. DDD (51 Discovered repos, #4 in code breadth) is the most-implemented pattern with zero production backing — a priority gap for future evidence collection.

---

## Evidence Coverage by Style (Detailed)

| Style | KataLog | AOSA | RealWorldASPNET | Ref Impls | Discovered | Total |
|-------|---------|------|-----------------|-----------|------------|-------|
| **Event-Driven** | 47 | 3 (NGINX, Twisted, ZeroMQ) | 2 (Squidex, Bitwarden) | 5 | 100 | 157 |
| **Microservices** | 39 | 0 | 0 | 5 | 54 | 98 |
| **Domain-Driven Design** | 4 | 0 | 0 | 3 | 51 | 58 |
| **Pipeline / Pipe-and-Filter** | 0 | 5 (NGINX, LLVM, ZeroMQ, Graphite, GStreamer) | 1 (Jellyfin) | 0 | 47 | 53 |
| **Modular Monolith** | 6 | 0 | 1 (Orchard Core) | 1 | 42 | 50 |
| **Layered Architecture** | 0 | 0 | 1 (nopCommerce) | 0 | 44 | 45 |
| **Service-Based** | 25 | 2 (Selenium, Graphite) | 1 (Bitwarden) | 1 | 10 | 39 |
| **CQRS/Event Sourcing** | 3 | 0 | 1 (Squidex) | 3 | 30 | 37 |
| **Hexagonal/Clean** | 4 | 0 | 0 | 3 | 15 | 22 |
| **Serverless** | 8 | 0 | 0 | 1 | 10 | 19 |
| **Space-Based** | 2 | 1 (Riak) | 0 | 0 | 10 | 13 |
| **Multi-Agent** | 3 | 0 | 0 | 0 | 10 | 13 |
| **Plugin/Microkernel** | 2 | 3 (LLVM, SQLAlchemy, GStreamer) | 3 (Jellyfin, Orchard Core, nopCommerce) | 0 | 0 | 8 |

**Source totals:** KataLog 78 teams, AOSA 12 projects, RealWorldASPNET 5 projects, Reference Impls 8 repos, Discovered 173 repos = **276 entries** across all five sources.

Note: Entry counts per style sum to more than total entries because each entry may exhibit multiple styles (e.g., a Discovered repo classified as both Event-Driven and Microservices counts once in each row). Discovered uses "Pipe-and-Filter" as the canonical name for the same pattern AOSA calls "Pipeline."

---

## Cloud Provider Pattern Mapping

Maps cloud provider design pattern documentation to the library's architecture styles.

### Event-Driven Architecture

| Provider | Pattern | Reference |
|----------|---------|-----------|
| AWS | Event-Driven Architecture | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/modernization-decomposing-monoliths/event-driven.html) |
| AWS | Saga Pattern (choreography) | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/saga.html) |
| Azure | Event-Driven Architecture style | [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) |
| Azure | Competing Consumers | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/competing-consumers) |
| Azure | Publisher-Subscriber | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/publisher-subscriber) |
| GCP | Event-Driven Architecture | [Google Cloud Architecture Center](https://cloud.google.com/architecture/event-driven) |

### Microservices

| Provider | Pattern | Reference |
|----------|---------|-----------|
| AWS | Decompose by business capability | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/decomposition.html) |
| AWS | API Gateway pattern | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/api-gateway.html) |
| Azure | Microservices architecture style | [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices) |
| Azure | Sidecar pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/sidecar) |
| Azure | Ambassador pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/ambassador) |
| GCP | Microservices architecture | [Google Cloud Architecture Center](https://cloud.google.com/architecture/microservices-architecture-introduction) |

### Service-Based Architecture

| Provider | Pattern | Reference |
|----------|---------|-----------|
| Azure | Web-Queue-Worker | [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/web-queue-worker) |
| Azure | N-tier architecture | [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/n-tier) |
| AWS | Strangler Fig pattern | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/strangler-fig.html) |

### CQRS/Event Sourcing

| Provider | Pattern | Reference |
|----------|---------|-----------|
| Azure | CQRS pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs) |
| Azure | Event Sourcing pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing) |
| Azure | Materialized View pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/materialized-view) |
| AWS | CQRS pattern | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/cqrs.html) |

### Serverless

| Provider | Pattern | Reference |
|----------|---------|-----------|
| AWS | Serverless architecture patterns | [AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/latest/dg/lambda-architecture.html) |
| Azure | Serverless architecture style | [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/serverless) |
| GCP | Serverless architecture | [Google Cloud Architecture Center](https://cloud.google.com/architecture/serverless-overview) |

### Resilience / Cross-Cutting (Applies to Multiple Styles)

| Provider | Pattern | Reference |
|----------|---------|-----------|
| Azure | Circuit Breaker | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker) |
| Azure | Retry pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/retry) |
| Azure | Bulkhead pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/bulkhead) |
| AWS | Throttling pattern | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/throttling.html) |
| All | Health Endpoint Monitoring | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/health-endpoint-monitoring) |

---

## Evidence Quality Comparison

| Dimension | TheKataLog | AOSA | RealWorldASPNET | Reference Impls | Discovered |
|-----------|-----------|------|-----------------|-----------------|------------|
| **Evidence type** | Competition design proposals | Book-chapter narratives by creators | Production apps with real users | Working code, sample domain | Working open-source code, auto-classified |
| **Evidence weight** | **1-4 pts** (placement) | **20 pts** (production) | **20 pts** (production) | **1-2 pts** (template) | Not weighted (breadth context) |
| **Entries** | 78 teams | 12 projects | 5 projects | 8 repos | 173 repos |
| **Has running code?** | No | No (describes existing code) | Yes | Yes | Yes |
| **Has real users?** | No | Yes (millions) | Yes (thousands to millions) | No (developers only) | Varies (some production, some tutorial) |
| **Covers production scale?** | No (theoretical) | Yes | Yes | No (sample domains) | Unknown (not verified) |
| **Architecture styles** | 12 canonical + variants | Pipeline, Plugin, Event-Driven | CQRS/ES, Plugin, Modular Monolith | Microservices, Hexagonal, DDD | All 12 canonical styles (n >= 10 each) |
| **Language diversity** | N/A (design only) | C, C++, Python, Java, Erlang | C# (.NET) | C#, Java, Go | Go, Java, Python, C#, TypeScript, Rust, Kotlin, Ruby, Elixir |
| **Strengths** | Large sample, placement data | Real-world, production insights | Modern .NET, actively maintained | Executable, testable | Massive breadth, all 12 styles, multi-language, includes ecosystems |
| **Limitations** | Competition bias, no code | Dated (2011-2012) | .NET-only, 5 entries | Sample domains, vendor-specific | Automated classification, quality varies, production status unverified |
