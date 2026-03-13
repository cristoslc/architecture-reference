---
id: architecture-reference-repo-cvn.1
status: closed
deps: []
links: []
created: 2026-03-09T02:47:18Z
type: task
priority: 1
assignee: Cristos L-C
---
# Task 1: Create test infrastructure and catalog loader tests

**Files:**
- Create: `pipeline/tests/__init__.py`
- Create: `pipeline/tests/test_recompute_frequencies.py`
- Create: `pipeline/tests/fixtures/` (directory with sample YAML files)

**Step 1: Create test fixtures**

Create 6 minimal catalog YAML files that cover all combinations:

```bash
mkdir -p pipeline/tests/fixtures
```

`pipeline/tests/fixtures/prod-platform-1.yaml`:
```yaml
project_name: ProdPlatform1
scope: platform
use_type: production
architecture_styles:
  - Modular Monolith
  - Event-Driven
classification_status: classified
classification_confidence: 0.92
classification_method: deep-analysis-tooluse
domain: Infrastructure
language: Go
languages:
  - Go
```

`pipeline/tests/fixtures/prod-platform-2.yaml`:
```yaml
project_name: ProdPlatform2
scope: platform
use_type: production
architecture_styles:
  - Event-Driven
  - Pipe-and-Filter
classification_status: classified
classification_confidence: 0.88
classification_method: deep-analysis-tooluse
domain: Data Processing
language: Java/Kotlin
languages:
  - Java/Kotlin
```

`pipeline/tests/fixtures/prod-app-1.yaml`:
```yaml
project_name: ProdApp1
scope: application
use_type: production
architecture_styles:
  - Layered
  - Domain-Driven Design
classification_status: classified
classification_confidence: 0.85
classification_method: deep-analysis-subagent
domain: E-Commerce
language: Python
languages:
  - Python
```

`pipeline/tests/fixtures/prod-app-2.yaml`:
```yaml
project_name: ProdApp2
scope: application
use_type: production
architecture_styles:
  - Event-Driven
classification_status: classified
classification_confidence: 0.90
classification_method: deep-analysis-tooluse
domain: Messaging
language: TypeScript
languages:
  - TypeScript
```

`pipeline/tests/fixtures/ref-1.yaml`:
```yaml
project_name: RefImpl1
scope: platform
use_type: reference
architecture_styles:
  - Hexagonal Architecture
  - Domain-Driven Design
classification_status: classified
classification_confidence: 0.91
classification_method: deep-analysis-tooluse
domain: Education
language: C#
languages:
  - C#
```

`pipeline/tests/fixtures/_index.yaml`:
```yaml
generated: '2026-03-07'
total_projects: 5
```

**Step 2: Write failing tests for catalog loading and filtering**

`pipeline/tests/__init__.py`: (empty file)

`pipeline/tests/test_recompute_frequencies.py`:
```python
"""Tests for recompute-frequencies.py."""

import os
import sys

import pytest

# Add pipeline/ to path so we can import the module
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

FIXTURES_DIR = os.path.join(os.path.dirname(__file__), "fixtures")


class TestLoadCatalog:
    def test_loads_all_yaml_files(self):
        from recompute_frequencies import load_catalog
        entries = load_catalog(FIXTURES_DIR)
        # 5 .yaml files, but _index.yaml is skipped (starts with _)
        assert len(entries) == 5

    def test_skips_underscore_prefixed_files(self):
        from recompute_frequencies import load_catalog
        entries = load_catalog(FIXTURES_DIR)
        names = [e["project_name"] for e in entries]
        assert all(not n.startswith("_") for n in names)


class TestFilterProduction:
    def test_filters_to_production_only(self):
        from recompute_frequencies import load_catalog, filter_production
        entries = load_catalog(FIXTURES_DIR)
        prod = filter_production(entries)
        assert len(prod) == 4  # 4 production, 1 reference
        assert all(e["use_type"] == "production" for e in prod)

    def test_excludes_reference_entries(self):
        from recompute_frequencies import load_catalog, filter_production
        entries = load_catalog(FIXTURES_DIR)
        prod = filter_production(entries)
        names = [e["project_name"] for e in prod]
        assert "RefImpl1" not in names


class TestSplitByScope:
    def test_splits_platform_and_application(self):
        from recompute_frequencies import load_catalog, filter_production, split_by_scope
        prod = filter_production(load_catalo...


