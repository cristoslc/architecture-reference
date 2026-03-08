# SPEC-024 Classification Report
_Generated 2026-03-08 — 184 Discovered catalog entries_

## Campaign summary

| Metric | Value |
|--------|-------|
| Entries classified | 184 |
| Classification model | Gemini 3 Flash (via OpenRouter) |
| Calibration model | Claude Sonnet 4.6 (via OpenRouter) |
| Method | deep-analysis (multi-turn, SPEC-011 escalation) |
| Mean original confidence | 0.917 |
| Mean calibrated confidence | 0.740 |
| Mean delta | -0.177 |
| Calibrated range | 0.45 – 0.88 |
| Calibrated spread | 0.43 |
| Flagged for review | 111/184 (60%) |

## Confidence distribution (calibrated)

| Bucket | Count | % |
|--------|-------|---|
| High (0.80+) | 54 | 29.3% |
| Mid (0.70-0.79) | 85 | 46.2% |
| Low (0.60-0.69) | 30 | 16.3% |
| Very Low (<0.60) | 15 | 8.2% |

## Calibration dimensions (averages)

| Dimension | Weight | Avg Score |
|-----------|--------|-----------|
| Evidence Strength | 30% | 0.767 |
| Style Clarity | 30% | 0.790 |
| Alternatives Dismissed | 20% | 0.634 |
| Exploration Completeness | 20% | 0.742 |

## Primary style distribution

| Style | Count | % |
|-------|-------|---|
| Microkernel (Plugin) | 44 | 23.9% |
| Modular Monolith | 39 | 21.2% |
| Layered | 35 | 19.0% |
| Microservices | 27 | 14.7% |
| Hexagonal Architecture | 10 | 5.4% |
| Domain-Driven Design | 7 | 3.8% |
| Service-Based | 7 | 3.8% |
| CQRS | 4 | 2.2% |
| Event-Driven | 3 | 1.6% |
| Space-Based | 3 | 1.6% |
| Pipeline (Pipe-and-Filter) | 3 | 1.6% |
| Multi-Agent | 1 | 0.5% |
| Serverless | 1 | 0.5% |

## All styles (including secondary)

| Style | Appearances | % of entries |
|-------|-------------|--------------|
| Microkernel (Plugin) | 82 | 44.6% |
| Event-Driven | 81 | 44.0% |
| Layered | 79 | 42.9% |
| Modular Monolith | 76 | 41.3% |
| Domain-Driven Design | 50 | 27.2% |
| Hexagonal Architecture | 36 | 19.6% |
| Microservices | 36 | 19.6% |
| CQRS | 17 | 9.2% |
| Pipeline (Pipe-and-Filter) | 17 | 9.2% |
| Service-Based | 15 | 8.2% |
| Space-Based | 6 | 3.3% |
| Multi-Agent | 1 | 0.5% |
| Serverless | 1 | 0.5% |

## Full entry table (sorted by calibrated confidence, ascending)

| # | Project | Primary Style | All Styles | Orig | Cal | Flag |
|---|---------|--------------|------------|------|-----|------|
| 1 | aws-serverless-airline-booking | Serverless | Serverless, Event-Driven, Microservices | 0.47 | 0.45 | analysis relies almost entirely on README documentation; ... |
| 2 | AFFiNE | Microkernel (Plugin) | Microkernel (Plugin), Domain-Driven Design, Layered | 0.55 | 0.46 | evidence often implied or inferred ('implied from the ind... |
| 3 | geode | Space-Based | Space-Based, Event-Driven, Modular Monolith | 0.95 | 0.51 | evidence is mostly README-level and module name observati... |
| 4 | pulsar | Microservices | Microservices, Event-Driven, Microkernel (Plugin) | 0.90 | 0.51 | classification appears reasonable but reasoning is shallo... |
| 5 | n8n | Microkernel (Plugin) | Microkernel (Plugin), Modular Monolith, Layered | 0.92 | 0.52 | evidence is largely inferred from common patterns and ind... |
| 6 | orbit | Service-Based | Service-Based, Microkernel (Plugin), Space-Based | 0.90 | 0.54 | Space-Based classification is weakly justified — virtual ... |
| 7 | spark | Modular Monolith | Modular Monolith, Pipeline (Pipe-and-Filter), Microkernel (Plugin) | 0.90 | 0.54 | evidence is mostly directory-level; no specific config va... |
| 8 | strapi | Microkernel (Plugin) | Microkernel (Plugin), Modular Monolith, Layered | 0.92 | 0.54 | evidence relies heavily on package.json and docs/examples... |
| 9 | airflow | Microkernel (Plugin) | Microkernel (Plugin), Service-Based, Layered | 0.62 | 0.55 | multi-style classification may be diluting clarity — prim... |
| 10 | argo-workflows | Microkernel (Plugin) | Microkernel (Plugin), Microservices, Event-Driven | 0.68 | 0.56 | primary style may be debatable — Microkernel classificati... |
| 11 | dragonfly | Domain-Driven Design | Domain-Driven Design, Layered, Hexagonal Architecture | 0.92 | 0.57 | multi-label classification with three co-equal styles red... |
| 12 | infinispan | Microkernel (Plugin) | Microkernel (Plugin), Space-Based, Modular Monolith | 0.90 | 0.57 | three co-primary styles reduces clarity; Space-Based as s... |
| 13 | azure-functions-durable-extension | Microkernel (Plugin) | Microkernel (Plugin), Event-Driven, Hexagonal Architecture | 0.92 | 0.59 | multiple co-equal primary styles listed (Microkernel, Eve... |
| 14 | eureka | Layered | Layered, Microkernel (Plugin), Service-Based | 0.90 | 0.59 | multi-style classification with weak dominance — Layered ... |
| 15 | realtime | Event-Driven | Event-Driven, Layered, Microkernel (Plugin) | 0.90 | 0.59 | microservices alternative dismissed mid-sentence; plugin ... |
| 16 | istio | Service-Based | Service-Based, Domain-Driven Design, Microkernel (Plugin) | 0.92 | 0.60 | classification combines three distinct styles (Service-Ba... |
| 17 | pipeline | Domain-Driven Design | Domain-Driven Design, Event-Driven, Microservices | 0.90 | 0.60 | DDD classification is debatable — Tekton is primarily a K... |
| 18 | erpnext | Modular Monolith | Modular Monolith, Microkernel (Plugin), Domain-Driven Design | 0.95 | 0.61 | alternatives not meaningfully dismissed — no consideratio... |
| 19 | redpanda | Modular Monolith | Modular Monolith, Event-Driven, Hexagonal Architecture | 0.92 | 0.61 | multi-label classification with three co-primary styles r... |
| 20 | flink | Pipeline (Pipe-and-Filter) | Pipeline (Pipe-and-Filter), Microkernel (Plugin), Modular Monolith | 0.92 | 0.62 | multi-style classification with three co-primary styles r... |
| 21 | gitlabhq | Modular Monolith | Modular Monolith, Layered, Event-Driven | 0.90 | 0.62 | evidence is moderately specific (config/application.rb, s... |
| 22 | hazelcast | Space-Based | Space-Based, Microkernel (Plugin), Pipeline (Pipe-and-Filter) | 0.95 | 0.62 | evidence relies heavily on directory names and README des... |
| 23 | jellyfin | Layered | Layered, Microkernel (Plugin), Modular Monolith | 0.90 | 0.62 | multi-label classification with three styles may indicate... |
| 24 | coherence | Space-Based | Space-Based, Microkernel (Plugin), Modular Monolith | 0.95 | 0.63 | Space-Based classification is plausible but heavily READM... |
| 25 | frappe | Microkernel (Plugin) | Microkernel (Plugin), Modular Monolith, Domain-Driven Design | 0.92 | 0.63 | DDD inclusion weakly justified — doctype folder organizat... |
| 26 | sdk-go | Hexagonal Architecture | Hexagonal Architecture, Microkernel (Plugin) | 0.92 | 0.63 | dual classification (Hexagonal + Microkernel) weakens sty... |
| 27 | terraform | Microkernel (Plugin) | Microkernel (Plugin), Pipeline (Pipe-and-Filter) | 0.95 | 0.63 | evidence relies partly on known Terraform architecture ra... |
| 28 | snakemake | Microkernel (Plugin) | Microkernel (Plugin), Pipeline (Pipe-and-Filter) | 0.92 | 0.64 | evidence relies heavily on pyproject.toml dependency name... |
| 29 | erxes | Microservices | Microservices, Microkernel (Plugin), Event-Driven | 0.95 | 0.65 | multi-label classification (3 styles) reduces clarity; mi... |
| 30 | logseq | Microkernel (Plugin) | Microkernel (Plugin), Modular Monolith | 0.90 | 0.65 | alternatives_dismissed is weak — no serious consideration... |
| 31 | nats-server | Layered | Layered, Event-Driven | 0.90 | 0.65 | Event-Driven may be overstated as a co-primary style — in... |
| 32 | vertical-slice-api-template | Layered | Layered, CQRS, Hexagonal Architecture | 0.95 | 0.65 | primary style is Vertical Slice but classified as Layered... |
| 33 | keycloak | Microkernel (Plugin) | Microkernel (Plugin), Modular Monolith, Hexagonal Architecture | 0.92 | 0.66 | evidence relies heavily on directory names and general Ke... |
| 34 | ngx-admin | Layered | Layered, Hexagonal Architecture | 0.90 | 0.66 | Hexagonal co-classification is weakly supported — module-... |
| 35 | posthog | Modular Monolith | Modular Monolith, Microservices, Event-Driven | 0.92 | 0.66 | self-reported confidence (0.92) appears inflated — altern... |
| 36 | zuul | Microkernel (Plugin) | Microkernel (Plugin), Pipeline (Pipe-and-Filter) | 0.92 | 0.66 | evidence is partially hedged ('likely') and relies on gen... |
| 37 | ksql | Layered | Layered, Event-Driven, Microkernel (Plugin) | 0.90 | 0.67 | multi-label classification (3 styles) reduces style_clari... |
| 38 | redis | Microkernel (Plugin) | Microkernel (Plugin), Event-Driven, Service-Based | 0.92 | 0.67 | primary style may be overstated — Redis core is fundament... |
| 39 | oppia | Hexagonal Architecture | Hexagonal Architecture, Layered, Domain-Driven Design | 0.95 | 0.68 | multi-label classification (Hexagonal + Layered + DDD) re... |
| 40 | vendure | Microkernel (Plugin) | Microkernel (Plugin), Layered, Modular Monolith | 0.95 | 0.68 |  |
| 41 | InvenTree | Layered | Layered, Microkernel (Plugin) | 0.95 | 0.69 | dual classification (Layered + Microkernel) is reasonable... |
| 42 | Radarr | Layered | Layered, Modular Monolith | 0.90 | 0.69 |  |
| 43 | beats | Microkernel (Plugin) | Microkernel (Plugin), Modular Monolith | 0.92 | 0.69 | alternatives_dismissed is low — no explicit consideration... |
| 44 | letta | Layered | Layered, Microkernel (Plugin), Domain-Driven Design | 0.85 | 0.69 |  |
| 45 | shopware | Modular Monolith | Modular Monolith, Microkernel (Plugin), Event-Driven | 0.95 | 0.69 | self-reported confidence of 0.95 seems inflated; alternat... |
| 46 | EventStore | Microkernel (Plugin) | Microkernel (Plugin), Domain-Driven Design, Layered | 0.92 | 0.70 | alternatives_dismissed section appears truncated (Hexagon... |
| 47 | dagster | Pipeline (Pipe-and-Filter) | Pipeline (Pipe-and-Filter), Microkernel (Plugin), Service-Based | 0.92 | 0.70 | multi-style classification reduces clarity score; primary... |
| 48 | loki | Microservices | Microservices, Modular Monolith, Domain-Driven Design | 0.95 | 0.70 | multi-label classification (3 styles) reduces clarity sco... |
| 49 | canvas-lms | Modular Monolith | Modular Monolith, Layered, Microkernel (Plugin) | 0.90 | 0.71 | reasoning is cut off mid-sentence in 'Rejection of Other ... |
| 50 | ignite | Microkernel (Plugin) | Microkernel (Plugin), Layered, Space-Based | 0.95 | 0.71 | three co-primary styles listed reduces clarity; Space-Bas... |
| 51 | kafka | Modular Monolith | Modular Monolith, Microkernel (Plugin) | 0.90 | 0.71 | Microkernel designation is weakly supported — connector/p... |
| 52 | kibana | Microkernel (Plugin) | Microkernel (Plugin), Modular Monolith | 0.95 | 0.71 | alternatives_dismissed is low — no explicit consideration... |
| 53 | medusa | Modular Monolith | Modular Monolith, Event-Driven, Domain-Driven Design | 0.90 | 0.71 |  |
| 54 | nhost | Microservices | Microservices, Service-Based | 0.95 | 0.71 | shared database noted as Service-Based indicator but prim... |
| 55 | snuba | Modular Monolith | Modular Monolith, Pipeline (Pipe-and-Filter), Event-Driven | 0.90 | 0.71 | alternatives_dismissed is weak — no explicit consideratio... |
| 56 | twenty | Modular Monolith | Modular Monolith, Event-Driven, Domain-Driven Design | 0.92 | 0.71 | DDD as a tertiary style may be overstated — evidence for ... |
| 57 | hapi-fhir | Modular Monolith | Modular Monolith, Layered, Microkernel (Plugin) | 0.92 | 0.72 | none — classification is reasonable, but layering evidenc... |
| 58 | ignite-3 | Modular Monolith | Modular Monolith, Microkernel (Plugin), Event-Driven | 0.92 | 0.72 | Event-Driven as tertiary style is weakly evidenced — even... |
| 59 | livekit | Service-Based | Service-Based, Event-Driven, Domain-Driven Design | 0.90 | 0.72 | multi-label classification (three styles) reduces clarity... |
| 60 | nextflow | Microkernel (Plugin) | Microkernel (Plugin), Pipeline (Pipe-and-Filter), Modular Monolith | 0.95 | 0.72 |  |
| 61 | nomad | Microkernel (Plugin) | Microkernel (Plugin), Event-Driven, Hexagonal Architecture | 0.92 | 0.72 | multi-style classification with three co-primary styles r... |
| 62 | squidex | CQRS | CQRS, Domain-Driven Design, Microkernel (Plugin) | 0.95 | 0.72 | evidence leans heavily on test directory names and folder... |
| 63 | temporal | Microservices | Microservices, Event-Driven, Domain-Driven Design | 0.95 | 0.72 | alternatives_dismissed is weak — no explicit consideratio... |
| 64 | bigcapital | Modular Monolith | Modular Monolith, Event-Driven, Domain-Driven Design | 0.95 | 0.73 | alternatives_dismissed is weak — microservices and layere... |
| 65 | grafana | Microkernel (Plugin) | Microkernel (Plugin), Modular Monolith, Domain-Driven Design | 0.92 | 0.73 | DDD as tertiary classification is weakly evidenced — nami... |
| 66 | lemmy | Modular Monolith | Modular Monolith, Layered, Event-Driven | 0.90 | 0.73 | Event-Driven classification is weakly justified — evidenc... |
| 67 | pachyderm | Modular Monolith | Modular Monolith, Microservices, Event-Driven | 0.92 | 0.73 | multi-label classification (3 styles) reduces clarity sco... |
| 68 | spree | Modular Monolith | Modular Monolith, Hexagonal Architecture, Event-Driven | 0.92 | 0.73 | reasoning is cut off mid-sentence for Layered rejection; ... |
| 69 | Ecommerce.Api | CQRS | CQRS, Layered, Domain-Driven Design | 0.95 | 0.74 | DDD evidence is relatively weak — relies on README claim ... |
| 70 | IDDD_Samples | Domain-Driven Design | Domain-Driven Design, Hexagonal Architecture, CQRS | 0.95 | 0.74 | evidence relies partly on README and naming conventions r... |
| 71 | OpenTripPlanner | Modular Monolith | Modular Monolith, Layered, Domain-Driven Design | 0.92 | 0.74 |  |
| 72 | Rocket.Chat | Microservices | Microservices, Event-Driven, Modular Monolith | 0.92 | 0.74 | multi-style classification makes clarity inherently lower... |
| 73 | cockroach | Layered | Layered, Modular Monolith, Event-Driven | 0.95 | 0.74 | alternatives_dismissed is low — microservices and pipelin... |
| 74 | consul | Modular Monolith | Modular Monolith, Event-Driven, Hexagonal Architecture | 0.92 | 0.74 | three co-equal styles listed which dilutes primary classi... |
| 75 | dbt-core | Microkernel (Plugin) | Microkernel (Plugin), Layered, Pipeline (Pipe-and-Filter) | 0.92 | 0.74 | self-reported confidence (0.92) appears inflated; evidenc... |
| 76 | go-clean-arch | Hexagonal Architecture | Hexagonal Architecture, Layered, Domain-Driven Design | 0.95 | 0.74 | DDD classification is weak — bounded contexts claim based... |
| 77 | killbill | Modular Monolith | Modular Monolith, Microkernel (Plugin), Event-Driven | 0.92 | 0.74 | reasoning cuts off mid-sentence on microservices rejectio... |
| 78 | luigi | Microkernel (Plugin) | Microkernel (Plugin), Pipeline (Pipe-and-Filter) | 0.95 | 0.74 | dual classification somewhat unusual but defensible; evid... |
| 79 | m-r | CQRS | CQRS, Layered, Event-Driven | 0.95 | 0.74 | alternatives_dismissed is low — no competing styles (e.g.... |
| 80 | mage-ai | Modular Monolith | Modular Monolith, Hexagonal Architecture, Pipeline (Pipe-and-Filter) | 0.90 | 0.74 |  |
| 81 | memcached | Layered | Layered, Microkernel (Plugin) | 0.85 | 0.74 | dual classification (Layered + Microkernel) may dilute co... |
| 82 | microservices-demo | Microservices | Microservices, Event-Driven | 0.95 | 0.74 | secondary Event-Driven classification is weak — the reaso... |
| 83 | solidus | Modular Monolith | Modular Monolith, Layered | 0.95 | 0.74 | Plugin/Microkernel architecture partially described but d... |
| 84 | spring-petclinic | Layered | Layered, Domain-Driven Design | 0.90 | 0.74 | DDD as secondary style is reasonable but 'package by feat... |
| 85 | Sonarr | Modular Monolith | Modular Monolith, Layered, Event-Driven | 0.92 | 0.75 |  |
| 86 | kotlin-fullstack-sample | Layered | Layered | 0.90 | 0.75 | Layered is reasonable but this is a small full-stack samp... |
| 87 | library | Domain-Driven Design | Domain-Driven Design, Hexagonal Architecture, Modular Monolith | 0.95 | 0.75 | alternatives_dismissed is low — no explicit consideration... |
| 88 | maybe | Layered | Layered, Domain-Driven Design | 0.90 | 0.75 |  |
| 89 | open-web-calendar | Layered | Layered | 0.85 | 0.75 |  |
| 90 | saleor | Modular Monolith | Modular Monolith, Event-Driven, Domain-Driven Design | 0.90 | 0.75 |  |
| 91 | traefik | Microkernel (Plugin) | Microkernel (Plugin), Pipeline (Pipe-and-Filter), Event-Driven | 0.92 | 0.75 | Layered briefly dismissed but without deep comparative an... |
| 92 | AutoGPT | Microservices | Microservices, Event-Driven, Microkernel (Plugin) | 0.78 | 0.76 |  |
| 93 | CleanArchitecture | Hexagonal Architecture | Hexagonal Architecture, Domain-Driven Design, Modular Monolith | 0.95 | 0.76 | Vertical Slice alternative noted but not seriously consid... |
| 94 | appwrite | Microservices | Microservices, Event-Driven | 0.83 | 0.76 |  |
| 95 | azure-functions-host | Microkernel (Plugin) | Microkernel (Plugin), Layered, Event-Driven | 0.90 | 0.76 |  |
| 96 | backstage | Microkernel (Plugin) | Microkernel (Plugin), Modular Monolith | 0.95 | 0.76 |  |
| 97 | decidim | Modular Monolith | Modular Monolith, Microkernel (Plugin), Event-Driven | 0.95 | 0.76 | self-reported confidence (0.95) is inflated; microservice... |
| 98 | dify | Service-Based | Service-Based, Event-Driven, Layered | 0.92 | 0.76 |  |
| 99 | go-backend-clean-architecture | Hexagonal Architecture | Hexagonal Architecture, Layered | 0.95 | 0.76 | dual classification (Hexagonal + Layered) is reasonable b... |
| 100 | linkerd2 | Microservices | Microservices, Domain-Driven Design | 0.95 | 0.76 | alternatives_dismissed is weak — no explicit consideratio... |
| 101 | mimir | Microservices | Microservices, Event-Driven, Modular Monolith | 0.95 | 0.76 | Event-Driven listed as secondary but evidence is thin — K... |
| 102 | modular-monolith-with-ddd | Modular Monolith | Modular Monolith, Domain-Driven Design, CQRS, Event-Driven | 1.00 | 0.76 | alternatives_dismissed is low — no competing styles consi... |
| 103 | moodle | Microkernel (Plugin) | Microkernel (Plugin), Layered | 0.95 | 0.76 | secondary Layered label is somewhat generic — present in ... |
| 104 | postgrest | Layered | Layered, Pipeline (Pipe-and-Filter) | 0.90 | 0.76 | dual-classification (Layered + Pipeline) with both listed... |
| 105 | schema-registry | Microkernel (Plugin) | Microkernel (Plugin), Modular Monolith, Event-Driven | 0.92 | 0.76 | multi-style classification with three labels somewhat dil... |
| 106 | EventSourcing.NetCore | Event-Driven | Event-Driven, CQRS, Domain-Driven Design | 0.95 | 0.77 | Samples directory not found — minor gap in exploration; e... |
| 107 | clean-architecture-manga | Hexagonal Architecture | Hexagonal Architecture, Microservices, Domain-Driven Design | 0.95 | 0.77 | multi-label classification (3 styles) makes style_clarity... |
| 108 | go-ecommerce-microservices | Microservices | Microservices, Event-Driven, Domain-Driven Design, CQRS | 0.95 | 0.77 | alternatives_dismissed is low — reasoning doesn't explici... |
| 109 | go-food-delivery-microservices | Microservices | Microservices, Event-Driven, Domain-Driven Design, CQRS | 0.95 | 0.77 | alternatives_dismissed is low — no explicit consideration... |
| 110 | plane | Service-Based | Service-Based, Event-Driven, Layered | 0.92 | 0.77 | self-reported confidence (0.92) appears inflated; alterna... |
| 111 | prefect | Layered | Layered, Microkernel (Plugin), Event-Driven | 0.90 | 0.77 |  |
| 112 | ralph | Layered | Layered, Modular Monolith | 0.90 | 0.77 |  |
| 113 | supabase | Microservices | Microservices, Event-Driven | 0.95 | 0.77 | Event-Driven as secondary may be overstated — WAL-based r... |
| 114 | tempo | Microservices | Microservices, Event-Driven, Modular Monolith | 0.95 | 0.77 | Three styles classified simultaneously; self-reported 0.9... |
| 115 | zadig | Microservices | Microservices, Service-Based, Event-Driven | 0.95 | 0.77 | Service-Based vs Microservices boundary is acknowledged b... |
| 116 | zammad | Layered | Layered, Event-Driven | 0.90 | 0.77 |  |
| 117 | Lidarr | Layered | Layered, Modular Monolith | 0.90 | 0.78 | Microkernel/Plugin partially dismissed but indexer/downlo... |
| 118 | OrchardCore | Microkernel (Plugin) | Microkernel (Plugin), Modular Monolith, Domain-Driven Design | 0.95 | 0.78 |  |
| 119 | analytics | Modular Monolith | Modular Monolith, Layered, Pipeline (Pipe-and-Filter) | 0.80 | 0.78 |  |
| 120 | auth | Layered | Layered | 0.85 | 0.78 |  |
| 121 | dapr | Microkernel (Plugin) | Microkernel (Plugin), Hexagonal Architecture, Microservices | 0.95 | 0.78 |  |
| 122 | debezium | Microkernel (Plugin) | Microkernel (Plugin), Event-Driven | 0.90 | 0.78 |  |
| 123 | openmrs-core | Layered | Layered, Microkernel (Plugin) | 0.90 | 0.78 |  |
| 124 | sample-dotnet-core-cqrs-api | CQRS | CQRS, Domain-Driven Design, Hexagonal Architecture | 0.95 | 0.78 | alternatives_dismissed is low — no consideration of wheth... |
| 125 | AppFlowy | Microkernel (Plugin) | Microkernel (Plugin), Hexagonal Architecture, Event-Driven | 0.81 | 0.79 |  |
| 126 | Practical.CleanArchitecture | Microservices | Microservices, Domain-Driven Design, Hexagonal Architecture | 0.95 | 0.79 | monolith/modular-monolith alternatives acknowledged but n... |
| 127 | Prowlarr | Layered | Layered, Hexagonal Architecture | 0.90 | 0.79 | Hexagonal co-classification may be overstated — the OS ad... |
| 128 | domain-driven-hexagon | Hexagonal Architecture | Hexagonal Architecture, Domain-Driven Design, Modular Monolith, CQRS | 0.98 | 0.79 |  |
| 129 | qdrant | Modular Monolith | Modular Monolith, Layered, Event-Driven | 0.92 | 0.79 | Event-Driven as a secondary style is weakly justified — R... |
| 130 | relay | Modular Monolith | Modular Monolith, Event-Driven, Hexagonal Architecture | 0.90 | 0.79 | multi-label classification (3 styles) reduces clarity sco... |
| 131 | Inflow | Modular Monolith | Modular Monolith, Event-Driven, Domain-Driven Design | 0.95 | 0.80 |  |
| 132 | cal.com | Modular Monolith | Modular Monolith, Microkernel (Plugin), Service-Based | 0.90 | 0.80 | Multi-label classification (3 styles) reduces clarity; se... |
| 133 | chatwoot | Layered | Layered, Event-Driven | 0.90 | 0.80 |  |
| 134 | eventuous | Domain-Driven Design | Domain-Driven Design, Event-Driven, Hexagonal Architecture | 0.92 | 0.80 |  |
| 135 | logstash | Pipeline (Pipe-and-Filter) | Pipeline (Pipe-and-Filter), Microkernel (Plugin) | 0.95 | 0.80 |  |
| 136 | sample-spring-microservices-new | Microservices | Microservices, Layered | 0.95 | 0.80 | secondary Layered style inferred without direct code insp... |
| 137 | clean-architecture-dotnet | Microservices | Microservices, CQRS, Hexagonal Architecture | 0.95 | 0.81 |  |
| 138 | ddd-forum | Domain-Driven Design | Domain-Driven Design, Hexagonal Architecture, Modular Monolith | 0.95 | 0.81 | some paths described as 'likely' rather than confirmed (e... |
| 139 | directus | Layered | Layered, Microkernel (Plugin), Modular Monolith | 0.90 | 0.81 | multi-label classification with three styles — primary La... |
| 140 | envoy | Microkernel (Plugin) | Microkernel (Plugin), Layered, Event-Driven | 0.95 | 0.81 |  |
| 141 | kafka-streams-examples | Event-Driven | Event-Driven, Microservices | 0.95 | 0.81 |  |
| 142 | mattermost | Layered | Layered, Microkernel (Plugin), Modular Monolith | 0.90 | 0.81 |  |
| 143 | nocodb | Layered | Layered, Microkernel (Plugin), Modular Monolith | 0.90 | 0.81 |  |
| 144 | storage | Modular Monolith | Modular Monolith, Hexagonal Architecture, Event-Driven | 0.92 | 0.81 |  |
| 145 | synapse | Service-Based | Service-Based, Layered, Microkernel (Plugin) | 0.90 | 0.81 |  |
| 146 | umami | Layered | Layered, Event-Driven | 0.90 | 0.81 |  |
| 147 | wild-workouts-go-ddd-example | Microservices | Microservices, Domain-Driven Design, CQRS, Hexagonal Architecture | 0.95 | 0.81 |  |
| 148 | akaunting | Modular Monolith | Modular Monolith, Event-Driven | 0.85 | 0.82 |  |
| 149 | clean-architecture-example | Hexagonal Architecture | Hexagonal Architecture, Modular Monolith, Domain-Driven Design | 0.95 | 0.82 |  |
| 150 | localstack | Microkernel (Plugin) | Microkernel (Plugin), Layered, Service-Based | 0.92 | 0.82 |  |
| 151 | nifi | Microkernel (Plugin) | Microkernel (Plugin), Pipeline (Pipe-and-Filter), Event-Driven | 0.95 | 0.82 |  |
| 152 | server | Microkernel (Plugin) | Microkernel (Plugin), Layered, Modular Monolith | 0.95 | 0.82 |  |
| 153 | tutor | Microkernel (Plugin) | Microkernel (Plugin), Microservices | 0.90 | 0.82 | dual classification (Microkernel + Microservices) is some... |
| 154 | NorthwindTraders | Hexagonal Architecture | Hexagonal Architecture, CQRS, Domain-Driven Design | 0.95 | 0.83 |  |
| 155 | conductor | Microkernel (Plugin) | Microkernel (Plugin), Event-Driven, Layered | 0.92 | 0.83 |  |
| 156 | ddd-playground | Domain-Driven Design | Domain-Driven Design, Hexagonal Architecture, Event-Driven | 0.95 | 0.83 |  |
| 157 | gitpod | Microservices | Microservices, Hexagonal Architecture | 0.95 | 0.83 |  |
| 158 | mastodon | Service-Based | Service-Based, Event-Driven, Layered | 0.92 | 0.83 |  |
| 159 | openproject | Modular Monolith | Modular Monolith, Layered, Microkernel (Plugin) | 0.95 | 0.83 |  |
| 160 | self-hosted | Microservices | Microservices, Event-Driven | 0.95 | 0.83 |  |
| 161 | eShop | Microservices | Microservices, Event-Driven, Domain-Driven Design, CQRS | 0.95 | 0.84 | alternatives_dismissed is low — no explicit consideration... |
| 162 | ftgo-application | Microservices | Microservices, Event-Driven, Domain-Driven Design, CQRS | 0.95 | 0.84 | alternatives_dismissed is weak — no explicit consideratio... |
| 163 | go-clean-template | Hexagonal Architecture | Hexagonal Architecture, Layered, CQRS | 0.95 | 0.84 | CQRS classification seems a stretch — reasoning admits it... |
| 164 | nopCommerce | Layered | Layered, Microkernel (Plugin), Event-Driven | 0.95 | 0.84 |  |
| 165 | MetaGPT | Multi-Agent | Multi-Agent, Event-Driven, Layered | 0.95 | 0.85 |  |
| 166 | bagisto | Modular Monolith | Modular Monolith, Layered | 0.95 | 0.85 |  |
| 167 | ckan | Microkernel (Plugin) | Microkernel (Plugin), Layered | 0.95 | 0.85 |  |
| 168 | rabbitmq-server | Microkernel (Plugin) | Microkernel (Plugin), Modular Monolith | 0.95 | 0.85 |  |
| 169 | discourse | Microkernel (Plugin) | Microkernel (Plugin), Layered | 0.95 | 0.86 |  |
| 170 | dotnet-starter-kit | Modular Monolith | Modular Monolith, Domain-Driven Design, Event-Driven | 0.95 | 0.86 |  |
| 171 | eShopOnWeb | Layered | Layered, Hexagonal Architecture, Domain-Driven Design | 0.95 | 0.86 |  |
| 172 | elasticsearch | Microkernel (Plugin) | Microkernel (Plugin), Modular Monolith | 0.95 | 0.86 |  |
| 173 | forem | Layered | Layered, Event-Driven | 0.95 | 0.86 |  |
| 174 | full-stack-fastapi-template | Layered | Layered | 0.90 | 0.86 |  |
| 175 | ghostfolio | Modular Monolith | Modular Monolith, Layered, Event-Driven | 0.90 | 0.86 |  |
| 176 | sentry | Modular Monolith | Modular Monolith, Event-Driven, Microkernel (Plugin) | 0.92 | 0.86 |  |
| 177 | spring-petclinic-microservices | Microservices | Microservices, Layered | 0.95 | 0.86 |  |
| 178 | Confab | Modular Monolith | Modular Monolith, Event-Driven, Domain-Driven Design | 0.95 | 0.87 |  |
| 179 | bank-of-anthos | Microservices | Microservices | 0.95 | 0.87 |  |
| 180 | outline | Layered | Layered, Event-Driven | 0.90 | 0.87 |  |
| 181 | overseerr | Layered | Layered, Domain-Driven Design | 0.90 | 0.87 |  |
| 182 | practical-dotnet-aspire | Microservices | Microservices, Event-Driven, Domain-Driven Design | 0.95 | 0.87 |  |
| 183 | vault | Microkernel (Plugin) | Microkernel (Plugin), Layered | 0.95 | 0.87 |  |
| 184 | open-event-server | Layered | Layered, Event-Driven | 0.95 | 0.88 |  |

---
_Classification: Gemini 3 Flash via `pipeline/llm-review.sh --mode deep-analysis`. Calibration: Claude Sonnet 4.6 via `pipeline/calibrate-confidence.sh`. Implements SPIKE-005 pivot (heuristic confidence) and SPIKE-006 (YAML frontmatter format)._
