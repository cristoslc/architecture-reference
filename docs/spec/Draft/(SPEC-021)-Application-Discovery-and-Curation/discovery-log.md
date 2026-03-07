# SPEC-021 Discovery Log

## Ecosystem Completion

### Included (19 entries created)

| Ecosystem | Repo | Stars | Rationale |
|-----------|------|-------|-----------|
| Elastic Stack | kibana | 20k+ | Visualization layer for Elasticsearch |
| Elastic Stack | logstash | 14k+ | Data processing pipeline |
| Elastic Stack | beats | 12k+ | Lightweight data shippers |
| Arr Stack | sonarr | 10k+ | TV series management |
| Arr Stack | radarr | 10k+ | Movie management |
| Arr Stack | prowlarr | 4k+ | Indexer manager |
| Arr Stack | lidarr | 3k+ | Music management |
| Sentry | sentry (backend) | 39k+ | Error tracking backend |
| Kafka ecosystem | schema-registry | 2k+ | Schema management for Kafka |
| HashiCorp | vault | 31k+ | Secrets management |
| HashiCorp | nomad | 15k+ | Workload orchestrator |
| HashiCorp | terraform | 43k+ | Infrastructure as Code |
| Supabase | auth (gotrue) | 4k+ | Authentication service |
| Supabase | postgrest | 23k+ | RESTful API for PostgreSQL |
| Supabase | realtime | 7k+ | Realtime subscriptions |
| Supabase | storage | 2k+ | Object storage API |
| Grafana LGTM | loki | 24k+ | Log aggregation |
| Grafana LGTM | mimir | 4k+ | Metrics backend |
| Grafana LGTM | tempo | 4k+ | Distributed tracing |

### Excluded

| Ecosystem | Repo | Reason |
|-----------|------|--------|
| Sentry | snuba | 393 stars — below 1k threshold |
| Sentry | relay | 364 stars — below 1k threshold |
| Kafka | ksql | 290 stars (main repo) — processed anyway via --min-stars 0 |
| Kafka | kafka-connect | No standalone repo; part of main Kafka codebase |
| GitLab | gitaly | Clone failed (wrong org URL: gitlabhq vs gitlab-org) |

## Uncataloged Manifest Repos (20 entries)

All 20 uncataloged manifest repos were triaged. None met selection criteria:

| Status | Count | Details |
|--------|-------|---------|
| Below 1k stars | 15 | Small reference projects, examples, samples |
| Clone failures | 5 | Wrong org URLs, archived/renamed repos |
| Added to catalog | 0 | None qualified |

These repos were already in the manifest from earlier pipeline runs but never produced catalog entries due to star thresholds or clone issues. No further action needed.

## Application Discovery (30 entries created)

### Selection methodology

1. Research across GitHub, awesome-lists, and domain-specific directories
2. Filtered by: >1k stars, active maintenance, classifiable architecture, end-user application (not platform/framework)
3. Prioritized underrepresented domains: healthcare, fintech, logistics, education, government
4. Cross-checked against existing catalog to avoid duplicates

### Included

| Domain | Repo | Stars | Type | Rationale |
|--------|------|-------|------|-----------|
| Healthcare | openmrs-core | 2k+ | Medical records | Open-source medical records system, Java, layered |
| Healthcare | hapi-fhir | 2k+ | Health data | FHIR standard implementation, Java, service-based |
| Healthcare | open-web-calendar | 1k+ | Calendar | Web calendar aggregator, Python |
| Fintech | killbill | 4k+ | Billing | Subscription billing platform, Java, modular monolith |
| Fintech | akaunting | 8k+ | Accounting | Free accounting software, PHP/Laravel |
| Fintech | open-event-server | 3k+ | Event mgmt | Event management platform, Python/Flask |
| Fintech | bigcapital | 3k+ | Accounting | Modern accounting SaaS, Node.js |
| Logistics | OpenTripPlanner | 2k+ | Trip planning | Multi-modal transport planner, Java |
| Logistics | InvenTree | 4k+ | Inventory | Inventory management system, Python/Django |
| Logistics | erpnext | 19k+ | ERP | Full ERP system, Python/Frappe |
| Education | canvas-lms | 5k+ | LMS | Learning management system, Ruby on Rails |
| Education | moodle | 5k+ | LMS | Learning platform, PHP |
| Education | tutor | 2k+ | LMS infra | Open edX distribution, Python |
| Education | oppia | 5k+ | Learning | Interactive learning platform, Python/Angular |
| Government | decidim | 3k+ | Participation | Citizen participation platform, Ruby on Rails |
| Government | ckan | 4k+ | Open data | Data management system, Python |
| Productivity | AppFlowy | 55k+ | Notion alt | Collaborative workspace, Rust/Flutter |
| Productivity | plane | 30k+ | Project mgmt | Project management tool, TypeScript |
| Productivity | logseq | 33k+ | Knowledge mgmt | Knowledge management, Clojure |
| Productivity | twenty | 20k+ | CRM | Modern CRM, TypeScript |
| Productivity | AFFiNE | 40k+ | Workspace | Knowledge base, TypeScript |
| CRM | frappe | 17k+ | Framework/App | Web framework + app platform, Python |
| E-Commerce | bagisto | 15k+ | E-commerce | Laravel-based e-commerce, PHP |
| E-Commerce | vendure | 6k+ | E-commerce | Headless commerce, TypeScript |
| Social | Rocket.Chat | 40k+ | Messaging | Team messaging platform, TypeScript |
| Social | lemmy | 13k+ | Forum | Reddit alternative, Rust |
| Social | synapse | 12k+ | Matrix server | Matrix homeserver, Python |
| Analytics | posthog | 22k+ | Product analytics | Product analytics platform, Python/TypeScript |
| Analytics | analytics (plausible) | 20k+ | Web analytics | Privacy-focused analytics, Elixir |
| Analytics | umami | 22k+ | Web analytics | Simple web analytics, TypeScript |

### Excluded from candidates

| Repo | Reason |
|------|--------|
| medusa | Already in catalog |
| nopCommerce | Already in catalog |
| mastodon | Already in catalog |
| forem | Already in catalog |
| cal.com | Already in catalog |
| chatwoot | Already in catalog |
| openproject | Already in catalog |
| ghostfolio | Already in catalog |
| maybe | Already in catalog |
| outline | Already in catalog |
| saleor | Already in catalog |
| shopware | Already in catalog |
| solidus | Already in catalog |
| spree | Already in catalog |
| zammad | Already in catalog |
| consul (civic) | Name collision with HashiCorp consul already in catalog |
| erxes | Already in catalog |
| discourse | Already in catalog |
| openboxes | 825 stars — below 1k threshold |
| openemr | Clone failed (wrong org: care-ai) |
| huly-platform | Clone failed |
| reaction | Clone failed (likely archived) |

## Summary

| Stream | Candidates | Included | Excluded |
|--------|-----------|----------|----------|
| Ecosystem completion | 24 | 19 | 5 (low stars, clone failures) |
| Uncataloged manifest repos | 20 | 0 | 20 (all below threshold) |
| Application discovery | 49 | 30 | 19 (15 duplicates, 1 low stars, 3 clone failures) |
| **Total** | **93** | **49** | **44** |

### Final catalog composition

| Category | Count |
|----------|-------|
| Production platforms | 87 |
| Production applications | 55 |
| Reference applications | 38 |
| Reference platforms | 4 |
| **Total** | **184** |
| **Production ratio (platform:application)** | **1.58:1** |
