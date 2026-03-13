---
id: architecture-reference-repo-cvn.3
status: closed
deps: []
links: []
created: 2026-03-09T02:47:18Z
type: task
priority: 1
assignee: Cristos L-C
---
# Task 3: Markdown table generation with tests

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


