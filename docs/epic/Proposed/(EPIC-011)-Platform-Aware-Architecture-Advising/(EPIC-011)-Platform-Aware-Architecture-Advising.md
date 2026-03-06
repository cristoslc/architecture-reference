---
title: "Platform-Aware Architecture Advising"
artifact: EPIC-011
status: Proposed
author: cristos
created: 2026-03-06
last-updated: 2026-03-06
parent-vision: VISION-001
success-criteria:
  - Architecture advisor skill detects whether the user's context is application-centric or platform/ecosystem-centric early in the conversation
  - Guidance, trade-off analysis, and style recommendations adapt based on the detected context
  - Platform-centric advice covers composition patterns (Pipe-and-Filter, Service-Based, Sidecar) and cross-repo concerns (API contracts, shared schemas, deployment topology)
  - Application-centric advice covers internal structure patterns (Layered, Hexagonal, Modular Monolith, Plugin/Microkernel) and single-repo concerns (module boundaries, dependency direction, package organization)
  - Reference library documents are consumable at both scales — the advisor can pull ecosystem evidence for platform questions and single-repo evidence for application questions
depends-on:
  - EPIC-002
  - EPIC-010
  - SPIKE-001
---

# Platform-Aware Architecture Advising

## Goal / Objective

Enhance the architecture-advisor skill to distinguish between platform/ecosystem architecture concerns and application architecture concerns, providing contextually appropriate guidance at each scale.

## The Problem

The current architecture-advisor skill treats every query as an application-level concern. When a user asks "what architecture should I use?", the skill recommends styles based on single-repo evidence — Layered, Modular Monolith, Hexagonal, etc. But if the user is building a *platform* (a composition of independently-developed services like the ELK stack, Grafana LGTM, or a media automation stack), the relevant patterns are different:

| Concern | Application-centric | Platform-centric |
|---------|-------------------|-----------------|
| Primary styles | Layered, Modular Monolith, Hexagonal, Plugin/Microkernel | Service-Based, Pipe-and-Filter, Event-Driven, Sidecar |
| Key trade-off | Coupling vs. cohesion within a codebase | Autonomy vs. coordination across repos |
| Deployment | Single deployable (possibly with plugins) | Multiple independently deployable components |
| Communication | In-process (function calls, DI) | Inter-process (HTTP, gRPC, message queues, shared storage) |
| Boundary definition | Module/package/layer boundaries | API contracts, shared schemas, protocol specs |
| Evidence source | Single-repo catalog (163 repos) | Ecosystem catalog (EPIC-010) + single-repo |

### Why this matters

1. **Wrong advice is worse than no advice.** Recommending Hexagonal Architecture to someone building a multi-service data pipeline is unhelpful — it's the right pattern at the wrong scale.

2. **The evidence exists at both scales.** Once EPIC-010 adds ecosystem entries, the advisor has evidence for platform-level patterns. But without context detection, it can't surface the right evidence.

3. **Many real-world systems span both scales.** A platform architect needs to think about both the ecosystem composition *and* the internal architecture of each member service. The advisor should support this layered thinking.

## Scope Boundaries

### In scope

- Context detection: conversational probing to determine if the user's concern is application-level, platform-level, or both
- Adaptive guidance: style recommendations, trade-off analysis, and decision paths that differ by context
- Dual-scale evidence surfacing: pulling from both single-repo and ecosystem catalogs as appropriate
- Skill prompt updates: modifying the architecture-advisor skill's system prompts and progressive disclosure to support both contexts

### Out of scope

- Building the ecosystem catalog (that's EPIC-010)
- Statistical modeling of ecosystem entries (that's SPIKE-001)
- Taxonomy expansion (that's SPIKE-002)
- Runtime topology analysis or deployment automation

## Child Specs

| ID | Title | Status | Focus |
|----|-------|--------|-------|
| — | TBD: Context Detection Prompts | — | Conversational probes to detect application vs. platform context |
| — | TBD: Dual-Scale Evidence Retrieval | — | Skill data-fetching updates to serve both single-repo and ecosystem evidence |
| — | TBD: Platform Architecture Decision Paths | — | New decision navigator paths for platform/ecosystem patterns |

## Key Dependencies

- **EPIC-002** (Complete): Provides the architecture-advisor skill as baseline
- **EPIC-010** (Proposed): Provides ecosystem-level evidence to power platform-centric advice
- **SPIKE-001** (Planned): Resolves how ecosystem evidence is weighted and presented — the advisor needs clear statistical data

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-06 | — | Initial creation; enhances advisor skill with platform/application context awareness |
