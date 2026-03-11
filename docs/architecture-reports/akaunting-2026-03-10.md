---
project: "akaunting"
date: 2026-03-10
scope: application
use-type: production
primary-language: PHP
confidence: 0.91
styles:
  - name: Microkernel
    role: primary
    confidence: 0.90
  - name: Modular Monolith
    role: secondary
    confidence: 0.85
  - name: Layered
    role: secondary
    confidence: 0.80
---

# Architecture Analysis: Akaunting

## Metadata

| Field | Value |
|---|---|
| Project | Akaunting |
| Repo | https://github.com/akaunting/akaunting |
| Date | 2026-03-10 |
| Scope | application |
| Use-type | production |
| Primary Language | PHP |
| Other Languages | JavaScript, Blade/HTML |

## Style Rationales

**Microkernel (primary, 0.90):** The dominant architectural characteristic is a first-class plugin system built on `akaunting/laravel-module`. `App\Utilities\ModuleActivator` implements `ActivatorInterface` to enable/disable modules per company at runtime — module state is persisted in a DB table and cached per tenant. The App Store (`akaunting.com/apps`) allows third-party modules to install into `modules/` at runtime via Composer. Abstract extension points are formalized in `app/Abstracts/` (Model, Job, Event, Widget, Report, BulkAction, Export, Import, Notification, Observer) and extension hooks are exposed via events: `PaymentMethodShowing`, `Menu\AdminCreated`, `Menu\PortalCreated`, `Report\FilterShowing`, `Report\RowsShowing`. Route macros (`Route::admin()`, `Route::portal()`, `Route::api()`, `Route::module()`) give modules a standard integration path. Module lifecycle events (`Installing`, `Installed`, `Enabling`, `Enabled`, `Disabling`, `Disabled`, `Uninstalling`, `Uninstalled`) are fully wired in `app/Events/Module/` and `app/Listeners/Module/`.

**Modular Monolith (secondary, 0.85):** The application deploys as a single PHP process with a single shared database. PSR-4 autoloading exposes `Modules\` (mapped to `modules/`) alongside `App\` in the same `composer.json`, making the codebase a monorepo-of-modules rather than independent services. The core ships two bundled modules (`OfflinePayments`, `PaypalStandard`) installed into `modules/` via Composer `installer-paths`. All modules share one Eloquent ORM with a unified schema and global `Company` scope for multi-tenancy — a hallmark of the modular monolith rather than microservices.

**Layered (secondary, 0.80):** Laravel's MVC foundation provides a strict horizontal layering beneath the plugin system. The HTTP layer contains Controllers (`app/Http/Controllers/`), Form Requests (`app/Http/Requests/`), and API Resources (`app/Http/Resources/`). The application layer uses the Command pattern via `app/Jobs/` (e.g., `Document\CreateDocument`, `Banking\CreateTransaction`) dispatched from controllers. The data access layer uses Eloquent Active Record models with global query scopes (`app/Scopes/Company.php`) enforcing multi-tenancy and soft deletes. The distinction from a pure Layered architecture is that the plugin system cuts vertically across all these layers per module.

## Evidence Table

| Evidence | File/Location | Style |
|---|---|---|
| `ModuleActivator` implementing `ActivatorInterface` with per-tenant DB state | `app/Utilities/ModuleActivator.php` | Microkernel |
| Module lifecycle events: Installed, Uninstalled, Enabling, Enabled, Disabling, Disabled | `app/Events/Module/` | Microkernel |
| `PaymentMethodShowing`, `Menu\AdminCreated`, `Report\RowsShowing` extension hooks | `app/Providers/Event.php` | Microkernel |
| `Route::module()`, `Route::admin()`, `Route::portal()`, `Route::api()` macros | `app/Providers/Route.php` | Microkernel |
| `app/Abstracts/` — Model, Job, Widget, Report, BulkAction, Import, Export as extension contracts | `app/Abstracts/` | Microkernel |
| App Store integration: `Modules` trait fetching remote API, subscription verification | `app/Traits/Modules.php` | Microkernel |
| `"Modules\\": "modules/"` PSR-4 alongside `"App\\": "app/"` in single composer.json | `composer.json` | Modular Monolith |
| `installer-paths` for OfflinePayments, PaypalStandard into `modules/` | `composer.json` | Modular Monolith |
| Single shared `database/migrations/`; global `Company` scope on all Eloquent models | `app/Scopes/Company.php`, `app/Abstracts/Model.php` | Modular Monolith |
| Controllers → Jobs (command pattern) → Eloquent Models layering | `app/Http/Controllers/`, `app/Jobs/`, `app/Models/` | Layered |
| 157 events + 69 listeners for internal side-effect management | `app/Events/`, `app/Listeners/` | Layered (event hooks) |

## Quality Attributes

| QA | Evidence |
|---|---|
| **Extensibility** | Runtime module install/uninstall via App Store; abstract extension point contracts (`Abstracts/`); event-based hooks for payment methods, menus, reports; `Route::module()` macro for standard integration |
| **Multi-tenancy** | Global `Company` scope applied automatically to all Eloquent queries; `ModuleActivator` tracks module enable/disable state per company; `{company_id}` URL prefix on all admin/portal routes |
| **Maintainability** | Strict PSR-4 module namespace isolation; abstract base classes enforce consistent patterns across modules; `config/module.php` stubs generate new modules with correct structure |
| **Evolvability** | Modules installable from remote App Store without code changes; `composer.json` installer-paths allow version-pinned module upgrades; 30+ versioned update listeners in `app/Listeners/Update/` handle DB migrations across releases |
| **Security** | Laravel Sanctum for API token auth; `laratrust/laratrust` for RBAC; `akaunting/laravel-firewall` for IP filtering; rate limiters for API, email, and import endpoints (`app/Providers/Route.php`) |
| **Observability** | Bugsnag and Sentry integrations (`bugsnag/bugsnag-laravel`, `sentry/sentry-laravel`); Laravel Debugbar (dev); model caching via `genealabs/laravel-model-caching` with explicit cache flushing |

## Domain

Small-business and freelancer accounting software. Core domains: Invoices/Bills (Document), Banking/Transactions, Sales/Purchases, Contacts, Reporting, Settings, and App Store/Module management. Multi-company SaaS model with per-company module activation.

## Production Context

- Single deployable Laravel 10 application; requires PHP 8.1+, MySQL/MariaDB/PostgreSQL/SQLite, web server
- Multi-tenant by company: every request is scoped to a `company_id` via global Eloquent scope; modules can be enabled/disabled independently per company
- App Store at `akaunting.com/apps` provides a marketplace of paid/free modules installable at runtime without redeployment
- RESTful API secured via Laravel Sanctum; separate API domain/prefix configured in `config/api.php`
- Ships two payment modules bundled (`OfflinePayments`, `PaypalStandard`); additional modules installed via Composer or App Store
