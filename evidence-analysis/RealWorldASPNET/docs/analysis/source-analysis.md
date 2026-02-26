# RealWorldASPNET Source Analysis: Patterns Across 5 Production .NET Applications

## Dataset Overview

This analysis covers **5 production open-source ASP.NET Core applications** with real users, active maintenance, and combined GitHub stars exceeding 73,000. Unlike the AOSA projects (described in retrospective book chapters from 2011--2012), these are **modern, actively maintained .NET applications** where the source code can be directly inspected.

Unlike competition designs (KataLog) or teaching codebases (Reference Architectures), these are products people use daily — from managing passwords to streaming media to running online stores.

| Project | Domain | Stars | Year Created | Key Styles |
|---------|--------|-------|-------------|------------|
| Jellyfin | Media server | ~38,000 | 2018 | Plugin, Pipeline, Client-Server |
| Bitwarden Server | Password management | ~16,000 | 2015 | Service-Based, Event-Driven |
| nopCommerce | E-Commerce | ~9,500 | 2008 | Plugin, Layered Architecture |
| Orchard Core | CMS / App Framework | ~7,500 | 2017 | Modular Monolith, Plugin |
| Squidex | Headless CMS | ~2,300 | 2017 | CQRS, Event Sourcing, Event-Driven |

---

## Architecture Style Distribution

| Architecture Style | Count | Projects |
|-------------------|-------|----------|
| **Plugin Architecture** | 3 | Jellyfin, nopCommerce, Orchard Core |
| **Event-Driven** | 2 | Bitwarden, Squidex |
| **Pipeline** | 1 | Jellyfin |
| **Service-Based** | 1 | Bitwarden |
| **Layered Architecture** | 1 | nopCommerce |
| **Modular Monolith** | 1 | Orchard Core |
| **CQRS** | 1 | Squidex |
| **Event Sourcing** | 1 | Squidex |
| **Client-Server** | 1 | Jellyfin |

### Key Findings

1. **Plugin Architecture dominates** (3 of 5 projects). This directly reinforces the AOSA finding where Plugin appears in 3 of 12 projects. Across both production sources combined, Plugin is present in 6 of 17 production systems (35%) — making it the most common production pattern after Pipeline. Yet only 2 of 78 KataLog teams ever proposed it.

2. **Event-Driven appears in 2 of 5** (Bitwarden, Squidex). Unlike KataLog where Event-Driven is the primary style, here it appears as a supporting mechanism: Bitwarden uses AMQP for cross-service events; Squidex uses event sourcing as the fundamental data model. Production systems use events for specific purposes, not as the governing style.

3. **Modular Monolith has production evidence** (Orchard Core). This is significant: Orchard Core proves the pattern works beyond teaching codebases. Its "feature" system with runtime activation/deactivation and NuGet-based distribution is a mature implementation of the modular monolith concept that competition teams propose but rarely detail.

4. **CQRS/Event Sourcing has its first production exemplar** (Squidex). Every content change stored as an immutable event with MongoDB as the event store — this is the production validation that was previously missing for this pattern.

5. **Zero Microservices.** Even Bitwarden, with 9 independently versioned services, self-describes as "Service-Based" rather than Microservices — they share a database and deployment pipeline. This continues the pattern seen in AOSA: production teams favor simpler decomposition strategies over full microservice independence.

---

## Quality Attributes

| Quality Attribute | Count | Projects |
|------------------|-------|----------|
| **Extensibility** | 3 | Jellyfin, nopCommerce, Orchard Core |
| **Security** | 2 | Bitwarden, Squidex |
| **Multi-tenancy** | 2 | Orchard Core, Squidex |
| **Performance** | 1 | Jellyfin |
| **Modularity** | 2 | Orchard Core, nopCommerce |
| **Privacy** | 1 | Jellyfin |
| **Scalability** | 1 | Bitwarden |
| **Data Integrity** | 1 | Squidex |

### Key Findings

1. **Extensibility is the #1 quality attribute** (3 of 5). This perfectly mirrors the AOSA finding where Extensibility is #2 (4 of 12). Combined across both production sources, extensibility appears in 7 of 17 production systems (41%) — by far the most undervalued attribute in KataLog competition entries.

2. **Multi-tenancy appears in 2 of 5** — a production concern entirely absent from KataLog and Reference Architectures. Both Orchard Core and Squidex support tenant isolation within a single deployment. This is a real-world architectural requirement that competition exercises rarely surface.

3. **Security is a first-class concern for 2 of 5** (Bitwarden's zero-knowledge encryption, Squidex's role-based multi-tenant access). In KataLog, security is cited by 37 of 78 teams but rarely backed by specific mechanisms. In production, it's baked into the architecture (Bitwarden's entire existence depends on it).

---

## The Plugin Pattern in Production

With 3 of 5 projects using Plugin Architecture, this source provides the richest evidence for how plugins work in modern production systems:

| Project | Plugin Mechanism | Plugin Count | Discovery Model |
|---------|-----------------|-------------|-----------------|
| **nopCommerce** | ASP.NET Core assembly loading | 1,500+ marketplace | Directory-scan at startup |
| **Jellyfin** | .NET runtime plugin discovery | Community plugins | Runtime discovery with metadata |
| **Orchard Core** | NuGet-based module distribution | Framework features | NuGet packages + runtime activation |

### Common Plugin Architecture Traits

1. **Runtime discovery**: All three scan for and load plugins without recompilation of the host.
2. **Stable core interface**: The host defines contracts; plugins implement them without modifying the core.
3. **Independent lifecycle**: Plugins can be added, removed, or upgraded independently of the core application.
4. **Marketplace/distribution**: All three have mechanisms for distributing plugins beyond the core team.

### How This Compares to AOSA Plugin Systems

The AOSA plugin systems (LLVM pass system, SQLAlchemy dialects, GStreamer elements) share the same core principles but differ in implementation:

- **AOSA plugins** are typically compiled (C/C++) with build-time or load-time linking
- **RealWorldASPNET plugins** use .NET reflection and runtime assembly loading
- Both share: stable interfaces, independent development, capability negotiation

---

## Technology Landscape

| Dimension | Projects |
|-----------|----------|
| **Language** | C# (.NET) — all 5 |
| **Database** | SQL Server (3), PostgreSQL (2), MySQL (1), MongoDB (1), SQLite (1) |
| **Messaging** | RabbitMQ/AMQP (1), internal event bus (2) |
| **Deployment** | Self-hosted (5), Docker (4), Kubernetes (2), Cloud SaaS (2) |

### Key Findings

1. **100% C#/.NET** — this source is deliberately focused on the .NET ecosystem. It complements AOSA's C/C++/Python/Java/Erlang coverage and the Reference Architectures' multi-language set.

2. **SQL-dominant data layer**: 4 of 5 projects use relational databases as their primary store (Squidex uses MongoDB). This contrasts with KataLog competition entries where NoSQL databases are frequently proposed.

3. **Self-hosted as default**: All 5 projects support self-hosting. This reflects a production reality for open-source software that cloud-native KataLog designs rarely address — users want to run the software on their own infrastructure.

---

## Notable Gaps

1. **No AI/ML integration**: None of the 5 projects incorporate AI features as a primary architectural concern.
2. **No real-time streaming**: While Jellyfin does media streaming, none address event-stream processing (Kafka, etc.) as a primary pattern.
3. **.NET monoculture**: Limits generalizability to other language ecosystems.
4. **Limited distributed systems**: Only Bitwarden has multiple services; the other 4 are single-deployment-unit applications.

---

## What RealWorldASPNET Uniquely Contributes

| Dimension | RealWorldASPNET | AOSA | KataLog | Reference Architectures |
|-----------|----------------|------|---------|------------------------|
| **Era** | 2008--2025 (modern) | 2011--2012 | 2020--2025 | 2017--2025 |
| **Code inspectable?** | Yes (open source) | Described in text | No code | Yes (sample domains) |
| **Real users?** | Yes (millions) | Yes (millions) | No | No |
| **Plugin evidence** | 3 projects (strongest) | 3 projects | 2 teams | 0 projects |
| **CQRS/ES evidence** | 1 project (Squidex) | 0 | 3 teams (design only) | 3 projects (teaching) |
| **Modular Monolith** | 1 project (Orchard Core) | 0 | 6 teams (design only) | 1 project (teaching) |
| **Unique insight** | Plugin marketplaces at scale, multi-tenancy, self-hosted deployment | Operational reality, failure modes | What judges reward, statistical patterns | Code-level pattern realization |

---

*Generated: 2026-02-26 from structured YAML metadata in `evidence-analysis/RealWorldASPNET/docs/catalog/`.*
