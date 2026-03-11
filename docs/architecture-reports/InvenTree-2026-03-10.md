---
project: "InvenTree"
date: 2026-03-10
scope: application
use-type: production
primary-language: Python
confidence: 0.90
styles:
  - name: Microkernel
    role: primary
    confidence: 0.88
  - name: Layered
    role: secondary
    confidence: 0.85
---

# Architecture Analysis: InvenTree

## Metadata

| Field | Value |
|---|---|
| Project | InvenTree |
| Version | 1.3.0 dev |
| Repo | https://github.com/inventree/InvenTree |
| Date | 2026-03-10 |
| Scope | application |
| Use-type | production |
| Primary Language | Python |
| Other Languages | TypeScript, JavaScript |

## Style Rationales

**Microkernel (primary, 0.88):** A `PluginsRegistry` (`src/backend/InvenTree/plugin/registry.py`) serves as the microkernel core — it discovers, loads, and manages plugin instances at runtime using thread-safe locks and dynamic URL/app registration. The `InvenTreePlugin` base class and `PluginMixinEnum` define 20+ named extension points (ACTION, BARCODE, EVENTS, LABELS, REPORT, VALIDATION, SCHEDULE, NAVIGATION, UI, MACHINE, MAIL, etc.) that third-party and built-in plugins can implement without modifying core code. Core functionality such as barcode scanning, label printing, currency exchange, and notifications is itself implemented as mandatory built-in plugins under `plugin/builtin/`, making the extension mechanism the primary architectural organising principle rather than a secondary concern.

**Layered (secondary, 0.85):** Within each Django domain app (part, stock, order, build, company, machine) the code follows a strict horizontal layering: `models.py` (ORM/data), `serializers.py` (DTO transformation), `api.py` (DRF REST views), `admin.py` (admin interface), and `tasks.py` (async background work). The React SPA frontend (`src/frontend/`) sits above the REST API as the presentation tier, communicating exclusively over HTTP with no direct DB access. A django-q2 worker process (`qcluster`) handles async tasks off the web tier, forming a three-process runtime: gunicorn (web), qcluster (worker), and an optional Redis/cache sidecar.

## Evidence Table

| Evidence | File/Location | Style |
|---|---|---|
| `PluginsRegistry` with dynamic URL/app registration | `src/backend/InvenTree/plugin/registry.py` | Microkernel |
| `PluginMixinEnum` — 20+ named extension points | `src/backend/InvenTree/plugin/plugin.py` | Microkernel |
| 15+ plugin mixin classes (Schedule, Action, Barcode, Event, UI…) | `src/backend/InvenTree/plugin/mixins/__init__.py` | Microkernel |
| Core features as mandatory built-in plugins (barcode, labels, currency) | `src/backend/InvenTree/plugin/builtin/` | Microkernel |
| `MANDATORY_PLUGINS` list in registry | `src/backend/InvenTree/plugin/registry.py` | Microkernel |
| `EventMixin` with `trigger_event` / `register_event` async dispatch | `src/backend/InvenTree/plugin/base/event/events.py` | Microkernel |
| Per-app `models.py` / `api.py` / `serializers.py` layering | `src/backend/InvenTree/part/`, `stock/`, `order/` | Layered |
| Django REST Framework (`rest_framework`) as API layer | `src/backend/InvenTree/InvenTree/settings.py` | Layered |
| django-q2 qcluster worker (separate process, same codebase) | `Procfile`, `Q_CLUSTER` config | Layered |
| React SPA consuming REST API only | `src/frontend/src/` (axios, react-query) | Layered |
| Gunicorn WSGI server + optional Redis cache | `src/backend/InvenTree/InvenTree/gunicorn.conf.py` | Layered |
| Domain events per app (`StockEvents`, `PartEvents`, `OrderEvents`) | `src/backend/InvenTree/{stock,part,order}/events.py` | Microkernel |
| Machine subsystem via `MachineDriverMixin` plugin interface | `src/backend/InvenTree/machine/machine_type.py` | Microkernel |

## Quality Attributes

| QA | Evidence |
|---|---|
| **Extensibility** | Plugin registry supports runtime load/unload; `AppMixin` lets plugins register full Django apps with models and migrations |
| **Deployability** | Single Docker image (`inventree/inventree`); `Procfile` runs web + worker; optional Redis and PostgreSQL/MySQL/SQLite backends |
| **Maintainability** | Strict per-app layering (models/api/serializers/tests) and uniform DRF pattern across all domain modules |
| **Scalability** | django-q2 qcluster with configurable worker count; Redis as shared cache/queue broker when `GLOBAL_CACHE_ENABLED` |
| **Testability** | Pytest with per-app test files; `PLUGIN_TESTING` flags and `PLUGIN_TESTING_EVENTS` for isolated plugin event testing |
| **Interoperability** | REST API documented via drf-spectacular; OAuth2 (`oauth2_provider`), SSO (`allauth`), API token auth; APICallMixin for outbound integrations |

## Domain

Inventory management and parts tracking (manufacturing/electronics/maker communities). Core domains: parts catalog, stock control, purchase orders, sales orders, build orders, supplier management, barcode scanning, and label/report generation.

## Production Context

- Self-hostable via Docker Compose (gunicorn + qcluster + Caddy proxy + PostgreSQL + Redis); 7,000+ GitHub stars; active cloud-hosted demo at `demo.inventree.org`
- Plugin ecosystem supports third-party extensions installable via pip entry points; `PLUGIN_FILE` lists active plugins persisted across restarts
- React/Mantine SPA (`src/frontend/`) served as static files by gunicorn; communicates exclusively over REST API with JWT/session/token auth
- Structured logging via `structlog`; OpenTelemetry tracing; optional Sentry integration for both web and worker processes
