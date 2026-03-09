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
from collections import Counter

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


def compute_frequencies(entries):
    """Count architecture style occurrences across entries. Returns dict sorted by count descending."""
    counter = Counter()
    for e in entries:
        styles = e.get("architecture_styles", [])
        if isinstance(styles, list):
            for s in styles:
                counter[s] += 1
    return dict(counter.most_common())


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


def build_comparison(old_freq, old_total, new_freq, new_total):
    """Build before/after comparison rows. Returns list of dicts sorted by absolute change."""
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
