#!/usr/bin/env python3
"""Load and normalize catalog entries from all evidence sources.

Scans catalog YAML files from Discovered, AOSA, ReferenceArchitectures,
and RealWorldASPNET evidence sources. Normalizes each entry to a common
CatalogEntry dataclass for use by the similarity scorer.

Excludes TheKataLog (team-centric, different schema).

Usage:
    from catalog_loader import load_catalog
    entries = load_catalog("/path/to/architecture-reference")
"""

import os
import sys
from dataclasses import dataclass, field

try:
    import yaml
except ImportError:
    print("Error: PyYAML required. Install with: uv pip install pyyaml", file=sys.stderr)
    sys.exit(1)


@dataclass
class CatalogEntry:
    """Normalized projection of a catalog entry for comparison."""

    project_name: str
    architecture_styles: list[str] = field(default_factory=list)
    domain: str = "Unknown"
    scope: str = "application"
    use_type: str = "production"
    quality_attributes: list[str] = field(default_factory=list)
    classification_confidence: float = 1.0
    source: str = ""
    source_url: str = ""
    one_line_summary: str = ""


# Evidence source directories relative to repo root, with their catalog subdirs.
EVIDENCE_SOURCES = [
    {
        "name": "Discovered",
        "catalog_path": "evidence-analysis/Discovered/docs/catalog",
    },
    {
        "name": "AOSA",
        "catalog_path": "evidence-analysis/AOSA/docs/catalog",
    },
    {
        "name": "ReferenceArchitectures",
        "catalog_path": "evidence-analysis/ReferenceArchitectures/docs/catalog",
    },
    {
        "name": "RealWorldASPNET",
        "catalog_path": "evidence-analysis/RealWorldASPNET/docs/catalog",
    },
]

# Files to skip when loading catalog entries.
SKIP_FILES = {"_index.yaml", "SCHEMA.yaml"}


def _normalize_entry(raw: dict, source_name: str) -> CatalogEntry | None:
    """Normalize a raw YAML dict to a CatalogEntry.

    Handles schema differences across sources:
    - Discovered entries follow catalog-schema.yaml strictly.
    - Other sources have additional fields (github_stars_approx,
      notable_strengths, etc.) but share core fields.
    - Entries without classification_confidence are treated as
      confidence 1.0 (human-validated reference entries).
    """
    if not raw or not isinstance(raw, dict):
        return None

    project_name = raw.get("project_name", "")
    if not project_name:
        return None

    # Architecture styles — always a list, primary first.
    styles = raw.get("architecture_styles", [])
    if not isinstance(styles, list):
        styles = [str(styles)] if styles else []

    # Domain — string.
    domain = raw.get("domain", "Unknown")
    if not isinstance(domain, str):
        domain = str(domain)

    # Scope — default to "application" if missing.
    scope = raw.get("scope", "application")

    # Use-type — infer from evidence_type for non-Discovered sources.
    use_type = raw.get("use_type", "")
    if not use_type:
        evidence_type = raw.get("evidence_type", "")
        if evidence_type == "reference-implementation":
            use_type = "reference"
        else:
            use_type = "production"

    # Quality attributes — always a list of strings.
    # Some entries have QAs as dicts (e.g., {"name": "Scalability", ...}
    # or {"Extensibility": "description"}). Normalize to plain strings.
    qa_raw = raw.get("quality_attributes", [])
    if not isinstance(qa_raw, list):
        qa_raw = []
    qa = []
    for item in qa_raw:
        if isinstance(item, str):
            qa.append(item)
        elif isinstance(item, dict):
            # Try "name" key first, then use first key as the attribute name.
            name = item.get("name")
            if name:
                qa.append(str(name))
            else:
                keys = list(item.keys())
                if keys:
                    qa.append(str(keys[0]))
        else:
            qa.append(str(item))

    # Classification confidence — default 1.0 for human-validated entries.
    confidence = raw.get("classification_confidence")
    if confidence is None:
        confidence = 1.0
    try:
        confidence = float(confidence)
    except (TypeError, ValueError):
        confidence = 1.0

    # Source URL — try source_url then project_url.
    source_url = raw.get("source_url", "") or raw.get("project_url", "")

    # One-line summary.
    summary = raw.get("one_line_summary", "")

    # Source — use the raw field if present, otherwise the directory source name.
    source = raw.get("source", source_name)

    return CatalogEntry(
        project_name=project_name,
        architecture_styles=styles,
        domain=domain,
        scope=scope,
        use_type=use_type,
        quality_attributes=qa,
        classification_confidence=confidence,
        source=source,
        source_url=source_url,
        one_line_summary=summary,
    )


def load_catalog(repo_root: str) -> list[CatalogEntry]:
    """Load all catalog entries from all evidence sources.

    Args:
        repo_root: Path to the architecture-reference repository root.

    Returns:
        List of normalized CatalogEntry objects.
    """
    entries = []

    for source_info in EVIDENCE_SOURCES:
        catalog_dir = os.path.join(repo_root, source_info["catalog_path"])

        if not os.path.isdir(catalog_dir):
            print(
                f"Warning: catalog directory not found: {catalog_dir}",
                file=sys.stderr,
            )
            continue

        for fname in sorted(os.listdir(catalog_dir)):
            if not fname.endswith(".yaml") or fname in SKIP_FILES:
                continue

            fpath = os.path.join(catalog_dir, fname)
            try:
                with open(fpath) as f:
                    raw = yaml.safe_load(f)
            except Exception as e:
                print(
                    f"Warning: failed to parse {fpath}: {e}",
                    file=sys.stderr,
                )
                continue

            entry = _normalize_entry(raw, source_info["name"])
            if entry is not None:
                entries.append(entry)

    return entries


def load_catalog_as_dicts(repo_root: str) -> list[dict]:
    """Load catalog and return as list of dicts (for template rendering).

    Convenience wrapper around load_catalog that converts dataclass
    instances to dicts.
    """
    from dataclasses import asdict

    return [asdict(e) for e in load_catalog(repo_root)]


if __name__ == "__main__":
    # Quick test: load catalog from repo root and print summary.
    import argparse

    parser = argparse.ArgumentParser(description="Load and summarize catalog entries")
    parser.add_argument(
        "--repo-root",
        default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."),
        help="Path to architecture-reference repo root",
    )
    args = parser.parse_args()

    entries = load_catalog(args.repo_root)
    print(f"Loaded {len(entries)} catalog entries")

    # Group by source.
    by_source: dict[str, int] = {}
    for e in entries:
        by_source[e.source] = by_source.get(e.source, 0) + 1
    for source, count in sorted(by_source.items()):
        print(f"  {source}: {count}")
