---
project: "OpenMRS Core"
date: 2026-03-11
scope: platform
use-type: production
primary-language: Java
confidence: 0.91
styles:
  - name: Microkernel
    role: primary
    confidence: 0.91
  - name: Layered
    role: primary
    confidence: 0.88
  - name: Modular Monolith
    role: secondary
    confidence: 0.75
---

# Architecture Analysis: OpenMRS Core

## Metadata

| Field | Value |
|---|---|
| Project | OpenMRS Core |
| Version | 3.0.0-SNAPSHOT |
| Repo | https://github.com/openmrs/openmrs-core |
| Date | 2026-03-11 |
| Scope | platform |
| Domain | Healthcare / Electronic Medical Records |
| Primary Language | Java |
| Languages | Java, SQL, XML |
| Build System | Maven (multi-module) |
| Deployment | WAR (Tomcat / Jetty) |

## Classification

| Attribute | Value |
|---|---|
| Architecture Styles | Microkernel (primary), Layered (primary), Modular Monolith (secondary) |
| Classification Confidence | 0.91 |
| Classification Method | deep-analysis |
| Classification Model | claude-sonnet-4-6 |

## One-Line Summary

Spring-based healthcare EMR platform structured as a three-tier layered monolith with an explicit microkernel module system that allows third-party plugins to extend the core at AOP-backed service extension points, privilege-controlled APIs, and named UI extension points.

---

## Architecture Classification Analysis

### Primary Style 1: Microkernel (0.91)

The defining characteristic of OpenMRS Core is its **module system** — a runtime plugin framework that allows third-party `.omod` files to be loaded, started, and stopped without restarting the application.

Key evidence:

- `api/src/main/java/org/openmrs/module/ModuleFactory.java` (1628 lines) manages the full lifecycle: `loadModule()`, `startModule()`, `stopModule()`, `unloadModule()`. Modules are discovered from a repository URL (`https://modules.openmrs.org/modules`) and loaded dynamically via `OpenmrsClassLoader`.
- `org.openmrs.module.Module` is the canonical plugin descriptor: `moduleId`, `version`, `requireOpenmrsVersion`, `activatorName`, `extensions`, Spring application context XML (`moduleApplicationContext.xml`), and Liquibase changelogs.
- `org.openmrs.module.ModuleActivator` defines the full plugin lifecycle contract: `willStart()`, `started()`, `willStop()`, `stopped()`, `willRefreshContext()`, `contextRefreshed()`, plus `setupOnVersionChangeBeforeSchemaChanges()` and `setupOnVersionChange()` for migration hooks.
- `org.openmrs.module.Extension` implements named **UI extension points**: modules declare extensions for specific `pointId` values (e.g., header links, admin sections). `ModuleFactory.extensionMap` maps each point ID to an ordered list of contributing extensions.
- Modules contribute additional Spring beans via their own `moduleApplicationContext.xml`, which is loaded by `web.xml` using `classpath*:/moduleApplicationContext.xml`.
- AOP advice (`api/src/main/java/org/openmrs/aop/`): `AuthorizationAdvice` intercepts every service call as a `MethodBeforeAdvice`, enforcing `@Authorized` privilege checks. Modules can add their own `Advisor` objects at runtime. `LoggingAdvice` and `RequiredDataAdvice` are also applied cross-cuttingly to all services.
- `ServiceContext` (singleton, `factory-method="getInstance"`) is the runtime plugin registry. Modules register additional `OpenmrsService` implementations via `ServiceContext.setService(Class, OpenmrsService)`, making them accessible globally through `Context.getService(MyModuleService.class)`.
- The `HandlerUtil` pattern allows modules to register implementations of handler interfaces (e.g., `EncounterVisitHandler`, `IdentifierValidator`) discovered at startup through `HandlerUtil.getHandlersForType()`.

The core is a minimal but complete kernel: patient records, concepts, encounters, orders, users, and a scheduler. All clinical workflow extension happens through modules.

### Primary Style 2: Layered (0.88)

Independently and simultaneously, OpenMRS Core enforces a strict **four-tier layered architecture** within the kernel itself:

1. **Presentation layer** — `web/` module: `DispatcherServlet`, `StaticDispatcherServlet`, `filter/`, `controller/`. Handles HTTP request routing. No business logic.
2. **Service layer** — `api/src/main/java/org/openmrs/api/`: 23 service interfaces (`PatientService`, `EncounterService`, `ConceptService`, `OrderService`, etc.) all extending `OpenmrsService`. Each is wrapped in AOP proxies for authorization, logging, and required-data population. `@Transactional` is applied at the service implementation level.
3. **DAO layer** — `api/src/main/java/org/openmrs/api/db/`: 20+ DAO interfaces (`PatientDAO`, `EncounterDAO`, etc.) with Hibernate implementations in `db/hibernate/` (e.g., `HibernatePatientDAO`). The DAO layer is never accessed directly by callers outside the service layer.
4. **Domain model** — `api/src/main/java/org/openmrs/`: rich domain objects (`Patient`, `Encounter`, `Obs`, `Order`, `Concept`, `Person`) mapped to MySQL/MariaDB via JPA/Hibernate annotations and `hibernate.cfg.xml`. Schema migrations managed by Liquibase.

**Cross-cutting concerns are applied uniformly via AOP:**
- `AuthorizationAdvice` — privilege enforcement on every service method.
- `LoggingAdvice` — method entry/exit tracing on all services.
- `RequiredDataAdvice` — fires `SaveHandler`/`VoidHandler`/`UnvoidHandler` callbacks to fill required fields before persistence.

The `applicationContext-service.xml` wires each service interface to its implementation and DAO through Spring DI. Validators (23 classes in `org.openmrs.validator`) form an auxiliary validation tier invoked by the service layer.

### Secondary Style: Modular Monolith (0.75)

The Maven build produces a single deployable WAR (`webapp/target/openmrs.war`). Within that WAR, the codebase is structured into well-separated Maven modules:

- `api/` — core business logic, domain model, DAO interfaces, module system
- `web/` — HTTP/servlet layer, module web extensions
- `webapp/` — WAR packaging, web.xml, static assets
- `liquibase/` — database migration scripts
- `tools/` — compile-time utilities (doclets, etc.)
- `test/`, `test-suite/` — shared test infrastructure
- `bom/` — Bill of Materials for dependency management

All modules share one classpath, one Spring application context, one Hibernate session factory, and one relational database. There is no inter-process communication, no message broker, and no distributed deployment topology in the core itself. This is a modular monolith — the module boundaries are Maven artifact boundaries, but all modules execute in one JVM process.

---

## What Was Rejected and Why

**Not Microservices:** The entire system deploys as one WAR file. There is one database, one Spring context, one JVM. Modules are not independent services — they are dynamically loaded JARs in the same process.

**Not Event-Driven (primary):** The `EventListeners` / `GlobalPropertyListener` pattern is a narrow internal notification mechanism for configuration changes only, not a primary coordination mechanism. There is no message broker, no event bus, no publish-subscribe infrastructure driving application flow.

**Not Service-Based:** Service-Based architecture implies independently deployable service units. OpenMRS Core has no such topology.

**Not Hexagonal Architecture:** While the DAO interface layer creates a degree of persistence abstraction, there are no formal "port" definitions and the layering is explicitly directional (top-down), not radial. The module system adds extension points but these are not primary/secondary ports in the Hexagonal sense.

**Not Pipeline:** Data does not flow through a sequence of processing stages. The request-response model through Controller → Service → DAO → Database is a layered call stack, not a pipeline.

---

## Quality Attributes Evidence

**EXTENSIBILITY:** The module system is the project's primary value proposition. The README explicitly states: "OpenMRS has a modular architecture that allows developers to extend the OpenMRS core functionality by creating modules that can easily be added or removed." Module Repository at `https://addons.openmrs.org/` lists hundreds of extensions.

**SECURITY:** `AuthorizationAdvice` enforces `@Authorized` privilege annotations on every service method call via AOP. Role-based access control (`Role`, `Privilege`) is a first-class domain concept. Authentication schemes (`DaoAuthenticationScheme`, `UsernamePasswordAuthenticationScheme`) are pluggable.

**MAINTAINABILITY:** Clear layered separation of concerns prevents cross-layer coupling. All 23 services expose interfaces; implementations are injectable. 36 validator classes enforce domain invariants at the service layer. AOP advice handles cross-cutting concerns without polluting business logic.

**EVOLVABILITY:** Liquibase manages all schema migrations, including per-module changelogs. Modules declare `requireOpenmrsVersion` to enforce compatibility contracts. `BaseModuleActivator` buffers modules from changes to `ModuleActivator` interface. The `setupOnVersionChangeBeforeSchemaChanges()` hook in `ModuleActivator` allows safe migrations at upgrade time.

**OBSERVABILITY:** `LoggingAdvice` provides uniform method-level logging across all services. Log4j2 configured via `log4j2.xml`. `LoggingConfigurationGlobalPropertyListener` allows runtime log configuration changes.

**TESTABILITY:** Shared `test/` module provides base classes and test utilities. Hibernate H2 in-memory database profile (`installation.h2.properties`) supports fast integration testing. 424 test Java files support broad coverage.

**PORTABILITY:** WAR packaging allows deployment to any Jakarta EE-compatible servlet container (Tomcat, Jetty). Docker Compose files provided for containerized deployments. ElasticSearch optional via Docker Compose override.

---

## Repository Structure

```
openmrs-core/
├── api/                        # Core API: domain, services, DAOs, module system
│   └── src/main/java/org/openmrs/
│       ├── (domain objects)    # Patient, Encounter, Obs, Concept, Order, ...
│       ├── api/                # 23 service interfaces + implementations + DAOs
│       │   ├── context/        # Context, ServiceContext, Daemon, auth schemes
│       │   ├── impl/           # Service implementations (@Transactional)
│       │   ├── db/             # DAO interfaces + Hibernate implementations
│       │   ├── handler/        # Save/Void/Unvoid handler extension points
│       │   └── cache/          # Spring Cache configuration (Infinispan)
│       ├── aop/                # AuthorizationAdvice, LoggingAdvice, RequiredDataAdvice
│       ├── module/             # ModuleFactory, Module, ModuleActivator, Extension
│       ├── scheduler/          # Task scheduling service
│       ├── hl7/                # HL7 v2 message ingest pipeline
│       ├── notification/       # Alert and mail notification services
│       ├── logic/              # Clinical logic evaluation engine
│       └── validator/          # 23+ domain validators
├── web/                        # Web layer: servlet, filters, module web extensions
├── webapp/                     # WAR packaging, web.xml, static assets
├── liquibase/                  # Schema migration scripts (Liquibase changelogs)
├── bom/                        # Maven Bill of Materials
├── tools/                      # Compile-time utilities
├── test/                       # Shared test infrastructure
└── test-suite/                 # Integration test suite
```
