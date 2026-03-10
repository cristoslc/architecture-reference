#!/usr/bin/env python3
"""Validate architecture_qualifiers and architecture_styles against style-taxonomy.yaml.

Checks that:
1. All architecture_styles values are in the canonical topology vocabulary
2. All architecture_qualifiers have valid type and value per the taxonomy
3. Flags entries still using pattern names (CQRS, DDD, Hexagonal) as styles

Usage:
    python3 scripts/normalize-qualifiers.py                    # validate (default)
    python3 scripts/normalize-qualifiers.py --catalog-dir path # custom catalog path
    python3 scripts/normalize-qualifiers.py --taxonomy path    # custom taxonomy path
"""

import argparse
import os
import sys

import yaml


def load_taxonomy(taxonomy_path):
    """Load style-taxonomy.yaml and return styles dict and qualifier_types dict."""
    with open(taxonomy_path) as f:
        data = yaml.safe_load(f)

    styles = set(data.get("styles", {}).keys())

    # Also collect aliases as valid style names (they'll be normalized separately)
    aliases = {}
    for style_name, style_info in data.get("styles", {}).items():
        for alias in style_info.get("aliases", []):
            aliases[alias] = style_name

    qualifier_types = {}
    for qtype, qinfo in data.get("qualifier_types", {}).items():
        qualifier_types[qtype] = set(qinfo.get("values", []))

    return styles, aliases, qualifier_types


# Pattern names that were moved to qualifiers per ADR-006.
RECLASSIFIED_PATTERNS = {
    "CQRS": "data-pattern:cqrs",
    "Domain-Driven Design": "design-approach:ddd",
    "Hexagonal Architecture": "design-approach:hexagonal",
}


def validate_entry(path, canonical_styles, aliases, qualifier_types):
    """Validate a single catalog YAML file. Returns list of findings."""
    with open(path) as f:
        data = yaml.safe_load(f)

    if not data:
        return []

    findings = []
    project = data.get("project_name", os.path.basename(path))

    # 1. Validate architecture_styles
    styles = data.get("architecture_styles", [])
    if styles:
        for style in styles:
            if style in RECLASSIFIED_PATTERNS:
                qualifier = RECLASSIFIED_PATTERNS[style]
                findings.append(
                    f"  PATTERN-AS-STYLE: '{style}' should be a qualifier "
                    f"({qualifier}) per ADR-006"
                )
            elif style in aliases:
                findings.append(
                    f"  ALIAS: '{style}' → '{aliases[style]}' "
                    f"(run normalize-styles.py --apply)"
                )
            elif style not in canonical_styles:
                findings.append(
                    f"  UNKNOWN-STYLE: '{style}' not in style-taxonomy.yaml"
                )

    # 2. Validate architecture_qualifiers
    qualifiers = data.get("architecture_qualifiers", [])
    if qualifiers:
        for i, q in enumerate(qualifiers):
            if not isinstance(q, dict):
                findings.append(f"  QUALIFIER[{i}]: not a dict")
                continue

            qtype = q.get("type")
            qvalue = q.get("value")

            if not qtype:
                findings.append(f"  QUALIFIER[{i}]: missing 'type' field")
            elif qtype not in qualifier_types:
                findings.append(
                    f"  QUALIFIER[{i}]: unknown type '{qtype}' "
                    f"(valid: {', '.join(sorted(qualifier_types.keys()))})"
                )
            else:
                if not qvalue:
                    findings.append(
                        f"  QUALIFIER[{i}]: missing 'value' field"
                    )
                elif qvalue not in qualifier_types[qtype]:
                    valid = ", ".join(sorted(qualifier_types[qtype]))
                    findings.append(
                        f"  QUALIFIER[{i}]: unknown value '{qvalue}' "
                        f"for type '{qtype}' (valid: {valid})"
                    )

    # 3. Validate ecosystem-specific fields
    scope = data.get("scope")
    if scope == "ecosystem":
        if not data.get("member_repos"):
            findings.append("  ECOSYSTEM: missing 'member_repos' field")
        if not data.get("emergent_architecture"):
            findings.append("  ECOSYSTEM: missing 'emergent_architecture' field")
        if not data.get("composition_pattern"):
            findings.append("  ECOSYSTEM: missing 'composition_pattern' field")

    if findings:
        findings.insert(0, f"{project} ({os.path.basename(path)}):")

    return findings


def main():
    default_catalog = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "..", "evidence-analysis", "Discovered", "docs", "catalog",
    )
    default_taxonomy = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "..", "evidence-analysis", "style-taxonomy.yaml",
    )

    parser = argparse.ArgumentParser(
        description="Validate architecture_qualifiers and styles against taxonomy",
    )
    parser.add_argument("--catalog-dir", default=default_catalog,
                        help="Path to catalog directory")
    parser.add_argument("--taxonomy", default=default_taxonomy,
                        help="Path to style-taxonomy.yaml")
    args = parser.parse_args()

    canonical_styles, aliases, qualifier_types = load_taxonomy(args.taxonomy)

    all_findings = []
    files_checked = 0
    files_with_findings = 0

    for fname in sorted(os.listdir(args.catalog_dir)):
        if not fname.endswith(".yaml") or fname.startswith("_") or fname == "SCHEMA.yaml":
            continue
        path = os.path.join(args.catalog_dir, fname)
        findings = validate_entry(path, canonical_styles, aliases, qualifier_types)
        files_checked += 1
        if findings:
            files_with_findings += 1
            all_findings.extend(findings)

    if all_findings:
        print("\n".join(all_findings))
        print(f"\n{files_with_findings}/{files_checked} files have findings")
        sys.exit(1)
    else:
        print(f"OK: {files_checked} files validated, no findings")
        sys.exit(0)


if __name__ == "__main__":
    main()
