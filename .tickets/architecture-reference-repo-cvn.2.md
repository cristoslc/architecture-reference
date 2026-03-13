---
id: architecture-reference-repo-cvn.2
status: closed
deps: []
links: []
created: 2026-03-09T02:47:18Z
type: task
priority: 1
assignee: Cristos L-C
---
# Task 2: Frequency computation with tests

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
git add pipeline/test...


