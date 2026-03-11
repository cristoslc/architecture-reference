---
project: "Open Web Calendar"
date: 2026-03-11
scope: application
use-type: production
primary-language: Python
confidence: 0.91
styles:
  - name: Layered
    role: primary
    confidence: 0.91
  - name: Pipeline
    role: secondary
    confidence: 0.82
---

# Architecture Analysis: Open Web Calendar

## Metadata

| Field | Value |
|---|---|
| Project | Open Web Calendar |
| Repo | https://github.com/niccokunzmann/open-web-calendar |
| Date | 2026-03-11 |
| Scope | application |
| Use Type | production |
| Primary Language | Python |
| Languages | Python, JavaScript, HTML/Jinja2 |
| Classification | Layered (primary), Pipeline (secondary) |
| Confidence | 0.91 |
| Method | deep-analysis |

---

## Summary

Open Web Calendar is a single-process Flask web application that accepts calendar source URLs (ICS or CalDAV) via HTTP query parameters, fetches and merges those feeds server-side, and serves the result as a rendered HTML calendar, a merged ICS feed, or a structured JSON events/calendars API. It is deployed as a single Gunicorn WSGI process (optionally in Docker or on Vercel) with no separate services, message buses, or background workers. The codebase is organized in clean horizontal layers — HTTP routing, conversion strategy, calendar source abstraction, and infrastructure utilities — with a linear retrieve-convert-merge pipeline at the core of each request.

---

## Directory Structure

```
open_web_calendar/
  app.py                        # Flask routes — HTTP layer
  config.py                     # Configuration / environment abstraction
  encryption.py                 # Credential encryption (Fernet)
  clean_html.py                 # HTML sanitisation utility
  error.py                      # Error formatting helpers
  translate.py                  # i18n / locale helpers
  default_specification.yml     # Default calendar specification
  calendars/                    # Source abstraction layer
    base.py                     # Calendars ABC
    ics.py                      # ICS/webcal source implementation
    caldav.py                   # CalDAV source implementation
    errors.py
    info/                       # Calendar metadata extractors
  convert/                      # Conversion strategy layer
    base.py                     # ConversionStrategy ABC + retrieve pipeline
    events.py                   # Strategy: JSON events (dhtmlx)
    ics.py                      # Strategy: merged ICS output
    calendar.py                 # Strategy: calendar metadata JSON
  templates/                    # Jinja2 presentation layer
    index.html
    about.html
    calendars/dhtmlx.html
    locale.js
  static/                       # Front-end assets
    js/calendar.js, index.js, common.js, signup.js ...
    img/
```

---

## Architecture Classification

### Primary Style: Layered

The codebase is structured in clear, horizontal dependency layers:

**Presentation layer** — `app.py` Flask routes render Jinja2 templates (`templates/`) and serve static assets (`static/`). Routes delegate immediately to the conversion layer; they contain no business logic. The `index.html` / `about.html` templates provide the configuration UI; `calendars/dhtmlx.html` renders the embedded dhtmlx Scheduler widget.

**Conversion (application) layer** — `convert/base.py` defines `ConversionStrategy`, an abstract base class that owns the retrieve-convert-merge pipeline. Three concrete strategies (`ConvertToEvents`, `ConvertToICS`, `ConvertToCalendars`) implement the three output formats. The strategy is selected by the file extension in the `/calendar.<ext>` route (`events.json`, `ics`, `json`, `html`). This layer calls down into the calendar source layer and up to the HTTP layer only via a `Response` object.

**Calendar source layer** — `calendars/base.py` defines `Calendars`, an abstract class with two methods: `get_events_between()` and `get_icalendars()`. `ICSCalendars` implements HTTP/webcal fetching with `recurring-ical-events` expansion; `CalDAVCalendars` implements the CalDAV protocol via the `caldav` library. The conversion layer depends on this interface, not on concrete implementations.

**Infrastructure / utility layer** — `config.py` (environment configuration), `encryption.py` (Fernet credential encryption), `clean_html.py` (lxml/BeautifulSoup sanitisation), `translate.py` (i18n), and `error.py` (HTTP error mapping). These have no upward dependencies; they are imported by the layers above.

The layer boundaries are strictly respected: `app.py` never imports from `calendars/`; the conversion layer never imports from `app.py`; utility modules have no application imports. This is textbook layered architecture.

### Secondary Style: Pipeline

Within each HTTP request that produces calendar output, the processing follows a fixed linear pipeline:

1. **Specification assembly** — `get_specification()` merges the YAML default spec, an optional remote `specification_url` YAML, and per-parameter query string overrides into a single `dict`.
2. **Parallel retrieval** — `ConversionStrategy.retrieve_calendars()` uses a `ThreadPoolExecutor` (up to 100 threads) to fetch all declared source URLs concurrently, producing `Calendars` objects.
3. **Component collection** — each `Calendars` result is passed to `collect_components_from()`, which appends transformed components (events, ICS calendars, or calendar metadata dicts) to a shared list under an `RLock`.
4. **Merge / serialise** — `merge()` assembles the collected components into the final `Response`: a `jsonify()` payload, a merged ICS `Calendar.to_ical()`, or a metadata JSON dict.

Data flows strictly left-to-right through these stages; there is no feedback or branching. This is the Template Method pattern applied as a data pipeline.

### What Was Rejected

**Not Microservices or Service-Based:** There is exactly one deployable process. The Docker image runs a single Gunicorn WSGI process. There is no inter-service communication, no API gateway, and no service registry.

**Not Event-Driven:** There are no message queues, event buses, or pub/sub channels. All processing is synchronous and request-scoped. The only concurrency is the `ThreadPoolExecutor` for parallel URL fetching within a single request.

**Not Microkernel:** There is no plugin discovery mechanism. Calendar source types (`ICSCalendars`, `CalDAVCalendars`) and output strategies are registered directly in `app.py` via a conditional on the file extension. New source types require code changes, not plugin registration.

**Not Hexagonal:** While there is a port-and-adapter flavour (the `Calendars` ABC insulates the conversion layer from source protocol details), the codebase lacks the domain/application/port/adapter naming and bidirectional port discipline that characterises Hexagonal. The `app.py` file conflates routing, specification assembly, and adapter selection. The pattern is layering with an interface boundary, not hexagonal.

**Not Serverless:** The Vercel deployment (`vercel.json`) routes all requests to a single Python WSGI entrypoint — functionally identical to the Gunicorn deployment. The application is not decomposed into individual functions.

---

## Quality Attributes

### Privacy / Security
The application is explicitly positioned as a privacy-preserving calendar aggregator. It proxies calendar feeds server-side so the visitor's browser never contacts the calendar source. `encryption.py` provides Fernet-based credential encryption (`OWC_ENCRYPTION_KEYS`) so CalDAV credentials can be embedded in URLs without being readable by the viewer. `clean_html.py` applies aggressive lxml/BeautifulSoup sanitisation to all event content to prevent XSS from malicious ICS sources. `flask-allowed-hosts` enforces an optional allowlist.

### Deployability
The application ships as a single Python package installable from PyPI (`pip install open-web-calendar`), a Docker image (Alpine, Gunicorn multi-worker), and a Vercel serverless deployment. No external data stores are required. Configuration is entirely via environment variables and query parameters.

### Customisability
The YAML/JSON specification system (`default_specification.yml` + `OWC_SPECIFICATION` env override + per-request query parameters) allows operators to preset defaults and users to override appearance, timezone, skin, language, tab configuration, HTML sanitisation policy, and calendar sources — all without code changes. The dhtmlx Scheduler front end supports custom CSS and JavaScript injection.

### Extensibility (limited)
New output formats require adding a `ConversionStrategy` subclass and a new `ext` branch in `get_calendar()`. New calendar source protocols require a new `Calendars` subclass and a new detection heuristic in `get_calendars_from_url()`. Both require code changes — there is no plugin registration.

### Internationalisation
Translation files live in `open_web_calendar/translations/` covering 25+ languages. The `translate.py` module loads locale data; the `prefer_browser_language` spec flag enables automatic language selection from `Accept-Language` headers.

---

## Key Dependencies

| Package | Role |
|---|---|
| Flask | HTTP routing and template rendering (Jinja2) |
| Gunicorn | WSGI production server |
| icalendar | RFC 5545 ICS parsing and serialisation |
| recurring-ical-events | RRULE expansion for repeated events |
| caldav | CalDAV protocol client |
| mergecal | Merging multiple ICS calendars into one |
| requests / requests-cache | HTTP fetching with optional filesystem cache |
| lxml + lxml_html_clean | HTML sanitisation |
| beautifulsoup4 | HTML parsing |
| cryptography + bcrypt | Fernet credential encryption |
| PyYAML | Specification loading |
| dhtmlx Scheduler | Front-end calendar widget (vendored JS) |

---

## Evidence Notes

- Single `app.py` as the sole Flask application entry point confirms monolithic deployment.
- `docker/start-service.sh` runs `gunicorn -w "$WORKERS" -b "0.0.0.0:$PORT" open_web_calendar.app:app` — one process, multiple Gunicorn workers.
- `vercel.json` routes all paths to `app.py` — no function-per-route decomposition.
- `ConversionStrategy` in `convert/base.py` with `ThreadPoolExecutor` for parallel URL fetch is the clearest pipeline evidence.
- `Calendars` ABC in `calendars/base.py` is the sole interface boundary between the conversion and source layers.
- No database, no message queue, no service discovery, no background task scheduler.
