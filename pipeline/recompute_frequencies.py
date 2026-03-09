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
