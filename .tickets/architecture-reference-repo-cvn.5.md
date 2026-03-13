---
id: architecture-reference-repo-cvn.5
status: closed
deps: []
links: []
created: 2026-03-09T02:47:18Z
type: task
priority: 1
---
# Task 5: Parse existing source-analysis.md for "before" baseline

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


