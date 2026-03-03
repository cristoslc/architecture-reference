# Architecture Overview

_Supporting document for [VISION-001](./\(VISION-001\)-Evidence-Based-Architecture-Decision-Platform.md)_

## System Shape

The Architecture Reference Platform is organized into three layers: **evidence collection**, **reference library**, and **delivery**.

### Evidence Collection Layer

Raw data from multiple sources, cataloged into structured YAML entries.

```
evidence-analysis/
  TheKataLog/          78 team submissions from 11 O'Reilly Kata seasons
  AOSA/                12 production open-source systems (Architecture of Open Source Applications)
  RealWorldASPNET/     5 production .NET applications
  ReferenceArchitectures/  8 curated reference implementations

evidence-pool/         Full team submission artifacts (ADRs, diagrams, transcripts)
```

Each evidence source has its own `docs/catalog/` (YAML per project) and `docs/analysis/` (comparative write-ups). A shared `_index.yaml` schema enables cross-source querying.

### Reference Library Layer

Derived, human-readable analysis synthesized from the evidence base.

```
docs/reference-library/
  problem-spaces.md          11 challenges classified across 10 dimensions
  solution-spaces.md         12 architecture styles with placement-weighted scores
  problem-solution-matrix.md  Mappings from problem dimensions to proven solutions
  decision-navigator.md      Step-by-step questionnaire leading to recommendations
  evidence/                  Per-style and per-attribute evidence tables
```

The reference library is the primary interface for human users. Every claim is traceable back to specific YAML catalog entries.

### Delivery Layer

How users access the platform's knowledge.

| Channel | Mechanism | Status |
|---------|-----------|--------|
| Direct reading | `docs/reference-library/` in the repo | Active |
| Architecture advisor skill | Remote-installable agent skill with sparse-clone data fetching | Planned (EPIC-002) |
| Architecture discovery skill | Repo analysis tool producing catalog entries | Planned (EPIC-001, Phase 2) |

## Data Flow

```
Sources (Katas, AOSA, etc.)
    |
    v
YAML Catalogs (evidence-analysis/*/docs/catalog/*.yaml)
    |
    v
Analysis Documents (evidence-analysis/*/docs/analysis/)
    |
    v
Reference Library (docs/reference-library/)
    |
    v
Delivery (direct reading, agent skills)
```

## Key Design Decisions

Architectural decisions are documented as ADRs. See `docs/adr/` (to be created as decisions arise).
