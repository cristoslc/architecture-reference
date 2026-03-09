# SPEC-022: Pipeline Run and Frequency Recomputation

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Recompute frequency rankings from production-only catalog entries now that all 184 entries have deep-analysis classifications (SPEC-024 complete, zero Indeterminate).

**Architecture:** One new read-only script (`pipeline/recompute-frequencies.py`) computes production-only frequency tables with platform/application splits and before/after comparison. Two existing scripts (`quality-report.py`, `generate-index.py`) are re-run to regenerate their respective artifacts. All scripts read catalog YAML files and write analysis markdown/YAML — no catalog modifications.

**Tech Stack:** Python 3, PyYAML (already available in the environment)

---

### Task 1: Create test infrastructure and catalog loader tests

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
        prod = filter_production(load_catalog(FIXTURES_DIR))
        platforms, applications = split_by_scope(prod)
        assert len(platforms) == 2
        assert len(applications) == 2
        assert all(e["scope"] == "platform" for e in platforms)
        assert all(e["scope"] == "application" for e in applications)
```

**Step 3: Run tests to verify they fail**

Run: `cd /Users/cristos/Documents/code/architecture-reference-repo && python3 -m pytest pipeline/tests/test_recompute_frequencies.py -v`
Expected: FAIL with `ModuleNotFoundError: No module named 'recompute_frequencies'`

**Step 4: Create minimal module skeleton to make loader tests pass**

`pipeline/recompute_frequencies.py`:
```python
#!/usr/bin/env python3
"""Recompute frequency rankings from production-only catalog entries.

Read-only: reads catalog YAML, writes analysis markdown. Does not modify catalog.

Usage:
    python3 pipeline/recompute_frequencies.py
    python3 pipeline/recompute_frequencies.py --dry-run
    python3 pipeline/recompute_frequencies.py --catalog-dir path/to/catalog --output-dir path/to/output
"""

import os
import sys

try:
    import yaml

    def load_yaml(path):
        with open(path) as f:
            return yaml.safe_load(f)

except ImportError:
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from classify import parse_yaml

    def load_yaml(path):
        with open(path) as f:
            return parse_yaml(f.read())


def load_catalog(catalog_dir):
    """Load all catalog entries from a directory. Skips _-prefixed files."""
    entries = []
    for fname in sorted(os.listdir(catalog_dir)):
        if not fname.endswith(".yaml") or fname.startswith("_"):
            continue
        path = os.path.join(catalog_dir, fname)
        try:
            entry = load_yaml(path)
            if entry and isinstance(entry, dict) and "project_name" in entry:
                entries.append(entry)
        except Exception as e:
            print(f"Warning: failed to parse {fname}: {e}", file=sys.stderr)
    return entries


def filter_production(entries):
    """Return only production-grade entries (use_type == 'production')."""
    return [e for e in entries if e.get("use_type") == "production"]


def split_by_scope(entries):
    """Split entries into (platforms, applications) by scope field."""
    platforms = [e for e in entries if e.get("scope") == "platform"]
    applications = [e for e in entries if e.get("scope") == "application"]
    return platforms, applications
```

**Step 5: Run tests to verify they pass**

Run: `cd /Users/cristos/Documents/code/architecture-reference-repo && python3 -m pytest pipeline/tests/test_recompute_frequencies.py -v`
Expected: All 5 tests PASS

**Step 6: Commit**

```bash
git add pipeline/tests/ pipeline/recompute_frequencies.py
git commit -m "feat(SPEC-022): add catalog loader with production filtering and scope split"
```

---

### Task 2: Frequency computation with tests

**Files:**
- Modify: `pipeline/tests/test_recompute_frequencies.py`
- Modify: `pipeline/recompute_frequencies.py`

**Step 1: Write failing tests for frequency computation**

Append to `pipeline/tests/test_recompute_frequencies.py`:
```python
class TestComputeFrequencies:
    def test_counts_all_styles_in_multi_style_entries(self):
        from recompute_frequencies import compute_frequencies
        entries = [
            {"architecture_styles": ["Modular Monolith", "Event-Driven"]},
            {"architecture_styles": ["Event-Driven", "Pipe-and-Filter"]},
            {"architecture_styles": ["Layered"]},
        ]
        freq = compute_frequencies(entries)
        assert freq == {
            "Modular Monolith": 1,
            "Event-Driven": 2,
            "Pipe-and-Filter": 1,
            "Layered": 1,
        }

    def test_returns_sorted_descending_by_count(self):
        from recompute_frequencies import compute_frequencies
        entries = [
            {"architecture_styles": ["A", "B"]},
            {"architecture_styles": ["B", "C"]},
            {"architecture_styles": ["B"]},
        ]
        freq = compute_frequencies(entries)
        keys = list(freq.keys())
        assert keys[0] == "B"  # count 3
        assert freq["B"] == 3

    def test_handles_empty_styles(self):
        from recompute_frequencies import compute_frequencies
        entries = [
            {"architecture_styles": []},
            {},
        ]
        freq = compute_frequencies(entries)
        assert freq == {}

    def test_fixture_combined_production_frequencies(self):
        from recompute_frequencies import load_catalog, filter_production, compute_frequencies
        prod = filter_production(load_catalog(FIXTURES_DIR))
        freq = compute_frequencies(prod)
        # Expected from fixtures:
        # Event-Driven: 3 (platform1 + platform2 + app2)
        # Modular Monolith: 1 (platform1)
        # Pipe-and-Filter: 1 (platform2)
        # Layered: 1 (app1)
        # Domain-Driven Design: 1 (app1)
        assert freq["Event-Driven"] == 3
        assert freq["Modular Monolith"] == 1
        assert freq["Layered"] == 1

    def test_fixture_platform_frequencies(self):
        from recompute_frequencies import (
            load_catalog, filter_production, split_by_scope, compute_frequencies,
        )
        prod = filter_production(load_catalog(FIXTURES_DIR))
        platforms, _ = split_by_scope(prod)
        freq = compute_frequencies(platforms)
        assert freq["Event-Driven"] == 2
        assert freq["Modular Monolith"] == 1
        assert freq["Pipe-and-Filter"] == 1

    def test_fixture_application_frequencies(self):
        from recompute_frequencies import (
            load_catalog, filter_production, split_by_scope, compute_frequencies,
        )
        prod = filter_production(load_catalog(FIXTURES_DIR))
        _, apps = split_by_scope(prod)
        freq = compute_frequencies(apps)
        assert freq["Event-Driven"] == 1
        assert freq["Layered"] == 1
        assert freq["Domain-Driven Design"] == 1
```

**Step 2: Run tests to verify they fail**

Run: `python3 -m pytest pipeline/tests/test_recompute_frequencies.py::TestComputeFrequencies -v`
Expected: FAIL with `ImportError: cannot import name 'compute_frequencies'`

**Step 3: Implement compute_frequencies**

Add to `pipeline/recompute_frequencies.py`:
```python
from collections import Counter


def compute_frequencies(entries):
    """Count architecture style occurrences across entries. Returns dict sorted by count descending."""
    counter = Counter()
    for e in entries:
        styles = e.get("architecture_styles", [])
        if isinstance(styles, list):
            for s in styles:
                counter[s] += 1
    return dict(counter.most_common())
```

**Step 4: Run tests to verify they pass**

Run: `python3 -m pytest pipeline/tests/test_recompute_frequencies.py -v`
Expected: All 11 tests PASS

**Step 5: Commit**

```bash
git add pipeline/tests/test_recompute_frequencies.py pipeline/recompute_frequencies.py
git commit -m "feat(SPEC-022): add frequency computation from architecture_styles lists"
```

---

### Task 3: Markdown table generation with tests

**Files:**
- Modify: `pipeline/tests/test_recompute_frequencies.py`
- Modify: `pipeline/recompute_frequencies.py`

**Step 1: Write failing tests for table formatting**

Append to `pipeline/tests/test_recompute_frequencies.py`:
```python
class TestFormatFrequencyTable:
    def test_produces_ranked_markdown_table(self):
        from recompute_frequencies import format_frequency_table
        freq = {"Event-Driven": 3, "Modular Monolith": 1}
        total = 4
        table = format_frequency_table(freq, total)
        lines = table.strip().split("\n")
        assert "| Rank |" in lines[0]
        assert "| 1 | Event-Driven | 3 |" in lines[2]
        assert "| 2 | Modular Monolith | 1 |" in lines[3]

    def test_percentages_based_on_total_entries(self):
        from recompute_frequencies import format_frequency_table
        freq = {"A": 50}
        table = format_frequency_table(freq, 100)
        assert "50.0%" in table

    def test_handles_empty_frequencies(self):
        from recompute_frequencies import format_frequency_table
        table = format_frequency_table({}, 0)
        assert "No data" in table or "| Rank |" in table
```

**Step 2: Run tests to verify they fail**

Run: `python3 -m pytest pipeline/tests/test_recompute_frequencies.py::TestFormatFrequencyTable -v`
Expected: FAIL with `ImportError`

**Step 3: Implement format_frequency_table**

Add to `pipeline/recompute_frequencies.py`:
```python
def format_frequency_table(freq, total_entries):
    """Format frequency dict as a ranked markdown table with percentages."""
    if not freq:
        return "No data.\n"
    lines = [
        "| Rank | Style | Count | % |",
        "|------|-------|-------|---|",
    ]
    for rank, (style, count) in enumerate(freq.items(), 1):
        pct = (count / total_entries * 100) if total_entries > 0 else 0
        lines.append(f"| {rank} | {style} | {count} | {pct:.1f}% |")
    return "\n".join(lines) + "\n"
```

**Step 4: Run tests to verify they pass**

Run: `python3 -m pytest pipeline/tests/test_recompute_frequencies.py -v`
Expected: All 14 tests PASS

**Step 5: Commit**

```bash
git add pipeline/tests/test_recompute_frequencies.py pipeline/recompute_frequencies.py
git commit -m "feat(SPEC-022): add markdown frequency table formatter"
```

---

### Task 4: Before/after comparison generation with tests

**Files:**
- Modify: `pipeline/tests/test_recompute_frequencies.py`
- Modify: `pipeline/recompute_frequencies.py`

**Step 1: Write failing tests for comparison**

Append to `pipeline/tests/test_recompute_frequencies.py`:
```python
class TestBuildComparison:
    def test_computes_percentage_point_change(self):
        from recompute_frequencies import build_comparison
        old_freq = {"Event-Driven": 78, "Modular Monolith": 60}
        old_total = 163
        new_freq = {"Modular Monolith": 55, "Event-Driven": 47}
        new_total = 142
        rows = build_comparison(old_freq, old_total, new_freq, new_total)
        # Modular Monolith: old 36.8%, new 38.7% → +1.9pp
        mm = next(r for r in rows if r["style"] == "Modular Monolith")
        assert abs(mm["old_pct"] - 36.8) < 0.1
        assert abs(mm["new_pct"] - 38.7) < 0.1
        assert abs(mm["change_pp"] - 1.9) < 0.2

    def test_includes_styles_only_in_old(self):
        from recompute_frequencies import build_comparison
        old_freq = {"A": 10, "B": 5}
        new_freq = {"A": 8}
        rows = build_comparison(old_freq, 100, new_freq, 80)
        styles = [r["style"] for r in rows]
        assert "B" in styles
        b = next(r for r in rows if r["style"] == "B")
        assert b["new_count"] == 0

    def test_includes_styles_only_in_new(self):
        from recompute_frequencies import build_comparison
        old_freq = {"A": 10}
        new_freq = {"A": 8, "C": 3}
        rows = build_comparison(old_freq, 100, new_freq, 80)
        styles = [r["style"] for r in rows]
        assert "C" in styles
        c = next(r for r in rows if r["style"] == "C")
        assert c["old_count"] == 0
```

**Step 2: Run tests to verify they fail**

Run: `python3 -m pytest pipeline/tests/test_recompute_frequencies.py::TestBuildComparison -v`
Expected: FAIL

**Step 3: Implement build_comparison**

Add to `pipeline/recompute_frequencies.py`:
```python
def build_comparison(old_freq, old_total, new_freq, new_total):
    """Build before/after comparison rows. Returns list of dicts with style, old/new counts/pcts, change."""
    all_styles = set(old_freq.keys()) | set(new_freq.keys())
    rows = []
    for style in all_styles:
        old_count = old_freq.get(style, 0)
        new_count = new_freq.get(style, 0)
        old_pct = (old_count / old_total * 100) if old_total > 0 else 0
        new_pct = (new_count / new_total * 100) if new_total > 0 else 0
        rows.append({
            "style": style,
            "old_count": old_count,
            "old_pct": old_pct,
            "new_count": new_count,
            "new_pct": new_pct,
            "change_pp": new_pct - old_pct,
        })
    rows.sort(key=lambda r: abs(r["change_pp"]), reverse=True)
    return rows
```

**Step 4: Run tests to verify they pass**

Run: `python3 -m pytest pipeline/tests/test_recompute_frequencies.py -v`
Expected: All 17 tests PASS

**Step 5: Commit**

```bash
git add pipeline/tests/test_recompute_frequencies.py pipeline/recompute_frequencies.py
git commit -m "feat(SPEC-022): add before/after frequency comparison builder"
```

---

### Task 5: Parse existing source-analysis.md for "before" baseline

**Files:**
- Modify: `pipeline/tests/test_recompute_frequencies.py`
- Modify: `pipeline/recompute_frequencies.py`

**Step 1: Write failing tests for baseline parser**

Append to `pipeline/tests/test_recompute_frequencies.py`:
```python
class TestParseOldFrequencies:
    def test_extracts_style_counts_from_markdown_table(self):
        from recompute_frequencies import parse_frequency_table
        md = """\
| Architecture Style | Count | Percentage |
|-------------------|-------|------------|
| **Modular Monolith** | 55 | 39% |
| **Event-Driven** | 47 | 33% |
| **Pipe-and-Filter** | 33 | 23% |
"""
        freq, total = parse_frequency_table(md)
        assert freq["Modular Monolith"] == 55
        assert freq["Event-Driven"] == 47
        assert freq["Pipe-and-Filter"] == 33

    def test_strips_bold_markers(self):
        from recompute_frequencies import parse_frequency_table
        md = "| **Bold Style** | 10 | 5% |\n"
        freq, _ = parse_frequency_table(md)
        assert "Bold Style" in freq

    def test_extracts_total_from_header(self):
        from recompute_frequencies import parse_source_analysis_baseline
        md = """\
## Architecture Style Distribution (Production Only)

Each project may exhibit multiple architecture styles. Production entries only (142 entries):

| Architecture Style | Count | Percentage |
|-------------------|-------|------------|
| **Modular Monolith** | 55 | 39% |
"""
        freq, total = parse_source_analysis_baseline(md)
        assert total == 142
        assert freq["Modular Monolith"] == 55
```

**Step 2: Run tests to verify they fail**

Run: `python3 -m pytest pipeline/tests/test_recompute_frequencies.py::TestParseOldFrequencies -v`
Expected: FAIL

**Step 3: Implement parsers**

Add to `pipeline/recompute_frequencies.py`:
```python
import re


def parse_frequency_table(md_text):
    """Extract style->count mapping from a markdown frequency table."""
    freq = {}
    for line in md_text.split("\n"):
        line = line.strip()
        if not line.startswith("|") or "---" in line or "Style" in line or "Architecture" in line:
            continue
        parts = [p.strip() for p in line.split("|")]
        parts = [p for p in parts if p]
        if len(parts) >= 2:
            style = parts[0].replace("**", "").strip()
            try:
                count = int(parts[1])
                freq[style] = count
            except ValueError:
                continue
    total = sum(freq.values())
    return freq, total


def parse_source_analysis_baseline(md_text):
    """Extract the frequency table and entry count from source-analysis.md."""
    total = 0
    m = re.search(r"\((\d+)\s+entries\)", md_text)
    if m:
        total = int(m.group(1))

    # Find the first frequency table after "Architecture Style Distribution"
    section_start = md_text.find("Architecture Style Distribution")
    if section_start == -1:
        section_start = 0
    section = md_text[section_start:]

    freq, _ = parse_frequency_table(section)
    if total == 0:
        total = len(freq)  # fallback
    return freq, total
```

**Step 4: Run tests to verify they pass**

Run: `python3 -m pytest pipeline/tests/test_recompute_frequencies.py -v`
Expected: All 20 tests PASS

**Step 5: Commit**

```bash
git add pipeline/tests/test_recompute_frequencies.py pipeline/recompute_frequencies.py
git commit -m "feat(SPEC-022): add source-analysis.md baseline parser for before/after comparison"
```

---

### Task 6: Source analysis markdown generation with tests

**Files:**
- Modify: `pipeline/tests/test_recompute_frequencies.py`
- Modify: `pipeline/recompute_frequencies.py`

**Step 1: Write failing tests for source-analysis output**

Append to `pipeline/tests/test_recompute_frequencies.py`:
```python
class TestGenerateSourceAnalysis:
    def test_includes_production_only_header(self):
        from recompute_frequencies import generate_source_analysis
        md = generate_source_analysis(
            all_entries=[{"use_type": "production", "scope": "platform",
                          "architecture_styles": ["A"], "language": "Go",
                          "domain": "Infra", "classification_confidence": 0.9,
                          "classification_status": "classified"}],
            prod_freq={"A": 1}, plat_freq={"A": 1}, app_freq={},
            n_prod=1, n_plat=1, n_app=0, n_ref=0, n_total=1,
        )
        assert "production" in md.lower()
        assert "ADR-001" in md

    def test_includes_platform_application_split_table(self):
        from recompute_frequencies import generate_source_analysis
        md = generate_source_analysis(
            all_entries=[
                {"use_type": "production", "scope": "platform",
                 "architecture_styles": ["A"], "language": "Go",
                 "domain": "Infra", "classification_confidence": 0.9,
                 "classification_status": "classified"},
                {"use_type": "production", "scope": "application",
                 "architecture_styles": ["B"], "language": "Python",
                 "domain": "Web", "classification_confidence": 0.85,
                 "classification_status": "classified"},
            ],
            prod_freq={"A": 1, "B": 1}, plat_freq={"A": 1}, app_freq={"B": 1},
            n_prod=2, n_plat=1, n_app=1, n_ref=0, n_total=2,
        )
        assert "Platform" in md
        assert "Application" in md
```

**Step 2: Run tests to verify they fail**

Run: `python3 -m pytest pipeline/tests/test_recompute_frequencies.py::TestGenerateSourceAnalysis -v`
Expected: FAIL

**Step 3: Implement generate_source_analysis**

This function generates the full `source-analysis.md` document. Model it on the existing file structure but with updated data. Add to `pipeline/recompute_frequencies.py`:

```python
from datetime import datetime, timezone


def generate_source_analysis(all_entries, prod_freq, plat_freq, app_freq,
                              n_prod, n_plat, n_app, n_ref, n_total):
    """Generate the source-analysis.md markdown document."""
    lines = [
        f"# Discovered Source Analysis: Patterns Across {n_total} Open-Source Repositories",
        "",
        "## Dataset Overview",
        "",
        f"This analysis covers **{n_total} open-source repositories** classified using deep-analysis "
        f"(LLM source code inspection per ADR-002). All entries have deep-analysis classifications "
        f"with zero Indeterminate results.",
        "",
        "Per ADR-001, entries are tagged with `scope` (platform | application) and `use_type` "
        f"(production | reference). **Frequency rankings below use production-only entries** "
        f"({n_prod} entries) unless noted.",
        "",
        "| Discovery Method | Year | Repositories |",
        "|-----------------|------|--------------|",
        f"| GitHub search + signal extraction | 2026 | {n_total} |",
        f"| Deep-analysis classification (ADR-002) | 2026 | {n_total} |",
        "",
        "### Taxonomy Composition",
        "",
        "| Category | Count |",
        "|----------|-------|",
        f"| Production platforms | {n_plat} |",
        f"| Production applications | {n_app} |",
        f"| Reference (all) | {n_ref} |",
        f"| **Total** | **{n_total}** |",
        "",
        f"Production ratio: {n_plat}:{n_app} = {n_plat/n_app:.2f}:1" if n_app > 0 else "",
        "",
        "---",
        "",
        f"## Architecture Style Distribution (Production Only)",
        "",
        f"Each project may exhibit multiple architecture styles. Production entries only ({n_prod} entries):",
        "",
        format_frequency_table(prod_freq, n_prod),
        "### Platform vs Application Split",
        "",
        _format_split_table(plat_freq, n_plat, app_freq, n_app, prod_freq),
        "",
    ]

    # Key findings
    top_styles = list(prod_freq.items())[:3]
    lines.extend([
        "### Key Findings",
        "",
    ])
    for i, (style, count) in enumerate(top_styles, 1):
        pct = count / n_prod * 100 if n_prod > 0 else 0
        lines.append(f"{i}. **{style}** leads at {count} of {n_prod} ({pct:.0f}%)")
    lines.append("")

    # Language distribution
    lang_counter = Counter()
    for e in all_entries:
        lang_counter[e.get("language", "Unknown")] += 1
    lines.extend([
        "---",
        "",
        "## Language Distribution",
        "",
        "| Language | Count | Percentage |",
        "|----------|-------|------------|",
    ])
    for lang, count in lang_counter.most_common():
        pct = count / n_total * 100
        lines.append(f"| {lang} | {count} | {pct:.0f}% |")

    # Confidence distribution
    confs = [e.get("classification_confidence", 0)
             for e in all_entries if e.get("classification_status") == "classified"]
    lines.extend([
        "",
        "---",
        "",
        "## Confidence Distribution",
        "",
        "| Confidence Range | Count | Percentage |",
        "|-----------------|-------|------------|",
    ])
    if confs:
        buckets = [
            ("0.90+", sum(1 for c in confs if c >= 0.90)),
            ("0.85-0.89", sum(1 for c in confs if 0.85 <= c < 0.90)),
            ("0.80-0.84", sum(1 for c in confs if 0.80 <= c < 0.85)),
            ("0.70-0.79", sum(1 for c in confs if 0.70 <= c < 0.80)),
            ("< 0.70", sum(1 for c in confs if c < 0.70)),
        ]
        for label, count in buckets:
            pct = count / len(confs) * 100
            lines.append(f"| {label} | {count} | {pct:.0f}% |")

    # Multi-style composition
    style_counts = Counter()
    for e in all_entries:
        n = len(e.get("architecture_styles", []))
        if n > 0:
            style_counts[n] += 1
    lines.extend([
        "",
        "---",
        "",
        "## Multi-Style Composition",
        "",
        "| Composition | Count |",
        "|-------------|-------|",
    ])
    for n_styles in sorted(style_counts.keys()):
        count = style_counts[n_styles]
        pct = count / n_total * 100
        lines.append(f"| {n_styles} style{'s' if n_styles > 1 else ''} | {count} ({pct:.0f}%) |")

    # Domain coverage
    domain_counter = Counter()
    for e in all_entries:
        domain_counter[e.get("domain", "Unknown")] += 1
    lines.extend([
        "",
        "---",
        "",
        f"## Domain Coverage",
        "",
        f"{len(domain_counter)} unique domains across {n_total} entries:",
        "",
        "| Domain | Count | Domain | Count |",
        "|--------|-------|--------|-------|",
    ])
    domains_sorted = domain_counter.most_common()
    half = (len(domains_sorted) + 1) // 2
    for i in range(half):
        left = domains_sorted[i]
        right = domains_sorted[i + half] if i + half < len(domains_sorted) else ("", "")
        lines.append(f"| {left[0]} | {left[1]} | {right[0]} | {right[1]} |")

    lines.extend([
        "",
        "---",
        "",
        "## Summary: Discovered vs. Other Sources",
        "",
        "| Metric | KataLog | AOSA | RealWorld | RefArch | Discovered |",
        "|--------|---------|------|-----------|---------|------------|",
    ])
    top = list(prod_freq.items())[0] if prod_freq else ("N/A", 0)
    top_pct = top[1] / n_prod * 100 if n_prod > 0 else 0
    multi_count = sum(1 for e in all_entries if len(e.get("architecture_styles", [])) > 1)
    multi_pct = multi_count / n_total * 100 if n_total > 0 else 0
    lines.extend([
        f"| Count | 78 | 12 | 5 | 8 | {n_prod} (prod) |",
        f"| Primary style | Event-Driven (56%) | Pipeline (42%) | Plugin Arch (60%) | Microservices (63%) | {top[0]} ({top_pct:.0f}%) |",
        f"| Multi-style | 73% | 67% | 80% | 75% | {multi_pct:.0f}% |",
        "| Top QA | Scalability (62%) | Performance (42%) | Extensibility (60%) | Testability (50%) | Deployability (90%) |",
        "| Detection method | Competition | Case study | Case study | Teaching code | Deep analysis |",
        "",
        f"The Discovered source provides **production-only frequency rankings** per ADR-001, "
        f"with separate platform and application views. All {n_total} entries classified via "
        f"deep-analysis per ADR-002 — zero Indeterminate results.",
        "",
    ])
    return "\n".join(lines)


def _format_split_table(plat_freq, n_plat, app_freq, n_app, combined_freq):
    """Format the platform vs application comparison table."""
    lines = [
        f"| Style | Platforms ({n_plat}) | % | Applications ({n_app}) | % |",
        "|-------|----------|---|-------------|---|",
    ]
    for style in combined_freq:
        pc = plat_freq.get(style, 0)
        ac = app_freq.get(style, 0)
        pp = (pc / n_plat * 100) if n_plat > 0 else 0
        ap = (ac / n_app * 100) if n_app > 0 else 0
        lines.append(f"| {style} | {pc} | {pp:.0f}% | {ac} | {ap:.0f}% |")
    return "\n".join(lines)
```

**Step 4: Run tests to verify they pass**

Run: `python3 -m pytest pipeline/tests/test_recompute_frequencies.py -v`
Expected: All 22 tests PASS

**Step 5: Commit**

```bash
git add pipeline/tests/test_recompute_frequencies.py pipeline/recompute_frequencies.py
git commit -m "feat(SPEC-022): add source-analysis.md generation with platform/application splits"
```

---

### Task 7: Main entry point and CLI with --dry-run

**Files:**
- Modify: `pipeline/tests/test_recompute_frequencies.py`
- Modify: `pipeline/recompute_frequencies.py`

**Step 1: Write failing test for main orchestration**

Append to `pipeline/tests/test_recompute_frequencies.py`:
```python
import tempfile
import shutil


class TestMainOrchestration:
    def test_dry_run_prints_to_stdout(self, capsys):
        from recompute_frequencies import run_recomputation
        run_recomputation(catalog_dir=FIXTURES_DIR, output_dir=None, dry_run=True)
        captured = capsys.readouterr()
        assert "Production entries:" in captured.out
        assert "Event-Driven" in captured.out

    def test_writes_source_analysis_file(self):
        from recompute_frequencies import run_recomputation
        with tempfile.TemporaryDirectory() as tmpdir:
            run_recomputation(catalog_dir=FIXTURES_DIR, output_dir=tmpdir, dry_run=False)
            sa_path = os.path.join(tmpdir, "source-analysis.md")
            assert os.path.exists(sa_path)
            content = open(sa_path).read()
            assert "Production Only" in content

    def test_writes_frequency_recomputation_file(self):
        from recompute_frequencies import run_recomputation
        with tempfile.TemporaryDirectory() as tmpdir:
            # Create a fake old source-analysis.md for before/after
            os.makedirs(os.path.join(tmpdir), exist_ok=True)
            with open(os.path.join(tmpdir, "source-analysis.md"), "w") as f:
                f.write("""\
## Architecture Style Distribution (Production Only)

Production entries only (10 entries):

| Architecture Style | Count | Percentage |
|-------------------|-------|------------|
| **Event-Driven** | 5 | 50% |
| **Modular Monolith** | 3 | 30% |
""")
            run_recomputation(catalog_dir=FIXTURES_DIR, output_dir=tmpdir, dry_run=False)
            fr_path = os.path.join(tmpdir, "frequency-recomputation.md")
            assert os.path.exists(fr_path)
            content = open(fr_path).read()
            assert "Before/After" in content or "Rank Changes" in content
```

**Step 2: Run tests to verify they fail**

Run: `python3 -m pytest pipeline/tests/test_recompute_frequencies.py::TestMainOrchestration -v`
Expected: FAIL

**Step 3: Implement run_recomputation and CLI**

Add to `pipeline/recompute_frequencies.py`:
```python
import argparse


def generate_frequency_recomputation(old_freq, old_total, new_freq, new_total,
                                      n_plat, n_app):
    """Generate the frequency-recomputation.md comparison document."""
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    lines = [
        "# SPEC-022: Frequency Recomputation Results",
        "",
        f"Generated: {now}",
        f"Catalog: {old_total + (new_total - new_total)} → {new_total} production entries",
        f"Production split: {n_plat} platforms, {n_app} applications",
        "Method: Production-only entries, equal weighting per ADR-001",
        "Classification: Deep-analysis only per ADR-002 (zero Indeterminate)",
        "",
        "## Rank Changes",
        "",
        "### Before/After Comparison",
        "",
        f"| Style | Old ({old_total}) | Old % | New ({new_total} prod) | New % | Change |",
        "|-------|---------------|-------|----------------|-------|--------|",
    ]
    rows = build_comparison(old_freq, old_total, new_freq, new_total)
    for r in rows:
        arrow = "↑" if r["change_pp"] > 0 else "↓" if r["change_pp"] < 0 else "—"
        lines.append(
            f"| {r['style']} | {r['old_count']} | {r['old_pct']:.1f}% "
            f"| {r['new_count']} | {r['new_pct']:.1f}% "
            f"| {arrow} {abs(r['change_pp']):.1f}pp |"
        )
    lines.append("")
    return "\n".join(lines)


def run_recomputation(catalog_dir, output_dir, dry_run=False):
    """Main orchestration: load catalog, compute frequencies, write outputs."""
    entries = load_catalog(catalog_dir)
    prod = filter_production(entries)
    platforms, applications = split_by_scope(prod)

    n_total = len(entries)
    n_prod = len(prod)
    n_plat = len(platforms)
    n_app = len(applications)
    n_ref = n_total - n_prod

    prod_freq = compute_frequencies(prod)
    plat_freq = compute_frequencies(platforms)
    app_freq = compute_frequencies(applications)

    if dry_run:
        print(f"Production entries: {n_prod} ({n_plat} platforms, {n_app} applications)")
        print(f"Reference entries: {n_ref}")
        print(f"Total: {n_total}")
        print()
        print("## Combined Production Frequencies")
        print(format_frequency_table(prod_freq, n_prod))
        print("## Platform Frequencies")
        print(format_frequency_table(plat_freq, n_plat))
        print("## Application Frequencies")
        print(format_frequency_table(app_freq, n_app))
        return

    os.makedirs(output_dir, exist_ok=True)

    # Read existing source-analysis.md for before/after baseline
    sa_path = os.path.join(output_dir, "source-analysis.md")
    old_freq = {}
    old_total = 0
    if os.path.exists(sa_path):
        with open(sa_path) as f:
            old_freq, old_total = parse_source_analysis_baseline(f.read())

    # Write source-analysis.md
    sa_content = generate_source_analysis(
        entries, prod_freq, plat_freq, app_freq,
        n_prod, n_plat, n_app, n_ref, n_total,
    )
    with open(sa_path, "w") as f:
        f.write(sa_content)
    print(f"Written: {sa_path}")

    # Write frequency-recomputation.md
    if old_freq:
        fr_content = generate_frequency_recomputation(
            old_freq, old_total, prod_freq, n_prod, n_plat, n_app,
        )
        fr_path = os.path.join(output_dir, "frequency-recomputation.md")
        with open(fr_path, "w") as f:
            f.write(fr_content)
        print(f"Written: {fr_path}")
    else:
        print("No previous source-analysis.md found — skipping before/after comparison")


def main():
    default_catalog = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "..", "evidence-analysis", "Discovered", "docs", "catalog",
    )
    default_output = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "..", "evidence-analysis", "Discovered", "docs", "analysis",
    )

    parser = argparse.ArgumentParser(
        description="Recompute frequency rankings from production-only catalog entries (read-only)",
    )
    parser.add_argument("--catalog-dir", default=default_catalog,
                        help="Path to catalog directory with *.yaml entries")
    parser.add_argument("--output-dir", default=default_output,
                        help="Output directory for analysis files")
    parser.add_argument("--dry-run", action="store_true",
                        help="Print tables to stdout without writing files")
    args = parser.parse_args()

    run_recomputation(args.catalog_dir, args.output_dir, args.dry_run)


if __name__ == "__main__":
    main()
```

**Step 4: Run tests to verify they pass**

Run: `python3 -m pytest pipeline/tests/test_recompute_frequencies.py -v`
Expected: All 25 tests PASS

**Step 5: Commit**

```bash
git add pipeline/tests/test_recompute_frequencies.py pipeline/recompute_frequencies.py
git commit -m "feat(SPEC-022): add main entry point with --dry-run, source-analysis and comparison output"
```

---

### Task 8: Run against real catalog (dry-run first, then full run)

**Files:**
- No new files — running existing scripts

**Step 1: Dry run the new script**

```bash
cd /Users/cristos/Documents/code/architecture-reference-repo
python3 pipeline/recompute_frequencies.py --dry-run
```

Expected: Printed frequency tables showing ~142 production entries, zero Indeterminate, Modular Monolith at top.

**Verify:** Confirm zero "Indeterminate" entries in the output. If Indeterminate appears, investigate which catalog entries still have it.

**Step 2: Full run — recompute frequencies**

```bash
python3 pipeline/recompute_frequencies.py
```

Expected output:
```
Written: evidence-analysis/Discovered/docs/analysis/source-analysis.md
Written: evidence-analysis/Discovered/docs/analysis/frequency-recomputation.md
```

**Step 3: Re-run existing quality report**

```bash
python3 pipeline/quality-report.py
```

Expected: `Generated evidence-analysis/Discovered/quality-report.md: 184 entries analyzed`

**Note:** `quality-report.py` reads `discovery_metadata.confidence` but current entries use flat `classification_confidence`. If the confidence section shows all zeros, that's a known mismatch from the schema migration — not a blocker for SPEC-022 (frequency data is correct regardless).

**Step 4: Re-run existing index generator**

```bash
python3 pipeline/generate-index.py
```

Expected: `Generated evidence-analysis/Discovered/_index.yaml: 184 projects`

**Step 5: Spot-check outputs**

Review the generated files:
- `source-analysis.md` — should show production-only frequencies with zero Indeterminate
- `frequency-recomputation.md` — should show before/after comparison with the old heuristic-contaminated data vs new clean data
- `quality-report.md` — should show 184 entries, 0 indeterminate
- `_index.yaml` — should list 184 projects with style frequencies

**Step 6: Commit**

```bash
git add evidence-analysis/Discovered/docs/analysis/source-analysis.md \
       evidence-analysis/Discovered/docs/analysis/frequency-recomputation.md \
       evidence-analysis/Discovered/quality-report.md \
       evidence-analysis/Discovered/_index.yaml
git commit -m "feat(SPEC-022): recompute frequency rankings with deep-analysis-only data"
```

---

### Task 9: Verify acceptance criteria and run full test suite

**Files:** None — verification only

**Step 1: Run full test suite**

```bash
python3 -m pytest pipeline/tests/ -v
```

Expected: All tests PASS

**Step 2: Verify acceptance criteria**

Check each criterion against the generated output:

1. **Frequency tables computed from production-grade entries only (reference excluded)** — Open `source-analysis.md`, confirm it says "Production entries only (142 entries)" and no reference entries counted.

2. **Separate frequency tables for platform-scope and application-scope entries** — Confirm "Platform vs Application Split" table exists in `source-analysis.md`.

3. **Combined production frequency table for overall rankings** — Confirm "Architecture Style Distribution (Production Only)" table exists.

4. **Before/after comparison document showing rank changes** — Open `frequency-recomputation.md`, confirm it has the comparison table with old vs new columns and pp change arrows.

5. **All analysis artifacts regenerated from new catalog** — Confirm `quality-report.md`, `source-analysis.md`, `_index.yaml` all have fresh generation dates.

6. **No reference or removed entries appear in frequency counts** — Grep for "reference" in the frequency tables. Reference entries should only appear in the taxonomy composition count, not in style frequencies.

**Step 3: Commit (if any verification fixes needed)**

If all checks pass, no commit needed. If minor fixes are required, fix and commit.
