# Evidence by Architecture Style

*Evidence drawn from 78 O'Reilly Architecture Kata submissions across 11 challenges and 9 seasons (Fall 2020 -- Winter 2025). Placement scoring: 1st = 4 pts, 2nd = 3 pts, 3rd = 2 pts, Runner-up = 1 pt.*

## Style Performance Rankings

| Rank | Architecture Style | Teams | Weighted Score | Top-3 Teams | Win Rate | Avg ADRs |
|------|-------------------|-------|---------------|-------------|----------|----------|
| 1 | Event-Driven | 47 | 94 | 23 | 48.9% | 10.9 |
| 2 | Microservices | 39 | 67 | 14 | 35.9% | 10.1 |
| 3 | Service-Based | 25 | 43 | 9 | 36.0% | 11.5 |
| 4 | Modular Monolith | 6 | 18 | 5 | 83.3% | 11.0 |
| 5 | Hybrid/Evolutionary | 9 | 16 | 3 | 33.3% | 8.9 |
| 6 | AI-Specific | 7 | 16 | 4 | 57.1% | 7.9 |
| 7 | Serverless | 8 | 12 | 2 | 25.0% | 10.5 |

*Note: Teams may appear under multiple styles (e.g., a team using "Microservices + Event-Driven" appears in both categories). The 78 teams total to more than 78 entries when summed across styles because of these overlaps.*

---

## Event-Driven

### Evidence Summary
- **Total teams**: 47 of 78
- **Weighted placement score**: 94 (rank #1 of all styles)
- **Win rate**: 48.9% of teams using this style placed top-3
- **Average ADR count**: 10.9

### Team Evidence Table
| Team | Season | Challenge | Placement | Score | Paired With | Key Tech | ADRs |
|------|--------|-----------|-----------|-------|-------------|----------|------|
| BluzBrothers | Winter 2024 | MonitorMe | 1st | 4 | - | Kafka, Kubernetes, time-series database (InfluxDB) | 20 |
| ConnectedAI | AI Winter 2024 | ShopWise AI Assistant | 1st | 4 | multi-agent, microservices | Python, LangGraph, FastAPI | 12 |
| MonArch | Fall 2022 | Hey Blue! | 1st | 4 | Microservices, Hexagonal Architecture | Google Cloud Platform, Cloud Run, GCP Pub/Sub | 7 |
| PegasuZ | Spring 2022 | Spotlight Platform | 1st | 4 | Modular Monolith (MVP) | GraphQL (BFF), NoSQL (DynamoDB), Cloud (unspecified, ADR compares AWS/Azure/GCP) | 12 |
| Pragmatic | Fall 2024 | ClearView | 1st | 4 | Service-Based Architecture | LLMs (external, pay-as-you-go), Event Streaming, draw.io | 22 |
| Profitero Data Alchemists | Fall 2023 (External) | Road Warrior | 1st | 4 | - | Kafka, MongoDB (NoSQL), Kubernetes | 15 |
| Team Seven | Spring 2021 | Sysops Squad | 1st | 4 | Service-Based | Message Queues (guaranteed delivery), API Gateway, Mobile App | 12 |
| The Archangels | Fall 2021 | Farmacy Family | 1st | 4 | - | AWS, Kafka, Graph Database | 18 |
| ZAITects | Winter 2025 | Certifiable Inc. | 1st | 4 | service-based, hybrid AI-human pipeline | LangChain, RAG, vector search | 18 |
| IPT | Fall 2022 | Hey Blue! | 2nd | 3 | Microservices, Domain-Driven Design | Microsoft Azure, Azure Container Apps, Azure Event Hub | 8 |
| Iconites | Fall 2023 (External) | Road Warrior | 2nd | 3 | Microservices, Space-Based Architecture | Next.js (SSR PWA), Cosmos DB, Redis | 15 |
| Katamarans | Fall 2024 | ClearView | 2nd | 3 | - | Third-party AI services, Azure (example deployment), Event broker | 14 |
| Mighty Orbots | Winter 2024 | MonitorMe | 2nd | 3 | microservices | time-series database, ELT data pipeline, rule alert processor | 5 |
| Miyagi's Little Forests | Fall 2020 | Farmacy Food | 2nd | 3 | Microservices, Hexagonal Architecture | AWS, Amazon EKS (Kubernetes), Amazon ECR | 6 |
| Sever Crew | Fall 2021 | Farmacy Family | 2nd | 3 | Service-Based | AWS (EC2, RDS, DynamoDB, S3, Lambda, Glue, Athena, Cognito, API Gateway, Kafka MSK, Forecast), Apache Kafka, AWS Cognito | 11 |
| Architects Evolution Zone | Winter 2024 | MonitorMe | 3rd (tied) | 2 | - | NoSQL database, in-memory caching, message broker (RabbitMQ) | 12 |
| Black Cat Manifestation | Fall 2022 | Hey Blue! | 3rd | 2 | Mediator Topology | Elixir, Actor Model, QR Codes | 7 |
| Ctrl+Alt+Elite | Fall 2024 | ClearView | 3rd | 2 | Microservices (supporting) | AWS (EC2, S3, RDS, EMR, Amplify, Redshift, QuickSight, SNS, CloudWatch), Kafka (event broker), Golang | 20 |
| Flexibility Fertilisers | Fall 2023 (External) | Road Warrior | 3rd | 2 | Microservices | Event-driven messaging (asynchronous), External Identity Provider, Mobile phone sharing capabilities | 9 |
| Jedis | Fall 2020 | Farmacy Food | 3rd | 2 | Microservices | Kafka, Cloud (unspecified) | 10 |
| LowCode | Winter 2024 | MonitorMe | 3rd (tied) | 2 | distributed system | event bus, webhooks, distributed appliance nodes | 3 |
| TheGlobalVariables | Spring 2022 | Spotlight Platform | 3rd | 2 | Serverless Microservices | AWS Amplify, AWS Lambda, AWS DynamoDB | 6 |
| Wonderous Toys | Fall 2023 | Wildlife Watcher | 3rd | 2 | Modular Monolith, Micro Kernel | iNaturalist, GBIF, Roboflow | 6 |
| Arch Angels | Fall 2021 | Farmacy Family | Runner-up | 1 | - | AWS (S3, Cognito, HIPAA-eligible services), Open source libraries, DynamoDB | 0 |
| ArchEnemies | Fall 2023 (External) | Road Warrior | Runner-up | 1 | Microservices | CDN, API Gateway, Event Broker | 8 |
| ArchZ | Fall 2024 | ClearView | Runner-up | 1 | Mixed (per-quanta style selection), Microservices (User Profile, Integrations) | AWS, Figma (UI designs), Miro (collaboration) | 21 |
| Byte Me | Fall 2023 (External) | Road Warrior | Runner-up | 1 | Microservices | API Gateway, Kubernetes, Redis | 7 |
| Cloudeneers | Fall 2023 (External) | Road Warrior | Runner-up | 1 | Microservices | PWA (Progressive Web App), Docker, Kubernetes | 10 |
| DaVinci | Fall 2020 | Farmacy Food | Runner-up | 1 | - | AWS, Kubernetes (EKS), Kafka | 9 |
| Data Arch Evangelists | Winter 2025 | Certifiable Inc. | runner-up | 1 | microservices | OpenAI GPT-4, Hugging Face Transformers, YOLO | 9 |
| DevExperts | Fall 2024 | ClearView | Runner-up | 1 | - | AWS (Lambda, Cognito, S3, SQS, DynamoDB, CloudWatch, CloudTrail, Step Functions, Athena, QuickSight), LLMs (external), RESTful Services | 10 |
| Goal Diggers | Spring 2022 | Spotlight Platform | Runner-up | 1 | Cell-Based Architecture, Microservices | Graph Database (Neo4j), Docker / Containerization, OAuth | 14 |
| Hey Dragon | Fall 2020 | Farmacy Food | Runner-up | 1 | Layered Monolith, Service-Based Architecture | - | 9 |
| InfyArchs | Winter 2024 | MonitorMe | Runner-up | 1 | microservices | K3s, InfluxDB, Grafana | 12 |
| It Depends | Fall 2022 | Hey Blue! | Runner-up | 1 | Serverless | Serverless functions, Event sourcing, QR codes | 16 |
| Jaikaturi | Fall 2020 | Farmacy Food | Runner-up | 1 | Serverless | Google Cloud Platform (GCP), Google Firebase, Cloud Functions | 9 |
| Kamikaze Slayers | Spring 2022 | Spotlight Platform | Runner-up | 1 | Microservices | AWS (EC2, VPC, Route53, ELB, CloudWatch, Cloudtrail), MySQL, DynamoDB (NoSQL) | 8 |
| Los Ingenials | Fall 2022 | Hey Blue! | Runner-up | 1 | Microservices, Serverless | AWS, Amazon EKS, AWS Lambda | 21 |
| Magenta Force | Fall 2023 (External) | Road Warrior | Runner-up | 1 | Microservices | Cloud-native services (XaaS), Kubernetes, Third-party Identity Provider | 5 |
| Pentagram | Spring 2021 | Sysops Squad | Runner-up | 1 | Service-Based (Phase 1), Microservices (Phase 3+, hybrid) | Message Broker (orchestrator), Cloud platform, Fitness functions | 8 |
| Pentagram 2021 | Fall 2021 | Farmacy Family | Runner-up | 1 | Service-Based | AWS (Data Lake, Kafka, Lambda), Structurizr (C4 modeling), Kafka (event bus) | 5 |
| Safezone Cartons | Winter 2024 | MonitorMe | Runner-up | 1 | service-based | Telegraf, InfluxDB, Ansible | 12 |
| Street Fighters | Fall 2023 (External) | Road Warrior | Runner-up | 1 | Microservices | Kubernetes, Message Broker, CQRS | 16 |
| Systems Savants | Winter 2024 | MonitorMe | Runner-up | 1 | microservices | Kubernetes (EKS), AWS Outposts, Ambassador API Gateway | 11 |
| WildCode Wranglers | Fall 2023 | Wildlife Watcher | Runner-up | 1 | Microservices, Service-Oriented Architecture (SOA) | iNaturalist, GBIF, Roboflow | 4 |
| Wildlife Watchers | Fall 2023 | Wildlife Watcher | Runner-up | 1 | - | iNaturalist, GBIF, Wildlife Insights | 8 |
| WrightStuffNJ | Spring 2022 | Spotlight Platform | Runner-up | 1 | Service-Based, Workflow-Driven | AWS S3 (static content), AWS Lambda (microservices / BFF), AWS Step Functions (workflow) | 11 |

### What Winners Did Differently

- **Deep event flow design**: Winners like Profitero Data Alchemists (1st, Road Warrior) designed partitioning keys aligned between Kafka topics and databases, three scaling groups for independent scaling, and compacted topics for messaging. BluzBrothers (1st, MonitorMe) proved sub-1-second end-to-end timing with fitness functions.
- **Selective application over wholesale adoption**: Pragmatic (1st, ClearView) used event-driven selectively -- only where interoperability demanded it. Team Seven (1st, Sysops Squad) specified point-to-point guaranteed-delivery queues rather than pub/sub, showing precise pattern matching to requirements.
- **Quantitative validation**: BluzBrothers provided end-to-end timing proof (693ms). Profitero Data Alchemists defined three scaling groups with workload-specific scaling. Top EDA teams backed their event-driven choices with throughput calculations.
- **Complementary patterns**: 1st-place EDA teams consistently paired events with additional structure -- service-based decomposition (Team Seven, Pragmatic, ZAITects), hexagonal ports and adapters (MonArch), modular monolith boundaries (PegasuZ), or CQRS read/write separation (Iconites).
- **Runner-up EDA teams** tended to adopt event-driven patterns without the same depth of event-flow design. They declared the style but did not show the mechanics -- topic design, partition strategy, consumer group configuration, or dead-letter handling.

### Challenge Fit
| Challenge | Event-Driven Teams | Best Placement | Notes |
|-----------|--------------------|------------------|-------|
| MonitorMe | 7 | 1st | Strong fit |
| Farmacy Family | 4 | 1st | Strong fit |
| Road Warrior | 8 | 1st | Strong fit |
| ClearView | 5 | 1st | Strong fit |
| Hey Blue! | 5 | 1st | Strong fit |
| ShopWise AI Assistant | 1 | 1st | Strong fit |
| Certifiable Inc. | 2 | 1st | Strong fit |
| Spotlight Platform | 5 | 1st | Strong fit |
| Sysops Squad | 2 | 1st | Strong fit |
| Farmacy Food | 5 | 2nd | Competitive |
| Wildlife Watcher | 3 | 3rd | Competitive |

### Recommended When

- Systems with inherently asynchronous data flows (sensor streams, email polling, notification broadcasting, analytics pipelines)
- Domains where multiple consumers need the same event (e.g., a connection event consumed by points, analytics, and social media services)
- Real-time monitoring and alerting systems (MonitorMe: all 7 teams used EDA; Road Warrior: 8 of 9 teams)
- Systems requiring loose coupling between bounded contexts
- Workloads with bursty or unpredictable traffic patterns

### Avoid When

- Small teams with limited operational experience managing message brokers and event infrastructure
- Problems where strong transactional consistency is required across services (without complementary patterns like Saga or Outbox)
- Systems where the cost of event infrastructure (Kafka, RabbitMQ) exceeds the budget -- particularly non-profit and startup contexts where simpler synchronous communication may suffice initially
- Pure event-driven without complementary structure scored lower than event-driven paired with service-based or microservices

---

## Microservices

### Evidence Summary
- **Total teams**: 39 of 78
- **Weighted placement score**: 67 (rank #2 of all styles)
- **Win rate**: 35.9% of teams using this style placed top-3
- **Average ADR count**: 10.1

### Team Evidence Table
| Team | Season | Challenge | Placement | Score | Paired With | Key Tech | ADRs |
|------|--------|-----------|-----------|-------|-------------|----------|------|
| CELUS Ceals | Fall 2023 | Wildlife Watcher | 1st | 4 | - | iNaturalist, GBIF, Roboflow | 15 |
| ConnectedAI | AI Winter 2024 | ShopWise AI Assistant | 1st | 4 | multi-agent, event-driven | Python, LangGraph, FastAPI | 12 |
| MonArch | Fall 2022 | Hey Blue! | 1st | 4 | Event-Driven, Hexagonal Architecture | Google Cloud Platform, Cloud Run, GCP Pub/Sub | 7 |
| PegasuZ | Spring 2022 | Spotlight Platform | 1st | 4 | Modular Monolith (MVP) | GraphQL (BFF), NoSQL (DynamoDB), Cloud (unspecified, ADR compares AWS/Azure/GCP) | 12 |
| IPT | Fall 2022 | Hey Blue! | 2nd | 3 | Event-Driven, Domain-Driven Design | Microsoft Azure, Azure Container Apps, Azure Event Hub | 8 |
| Iconites | Fall 2023 (External) | Road Warrior | 2nd | 3 | Event-Driven Architecture, Space-Based Architecture | Next.js (SSR PWA), Cosmos DB, Redis | 15 |
| Mighty Orbots | Winter 2024 | MonitorMe | 2nd | 3 | event-driven | time-series database, ELT data pipeline, rule alert processor | 5 |
| Miyagi's Little Forests | Fall 2020 | Farmacy Food | 2nd | 3 | Event-Driven Architecture, Hexagonal Architecture | AWS, Amazon EKS (Kubernetes), Amazon ECR | 6 |
| Rapid Response | Fall 2023 | Wildlife Watcher | 2nd | 3 | Modular Monolith (deployable as monolith initially) | iNaturalist, GBIF, Roboflow | 8 |
| The Marmots | Spring 2022 | Spotlight Platform | 2nd | 3 | - | Static Frontend (SPA), Route Handlers, Load Balancer / DNS (Infrastructure Abstraction) | 19 |
| Ctrl+Alt+Elite | Fall 2024 | ClearView | 3rd | 2 | Event-Driven Architecture | AWS (EC2, S3, RDS, EMR, Amplify, Redshift, QuickSight, SNS, CloudWatch), Kafka (event broker), Golang | 20 |
| Flexibility Fertilisers | Fall 2023 (External) | Road Warrior | 3rd | 2 | Event-Driven Architecture | Event-driven messaging (asynchronous), External Identity Provider, Mobile phone sharing capabilities | 9 |
| Jedis | Fall 2020 | Farmacy Food | 3rd | 2 | Event-Driven Architecture | Kafka, Cloud (unspecified) | 10 |
| TheGlobalVariables | Spring 2022 | Spotlight Platform | 3rd | 2 | Event-Driven | AWS Amplify, AWS Lambda, AWS DynamoDB | 6 |
| Achievers | Fall 2022 | Hey Blue! | Runner-up | 1 | - | API Gateway, AWS (implied), Kubernetes | 9 |
| Arch Angels | Fall 2021 | Farmacy Family | Runner-up | 1 | - | AWS (S3, Cognito, HIPAA-eligible services), Open source libraries, DynamoDB | 0 |
| Arch Mahal | Spring 2021 | Sysops Squad | Runner-up | 1 | - | Message Broker (asynchronous communication), Load Balancer cluster, Active-Passive DR deployment | 6 |
| ArchEnemies | Fall 2023 (External) | Road Warrior | Runner-up | 1 | Event-Driven Architecture | CDN, API Gateway, Event Broker | 8 |
| ArchZ | Fall 2024 | ClearView | Runner-up | 1 | Mixed (per-quanta style selection), Event-Driven (AI, Matching) | AWS, Figma (UI designs), Miro (collaboration) | 21 |
| Byte Me | Fall 2023 (External) | Road Warrior | Runner-up | 1 | Event-Driven Architecture | API Gateway, Kubernetes, Redis | 7 |
| Cloudeneers | Fall 2023 (External) | Road Warrior | Runner-up | 1 | Event-Driven Architecture | PWA (Progressive Web App), Docker, Kubernetes | 10 |
| DaVinci | Fall 2020 | Farmacy Food | Runner-up | 1 | - | AWS, Kubernetes (EKS), Kafka | 9 |
| Data Arch Evangelists | Winter 2025 | Certifiable Inc. | runner-up | 1 | event-driven | OpenAI GPT-4, Hugging Face Transformers, YOLO | 9 |
| Elephant on a Cycle | Fall 2021 | Farmacy Family | Runner-up | 1 | Cloud-Native | Kubernetes, Micro-frontends, SaaS Omnichannel Messaging Gateway | 6 |
| Goal Diggers | Spring 2022 | Spotlight Platform | Runner-up | 1 | Cell-Based Architecture, Event-Driven | Graph Database (Neo4j), Docker / Containerization, OAuth | 14 |
| Hey Dragon | Fall 2020 | Farmacy Food | Runner-up | 1 | Layered Monolith, Service-Based Architecture | - | 9 |
| InfyArchs | Winter 2024 | MonitorMe | Runner-up | 1 | event-driven | K3s, InfluxDB, Grafana | 12 |
| Jazz Executor | Fall 2024 | ClearView | Runner-up | 1 | - | AI/ML Service (LLMs), REST APIs, OAuth2 / JWT (authentication) | 11 |
| Kamikaze Slayers | Spring 2022 | Spotlight Platform | Runner-up | 1 | Event-Driven | AWS (EC2, VPC, Route53, ELB, CloudWatch, Cloudtrail), MySQL, DynamoDB (NoSQL) | 8 |
| Los Ingenials | Fall 2022 | Hey Blue! | Runner-up | 1 | Event-Driven, Serverless | AWS, Amazon EKS, AWS Lambda | 21 |
| Magenta Force | Fall 2023 (External) | Road Warrior | Runner-up | 1 | Event-Driven Architecture | Cloud-native services (XaaS), Kubernetes, Third-party Identity Provider | 5 |
| Pentagram | Spring 2021 | Sysops Squad | Runner-up | 1 | Service-Based (Phase 1), Event-Driven | Message Broker (orchestrator), Cloud platform, Fitness functions | 8 |
| Self-Driven Team | Fall 2020 | Farmacy Food | Runner-up | 1 | - | Cloud (unspecified), REST APIs, Durable Message Queues | 20 |
| Shokunin | Spring 2022 | Spotlight Platform | Runner-up | 1 | Domain-Driven Design | GraphQL (Federated), ElasticSearch, Redis (internal event messaging) | 6 |
| Street Fighters | Fall 2023 (External) | Road Warrior | Runner-up | 1 | Event-Driven Architecture | Kubernetes, Message Broker, CQRS | 16 |
| Super Kings | Fall 2020 | Farmacy Food | Runner-up | 1 | Service-Oriented Architecture | Cloud (unspecified), Encryption/Decryption Service, Data Pump (ETL) | 3 |
| Systems Savants | Winter 2024 | MonitorMe | Runner-up | 1 | event-driven | Kubernetes (EKS), AWS Outposts, Ambassador API Gateway | 11 |
| WildCode Wranglers | Fall 2023 | Wildlife Watcher | Runner-up | 1 | Service-Oriented Architecture (SOA), Event-Driven Architecture | iNaturalist, GBIF, Roboflow | 4 |
| Wildlife Watchers | Fall 2023 | Wildlife Watcher | Runner-up | 1 | - | iNaturalist, GBIF, Wildlife Insights | 8 |

### What Winners Did Differently

- **Justified decomposition**: Miyagi's Forests (2nd, Farmacy Food) mapped DDD context maps to microservices boundaries with element catalogs and hexagonal internal structure. Celus Ceals (1st, Wildlife Watcher) scored microservices against 4 criteria in ADR-007, explicitly acknowledging the simplicity trade-off.
- **Pragmatic deployment**: Rapid Response (2nd, Wildlife Watcher) designed 6 microservices but deployed 5 as a monolith, keeping only the Camera Feed Engine separate. MonArch (1st, Hey Blue!) proposed a modular monolith as initial deployment that could later decompose along bounded-context seams.
- **Runner-up microservices teams** tended to adopt the style as a default without justifying the operational overhead, or without addressing database decomposition, distributed transactions, or cost implications.
- **Over-engineering signal**: In the Sysops Squad challenge, the sole microservices team (Arch Mahal) placed as runner-up while all 6 service-based teams placed higher. In ClearView, the sole pure microservices team (Jazz Executor) placed as runner-up.
- **Key differentiator**: Top microservices teams paired the style with DDD, event storming, or explicit evolutionary paths. Runner-up teams treated microservices as an end state rather than a justified choice.

### Challenge Fit
| Challenge | Microservices Teams | Best Placement | Notes |
|-----------|---------------------|------------------|-------|
| Hey Blue! | 4 | 1st | Strong fit |
| Wildlife Watcher | 4 | 1st | Strong fit |
| ShopWise AI Assistant | 1 | 1st | Strong fit |
| Spotlight Platform | 6 | 1st | Strong fit |
| Road Warrior | 7 | 2nd | Competitive |
| Farmacy Food | 6 | 2nd | Competitive |
| MonitorMe | 3 | 2nd | Competitive |
| ClearView | 3 | 3rd | Competitive |
| Farmacy Family | 2 | Runner-up | Runner-up only |
| Sysops Squad | 2 | Runner-up | Runner-up only |
| Certifiable Inc. | 1 | runner-up | Runner-up only |

### Recommended When

- Systems with well-understood domain boundaries where independent deployment and scaling provide clear value
- Organizations with mature DevOps capabilities and experience operating distributed systems
- Challenges with high availability and independent scalability requirements (Road Warrior: 15M users)
- Teams that can justify the operational complexity with concrete domain analysis (DDD, event storming)

### Avoid When

- Startup and non-profit contexts where operational overhead is prohibitive (ClearView, Hey Blue!, Spotlight Platform winners all chose simpler styles)
- Monolith migration where the domain model is not yet well understood (Sysops Squad: 6 of 7 teams chose service-based over microservices)
- Small teams (under 4 members) who cannot sustain the operational burden
- Greenfield projects where the domain model is still evolving -- modular monolith or service-based provides a safer starting point

---

## Service-Based

### Evidence Summary
- **Total teams**: 25 of 78
- **Weighted placement score**: 43 (rank #3 of all styles)
- **Win rate**: 36.0% of teams using this style placed top-3
- **Average ADR count**: 11.5

### Team Evidence Table
| Team | Season | Challenge | Placement | Score | Paired With | Key Tech | ADRs |
|------|--------|-----------|-----------|-------|-------------|----------|------|
| Pragmatic | Fall 2024 | ClearView | 1st | 4 | Event-Driven Architecture (selective) | LLMs (external, pay-as-you-go), Event Streaming, draw.io | 22 |
| Team Seven | Spring 2021 | Sysops Squad | 1st | 4 | Event-Driven (message queues) | Message Queues (guaranteed delivery), API Gateway, Mobile App | 12 |
| ZAITects | Winter 2025 | Certifiable Inc. | 1st | 4 | event-driven, hybrid AI-human pipeline | LangChain, RAG, vector search | 18 |
| ArchElekt | Spring 2021 | Sysops Squad | 2nd | 3 | - | API Gateway, Persistent Queue (ticket capture), Monitoring tools | 12 |
| Litmus | Winter 2025 | Certifiable Inc. | 2nd | 3 | - | RAG, LLM, ETL data pipeline | 18 |
| Sever Crew | Fall 2021 | Farmacy Family | 2nd | 3 | Event-Driven (Kafka integration layer) | AWS (EC2, RDS, DynamoDB, S3, Lambda, Glue, Athena, Cognito, API Gateway, Kafka MSK, Forecast), Apache Kafka, AWS Cognito | 11 |
| Architects++ | Fall 2021 | Farmacy Family | 3rd | 2 | Hexagonal Architecture, Batch Processing (AWS Batch) | AWS (Batch, RDS, VPN, SSM Runbooks), Facebook Groups, Eventbrite | 15 |
| Software Architecture Guild | Winter 2025 | Certifiable Inc. | 3rd | 2 | microkernel (plug-in) | LLM, vector search, full-text search | 6 |
| The Mad Katas | Spring 2021 | Sysops Squad | 3rd | 2 | Micro Frontend | Graph Database (Neo4j), Containerization, Orchestrator services | 17 |
| AnimAI | Fall 2023 | Wildlife Watcher | Runner-up | 1 | - | iNaturalist, GBIF, Roboflow | 18 |
| Arch8s | Spring 2022 | Spotlight Platform | Runner-up | 1 | - | AWS ECS (Docker containers), AWS Aurora PostgreSQL, AWS Lambda (serverless for heavy tasks) | 17 |
| ArchZ | Fall 2024 | ClearView | Runner-up | 1 | Mixed (per-quanta style selection), Event-Driven (AI, Matching) | AWS, Figma (UI designs), Miro (collaboration) | 21 |
| Deep Archs | Winter 2025 | Certifiable Inc. | runner-up | 1 | modular AI pipeline | AWS, Amazon Bedrock, Amazon SageMaker | 11 |
| Equi Hire Architects | Fall 2024 | ClearView | Runner-up | 1 | - | LLMs (external AI service for tips, anonymization), Cosine Similarity (matching algorithm, with LLM strategy option), OAuth2 / Apache Shiro (authentication) | 9 |
| Global Architects | Spring 2021 | Sysops Squad | Runner-up | 1 | - | AWS (RDS PostgreSQL, Redshift, ElasticSearch, SQS), Message queues, Chatbot with ML | 3 |
| Hananoyama | Fall 2020 | Farmacy Food | Runner-up | 1 | - | - | 5 |
| Hey Dragon | Fall 2020 | Farmacy Food | Runner-up | 1 | Layered Monolith, Event-Driven Microservices | - | 9 |
| Knowledge Out of Range Exception | Winter 2025 | Certifiable Inc. | runner-up | 1 | multi-model AI ensemble | multiple LLM models, multi-prompt strategy, confidence scoring | 11 |
| Pentagram | Spring 2021 | Sysops Squad | Runner-up | 1 | Event-Driven, Microservices (Phase 3+, hybrid) | Message Broker (orchestrator), Cloud platform, Fitness functions | 8 |
| Pentagram 2021 | Fall 2021 | Farmacy Family | Runner-up | 1 | Event-Driven (hybrid) | AWS (Data Lake, Kafka, Lambda), Structurizr (C4 modeling), Kafka (event bus) | 5 |
| Renaissance | Spring 2021 | Sysops Squad | Runner-up | 1 | - | AWS (EKS, DynamoDB, RDS, Redshift, SQS), Kubernetes, 3rd party BI tool | 6 |
| Safezone Cartons | Winter 2024 | MonitorMe | Runner-up | 1 | event-driven | Telegraf, InfluxDB, Ansible | 12 |
| Usfive | Winter 2025 | Certifiable Inc. | runner-up | 1 | multi-agent scoring | LLM, relational database with caching, Redis | 6 |
| Worried Warriors | Fall 2023 (External) | Road Warrior | Runner-up | 1 | - | Cloud-native, RESTful APIs, Asynchronous message queues | 4 |
| WrightStuffNJ | Spring 2022 | Spotlight Platform | Runner-up | 1 | Event-Driven, Workflow-Driven | AWS S3 (static content), AWS Lambda (microservices / BFF), AWS Step Functions (workflow) | 11 |

### What Winners Did Differently

- **Pragmatic middle ground**: Team Seven (1st, Sysops Squad) used service-based as a migration target from monolith, with event-driven queues for cross-domain communication. Pragmatic (1st, ClearView) chose service-based for its balance of feasibility and testability, adding events only where interoperability demanded it.
- **Cost-conscious justification**: Service-based architecture was the dominant choice when budget constraints were explicit. In Sysops Squad (6 of 7 teams), ClearView (2 of 7), Certifiable Inc. (6 of 7), and Farmacy Family (2 of 7), teams chose service-based specifically citing lower operational cost than microservices.
- **Transition architecture**: Service-based was frequently chosen as Phase 1 of an evolutionary approach, with microservices as a documented future state. Pentagram (Runner-up, Sysops Squad) used fitness-function-driven phase gates. ArchElekt (2nd, Sysops Squad) focused on problem-first design with clear ADR-to-problem tracing.
- **Winner pattern**: Top service-based teams distinguished themselves by adding event-driven communication where async was natural (Team Seven, Pragmatic, ZAITects) while keeping the overall deployment and data model simpler than full microservices.

### Challenge Fit
| Challenge | Service-Based Teams | Best Placement | Notes |
|-----------|---------------------|------------------|-------|
| Sysops Squad | 6 | 1st | Strong fit |
| ClearView | 3 | 1st | Strong fit |
| Certifiable Inc. | 6 | 1st | Strong fit |
| Farmacy Family | 3 | 2nd | Competitive |
| Wildlife Watcher | 1 | Runner-up | Runner-up only |
| Spotlight Platform | 2 | Runner-up | Runner-up only |
| Farmacy Food | 2 | Runner-up | Runner-up only |
| MonitorMe | 1 | Runner-up | Runner-up only |
| Road Warrior | 1 | Runner-up | Runner-up only |

### Recommended When

- Monolith migration where immediate independent deployability is needed without full microservices complexity (Sysops Squad: near-unanimous choice)
- Non-profit and budget-constrained contexts (ClearView, Spotlight Platform)
- Organizations with limited DevOps maturity who need fault isolation without distributed systems overhead
- Domains where a shared database is acceptable in the short term, with extraction points for later decomposition
- AI-integration scenarios where the primary goal is adding AI capabilities to an existing platform (Certifiable Inc.: 6 of 7 teams)

### Avoid When

- Systems requiring extreme independent scalability across service boundaries
- Large teams (10+) that benefit from microservices-level independence for parallel development
- Domains with very high throughput requirements where shared database becomes a bottleneck

---

## Modular Monolith

### Evidence Summary
- **Total teams**: 6 of 78
- **Weighted placement score**: 18 (rank #4 of all styles)
- **Win rate**: 83.3% of teams using this style placed top-3
- **Average ADR count**: 11.0

### Team Evidence Table
| Team | Season | Challenge | Placement | Score | Paired With | Key Tech | ADRs |
|------|--------|-----------|-----------|-------|-------------|----------|------|
| ArchColider | Fall 2020 | Farmacy Food | 1st | 4 | Event Sourcing, Domain-Driven Design | AWS, Amazon MQ (RabbitMQ), DynamoDB | 16 |
| MonArch | Fall 2022 | Hey Blue! | 1st | 4 | Microservices, Event-Driven | Google Cloud Platform, Cloud Run, GCP Pub/Sub | 7 |
| PegasuZ | Spring 2022 | Spotlight Platform | 1st | 4 | Microservices + Event-Driven (Long Term) | GraphQL (BFF), NoSQL (DynamoDB), Cloud (unspecified, ADR compares AWS/Azure/GCP) | 12 |
| Rapid Response | Fall 2023 | Wildlife Watcher | 2nd | 3 | Microservices | iNaturalist, GBIF, Roboflow | 8 |
| Wonderous Toys | Fall 2023 | Wildlife Watcher | 3rd | 2 | Micro Kernel, Event-Driven | iNaturalist, GBIF, Roboflow | 6 |
| Arch8s | Spring 2022 | Spotlight Platform | Runner-up | 1 | - | AWS ECS (Docker containers), AWS Aurora PostgreSQL, AWS Lambda (serverless for heavy tasks) | 17 |

### What Winners Did Differently

- **Highest win rate of all styles (83.3%)**: 5 of 6 teams using modular monolith placed top-3. ArchColider (1st, Farmacy Food) produced the most comprehensive cost analysis and won with a contrarian modular monolith choice against a field of microservices teams.
- **Startup context expertise**: ArchColider's structured comparison matrix scored modular monolith highest when team size, unproven domain model, and cognitive simplicity were weighted. PegasuZ (1st, Spotlight Platform) used modular monolith as MVP with documented extraction points.
- **Deliberate trade-off documentation**: Winners documented exactly why they chose against microservices -- ArchColider noted microservices "require a lot of attention to infrastructure, separation of responsibility, preferably a stable and known domain model." PegasuZ asked: "Why should the business invest to build a fortress when it is not sure if anyone would be staying in it?"
- **Key enabler -- hexagonal internals**: MonArch (1st, Hey Blue!) paired modular monolith with hexagonal architecture (ports and adapters), ensuring each module's internals were structured for future extraction without rewriting business logic.
- **Small sample caveat**: With only 6 teams, the 83.3% win rate is directionally strong but statistically limited.

### Challenge Fit
| Challenge | Modular Monolith Teams | Best Placement | Notes |
|-----------|------------------------|------------------|-------|
| Spotlight Platform | 2 | 1st | Strong fit |
| Farmacy Food | 1 | 1st | Strong fit |
| Hey Blue! | 1 | 1st | Strong fit |
| Wildlife Watcher | 2 | 2nd | Competitive |

### Recommended When

- Greenfield startup/non-profit projects where the domain model is not yet validated (Farmacy Food, Spotlight Platform, Hey Blue!)
- Small teams (2-5 members) who cannot sustain microservices operational overhead
- Contexts where time-to-market and cost are primary drivers
- When paired with hexagonal architecture or explicit bounded contexts, providing documented extraction points for future decomposition
- Projects where the team wants to validate product-market fit before investing in distributed infrastructure

### Avoid When

- Systems that have already proven their domain boundaries and need independent deployment and scaling
- Large organizations with mature DevOps where the monolith deployment model creates deployment contention
- Systems with fundamentally different scaling characteristics across components (e.g., the Camera Feed Engine in Wildlife Watcher needed independent scaling)

---

## Serverless

### Evidence Summary
- **Total teams**: 8 of 78
- **Weighted placement score**: 12 (rank #7 of all styles)
- **Win rate**: 25.0% of teams using this style placed top-3
- **Average ADR count**: 10.5

### Team Evidence Table
| Team | Season | Challenge | Placement | Score | Paired With | Key Tech | ADRs |
|------|--------|-----------|-----------|-------|-------------|----------|------|
| MonArch | Fall 2022 | Hey Blue! | 1st | 4 | Microservices, Event-Driven | Google Cloud Platform, Cloud Run, GCP Pub/Sub | 7 |
| TheGlobalVariables | Spring 2022 | Spotlight Platform | 3rd | 2 | Event-Driven | AWS Amplify, AWS Lambda, AWS DynamoDB | 6 |
| Arch8s | Spring 2022 | Spotlight Platform | Runner-up | 1 | - | AWS ECS (Docker containers), AWS Aurora PostgreSQL, AWS Lambda (serverless for heavy tasks) | 17 |
| Berlin Bears | Fall 2021 | Farmacy Family | Runner-up | 1 | Modular (component-based) | AWS (Lambda, API Gateway, DynamoDB, S3, Step Functions, CloudWatch, Glue, Athena, Cognito, SNS), Tableau (reporting), NoSQL (DynamoDB) | 3 |
| It Depends | Fall 2022 | Hey Blue! | Runner-up | 1 | Event-Driven | Serverless functions, Event sourcing, QR codes | 16 |
| Jaikaturi | Fall 2020 | Farmacy Food | Runner-up | 1 | Event-Driven Architecture | Google Cloud Platform (GCP), Google Firebase, Cloud Functions | 9 |
| Los Ingenials | Fall 2022 | Hey Blue! | Runner-up | 1 | Microservices, Event-Driven | AWS, Amazon EKS, AWS Lambda | 21 |
| Team Pacman | Fall 2020 | Farmacy Food | Runner-up | 1 | - | Cloud (serverless), PlantUML | 5 |

### What Winners Did Differently

- **Cost optimization focus**: TheGlobalVariables (3rd, Spotlight Platform) calculated per-user costs at $0.002/month with a lock-in cost formula. Jaikaturi (Runner-up, Farmacy Food) argued serverless eliminated the developer time spent maintaining and operating VMs.
- **Lower overall win rate (25.0%)**: Only 2 of 8 serverless teams placed top-3. The style appeared most successful when combined with other patterns rather than used as the sole architecture.
- **Best fit: intermittent workloads**: It Depends (Runner-up, Hey Blue!) argued that Hey Blue!'s burst pattern (daytime activity, near-zero overnight) mapped perfectly to scale-to-zero economics.
- **Gaps in serverless submissions**: Teams often chose serverless without addressing vendor lock-in, cold start latency, or state management challenges. Berlin Bears (Runner-up, Farmacy Family) and Team Pacman (Runner-up, Farmacy Food) had fewer ADRs and less architectural depth.
- **Strongest when combined**: DevExperts (Runner-up, ClearView) achieved the lowest infrastructure cost ($8,448/year) with a fully serverless AWS stack (Lambda, SQS, Step Functions) but lacked the ADR depth of winners.

### Challenge Fit
| Challenge | Serverless Teams | Best Placement | Notes |
|-----------|------------------|------------------|-------|
| Hey Blue! | 3 | 1st | Strong fit |
| Spotlight Platform | 2 | 3rd | Competitive |
| Farmacy Family | 1 | Runner-up | Runner-up only |
| Farmacy Food | 2 | Runner-up | Runner-up only |

### Recommended When

- Non-profit and ultra-cost-sensitive contexts where pay-per-request pricing aligns with budget constraints
- Systems with highly intermittent or bursty workloads (Hey Blue!'s daytime-only pattern, event-based triggers)
- MVP/prototype contexts where eliminating infrastructure management accelerates delivery
- Combined with other styles for specific components (e.g., PegasuZ used serverless for less-critical services while containers handled high-availability needs)

### Avoid When

- Systems requiring consistent low-latency responses (cold start penalties affect user experience)
- Workloads with sustained high throughput (e.g., MonitorMe's continuous sensor streams)
- Teams that need to demonstrate architectural depth in kata competitions -- pure serverless submissions consistently scored lower on ADR rigor and architectural narrative
- Systems where vendor lock-in is a significant concern (though TheGlobalVariables argued effectively that lock-in risk was manageable)

---

## Hybrid/Evolutionary

### Evidence Summary
- **Total teams**: 9 of 78
- **Weighted placement score**: 16 (rank #5 of all styles)
- **Win rate**: 33.3% of teams using this style placed top-3
- **Average ADR count**: 8.9

### Team Evidence Table
| Team | Season | Challenge | Placement | Score | Paired With | Key Tech | ADRs |
|------|--------|-----------|-----------|-------|-------------|----------|------|
| MonArch | Fall 2022 | Hey Blue! | 1st | 4 | Microservices, Event-Driven | Google Cloud Platform, Cloud Run, GCP Pub/Sub | 7 |
| ZAITects | Winter 2025 | Certifiable Inc. | 1st | 4 | service-based, event-driven | LangChain, RAG, vector search | 18 |
| Transformers | AI Winter 2024 | ShopWise AI Assistant | 3rd | 2 | monolithic, text-to-SQL pipeline | Python, Flask, Google Gemini Pro | 0 |
| Arch Angels | Fall 2021 | Farmacy Family | Runner-up | 1 | - | AWS (S3, Cognito, HIPAA-eligible services), Open source libraries, DynamoDB | 0 |
| Arch8s | Spring 2022 | Spotlight Platform | Runner-up | 1 | - | AWS ECS (Docker containers), AWS Aurora PostgreSQL, AWS Lambda (serverless for heavy tasks) | 17 |
| Hey Dragon | Fall 2020 | Farmacy Food | Runner-up | 1 | Layered Monolith, Service-Based Architecture | - | 9 |
| It Depends | Fall 2022 | Hey Blue! | Runner-up | 1 | Event-Driven, Serverless | Serverless functions, Event sourcing, QR codes | 16 |
| Pentagram | Spring 2021 | Sysops Squad | Runner-up | 1 | Service-Based (Phase 1), Event-Driven | Message Broker (orchestrator), Cloud platform, Fitness functions | 8 |
| Pentagram 2021 | Fall 2021 | Farmacy Family | Runner-up | 1 | Service-Based | AWS (Data Lake, Kafka, Lambda), Structurizr (C4 modeling), Kafka (event bus) | 5 |

### What Winners Did Differently

- **Phase-gate thinking**: PegasuZ (1st, Spotlight Platform) defined modular monolith for MVP with documented phase gates to microservices based on business milestones. Pentagram (Runner-up, Sysops Squad) introduced fitness-function-driven phase transitions.
- **Multi-style justification**: Hey Dragon (Runner-up, Farmacy Food) made architecture evolution their central thesis with three documented stages: layered monolith, service-based, event-driven microservices -- each with its own ADRs and diagrams.
- **Evolutionary winners**: MonArch (1st, Hey Blue!) opened with a Sam Newman quote -- "Microservices are not the goal" -- and proposed modular monolith as initial deployment with extraction along bounded-context seams. This pragmatic evolutionary thinking was a distinguishing feature of 1st-place teams.
- **ArchZ (Runner-up, ClearView)** took the most theoretically sophisticated approach: per-quanta style selection where different components used different architecture styles. While intellectually rigorous, it lacked feasibility analysis.
- **Winner pattern**: Evolutionary approaches won when the phase gates were tied to business milestones (user counts, funding rounds) rather than arbitrary timelines.

### Challenge Fit
| Challenge | Hybrid/Evolutionary Teams | Best Placement | Notes |
|-----------|---------------------------|------------------|-------|
| Hey Blue! | 2 | 1st | Strong fit |
| Certifiable Inc. | 1 | 1st | Strong fit |
| ShopWise AI Assistant | 1 | 3rd | Competitive |
| Farmacy Family | 2 | Runner-up | Runner-up only |
| Spotlight Platform | 1 | Runner-up | Runner-up only |
| Farmacy Food | 1 | Runner-up | Runner-up only |
| Sysops Squad | 1 | Runner-up | Runner-up only |

### Recommended When

- Migration projects from monolith to distributed architecture (Sysops Squad is the exemplar)
- Startup/non-profit contexts where the initial build cannot justify full distributed systems complexity
- When there is genuine uncertainty about future scale or domain boundaries
- Organizations that need to demonstrate ROI at each phase before investing in the next

### Avoid When

- Kata submissions where time constraints prevent documenting multiple phases with sufficient depth -- incomplete evolutionary roadmaps score lower than complete single-phase architectures
- When the evolutionary path is not tied to measurable criteria (fitness functions, user thresholds, business milestones)
- Projects where the team lacks the discipline to maintain extraction points across phases (evolutionary intent without structural support becomes technical debt)

---

## AI-Specific

### Evidence Summary
- **Total teams**: 7 of 78
- **Weighted placement score**: 16 (rank #6 of all styles)
- **Win rate**: 57.1% of teams using this style placed top-3
- **Average ADR count**: 7.9

### Team Evidence Table
| Team | Season | Challenge | Placement | Score | Paired With | Key Tech | ADRs |
|------|--------|-----------|-----------|-------|-------------|----------|------|
| ConnectedAI | AI Winter 2024 | ShopWise AI Assistant | 1st | 4 | multi-agent, event-driven | Python, LangGraph, FastAPI | 12 |
| ZAITects | Winter 2025 | Certifiable Inc. | 1st | 4 | service-based, event-driven | LangChain, RAG, vector search | 18 |
| Breakwater | AI Winter 2024 | ShopWise AI Assistant | 2nd | 3 | multi-agent, workflow-orchestrated | n8n, OpenAI, PostgreSQL | 5 |
| Transformers | AI Winter 2024 | ShopWise AI Assistant | 3rd | 2 | monolithic, text-to-SQL pipeline | Python, Flask, Google Gemini Pro | 0 |
| Deep Archs | Winter 2025 | Certifiable Inc. | runner-up | 1 | service-based, modular AI pipeline | AWS, Amazon Bedrock, Amazon SageMaker | 11 |
| IntelliMutual | AI Winter 2024 | ShopWise AI Assistant | Runner-up | 1 | two-chain pipeline, containerized | Python, Streamlit, Amazon Bedrock | 3 |
| Usfive | Winter 2025 | Certifiable Inc. | runner-up | 1 | service-based, multi-agent scoring | LLM, relational database with caching, Redis | 6 |

### What Winners Did Differently

- **Production operationalization**: ConnectedAI (1st, ShopWise) built a multi-agent supervisor hierarchy with LangGraph, dual-LLM cost optimization (Claude for reasoning, Gemini for routing), and quantitative evaluation with Ragas + LangFuse. ZAITects (1st, Certifiable Inc.) assembled a comprehensive LLM production stack covering AI Gateway, observability, guardrails, and OWASP security.
- **Architectural constraints on AI**: Pragmatic (1st, ClearView) designed a deterministic matching pipeline that reduced LLM calls from O(n*m) to O(n+m). Software Architecture Guild (3rd, Certifiable Inc.) ran six parallel AI solutions via microkernel plug-in architecture.
- **Documented rejections**: ZAITects explicitly rejected Agentic AI for structured grading workflows. Usfive rejected RAG due to homogenization risk. Litmus rejected AI anti-cheating and LLM caching with full ADRs.
- **Winner pattern in AI katas**: Top teams constrained AI rather than giving it free rein. They designed deterministic boundaries, confidence-based escalation, and human-in-the-loop as architectural requirements -- not afterthoughts.
- **Evaluation as architecture**: ConnectedAI was the only ShopWise team with a formal evaluation framework. This separated 1st place from all others. In Certifiable Inc., all top-3 teams included feasibility analysis.

### Challenge Fit
| Challenge | AI-Specific Teams | Best Placement | Notes |
|-----------|-------------------|------------------|-------|
| ShopWise AI Assistant | 4 | 1st | Strong fit |
| Certifiable Inc. | 3 | 1st | Strong fit |

### Recommended When

- Systems where AI is a core component that must be constrained, evaluated, and governed (ClearView, Certifiable Inc., ShopWise)
- Domains where LLM costs must be optimized through architectural patterns (deterministic pipelines, multi-model routing, confidence-based escalation)
- AI-powered systems where explainability, testability, and human oversight are non-negotiable
- When paired with service-based or microkernel architectures that allow AI components to be independently deployed, tested, and replaced

### Avoid When

- Systems where AI is a minor feature that does not justify dedicated architectural treatment
- Teams unfamiliar with AI production concerns (observability, guardrails, evaluation, governance) -- AI kata winners demonstrated operational depth, not just model integration
- Contexts where AI costs have not been estimated -- every top-3 AI team included cost or feasibility analysis

---
