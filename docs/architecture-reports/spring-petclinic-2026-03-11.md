# Architecture Report: Spring PetClinic

**Date:** 2026-03-11
**Repository:** https://github.com/spring-projects/spring-petclinic
**Classification:** Layered
**Confidence:** 0.97
**Analyst Model:** claude-sonnet-4-6

---

## Summary

Spring PetClinic is the canonical Spring Framework reference application, implementing a veterinary clinic management system as a textbook Layered architecture. The codebase consists of a single deployable Spring Boot JAR containing a presentation layer (Spring MVC controllers + Thymeleaf templates), a data access layer (Spring Data JPA repositories), a domain model layer (JPA entities), and a cross-cutting system package. Controllers invoke repositories directly without a formal service layer, as the business logic is simple enough to live in either the controller or the domain entity. There is no module boundary enforcement, no message broker, no separate deployment units, and no formal design pattern overlay (DDD, Hexagonal, or CQRS).

---

## Evidence

### Repository Structure

```
spring-petclinic/
├── pom.xml                          # Single Maven artifact: spring-petclinic 4.0.0-SNAPSHOT
├── docker-compose.yml               # Database containers only (MySQL, PostgreSQL)
├── k8s/
│   ├── petclinic.yml                # Single-replica Deployment + NodePort Service
│   └── db.yml                       # PostgreSQL StatefulSet for k8s deployment
└── src/main/java/org/springframework/samples/petclinic/
    ├── PetClinicApplication.java    # @SpringBootApplication — single entry point
    ├── model/                        # Shared base entities (BaseEntity, Person, NamedEntity)
    ├── owner/                        # Owner, Pet, PetType, Visit + controllers + repos
    ├── vet/                          # Vet, Specialty, Vets + controller + repo
    └── system/                       # CacheConfiguration, WebConfiguration, CrashController
```

---

## Styles Identified with Evidence

### Primary: Layered

**1. Presentation Layer — Spring MVC Controllers**

Five `@Controller` classes handle all HTTP requests:

- `OwnerController` — CRUD for pet owners, paginated listing (`/owners`, `/owners/{id}`)
- `PetController` — pet registration and update under owner scope
- `VisitController` — visit booking under owner/pet scope
- `VetController` — veterinarian listing with JSON (`@ResponseBody`) and HTML endpoints
- `CrashController` / `WelcomeController` — system and welcome pages

Thymeleaf templates in `src/main/resources/templates/` serve as the view layer: `owners/`, `pets/`, `vets/`, and `fragments/` directories provide server-rendered HTML. Controllers use Spring's `Model` / `ModelAndView` to pass data to views.

**2. Data Access Layer — Spring Data JPA Repositories**

Three repository interfaces abstract all persistence:

```java
// OwnerRepository.java
public interface OwnerRepository extends JpaRepository<Owner, Integer> {
    Page<Owner> findByLastNameStartingWith(String lastName, Pageable pageable);
    Optional<Owner> findById(Integer id);
}
```

- `OwnerRepository extends JpaRepository<Owner, Integer>`
- `VetRepository extends Repository<Vet, Integer>`
- `PetTypeRepository`

Spring profiles (`application-mysql.properties`, `application-postgres.properties`) switch the underlying database between H2 (default), MySQL, and PostgreSQL without changing application code.

**3. Domain Model Layer — JPA Entities**

A shallow inheritance hierarchy provides shared persistence plumbing:

- `BaseEntity` — `@MappedSuperclass` with `@Id @GeneratedValue` primary key
- `Person extends BaseEntity` — `firstName`, `lastName` for `Owner` and `Vet`
- `NamedEntity extends BaseEntity` — `name` for `PetType` and `Specialty`
- `Owner`, `Pet`, `Vet`, `Visit`, `PetType`, `Specialty` — concrete `@Entity` classes

Entities carry validation annotations (`@NotBlank`, `@Pattern`) and JPA relationship annotations (`@OneToMany(cascade = ALL, fetch = EAGER)`). Business logic lives directly on entities: `Owner.addPet()`, `Owner.addVisit()`, `Owner.getPet(name/id)`.

**4. Cross-Cutting System Package**

`org.springframework.samples.petclinic.system` centralizes infrastructure concerns:

- `CacheConfiguration` — `@EnableCaching` with JCache/Caffeine for the `vets` cache
- `WebConfiguration` — MVC configuration (format handlers, resource serving)
- `WelcomeController`, `CrashController` — system-level request handling

**5. Skinny Service Variant — Direct Controller-to-Repository Wiring**

No `@Service` annotated classes exist in the production codebase. Controllers inject repositories directly:

```java
// OwnerController.java
private final OwnerRepository owners;

public OwnerController(OwnerRepository owners) {
    this.owners = owners;
}
```

This is the "skinny service" or "smart controller" variant of Layered architecture — the controller itself mediates between the presentation and persistence layers for simple CRUD operations. Business logic that requires cross-entity coordination (e.g., booking a visit against an owner aggregate) is delegated to the domain entity (`owner.addVisit(petId, visit)`).

**6. Single Deployable Unit**

- One `pom.xml` with artifact `spring-petclinic` — no Maven modules, no Gradle subprojects
- One `@SpringBootApplication` entry point (`PetClinicApplication`)
- Kubernetes deployment: a single-replica `Deployment` with image `dsyer/petclinic` (one container)
- `docker-compose.yml` contains only the database containers, not a separate application container

### Ruled Out

- **Modular Monolith**: The `owner/`, `vet/`, and `system/` packages are organizational, not architectural boundaries. There is no `module-info.java`, no ArchUnit enforcement, no package-level access restrictions, and no explicit module contracts. Packages freely reference each other (e.g., `VisitController` imports `OwnerRepository` from the `owner` package without indirection).
- **Microservices**: Single JAR, single database schema, single Kubernetes `Deployment`. No service discovery, no API gateway, no inter-service communication.
- **Service-Based**: Only one coarse-grained service exists; Service-Based requires multiple independently deployed services sharing a database.
- **Event-Driven**: No message broker (Kafka, RabbitMQ, ActiveMQ), no `@EventListener` on business events, no `ApplicationEvent` subclasses for domain events, no `@Async` processing pipeline. The single `ApplicationPreparedEvent` handler found is in test infrastructure (`PostgresIntegrationTests`), not production code.
- **Pipeline**: No data processing pipeline, no filter stages, no pipe-and-filter topology.
- **Microkernel**: No plugin system, no core/extension separation.
- **Space-Based**: No in-memory data grid, no distributed processing units.
- **Serverless**: No function-as-a-service patterns, no cloud function deployment.
- **Multi-Agent**: No autonomous agents.
- **CQRS (qualifier)**: Single read/write model throughout; all controllers read and write through the same repository interfaces with no command/query separation.
- **Domain-Driven Design (qualifier)**: Entities are anemic data containers with getters/setters and simple convenience methods. No aggregates (in the DDD sense), no value objects, no domain services, no bounded contexts, no domain events, no application services with domain logic.
- **Hexagonal Architecture (qualifier)**: Repositories are Spring Data interfaces (framework-coupled), not abstracted application ports. Controllers are Spring MVC classes, not adapter implementations. There is no port/adapter contract layer.

---

## Quality Attributes with Justification

| Attribute | Justification |
|---|---|
| **Simplicity** | The codebase has under 25 production Java files. The controller-to-repository pattern eliminates the service layer boilerplate for simple CRUD, making the code easy to read and trace end-to-end. |
| **Maintainability** | Feature packages (`owner/`, `vet/`) collocate all related classes (controller, entity, repository, validator), reducing navigation overhead. Consistent Spring Boot conventions across all packages. |
| **Testability** | Controller tests use `@WebMvcTest` (slice test) to test presentation in isolation from persistence. Repository/integration tests use `@DataJpaTest` and Testcontainers for MySQL/PostgreSQL. JMeter plan provided for load testing. |
| **Deployability** | Single artifact with embedded Tomcat; `./mvnw spring-boot:run` is the full deployment command. Spring Boot Maven/Gradle plugins produce a runnable fat-JAR. GraalVM native image support via `native-maven-plugin` and `PetClinicRuntimeHints`. |
| **Portability** | Three database backends (H2, MySQL, PostgreSQL) switchable via Spring profiles without code change. Kubernetes manifests and docker-compose files provided. |
| **Observability** | Spring Boot Actuator (`management.endpoints.web.exposure.include=*`) exposes health, metrics, info, and SBOM (CycloneDX) endpoints. Build info and git commit ID included in actuator output. JCache statistics enabled for the `vets` cache. |
| **Learnability** | Explicit goal of the project is to be a pedagogical reference — minimal configuration, readable code, links to Spring documentation inline. Used by the Spring team to demonstrate framework evolution across versions. |

---

## Classification Reasoning

Spring PetClinic is the archetypal **Layered** architecture implemented on Spring Boot. Every structural signal points to the same conclusion:

1. The code is organized by horizontal technical responsibility: presentation (controllers + templates), data access (JPA repositories), and domain model (entities), with a cross-cutting system package.
2. A single Maven artifact (`spring-petclinic`) produces a single executable JAR with one `@SpringBootApplication` entry point.
3. The Kubernetes manifest deploys exactly one container (the application) alongside one database.
4. No formal service layer exists — the `owner/` and `vet/` feature packages each contain a controller that calls a repository directly, which is the classic Layered anti-pattern of a "fat controller" when business logic is minimal, or a deliberate simplification for a teaching application.
5. The `Owner` aggregate root performs cross-entity coordination (`addVisit(petId, visit)`), but this is domain entity behavior, not a domain service in the DDD sense.

The classification confidence is **0.97**. The only reason it is not 1.0 is that the feature-package organization (`owner/`, `vet/`) is a step toward Modular Monolith, but the absence of any enforced boundary contracts — no Java modules, no ArchUnit rules, no package-private isolation — keeps this firmly in the Layered camp. The project README itself describes it as a "sample application" demonstrating "Spring Boot" patterns, consistent with Layered being the intended architectural statement.
