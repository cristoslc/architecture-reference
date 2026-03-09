# Discovered Source Analysis: Patterns Across 184 Open-Source Repositories

## Dataset Overview

This analysis covers **184 open-source repositories** classified using deep-analysis (LLM source code inspection per ADR-002). All entries have deep-analysis classifications with zero Indeterminate results.

Per ADR-001, entries are tagged with `scope` (platform | application) and `use_type` (production | reference). **Frequency rankings below use production-only entries** (142 entries) unless noted.

| Discovery Method | Year | Repositories |
|-----------------|------|--------------|
| GitHub search + signal extraction | 2026 | 184 |
| Deep-analysis classification (ADR-002) | 2026 | 184 |

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

| Rank | Style | Count | % |
|------|-------|-------|---|
| 1 | Microkernel | 83 | 58.5% |
| 2 | Layered | 78 | 54.9% |
| 3 | Modular Monolith | 57 | 40.1% |
| 4 | Event-Driven | 17 | 12.0% |
| 5 | Pipeline | 13 | 9.2% |
| 6 | Microservices | 12 | 8.5% |
| 7 | Service-Based | 7 | 4.9% |
| 8 | Hexagonal Architecture | 5 | 3.5% |
| 9 | Domain-Driven Design | 3 | 2.1% |
| 10 | Multi-Agent | 1 | 0.7% |
| 11 | Space-Based | 1 | 0.7% |
| 12 | CQRS | 1 | 0.7% |

### Platform vs Application Split

| Style | Platforms (87) | % | Applications (55) | % |
|-------|----------|---|-------------|---|
| Microkernel | 53 | 61% | 30 | 55% |
| Layered | 41 | 47% | 37 | 67% |
| Modular Monolith | 36 | 41% | 21 | 38% |
| Event-Driven | 7 | 8% | 10 | 18% |
| Pipeline | 11 | 13% | 2 | 4% |
| Microservices | 11 | 13% | 1 | 2% |
| Service-Based | 4 | 5% | 3 | 5% |
| Hexagonal Architecture | 3 | 3% | 2 | 4% |
| Domain-Driven Design | 2 | 2% | 1 | 2% |
| Multi-Agent | 0 | 0% | 1 | 2% |
| Space-Based | 1 | 1% | 0 | 0% |
| CQRS | 0 | 0% | 1 | 2% |

### Key Findings

1. **Microkernel** leads at 83 of 142 (58%)
2. **Layered** leads at 78 of 142 (55%)
3. **Modular Monolith** leads at 57 of 142 (40%)

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
|  | 1 | 1% |

---

## Confidence Distribution

| Confidence Range | Count | Percentage |
|-----------------|-------|------------|
| 0.90+ | 140 | 76% |
| 0.85-0.89 | 38 | 21% |
| 0.80-0.84 | 4 | 2% |
| 0.70-0.79 | 2 | 1% |
| < 0.70 | 0 | 0% |

---

## Multi-Style Composition

| Composition | Count |
|-------------|-------|
| 1 style | 24 (13%) |
| 2 styles | 137 (74%) |
| 3 styles | 20 (11%) |
| 4 styles | 3 (2%) |

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
| Primary style | Event-Driven (56%) | Pipeline (42%) | Plugin Arch (60%) | Microservices (63%) | Microkernel (58%) |
| Multi-style | 73% | 67% | 80% | 75% | 87% |
| Top QA | Scalability (62%) | Performance (42%) | Extensibility (60%) | Testability (50%) | Deployability (90%) |
| Detection method | Competition | Case study | Case study | Teaching code | Deep analysis |

The Discovered source provides **production-only frequency rankings** per ADR-001, with separate platform and application views. All 184 entries classified via deep-analysis per ADR-002 — zero Indeterminate results.
