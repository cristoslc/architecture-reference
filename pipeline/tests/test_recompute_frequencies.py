"""Tests for recompute_frequencies.py."""

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
