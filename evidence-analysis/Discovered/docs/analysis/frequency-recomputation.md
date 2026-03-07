# SPEC-022: Frequency Recomputation Results

Generated: 2026-03-07
Catalog: 184 total entries (142 production, 42 reference)
Production split: 87 platforms, 55 applications
Method: Production-only entries, equal weighting per ADR-001

## Production Frequency Tables

### Combined Production (142 entries)

| Rank | Style | Count | % |
|------|-------|-------|---|
| 1 | Modular Monolith | 55 | 38.7% |
| 2 | Event-Driven | 47 | 33.1% |
| 3 | Indeterminate | 42 | 29.6% |
| 4 | Pipe-and-Filter | 33 | 23.2% |
| 5 | Plugin/Microkernel | 28 | 19.7% |
| 6 | Layered | 27 | 19.0% |
| 7 | Service-Based | 18 | 12.7% |
| 8 | Domain-Driven Design | 12 | 8.5% |
| 9 | CQRS | 10 | 7.0% |
| 10 | Microservices | 9 | 6.3% |
| 11 | Hexagonal Architecture | 5 | 3.5% |
| 12 | Space-Based | 5 | 3.5% |
| 13 | Multi-Agent | 3 | 2.1% |
| 14 | Serverless | 2 | 1.4% |

### Production Platforms (87 entries)

| Rank | Style | Count | % |
|------|-------|-------|---|
| 1 | Modular Monolith | 40 | 46.0% |
| 2 | Event-Driven | 31 | 35.6% |
| 3 | Plugin/Microkernel | 25 | 28.7% |
| 4 | Pipe-and-Filter | 25 | 28.7% |
| 5 | Indeterminate | 15 | 17.2% |
| 6 | Layered | 15 | 17.2% |
| 7 | Service-Based | 9 | 10.3% |
| 8 | Microservices | 8 | 9.2% |
| 9 | Space-Based | 5 | 5.7% |
| 10 | CQRS | 4 | 4.6% |
| 11 | Domain-Driven Design | 4 | 4.6% |
| 12 | Hexagonal Architecture | 4 | 4.6% |
| 13 | Multi-Agent | 2 | 2.3% |
| 14 | Serverless | 2 | 2.3% |

### Production Applications (55 entries)

| Rank | Style | Count | % |
|------|-------|-------|---|
| 1 | Indeterminate | 27 | 49.1% |
| 2 | Event-Driven | 16 | 29.1% |
| 3 | Modular Monolith | 15 | 27.3% |
| 4 | Layered | 12 | 21.8% |
| 5 | Service-Based | 9 | 16.4% |
| 6 | Domain-Driven Design | 8 | 14.5% |
| 7 | Pipe-and-Filter | 8 | 14.5% |
| 8 | CQRS | 6 | 10.9% |
| 9 | Plugin/Microkernel | 3 | 5.5% |
| 10 | Multi-Agent | 1 | 1.8% |
| 11 | Hexagonal Architecture | 1 | 1.8% |
| 12 | Microservices | 1 | 1.8% |

## Rank Changes

### Before/After Comparison

| Style | Old (163 all) | Old % | New (142 prod) | New % | Change |
|-------|---------------|-------|----------------|-------|--------|
| Modular Monolith | 60 | 37% | 55 | 38.7% | ↑ 1.7pp |
| Event-Driven | 78 | 48% | 47 | 33.1% | ↓ 14.9pp |
| Indeterminate | 20 | 12% | 42 | 29.6% | ↑ 17.6pp |
| Pipe-and-Filter | 42 | 26% | 33 | 23.2% | ↓ 2.8pp |
| Plugin/Microkernel | 5 | 3% | 28 | 19.7% | ↑ 16.7pp |
| Layered | 35 | 21% | 27 | 19.0% | ↓ 2.0pp |
| Service-Based | 19 | 12% | 18 | 12.7% | ↑ 0.7pp |
| Domain-Driven Design | 51 | 31% | 12 | 8.5% | ↓ 22.5pp |
| CQRS | 24 | 15% | 10 | 7.0% | ↓ 8.0pp |
| Microservices | 43 | 26% | 9 | 6.3% | ↓ 19.7pp |
| Hexagonal Architecture | 25 | 15% | 5 | 3.5% | ↓ 11.5pp |
| Space-Based | 4 | 2% | 5 | 3.5% | ↑ 1.5pp |
| Multi-Agent | 11 | 7% | 3 | 2.1% | ↓ 4.9pp |
| Serverless | 8 | 5% | 2 | 1.4% | ↓ 3.6pp |

## Key Observations

1. **Modular Monolith rises to #1** (38.7% vs old 37%) — the most common production pattern overall, driven by platforms that organize around module boundaries.

2. **Event-Driven drops from #1 to #2** (33.1% vs old 48%) — removing libraries and frameworks that inflated async messaging counts brings this pattern closer to actual production deployment frequency.

3. **Indeterminate is high at 29.6%** — 30 newly-added application entries have only heuristic classification. LLM review and deep-validation would resolve most of these, but that work is outside SPEC-022 scope (would be a follow-up classification campaign).

4. **Plugin/Microkernel remains significant in platforms** (28.7%) but drops to 5.5% in applications — confirming the hypothesis that this pattern is platform-dominated.

5. **Pipe-and-Filter splits similarly**: 28.7% of platforms vs 14.5% of applications — data processing platforms (Kafka, NiFi, Flink) drive this pattern.

6. **Application-specific patterns**: Applications show stronger Service-Based (16.4%), DDD (14.5%), and CQRS (10.9%) compared to platforms, supporting the hypothesis that application architects should see different frequency rankings than the overall catalog.

7. **Domain-Driven Design drops from 31% to 8.5%** in production-only — many DDD entries were reference implementations (removed in SPEC-020) or libraries. The remaining DDD signal is concentrated in applications (14.5% vs 4.6% platforms).

8. **Hexagonal Architecture drops from 15% to 3.5%** — most hexagonal entries were reference implementations demonstrating the pattern, not production systems using it.
