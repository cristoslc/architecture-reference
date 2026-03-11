# Architecture Report: full-stack-fastapi-template

**Date:** 2026-03-11
**Model:** claude-sonnet-4-6
**Method:** deep-analysis
**Source:** https://github.com/tiangolo/full-stack-fastapi-template
**SPEC:** SPEC-031

---

## Summary

full-stack-fastapi-template is a production-quality starter template for building full-stack web applications. It combines a FastAPI (Python) backend with a React (TypeScript) frontend, orchestrated via Docker Compose with Traefik as a reverse proxy. The repository is designed as an opinionated reference that engineers fork and extend.

**Primary style:** Service-Based
**Secondary style:** Layered
**Confidence:** 0.92

---

## Deployment Topology (Service-Based)

The `compose.yml` defines four runtime services:

| Service | Image / Build | Role |
|---------|--------------|------|
| `db` | `postgres:18` | Shared relational database |
| `adminer` | `adminer` | DB admin UI |
| `prestart` | backend Dockerfile | One-shot migration runner |
| `backend` | backend Dockerfile | FastAPI application |
| `frontend` | frontend Dockerfile | React SPA (served by Nginx) |

Backend and frontend are separately containerized from distinct Dockerfiles and are independently deployable. Both share the same PostgreSQL instance — the defining characteristic of a **Service-Based Architecture**: coarse-grained services collaborating over a shared data store, without the independent data ownership and network API contracts of Microservices.

Traefik routes HTTP/HTTPS to `api.<DOMAIN>` (backend) and `dashboard.<DOMAIN>` (frontend), providing TLS termination via Let's Encrypt (`compose.traefik.yml`).

### Evidence against Microservices

- Two coarse-grained services (not 5–20+ fine-grained)
- Single shared PostgreSQL database — no per-service data ownership
- No service mesh, no inter-service event bus, no circuit-breaker infrastructure
- Backend and frontend communicate only through a synchronous REST API generated from the backend's OpenAPI spec (`frontend/src/client/sdk.gen.ts`)

---

## Backend Internal Structure (Layered)

Within the single `backend/` deployment unit, the code is organized into horizontal layers by technical responsibility:

```
backend/app/
├── api/
│   ├── routes/          # Presentation layer: HTTP route handlers (FastAPI APIRouter)
│   │   ├── users.py     # CRUD endpoints for users
│   │   ├── items.py     # CRUD endpoints for items
│   │   ├── login.py     # Authentication endpoints (OAuth2 + JWT)
│   │   └── utils.py     # Health-check, test email
│   ├── deps.py          # Cross-cutting: DI helpers (SessionDep, CurrentUser)
│   └── main.py          # API router assembly
├── core/
│   ├── config.py        # Settings (pydantic-settings, reads .env)
│   ├── db.py            # Database engine creation (SQLModel/SQLAlchemy)
│   └── security.py      # JWT creation/verification, Argon2 hashing
├── crud.py              # Data access layer: create_user, update_user, authenticate, create_item
├── models.py            # Data model layer: SQLModel entities + Pydantic schemas
├── main.py              # Application entry point (FastAPI, CORS, Sentry)
└── utils.py             # Cross-cutting utilities (email generation, token helpers)
```

### Layer responsibilities

**Presentation layer (`api/routes/`):** FastAPI route handlers receive HTTP requests, validate inputs via Pydantic model binding, enforce authorization via `Depends()` annotations, delegate to the CRUD layer, and return serialized Pydantic response models.

**Business logic / data access layer (`crud.py`):** Thin but distinct service layer. Functions (`create_user`, `update_user`, `get_user_by_email`, `authenticate`, `create_item`) accept SQLModel `Session` objects and domain models; they perform ORM queries and contain no HTTP concerns. Authentication includes a timing-attack-safe dummy hash comparison.

**Data model layer (`models.py`):** SQLModel entities (which unify SQLAlchemy ORM table definitions with Pydantic schemas). User and Item entities, plus separate Input/Output schemas (`UserCreate`, `UserPublic`, `ItemCreate`, `ItemPublic`) — a clean schema segregation pattern.

**Infrastructure layer (`core/`):** Configuration via `pydantic-settings`, DB engine initialization, JWT signing, and Argon2/bcrypt password hashing. No business logic here.

### Evidence against Hexagonal / Ports-and-Adapters

There are no repository interfaces, ports, or adapters. Routes import `crud.py` directly; `crud.py` accepts SQLModel `Session` from the calling context. This is standard layered dependency, not a hexagonal boundary.

---

## Frontend Architecture

The React SPA (`frontend/src/`) is organized by technical role:

```
frontend/src/
├── client/          # Auto-generated OpenAPI SDK (axios-based)
├── components/      # UI components (Admin, Items, UserSettings, Common, Sidebar, ui/)
├── hooks/           # Custom React hooks
├── routes/          # TanStack Router route tree (file-based routing)
└── utils.ts         # Shared helpers
```

Key design decisions:
- **Auto-generated API client:** `openapi-ts.config.ts` generates `src/client/` from the backend's OpenAPI spec, eliminating manual API contract maintenance
- **TanStack Router + TanStack Query:** Type-safe file-based routing with async data fetching
- **shadcn/ui + Tailwind CSS + Radix UI:** Accessible component primitives with utility-first styling
- **Playwright:** End-to-end testing from the browser perspective

---

## Key Technologies

| Layer | Technology |
|-------|-----------|
| Backend framework | FastAPI 0.114+ with Python 3.10+ |
| ORM / Schema | SQLModel (SQLAlchemy + Pydantic unified) |
| Database | PostgreSQL 18 (via psycopg3) |
| Migrations | Alembic |
| Auth | JWT (PyJWT) + Argon2/bcrypt (pwdlib) |
| Observability | Sentry SDK (FastAPI integration) |
| Frontend | React 18 + TypeScript |
| Routing | TanStack Router (file-based, type-safe) |
| Data fetching | TanStack Query + axios |
| UI components | shadcn/ui + Radix UI + Tailwind CSS |
| E2E testing | Playwright |
| Reverse proxy | Traefik (with Let's Encrypt TLS) |
| Containerization | Docker Compose |
| Template engine | Copier |
| CI/CD | GitHub Actions (test-backend, test-docker-compose, playwright, deploy-staging, deploy-production) |

---

## Quality Attributes

**Developer Experience:** Copier-based project generation, auto-generated frontend client from OpenAPI spec, sensible defaults, comprehensive README, and `development.md` documentation make this a fast starting point for new projects.

**Security:** JWT bearer tokens for API authentication, Argon2id password hashing with timing-attack-safe dummy comparison, HTTPS-only routing via Traefik with automatic Let's Encrypt certificates, CORS configured per environment, Sentry integration for error tracking.

**Testability:** Pytest suite for backend with a `conftest.py` fixture base, Playwright for E2E frontend testing, separate `prestart` Docker service for migration isolation, and a `docker-compose.override.yml` for local dev overrides. GitHub Actions runs both test suites in CI.

**Deployability:** Docker Compose provides both local development and production deployment. `compose.traefik.yml` adds TLS-terminating Traefik for production. A `prestart` service gates the main backend service on successful migration completion.

**Maintainability:** Clear horizontal layer separation in the backend; thin crud.py that never bleeds HTTP concerns into data access; SQLModel models that serve dual duty as ORM entities and Pydantic schemas; ruff + mypy for Python linting/type checking; Biome for TypeScript linting. Alembic migration history is versioned.

**Observability:** Sentry SDK integration in `main.py` (enabled for non-local environments), health-check endpoint at `/api/v1/utils/health-check/`, Docker healthcheck for both the database and backend container.

---

## Classification Confidence

**0.92** — The Service-Based + Layered classification is strongly supported by direct evidence:

- `compose.yml` with two separately-built application images and one shared database
- `backend/app/` directory structure maps cleanly to the Layered pattern
- `crud.py` is a distinct data access layer with no HTTP coupling
- `api/routes/*.py` contains no database code
- No async messaging, no event bus, no independent data stores per service, no plugin extension points

The 0.08 uncertainty reflects: (a) the codebase is small and opinionated enough that applying further styles is not warranted, and (b) the service count (2) is at the low end of the Service-Based pattern.

---

## Artifacts Inspected

- `compose.yml`, `compose.override.yml`, `compose.traefik.yml`
- `backend/app/main.py`, `crud.py`, `models.py`, `utils.py`
- `backend/app/api/main.py`, `deps.py`
- `backend/app/api/routes/users.py`, `items.py`, `login.py`
- `backend/app/core/config.py`, `db.py`, `security.py`
- `backend/pyproject.toml`
- `frontend/src/` directory structure
- `frontend/package.json`
- `.github/workflows/` directory listing
- `README.md`, `development.md`, `deployment.md`
