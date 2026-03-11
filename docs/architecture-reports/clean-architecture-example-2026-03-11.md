# Architecture Report: clean-architecture-example

**Date:** 2026-03-11
**Repo URL:** https://github.com/mattia-battiston/clean-architecture-example
**Classification:** Hexagonal Architecture, Modular Monolith
**Confidence:** 0.97

---

## Summary

`clean-architecture-example` is a textbook Java reference implementation of Clean Architecture (Uncle Bob's variant of Hexagonal Architecture / Ports and Adapters). The project explicitly demonstrates how to structure a single Spring Boot application so that the domain core is isolated from all frameworks, databases, and delivery mechanisms. The module boundary structure is enforced at compile time via Gradle subproject dependencies, making incorrect cross-layer imports a build failure rather than a runtime or convention concern.

---

## Evidence from Code Exploration

### Repository Structure

```
clean-architecture-example/
├── application/
│   ├── core/              # Entities + Use Cases (no framework deps)
│   ├── dataproviders/     # Driven adapters (DB, network)
│   ├── entrypoints/       # Driving adapters (REST, scheduled jobs)
│   └── configuration/     # Composition root + Spring Boot entry point
├── acceptance-tests/
├── integration-tests/
├── build.gradle           # Root Gradle; defines all shared lib versions
└── settings.gradle        # Declares all subprojects
```

### Module Dependency Graph (from Gradle build files)

- `core` — only depends on `commons-lang3` (string utils). Zero framework imports.
- `dataproviders` — depends on `core` + `spring-jdbc`. Implements core port interfaces.
- `entrypoints` — depends on `core` + `spring-web`. Invokes use cases via constructor injection.
- `configuration` — depends on `core`, `dataproviders`, `entrypoints`, and `spring-boot`. Acts as the composition root.

This graph enforces the Dependency Rule: outer modules depend on inner modules, never the reverse.

### Key Port Interfaces (defined in `core`)

- `GetDeviceDetails` — interface for fetching a single device by hostname
- `GetAllDeviceHostnames` — interface for listing all device hostnames
- `GetSerialNumberFromModel` — interface for reading the model's serial number
- `GetSerialNumberFromReality` — interface for reading a device's actual serial number over the network
- `UpdateSerialNumberInModel` — interface for persisting a reconciled serial number
- `DoesExchangeExist` — interface for validating exchange existence
- `GetAvailablePortsOfAllDevicesInExchange` — interface for capacity queries

### Adapter Implementations (in `dataproviders`)

`BroadbandAccessDeviceDatabaseDataProvider` implements five core port interfaces simultaneously (`GetAllDeviceHostnames`, `GetSerialNumberFromModel`, `UpdateSerialNumberInModel`, `GetDeviceDetails`, `GetAvailablePortsOfAllDevicesInExchange`) using Spring JDBC. Framework code (JdbcTemplate) is confined entirely to this adapter module.

`BroadbandAccessDeviceNetworkDataProvider` and `ExchangeDatabaseDataProvider` cover the remaining ports.

### Inbound Adapters (in `entrypoints`)

- `GetBroadbandAccessDeviceEndpoint` — `@RestController` that receives HTTP GET requests and delegates to `GetBroadbandAccessDeviceDetailsUseCase`. Translates the domain entity to a DTO for the JSON response.
- `GetCapacityForExchangeEndpoint` — REST endpoint for exchange capacity queries.
- `ReconcileBroadbandAccessDeviceJob` — `ScheduledJob` implementation that triggers `ReconcileBroadbandAccessDevicesUseCase` every 5 seconds.

### Composition Root (in `configuration`)

`UseCaseConfiguration` is a Spring `@Configuration` class that instantiates use cases by injecting the appropriate adapter implementations through the port interfaces. Use cases are instantiated with plain `new` (no Spring annotations on domain objects), keeping the core framework-free.

### Single Deployable Artifact

`application/configuration/build.gradle` applies the `spring-boot` plugin and produces a single executable JAR named `clean-architecture-example.jar`. There is no separate service infrastructure, message broker, or distributed runtime — this is a self-contained monolith.

---

## Architecture Styles Identified

### Primary: Hexagonal Architecture (Ports and Adapters)

**Evidence:**
1. Core module defines port interfaces (`GetDeviceDetails`, `GetAllDeviceHostnames`, etc.) that outer modules implement — this is the defining Ports and Adapters pattern.
2. Use cases depend only on interface abstractions, never on concrete adapter classes; adapters are wired in the composition root.
3. The `core` Gradle module has zero application-level dependencies: `compile libs.string_utils` only. No Spring, no JDBC, no HTTP.
4. The README explicitly references Uncle Bob's Clean Architecture and Alistair Cockburn's Hexagonal Architecture.
5. Entrypoints (REST controllers, scheduled jobs) are driving adapters; dataproviders (database, network) are driven adapters.
6. The `configuration` module acts as the composition root / wiring layer, the standard Hexagonal pattern for assembly.

### Secondary: Modular Monolith

**Evidence:**
1. All modules compile into a single Spring Boot JAR deployed as one process.
2. Module boundaries are enforced at compile time by Gradle subproject dependencies — `core` cannot import from `dataproviders` without a build failure.
3. The README explicitly calls this a "good monolith" and notes it can be split into microservices later once use cases are well-understood.
4. Four distinct modules (`core`, `dataproviders`, `entrypoints`, `configuration`) each have a clear, bounded responsibility with no shared mutable state crossing boundaries except through the defined port interfaces.

---

## Quality Attributes

| Attribute | Justification |
|-----------|--------------|
| **Testability** | The core has zero framework dependencies, enabling pure unit tests for use cases and domain entities without Spring context startup. Acceptance tests exercise use cases in isolation. A full testing pyramid is implemented: unit, acceptance, integration, end-to-end. |
| **Maintainability** | Business logic is centralized in use case classes. Package structure "screams" intent — reading the tree reveals domain concepts (`broadbandaccessdevice`, `exchange`) before technical details. |
| **Modularity** | Compile-time module boundaries prevent architectural violations. The build fails if a developer incorrectly imports an adapter class into core. |
| **Flexibility / Evolvability** | Frameworks are isolated to adapter modules; swapping Spring for another DI container or a different database layer requires changes only in `dataproviders` and `configuration`, with core untouched. |
| **Deployability** | Single JAR artifact produced by the build simplifies deployment. The README notes continuous deployment readiness ("we're always ready to deploy"). |
| **Separation of Concerns** | Each module has a strictly bounded role: entities/use-cases, adapters, entrypoints, wiring. No cross-cutting business logic leaks into framework code. |

---

## Classification Reasoning

This repository is unambiguously a **Hexagonal Architecture** implementation. The evidence is structural (Gradle module graph enforcing dependency inversion), behavioral (port interfaces defined in core, implemented in adapters), and explicitly self-documented (README cites Cockburn's Hexagonal Architecture and Uncle Bob's Clean Architecture). The dependency rule — all compile dependencies point inward toward the domain core — is the architectural fingerprint of Hexagonal/Clean Architecture and is demonstrably enforced here.

The secondary classification of **Modular Monolith** is appropriate because the four Gradle submodules impose explicit, compile-enforced module boundaries within a single deployable unit. This is not merely a convention — incorrect imports fail the build. The README also frames it as a "good monolith" explicitly.

This is NOT:
- **Layered Architecture**: In Layered, all dependencies flow one direction (Presentation → Business → Data). Here, the dependency direction is inverted — the core defines interfaces that the data layer implements, not the other way around.
- **Domain-Driven Design**: No bounded contexts, aggregates, value objects, domain events, repositories (DDD sense), or ubiquitous language enforcement. Entities are simple POJOs without DDD invariant patterns.
- **Microservices**: Single process, single deployable JAR, shared H2 database.
- **CQRS**: No command/query separation, no separate read/write models or stores.
- **Event-Driven**: No message broker, event bus, or asynchronous event channels. The scheduled job triggers synchronously on a timer.
