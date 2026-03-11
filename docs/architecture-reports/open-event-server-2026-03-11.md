# Architecture Report: Open Event Server

**Date:** 2026-03-11
**Source:** https://github.com/fossasia/open-event-server
**Classification:** Layered, Modular Monolith
**Confidence:** 0.88

---

## Overview

Open Event Server is a production-grade event management backend built on Flask (Python). It provides a JSON:API-compliant REST API, a GraphQL endpoint, async task processing via Celery, real-time WebSocket support via FastAPI/broadcaster, and integrations with external services (Stripe, PayPal, Sendgrid, Rocket.Chat, Elasticsearch). The system manages the full lifecycle of events: sessions, speakers, attendees, ticketing, payments, notifications, and exports.

---

## Directory Structure

```
open-event-server/
├── app/
│   ├── api/               # REST resource handlers (93 modules)
│   │   ├── helpers/       # Cross-cutting services (mail, payment, tasks, auth)
│   │   ├── data_layers/   # Custom flask-rest-jsonapi data access layers
│   │   ├── schema/        # Marshmallow-JSONAPI serialization schemas
│   │   ├── custom/        # Non-JSONAPI custom route handlers
│   │   ├── chat/          # Rocket.Chat integration
│   │   └── video_channels/ # BBB video integration
│   ├── models/            # SQLAlchemy ORM models (40+ entities)
│   ├── graphql/           # GraphQL schema and views (graphene-sqlalchemy)
│   ├── extensions/        # Flask extension initialization (limiter, shell)
│   ├── settings/          # Application settings (DB-backed)
│   ├── templates/         # Jinja2 templates (email, admin UI)
│   ├── views/             # Blueprints manager, health check, Redis, Elasticsearch
│   ├── instance.py        # Application factory + Celery + scheduled jobs setup
│   └── asgi.py            # FastAPI WebSocket endpoint (broadcaster/Redis pub-sub)
├── migrations/            # Alembic migration files
├── tests/                 # Test suite
├── scripts/               # Heroku/deploy scripts
├── kubernetes/            # Kubernetes manifests
├── docker-compose.yml     # Services: postgres, redis, web, celery
└── config.py              # Configuration classes (Dev, Production, Testing)
```

---

## Architectural Analysis

### Primary Style: Layered Architecture

The codebase is organized into canonical horizontal layers that are consistent across all domain areas:

1. **Presentation / API Layer** (`app/api/`) — Flask blueprints and flask-rest-jsonapi `ResourceList`/`ResourceDetail`/`ResourceRelationship` views handle HTTP routing, request parsing, and response serialization using Marshmallow-JSONAPI schemas.

2. **Schema / Serialization Layer** (`app/api/schema/`) — Marshmallow schemas define the JSON:API contract, field validation, and relationship mapping between API representation and domain objects.

3. **Service / Helper Layer** (`app/api/helpers/`) — Cross-cutting concerns are isolated here: authentication (`auth.py`, `jwt.py`, `permission_manager.py`), email dispatch (`mail.py`, `tasks.py`), payment processing (`payment.py`), file handling (`files.py`, `storage.py`), export/import (`export_helpers.py`, `import_helpers.py`), and async task delegation to Celery.

4. **Data Access Layer** (`app/api/data_layers/`) — Custom flask-rest-jsonapi data layers (e.g., `EventCopyLayer`, `ChargesLayer`, `SearchFilterLayer`) encapsulate complex persistence logic, isolating it from route handlers.

5. **Domain Model / Persistence Layer** (`app/models/`) — SQLAlchemy ORM models with `sqlalchemy-continuum` versioning. All 40+ entities map to a single PostgreSQL database. Models contain domain logic (soft deletion, identifier generation, event state management).

### Secondary Style: Modular Monolith

While layered in horizontal structure, the system exhibits deliberate feature-level modularity: each resource type (events, sessions, speakers, tickets, orders, etc.) is self-contained across a set of coordinated files — a route module in `api/`, a schema module in `api/schema/`, and a model in `models/`. The Flask Blueprint system enforces module boundaries at the routing level. There is no runtime process or network boundary between these modules; they share the same process, database connection pool, and SQLAlchemy session, making this a modular monolith rather than microservices.

### Supporting Patterns

**Async task processing (Celery + Redis):** Long-running operations (email dispatch, PDF generation, import/export, badge creation, scheduled notifications) are offloaded to a dedicated Celery worker process. Redis serves as both message broker and result backend. This provides a lightweight event-driven pipeline for background work without a full event-driven architecture at the domain level.

**GraphQL endpoint:** A secondary read interface via graphene-sqlalchemy and flask-graphql exposes the same domain models under `/graphql`. This is additive, not architectural — it shares models and database with the REST API.

**Real-time WebSocket layer:** A FastAPI ASGI app (`app/asgi.py`) provides a chatroom-style WebSocket endpoint using the `broadcaster` library over Redis pub-sub. This is a thin additional process, distinct from the Flask WSGI app.

**Scheduled jobs (APScheduler + Celery Beat):** Time-triggered tasks (ticket sales end notifications, invoice reminders, session state updates) are registered via `setup_scheduled_task` using APScheduler integrated with Celery.

**Search (Elasticsearch):** Elasticsearch-DSL provides full-text search over event data, surfaced through `app/views/elastic_search.py` and `app/api/full_text_search/`.

**Admin UI (Flask-Admin):** A built-in admin interface is included for super-admin operations, further evidence of a self-contained monolith rather than a service-oriented split.

---

## Technology Stack

| Component | Technology |
|-----------|-----------|
| Language | Python 3.8 |
| Web Framework | Flask 1.1.2 |
| API Style | JSON:API (flask-rest-jsonapi), GraphQL (graphene-sqlalchemy), REST |
| ORM | SQLAlchemy 1.3 + Flask-SQLAlchemy |
| Database | PostgreSQL (postgis extension) |
| Async Tasks | Celery 5.3 + Redis |
| Real-time | FastAPI + broadcaster (Redis pub-sub) |
| Search | Elasticsearch 7 (elasticsearch-dsl) |
| Auth | JWT (flask-jwt-extended) + OAuth (Google, Facebook) |
| Payments | Stripe, PayPal, Omise, Alipay |
| Email | SMTP (marrow.mailer) + SendGrid |
| Caching | Redis (flask-caching, flask-redis) |
| Schema Versioning | sqlalchemy-continuum |
| Chat Integration | Rocket.Chat |
| Migrations | Alembic (Flask-Migrate) |
| Deployment | Docker Compose, Heroku, Kubernetes |

---

## Quality Attributes

- **Maintainability:** Consistent layering and the modular resource-per-file convention make the codebase navigable. Blueprint separation enforces module isolation.
- **Extensibility:** New resource types follow a clear template (model + schema + route + data_layer). Celery tasks are easily added for async work.
- **Scalability:** Celery workers and the web process scale independently. Redis as broker/cache supports horizontal worker scaling. Kubernetes manifests support container orchestration.
- **Observability:** Sentry integration across Flask, Celery, Redis, and SQLAlchemy layers; health-check endpoint covering DB, Celery, and migrations.
- **Security:** JWT with blacklisting, permission manager enforcing role-based access at every resource endpoint, rate limiting via Flask-Limiter.
- **Testability:** Factory-boy fixtures, transaction rollback proxy for test isolation, `CELERY_ALWAYS_EAGER` support for synchronous task testing.

---

## Classification Reasoning

Open Event Server is unambiguously a **Layered Architecture** — the horizontal separation of presentation, serialization, service, data access, and persistence is explicit, consistent, and enforced structurally (not just conceptually). It also qualifies as a **Modular Monolith** because the domain is organized into well-bounded feature modules, all deployed together in a single application process with a shared database. There is no service mesh, no inter-service RPC, and no domain event bus — disqualifying Microservices, Service-Based, or Event-Driven as primary styles. The Celery+Redis background task system introduces pipeline-like characteristics for async work, but this does not constitute a Pipeline architecture at the system level.
