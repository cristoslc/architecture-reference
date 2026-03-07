# Discovered Source Analysis: Patterns Across 184 Open-Source Repositories

## Dataset Overview

This analysis covers **184 open-source repositories** automatically discovered via GitHub search and classified using structural signal extraction (extract-signals.sh) combined with multi-turn LLM validation for confidence scoring. The catalog was expanded in SPEC-021 to include 30 production applications across 10 underrepresented domains and 19 ecosystem companion repos.

Per ADR-001, entries are tagged with `scope` (platform | application) and `use_type` (production | reference). **Frequency rankings below use production-only entries** (142 entries) unless noted.

| Discovery Method | Year | Repositories |
|-----------------|------|--------------|
| GitHub search + signal extraction | 2026 | 184 |
| Multi-turn validation + LLM review | 2026 | 184 |

### Taxonomy Composition

| Category | Count |
|----------|-------|
| Production platforms | 87 |
| Production applications | 55 |
| Reference (all) | 42 |
| **Total** | **184** |

Production ratio: 87:55 = 1.58:1

---

## Architecture Style Distribution (Production Only)

Each project may exhibit multiple architecture styles. Production entries only (142 entries):

| Architecture Style | Count | Percentage |
|-------------------|-------|------------|
| **Modular Monolith** | 55 | 39% |
| **Event-Driven** | 47 | 33% |
| **Indeterminate** | 42 | 30% |
| **Pipe-and-Filter** | 33 | 23% |
| **Plugin/Microkernel** | 28 | 20% |
| **Layered** | 27 | 19% |
| **Service-Based** | 18 | 13% |
| **Domain-Driven Design** | 12 | 8% |
| **CQRS** | 10 | 7% |
| **Microservices** | 9 | 6% |
| **Hexagonal Architecture** | 5 | 4% |
| **Space-Based** | 5 | 4% |
| **Multi-Agent** | 3 | 2% |
| **Serverless** | 2 | 1% |

### Platform vs Application Split

| Style | Platforms (87) | % | Applications (55) | % |
|-------|----------|---|-------------|---|
| Modular Monolith | 40 | 46% | 15 | 27% |
| Event-Driven | 31 | 36% | 16 | 29% |
| Indeterminate | 15 | 17% | 27 | 49% |
| Pipe-and-Filter | 25 | 29% | 8 | 15% |
| Plugin/Microkernel | 25 | 29% | 3 | 5% |
| Layered | 15 | 17% | 12 | 22% |
| Service-Based | 9 | 10% | 9 | 16% |
| Domain-Driven Design | 4 | 5% | 8 | 15% |
| CQRS | 4 | 5% | 6 | 11% |
| Microservices | 8 | 9% | 1 | 2% |
| Space-Based | 5 | 6% | 0 | 0% |
| Hexagonal Architecture | 4 | 5% | 1 | 2% |
| Multi-Agent | 2 | 2% | 1 | 2% |
| Serverless | 2 | 2% | 0 | 0% |

### Key Findings

1. **Modular Monolith leads production entries** (55 of 142, 39%) — the most common production pattern, especially in platforms (46%) where modular organization is prevalent.

2. **Event-Driven is #2** (47 of 142, 33%) — down from 48% in the pre-cleanup catalog. Removing libraries and frameworks that inflated async messaging counts brings this closer to true production frequency.

3. **High Indeterminate rate in applications** (27 of 55, 49%) — newly-added application entries have only heuristic classification. LLM review and deep-validation would resolve most of these.

4. **Plugin/Microkernel is platform-dominated** (25 platforms vs 3 applications) — confirming that plugin architectures are primarily an infrastructure pattern.

5. **Application-specific patterns**: Applications show stronger Service-Based (9/55, 16%) and DDD (8/55, 15%) representation than platforms, suggesting application architects encounter different pattern distributions.

---

## Language Distribution

| Language | Count | Percentage |
|----------|-------|------------|
| Java/Kotlin | 35 | 19% |
| Go | 31 | 17% |
| TypeScript | 30 | 16% |
| C# | 29 | 16% |
| Python | 26 | 14% |
| Ruby | 12 | 7% |
| PHP | 6 | 3% |
| JavaScript | 5 | 3% |
| C/C++ | 5 | 3% |
| Rust | 4 | 2% |
| Unknown | 1 | 1% |

---

## Quality Attributes Prioritized

| Quality Attribute | Count | Percentage |
|-------------------|-------|------------|
| **Deployability** | 165 | 90% |
| **Modularity** | 64 | 35% |
| **Scalability** | 43 | 23% |
| **Fault Tolerance** | 27 | 15% |
| **Observability** | 7 | 4% |
| **Evolvability** | 3 | 2% |

---

## Confidence Distribution

| Confidence Range | Count | Percentage |
|-----------------|-------|------------|
| 0.90+ | 0 | 0% |
| 0.85-0.89 | 0 | 0% |
| 0.80-0.84 | 0 | 0% |
| < 0.80 | 0 | 0% |
| No score (new entries) | 184 | — |

---

## Multi-Style Composition

| Composition | Count |
|-------------|-------|
| 1 style | 70 (38%) |
| 2 styles | 51 (28%) |
| 3 styles | 43 (23%) |
| 4 styles | 13 (7%) |
| 5 styles | 5 (3%) |
| 6 styles | 1 (1%) |
| 8 styles | 1 (1%) |

---

## Domain Coverage

47 unique domains across 184 entries:

| Domain | Count | Domain | Count |
|--------|-------|--------|-------|
| Developer Tools | 36 | Database | 2 |
| E-Commerce | 15 | Data Integration | 2 |
| Observability | 11 | CRM | 2 |
| Data Processing | 11 | Food Delivery | 2 |
| Infrastructure | 9 | Finance | 2 |
| Data Grid | 8 | Bioinformatics | 2 |
| Messaging | 6 | Security | 2 |
| Productivity | 5 | Veterinary | 2 |
| Media Automation | 5 | Collaboration | 1 |
| Workflow Orchestration | 5 | Payments | 1 |
| AI/ML | 4 | Travel | 1 |
| CMS | 4 | Scheduling | 1 |
| Fintech | 4 | Media | 1 |
| Education | 4 | Library Management | 1 |
| Social Media | 4 | Real-Time Communications | 1 |
| Logistics | 3 | Caching | 1 |
| Social | 3 | Workflow Automation | 1 |
| Analytics | 3 | Project Management | 1 |
| Healthcare | 3 | Knowledge Management | 1 |
| Conference Management | 2 | CI/CD | 1 |
| Identity Management | 2 | Asset Management | 1 |
| Banking | 2 | Fitness | 1 |
| Customer Support | 2 | DevOps | 1 |
| Government | 2 |  |  |

---

## Summary: Discovered vs. Other Sources

| Metric | KataLog | AOSA | RealWorld | RefArch | Discovered |
|--------|---------|------|-----------|---------|------------|
| Count | 78 | 12 | 5 | 8 | 142 (prod) |
| Primary style | Event-Driven (56%) | Pipeline (42%) | Plugin Arch (60%) | Microservices (63%) | Modular Monolith (39%) |
| Multi-style | 73% | 67% | 80% | 75% | 62% |
| Top QA | Scalability (62%) | Performance (42%) | Extensibility (60%) | Testability (50%) | Deployability (90%) |
| Detection method | Competition | Case study | Case study | Teaching code | Automated |

The Discovered source now provides **production-only frequency rankings** per ADR-001, with separate platform and application views. The production ratio of 87:55 (1.58:1) is within the ≤2:1 target set by EPIC-012.
