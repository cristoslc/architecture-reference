# Evidence by Quality Attribute

*Evidence drawn from 78 O'Reilly Architecture Kata submissions across 11 challenges and 9 seasons (Fall 2020 -- Winter 2025). Quality attributes are normalized from each team's stated priorities in their YAML catalog entries.*

## Quality Attribute Rankings

| Rank | Quality Attribute | Teams Prioritizing | Avg Placement Score | Top-3 Rate | Most Common Challenge |
|------|-------------------|-------------------|--------------------|-----------|-----------------------|
| 1 | Scalability | 55 | 1.75 | 32.7% | Farmacy Food |
| 2 | Availability | 43 | 1.79 | 39.5% | Road Warrior |
| 3 | Performance | 41 | 1.93 | 48.8% | MonitorMe |
| 4 | Security | 40 | 1.82 | 37.5% | Farmacy Family |
| 5 | Evolvability/Extensibility | 35 | 1.89 | 42.9% | Farmacy Food |
| 6 | Cost/Feasibility | 26 | 2.0 | 50.0% | Spotlight Platform |
| 7 | Data Integrity/Consistency | 20 | 2.2 | 60.0% | MonitorMe |
| 8 | Interoperability | 15 | 2.07 | 60.0% | ClearView |
| 9 | Observability/Telemetry | 11 | 2.0 | 45.5% | Sysops Squad |
| 10 | Simplicity | 6 | 1.83 | 50.0% | Wildlife Watcher |

---

## Scalability

- **Teams prioritizing**: 55 of 78
- **Average placement score**: 1.75
- **Top-3 rate**: 32.7% (18 of 55)

### Architecture Styles That Best Support It

| Architecture Style | Teams | Avg Score | Top-3 Rate |
|-------------------|-------|-----------|-----------|
| Modular Monolith | 3 | 3.0 | 66.7% |
| AI-Specific | 3 | 3.0 | 66.7% |
| Hybrid/Evolutionary | 6 | 2.0 | 33.3% |
| Event-Driven | 36 | 1.97 | 41.7% |
| Microservices | 32 | 1.69 | 31.2% |
| Service-Based | 17 | 1.59 | 23.5% |
| Serverless | 6 | 1.5 | 16.7% |

### Challenges That Most Demanded It

| Challenge | Teams Citing | Top-3 Among Them |
|-----------|-------------|-----------------|
| Farmacy Food | 9 | 2 |
| Road Warrior | 8 | 2 |
| Spotlight Platform | 6 | 2 |
| ClearView | 6 | 3 |
| Hey Blue! | 5 | 3 |
| Farmacy Family | 5 | 1 |
| Sysops Squad | 5 | 2 |
| Wildlife Watcher | 4 | 1 |
| Certifiable Inc. | 4 | 1 |
| MonitorMe | 2 | 0 |
| ShopWise AI Assistant | 1 | 1 |

### Top-Performing Teams Prioritizing This Attribute

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| The Archangels | 1st | Farmacy Family | Event-Driven |
| CELUS Ceals | 1st | Wildlife Watcher | Microservices |
| ConnectedAI | 1st | ShopWise AI Assistant | multi-agent, event-driven |
| MonArch | 1st | Hey Blue! | Microservices, Event-Driven |
| PegasuZ | 1st | Spotlight Platform | Modular Monolith (MVP), Microservices + Event-Driven (Long Term) |
| Pragmatic | 1st | ClearView | Service-Based Architecture, Event-Driven Architecture (selective) |
| Profitero Data Alchemists | 1st | Road Warrior | Event-Driven Architecture |
| Team Seven | 1st | Sysops Squad | Service-Based, Event-Driven (message queues) |

### Evidence-Based Guidance

- Scalability was the most frequently cited quality attribute, appearing in over half of all submissions. However, prioritizing scalability did not strongly predict placement -- teams that over-indexed on scalability sometimes chose overly complex architectures (full microservices, space-based) when simpler styles would have sufficed.
- **Key insight from MonitorMe**: BluzBrothers (1st) deliberately *downplayed* scalability (ADR-008) since the system had a fixed 500-patient ceiling. This mature scoping decision was noted as a strength.
- **Key insight from Wildlife Watcher**: AnimAI initially rejected scalability (ADR-001) then revised (ADR-017 "Need Scalability to Some Degree"), showing thoughtful recalibration.
- **Pattern**: Winners addressed scalability through targeted mechanisms (scaling groups, CQRS, queue-based decoupling) rather than choosing an entire architecture style for scalability alone.

---

## Availability

- **Teams prioritizing**: 43 of 78
- **Average placement score**: 1.79
- **Top-3 rate**: 39.5% (17 of 43)

### Architecture Styles That Best Support It

| Architecture Style | Teams | Avg Score | Top-3 Rate |
|-------------------|-------|-----------|-----------|
| Modular Monolith | 3 | 3.67 | 100.0% |
| Event-Driven | 29 | 1.86 | 41.4% |
| Microservices | 23 | 1.78 | 34.8% |
| Serverless | 4 | 1.75 | 25.0% |
| Hybrid/Evolutionary | 5 | 1.6 | 20.0% |
| Service-Based | 14 | 1.5 | 28.6% |

### Challenges That Most Demanded It

| Challenge | Teams Citing | Top-3 Among Them |
|-----------|-------------|-----------------|
| Road Warrior | 8 | 3 |
| MonitorMe | 7 | 4 |
| Sysops Squad | 7 | 3 |
| Farmacy Food | 7 | 1 |
| ClearView | 3 | 0 |
| Hey Blue! | 3 | 2 |
| Wildlife Watcher | 3 | 2 |
| Farmacy Family | 2 | 1 |
| Spotlight Platform | 2 | 1 |
| Certifiable Inc. | 1 | 0 |

### Top-Performing Teams Prioritizing This Attribute

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| BluzBrothers | 1st | MonitorMe | event-driven |
| CELUS Ceals | 1st | Wildlife Watcher | Microservices |
| MonArch | 1st | Hey Blue! | Microservices, Event-Driven |
| PegasuZ | 1st | Spotlight Platform | Modular Monolith (MVP), Microservices + Event-Driven (Long Term) |
| Profitero Data Alchemists | 1st | Road Warrior | Event-Driven Architecture |
| Team Seven | 1st | Sysops Squad | Service-Based, Event-Driven (message queues) |
| ArchElekt | 2nd | Sysops Squad | Service-Based |
| Iconites | 2nd | Road Warrior | Microservices, Event-Driven Architecture |

### Evidence-Based Guidance

- Availability was the dominant concern in MonitorMe (medical monitoring) and Road Warrior (travel dashboard with 99.99% SLA).
- **LowCode (3rd tied, MonitorMe)**: Designed the most explicit graceful degradation model -- 3-node, 2-node, 1-node failure states with documented capability loss at each level. This approach was more valuable than claiming generic "high availability."
- **BluzBrothers (1st, MonitorMe)**: Addressed availability at the deployment level (duplicate instances, ADR-018/020) rather than letting it drive architecture style selection -- a mature distinction documented in ADR-010.
- **Pattern**: Graceful degradation (explicitly mapping what works at each failure level) was valued more than binary availability claims.

---

## Performance

- **Teams prioritizing**: 41 of 78
- **Average placement score**: 1.93
- **Top-3 rate**: 48.8% (20 of 41)

### Architecture Styles That Best Support It

| Architecture Style | Teams | Avg Score | Top-3 Rate |
|-------------------|-------|-----------|-----------|
| Modular Monolith | 3 | 3.33 | 100.0% |
| Hybrid/Evolutionary | 2 | 2.5 | 50.0% |
| Event-Driven | 30 | 2.0 | 53.3% |
| Microservices | 22 | 1.86 | 40.9% |
| Service-Based | 9 | 1.67 | 33.3% |
| Serverless | 6 | 1.67 | 33.3% |

### Challenges That Most Demanded It

| Challenge | Teams Citing | Top-3 Among Them |
|-----------|-------------|-----------------|
| MonitorMe | 9 | 6 |
| Road Warrior | 8 | 2 |
| Wildlife Watcher | 5 | 3 |
| ClearView | 4 | 2 |
| Farmacy Family | 4 | 2 |
| Sysops Squad | 3 | 1 |
| Hey Blue! | 3 | 2 |
| Spotlight Platform | 2 | 1 |
| Farmacy Food | 2 | 0 |
| ShopWise AI Assistant | 1 | 1 |

### Top-Performing Teams Prioritizing This Attribute

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| BluzBrothers | 1st | MonitorMe | event-driven |
| CELUS Ceals | 1st | Wildlife Watcher | Microservices |
| ConnectedAI | 1st | ShopWise AI Assistant | multi-agent, event-driven |
| MonArch | 1st | Hey Blue! | Microservices, Event-Driven |
| Profitero Data Alchemists | 1st | Road Warrior | Event-Driven Architecture |
| Team Seven | 1st | Sysops Squad | Service-Based, Event-Driven (message queues) |
| Iconites | 2nd | Road Warrior | Microservices, Event-Driven Architecture |
| Katamarans | 2nd | ClearView | Event-Driven Architecture |

### Evidence-Based Guidance

- Performance was most critical in real-time systems (MonitorMe, Road Warrior) where specific SLAs were stated in requirements.
- **BluzBrothers (1st, MonitorMe)**: End-to-end timing proof of 693ms against 1-second SLA. **Street Fighters (Runner-up, Road Warrior)**: Quantitative load analysis (25 requests/second, 1,000 reservation updates/second).
- **Pattern**: Teams that quantified performance with specific calculations or fitness functions placed higher than teams that listed performance as a priority without backing it with numbers.
- **Time-series databases**: InfluxDB was the consensus choice for performance-sensitive vital sign storage (MonitorMe), chosen for high-throughput writes and native temporal querying.

---

## Security

- **Teams prioritizing**: 40 of 78
- **Average placement score**: 1.82
- **Top-3 rate**: 37.5% (15 of 40)

### Architecture Styles That Best Support It

| Architecture Style | Teams | Avg Score | Top-3 Rate |
|-------------------|-------|-----------|-----------|
| Modular Monolith | 4 | 3.25 | 100.0% |
| Service-Based | 10 | 1.9 | 40.0% |
| Event-Driven | 27 | 1.89 | 40.7% |
| Serverless | 6 | 1.67 | 33.3% |
| Hybrid/Evolutionary | 5 | 1.6 | 20.0% |
| Microservices | 21 | 1.52 | 23.8% |
| AI-Specific | 2 | 1.0 | 0.0% |

### Challenges That Most Demanded It

| Challenge | Teams Citing | Top-3 Among Them |
|-----------|-------------|-----------------|
| Farmacy Family | 7 | 3 |
| Hey Blue! | 5 | 2 |
| Farmacy Food | 5 | 1 |
| ClearView | 5 | 2 |
| Wildlife Watcher | 5 | 3 |
| Sysops Squad | 3 | 1 |
| Spotlight Platform | 3 | 1 |
| MonitorMe | 3 | 1 |
| Road Warrior | 2 | 1 |
| ShopWise AI Assistant | 1 | 0 |
| Certifiable Inc. | 1 | 0 |

### Top-Performing Teams Prioritizing This Attribute

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| ArchColider | 1st | Farmacy Food | Modular Monolith, Event Sourcing |
| The Archangels | 1st | Farmacy Family | Event-Driven |
| CELUS Ceals | 1st | Wildlife Watcher | Microservices |
| MonArch | 1st | Hey Blue! | Microservices, Event-Driven |
| Pragmatic | 1st | ClearView | Service-Based Architecture, Event-Driven Architecture (selective) |
| Profitero Data Alchemists | 1st | Road Warrior | Event-Driven Architecture |
| Team Seven | 1st | Sysops Squad | Service-Based, Event-Driven (message queues) |
| IPT | 2nd | Hey Blue! | Microservices, Event-Driven |

### Evidence-Based Guidance

- Security was broadly cited but rarely a differentiator on its own -- it was expected as table stakes. Teams that went deeper into specific security patterns stood out.
- **Differentiating approaches**: ArchColider's zero trust from day one (ADR-006), The Mad Katas' zero trust with performance-aware authentication (ADR-011), Archangels' crypto-shredding for GDPR (ADR-005), and Wildlife Watchers' internal CA with Mutual TLS for camera authentication.
- **In AI contexts**: ZAITects (1st, Certifiable Inc.) performed an OWASP Top 10 security analysis specifically for LLM integration. IntelliMutual implemented SQL safety guardrails (SELECT-only validation, LIMIT enforcement).
- **Pattern**: Security as a quality attribute predicted placement only when backed by specific ADRs addressing concrete security decisions -- not when listed generically.

---

## Evolvability/Extensibility

- **Teams prioritizing**: 35 of 78
- **Average placement score**: 1.89
- **Top-3 rate**: 42.9% (15 of 35)

### Architecture Styles That Best Support It

| Architecture Style | Teams | Avg Score | Top-3 Rate |
|-------------------|-------|-----------|-----------|
| Modular Monolith | 2 | 4.0 | 100.0% |
| Serverless | 2 | 2.5 | 50.0% |
| Microservices | 20 | 1.9 | 45.0% |
| Event-Driven | 23 | 1.87 | 43.5% |
| Hybrid/Evolutionary | 6 | 1.5 | 16.7% |
| Service-Based | 10 | 1.4 | 20.0% |

### Challenges That Most Demanded It

| Challenge | Teams Citing | Top-3 Among Them |
|-----------|-------------|-----------------|
| Farmacy Food | 7 | 4 |
| Road Warrior | 7 | 2 |
| Wildlife Watcher | 4 | 1 |
| Sysops Squad | 4 | 1 |
| Farmacy Family | 3 | 0 |
| ClearView | 3 | 1 |
| Hey Blue! | 3 | 2 |
| Spotlight Platform | 2 | 2 |
| MonitorMe | 1 | 1 |
| Certifiable Inc. | 1 | 1 |

### Top-Performing Teams Prioritizing This Attribute

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| ArchColider | 1st | Farmacy Food | Modular Monolith, Event Sourcing |
| CELUS Ceals | 1st | Wildlife Watcher | Microservices |
| MonArch | 1st | Hey Blue! | Microservices, Event-Driven |
| Profitero Data Alchemists | 1st | Road Warrior | Event-Driven Architecture |
| Team Seven | 1st | Sysops Squad | Service-Based, Event-Driven (message queues) |
| IPT | 2nd | Hey Blue! | Microservices, Event-Driven |
| Katamarans | 2nd | ClearView | Event-Driven Architecture |
| The Marmots | 2nd | Spotlight Platform | Microservices |

### Evidence-Based Guidance

- Evolvability was the hallmark of top-placing evolutionary architecture teams. Profitero Data Alchemists (1st, Road Warrior) chose evolvability over elasticity as their third characteristic, reasoning that startup adaptability was paramount.
- **Fitness-function governance**: Pentagram (Runner-up, Sysops Squad) and Elephant on a Cycle (Runner-up, Farmacy Family) defined concrete fitness functions to measure whether architecture characteristics were maintained over time.
- **Microkernel for extensibility**: Wonderous Toys (3rd, Wildlife Watcher) used micro kernel for integration plugins. Software Architecture Guild (3rd, Certifiable Inc.) used microkernel to run six parallel AI solutions.
- **Pattern**: Teams citing evolvability placed higher when they provided structural mechanisms (hexagonal ports, plugin architectures, explicit extraction points) rather than just stating the aspiration.

---

## Cost/Feasibility

- **Teams prioritizing**: 26 of 78
- **Average placement score**: 2.0
- **Top-3 rate**: 50.0% (13 of 26)

### Architecture Styles That Best Support It

| Architecture Style | Teams | Avg Score | Top-3 Rate |
|-------------------|-------|-----------|-----------|
| Modular Monolith | 5 | 3.0 | 80.0% |
| Serverless | 3 | 2.33 | 66.7% |
| Hybrid/Evolutionary | 5 | 2.2 | 40.0% |
| Service-Based | 6 | 2.17 | 50.0% |
| Event-Driven | 19 | 2.05 | 52.6% |
| Microservices | 16 | 1.81 | 43.8% |

### Challenges That Most Demanded It

| Challenge | Teams Citing | Top-3 Among Them |
|-----------|-------------|-----------------|
| Spotlight Platform | 5 | 3 |
| ClearView | 5 | 3 |
| Wildlife Watcher | 4 | 1 |
| Hey Blue! | 3 | 2 |
| Certifiable Inc. | 3 | 2 |
| Farmacy Family | 2 | 0 |
| Farmacy Food | 2 | 2 |
| Road Warrior | 2 | 0 |

### Top-Performing Teams Prioritizing This Attribute

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| ArchColider | 1st | Farmacy Food | Modular Monolith, Event Sourcing |
| MonArch | 1st | Hey Blue! | Microservices, Event-Driven |
| PegasuZ | 1st | Spotlight Platform | Modular Monolith (MVP), Microservices + Event-Driven (Long Term) |
| Pragmatic | 1st | ClearView | Service-Based Architecture, Event-Driven Architecture (selective) |
| ZAITects | 1st | Certifiable Inc. | service-based, event-driven |
| IPT | 2nd | Hey Blue! | Microservices, Event-Driven |
| Katamarans | 2nd | ClearView | Event-Driven Architecture |
| The Marmots | 2nd | Spotlight Platform | Microservices |

### Evidence-Based Guidance

- Cost/feasibility was the strongest predictor of placement in non-profit and startup katas. Teams that included concrete cost analysis consistently placed higher.
- **ArchColider (1st, Farmacy Food)**: Three-scenario cost model ($12K-$23K/year). **MonArch (1st, Hey Blue!)**: $2,780/month GCP breakdown. **TheGlobalVariables (3rd, Spotlight Platform)**: $0.002/user/month. **Pragmatic (1st, ClearView)**: Token estimation with AI expert interview.
- **Pattern**: Every 1st-place team in non-profit/startup challenges included some form of cost analysis. The absence of cost analysis in non-profit contexts was consistently noted as a gap by challenge analyses.
- **Architecture style correlation**: Modular monolith (83.3% win rate) and service-based teams most frequently cited cost, and their simpler deployment models naturally reduced infrastructure spend.

---

## Data Integrity/Consistency

- **Teams prioritizing**: 20 of 78
- **Average placement score**: 2.2
- **Top-3 rate**: 60.0% (12 of 20)

### Architecture Styles That Best Support It

| Architecture Style | Teams | Avg Score | Top-3 Rate |
|-------------------|-------|-----------|-----------|
| Service-Based | 4 | 2.5 | 75.0% |
| Event-Driven | 16 | 2.12 | 56.2% |
| Microservices | 13 | 2.0 | 46.2% |

### Challenges That Most Demanded It

| Challenge | Teams Citing | Top-3 Among Them |
|-----------|-------------|-----------------|
| MonitorMe | 5 | 3 |
| ClearView | 4 | 1 |
| Road Warrior | 4 | 1 |
| Spotlight Platform | 2 | 2 |
| Farmacy Family | 1 | 1 |
| Hey Blue! | 1 | 1 |
| Wildlife Watcher | 1 | 1 |
| Certifiable Inc. | 1 | 1 |
| Sysops Squad | 1 | 1 |

### Top-Performing Teams Prioritizing This Attribute

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| The Archangels | 1st | Farmacy Family | Event-Driven |
| CELUS Ceals | 1st | Wildlife Watcher | Microservices |
| PegasuZ | 1st | Spotlight Platform | Modular Monolith (MVP), Microservices + Event-Driven (Long Term) |
| Pragmatic | 1st | ClearView | Service-Based Architecture, Event-Driven Architecture (selective) |
| Iconites | 2nd | Road Warrior | Microservices, Event-Driven Architecture |
| Litmus | 2nd | Certifiable Inc. | service-based |
| Mighty Orbots | 2nd | MonitorMe | microservices, event-driven |
| Mighty Orbots | 2nd | MonitorMe | microservices, event-driven |

### Evidence-Based Guidance

- Data integrity was most critical in medical (MonitorMe), financial (Sysops Squad billing), and certification (Certifiable Inc.) contexts.
- **Mighty Orbots (2nd, MonitorMe)**: ELT pipeline decision prioritized data integrity by loading raw data immediately and transforming later.
- **Pragmatic (1st, ClearView)**: Deliberately "downplayed" data integrity (ADR-004) to keep architecture simpler, acknowledging the trade-off. This transparency was noted as a strength.
- **Pattern**: Teams that explicitly acknowledged data integrity trade-offs (eventual consistency, stale data) and designed mitigation strategies scored higher than teams that claimed strong consistency without addressing the distributed systems implications.

---

## Interoperability

- **Teams prioritizing**: 15 of 78
- **Average placement score**: 2.07
- **Top-3 rate**: 60.0% (9 of 15)

### Architecture Styles That Best Support It

| Architecture Style | Teams | Avg Score | Top-3 Rate |
|-------------------|-------|-----------|-----------|
| Event-Driven | 12 | 2.33 | 75.0% |
| Service-Based | 5 | 2.0 | 40.0% |
| Microservices | 6 | 1.67 | 50.0% |

### Challenges That Most Demanded It

| Challenge | Teams Citing | Top-3 Among Them |
|-----------|-------------|-----------------|
| ClearView | 5 | 3 |
| Wildlife Watcher | 2 | 1 |
| Farmacy Family | 2 | 2 |
| Road Warrior | 2 | 1 |
| MonitorMe | 2 | 0 |
| Hey Blue! | 1 | 1 |
| Spotlight Platform | 1 | 1 |

### Top-Performing Teams Prioritizing This Attribute

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| The Archangels | 1st | Farmacy Family | Event-Driven |
| Pragmatic | 1st | ClearView | Service-Based Architecture, Event-Driven Architecture (selective) |
| Iconites | 2nd | Road Warrior | Microservices, Event-Driven Architecture |
| Katamarans | 2nd | ClearView | Event-Driven Architecture |
| Sever Crew | 2nd | Farmacy Family | Service-Based, Event-Driven (Kafka integration layer) |
| Black Cat Manifestation | 3rd | Hey Blue! | Event-Driven, Mediator Topology |
| Ctrl+Alt+Elite | 3rd | ClearView | Event-Driven Architecture, Microservices (supporting) |
| TheGlobalVariables | 3rd | Spotlight Platform | Serverless Microservices, Event-Driven |

### Evidence-Based Guidance

- Interoperability was most critical in challenges requiring extensive third-party integration: ClearView (HR systems), Wildlife Watcher (conservation platforms), and Farmacy Food (smart fridges, POS systems).
- **Pragmatic (1st, ClearView)**: Named interoperability as their top quality attribute, designing adapter-based HR integration with event-driven triggers.
- **Celus Ceals (1st, Wildlife Watcher)**: Produced detailed comparative analysis of all third-party tools, evaluating labeling platforms and training tools across deployment model, API availability, and upload mechanisms.
- **Pattern**: Interoperability as a priority predicted placement when backed by concrete integration analysis -- investigating actual APIs, data formats, and deployment models of target systems.

---

## Observability/Telemetry

- **Teams prioritizing**: 11 of 78
- **Average placement score**: 2.0
- **Top-3 rate**: 45.5% (5 of 11)

### Architecture Styles That Best Support It

| Architecture Style | Teams | Avg Score | Top-3 Rate |
|-------------------|-------|-----------|-----------|
| Service-Based | 4 | 2.25 | 50.0% |
| Hybrid/Evolutionary | 3 | 2.0 | 33.3% |
| Event-Driven | 8 | 1.75 | 37.5% |
| Microservices | 6 | 1.5 | 33.3% |

### Challenges That Most Demanded It

| Challenge | Teams Citing | Top-3 Among Them |
|-----------|-------------|-----------------|
| Sysops Squad | 3 | 1 |
| Hey Blue! | 2 | 1 |
| Farmacy Food | 1 | 1 |
| ClearView | 1 | 1 |
| Spotlight Platform | 1 | 0 |
| MonitorMe | 1 | 0 |
| Wildlife Watcher | 1 | 0 |
| Certifiable Inc. | 1 | 1 |

### Top-Performing Teams Prioritizing This Attribute

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| ArchColider | 1st | Farmacy Food | Modular Monolith, Event Sourcing |
| ZAITects | 1st | Certifiable Inc. | service-based, event-driven |
| ArchElekt | 2nd | Sysops Squad | Service-Based |
| IPT | 2nd | Hey Blue! | Microservices, Event-Driven |
| Ctrl+Alt+Elite | 3rd | ClearView | Event-Driven Architecture, Microservices (supporting) |
| Goal Diggers | Runner-up | Spotlight Platform | Cell-Based Architecture, Microservices |
| InfyArchs | Runner-up | MonitorMe | microservices, event-driven |
| It Depends | Runner-up | Hey Blue! | Event-Driven, Serverless |

### Evidence-Based Guidance

- Observability was cited by relatively few teams, but its presence correlated with operational maturity in submissions.
- **ConnectedAI (1st, ShopWise)**: Only team with LLM-specific observability (LangFuse) for AI system tracing. **ZAITects (1st, Certifiable Inc.)**: Langwatch for LLM observability.
- **Pentagram (Runner-up, Sysops Squad)**: Prioritized observability alongside evolvability as a core characteristic.
- **Pattern**: Observability appeared as a differentiator primarily in AI-focused katas where LLM behavior monitoring was a production requirement. In traditional katas, it was rarely cited despite its practical importance.

---

## Simplicity

- **Teams prioritizing**: 6 of 78
- **Average placement score**: 1.83
- **Top-3 rate**: 50.0% (3 of 6)

### Architecture Styles That Best Support It

| Architecture Style | Teams | Avg Score | Top-3 Rate |
|-------------------|-------|-----------|-----------|
| Modular Monolith | 3 | 2.33 | 66.7% |
| Service-Based | 4 | 1.25 | 25.0% |

### Challenges That Most Demanded It

| Challenge | Teams Citing | Top-3 Among Them |
|-----------|-------------|-----------------|
| Wildlife Watcher | 2 | 1 |
| Spotlight Platform | 1 | 0 |
| Farmacy Food | 1 | 1 |
| ClearView | 1 | 0 |
| Certifiable Inc. | 1 | 1 |

### Top-Performing Teams Prioritizing This Attribute

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| ArchColider | 1st | Farmacy Food | Modular Monolith, Event Sourcing |
| Software Architecture Guild | 3rd | Certifiable Inc. | microkernel (plug-in), service-based |
| Wonderous Toys | 3rd | Wildlife Watcher | Modular Monolith, Micro Kernel |
| AnimAI | Runner-up | Wildlife Watcher | Service-Based Architecture |
| Arch8s | Runner-up | Spotlight Platform | Hybrid: Modular Monolith + Service-Based + Serverless |
| Equi Hire Architects | Runner-up | ClearView | Service-Based Architecture |

### Evidence-Based Guidance

- Simplicity was cited almost exclusively by teams in non-profit or startup challenges, and correlated with pragmatic architecture choices.
- **Equihire Architects (Runner-up, ClearView)**: Explicitly chose service-based over microservices and event-driven because "cost and simplicity were the main characteristics which made the difference."
- **Architects++ (3rd, Farmacy Family)**: Partnership-over-build philosophy, choosing Facebook Groups, Eventbrite, and WordPress over custom development.
- **Pattern**: Simplicity as a stated priority led teams toward modular monolith, service-based, or buy-over-build decisions that reduced custom code surface area. It rarely appeared alongside microservices selections.

---
