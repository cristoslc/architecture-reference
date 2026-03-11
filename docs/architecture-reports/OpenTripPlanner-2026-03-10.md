---
project: "OpenTripPlanner"
date: 2026-03-10
scope: application
use-type: production
primary-language: Java
confidence: 0.93
styles:
  - name: Modular Monolith
    role: primary
    confidence: 0.93
  - name: Layered
    role: secondary
    confidence: 0.88
---

# Architecture Analysis: OpenTripPlanner

| Field | Value |
|---|---|
| Repository | https://github.com/opentripplanner/OpenTripPlanner |
| Classified | 2026-03-10 |
| Primary Language | Java 25 (Maven multi-module) |
| Domain | Transportation / Multi-Modal Trip Planning |
| Scope | Application |
| Use-Type | Production |
| Confidence | 0.93 |

---

## Architecture Styles

### Primary: Modular Monolith

OpenTripPlanner produces a single shaded JAR (`otp-shaded/target/otp-shaded-VERSION.jar`) yet is organized into eight Maven modules — `utils`, `domain-core`, `raptor`, `astar`, `street`, `gtfs-realtime-protobuf`, `application`, and `otp-shaded` — each with strictly declared compile-time dependencies in its own `pom.xml`. The Raptor transit-routing engine is the canonical example of enforced isolation: `ARCHITECTURE.md` explicitly states "there are no dependencies from Raptor to other parts of OTP code, only to utility classes not found in the JDK," and this is enforced at test time via `RaptorArchitectureTest.java` (ArchUnit). `DEVELOPMENT_DECISION_RECORDS.md` codifies the convention: "Consider adding an `api`, `spi` and mapping code to isolate the module from the rest of the code. Avoid circular dependencies between modules." The Dagger-based wiring convention (`<module>/configure/<Module>Module.java`) provides an explicit composition root that holds all module assembly code away from business logic.

### Secondary: Layered

Within and across modules, `ARCHITECTURE.md` documents four canonical horizontal layers: **Use Case Services** (stateless orchestrators that compose domain services, e.g., `DefaultRoutingService`), **Domain Services** (business logic for a specific domain such as transit or vehicle positions), **Domain Models** (aggregate roots with separate `Service` and `Repository` interfaces), and **Repositories** (mutable model stores consumed by real-time updaters). The service package convention enforces this pattern via a prescribed sub-package layout: `configure/`, `internal/`, `model/`, `<Name>Service`, `<Name>Repository`. The `standalone/configure/ConstructApplication.java` is the single wiring point that assembles all layers top-to-bottom before the server starts.

---

## Evidence Table

| Evidence | Location | Supports |
|---|---|---|
| Single shaded JAR assembly target | `otp-shaded/pom.xml`, `README.md` | Modular Monolith |
| Eight Maven modules with controlled `<dependency>` declarations | `pom.xml` lines 97–107 | Modular Monolith |
| "No dependencies from Raptor to other parts of OTP code" | `ARCHITECTURE.md` lines 64–67 | Modular Monolith |
| `RaptorArchitectureTest` — ArchUnit enforces intra-module package deps | `raptor/src/test/…/RaptorArchitectureTest.java` | Modular Monolith |
| `TimetableRepositoryArchitectureTest`, `DataStoreArchitectureTest` | `application/src/test/…/` | Modular Monolith |
| Dagger wiring convention `<module>/configure/<Module>Module.java` | `DEVELOPMENT_DECISION_RECORDS.md` §Use-Dependency-Injection | Modular Monolith |
| `ConstructApplication` assembles all components before server start | `standalone/configure/ConstructApplication.java` | Modular Monolith |
| Four-layer model: Use Case Service → Domain Service → Domain Model → Repository | `ARCHITECTURE.md` lines 27–35 | Layered |
| `DefaultRoutingService` delegates to `RoutingWorker` → Raptor via SPI | `routing/service/DefaultRoutingService.java` | Layered |
| Prescribed service sub-package layout (`configure/`, `internal/`, `model/`) | `service/package.md` | Layered |
| Aggregate roots, entities, value objects, repositories in transit model | `transit/model/package.md`, `transit/service/TimetableRepository.java` | DDD design-approach |
| `TransitService` / `TransitEditorService` read/write split | `transit/service/TransitEditorService.java`, `TransitService.java` | Layered |
| Real-time updater SPI (`GraphUpdater`, `WriteToGraphCallback`) | `updater/spi/` | Layered |
| GraphQL API layer (GTFS, Transmodel) backed by service interfaces | `apis/gtfs/`, `apis/transmodel/` | Layered |
| Config POJOs injected via Dagger; config module has no OTP dependencies | `standalone/config/package.md` | Layered |
| Sandbox feature-flag mechanism for experimental modules | `CLAUDE.md` §Sandbox Features, `OTPFeature.java` | Modular Monolith |

---

## Quality Attributes

| Attribute | Evidence | Rating |
|---|---|---|
| Modularity | ArchUnit tests enforce zero cross-module leakage; raptor SPI boundary; Dagger DI composition root | High |
| Testability | ArchUnit boundary tests; JUnit 5 unit coverage target; snapshot tests for APIs/itineraries | High |
| Performance | Range Raptor multi-criteria pareto-optimal search; SpeedTest run on every merge; no pointer-chasing over contiguous arrays | High |
| Evolvability | Sandbox feature flags for experimental features; versioned serialization ID; DDD aggregate model enables model evolution | Medium-High |
| Observability | Micrometer metrics; SLF4J/Logback throughout; `ProgressTracker` for long graph builds | Medium |
| Deployability | Single fat-JAR deployment; config via JSON files; graph serialized to `graph.obj` for fast restart | Medium |
| Fault Tolerance | Graceful handling of malformed realtime feeds; `UpdateResult` error model in updater SPI | Medium |

---

## Domain

Transportation / Multi-Modal Trip Planning — OTP is an open-source multi-modal journey planner used in production across Norway (Entur), Finland, the Netherlands, and many US transit agencies. It ingests GTFS and NeTEx schedules plus OpenStreetMap data, builds an in-memory routing graph, and serves trip plans via GraphQL APIs.

---

## Production Context

- Deployed as a standalone long-lived server process; graph is loaded once at startup from a serialized `graph.obj` or rebuilt from source data.
- Real-time transit updates (GTFS-RT, SIRI) are consumed continuously via background updater threads that patch the in-memory timetable snapshot without stopping routing.
- Two GraphQL APIs are offered simultaneously: a GTFS-flavored API (`/gtfs`) and a Transmodel/NeTEx-flavored API (`/transmodel`).
- Performance is mission-critical: the SpeedTest benchmark runs automatically after each merged PR against a real-world Norway dataset; all Raptor changes must demonstrate no regression.
- Versioned serialization (`otp.serialization.version.id = 249`) ensures graph files are rejected if built by an incompatible OTP version, preventing silent data corruption.
