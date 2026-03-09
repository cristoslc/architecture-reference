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
