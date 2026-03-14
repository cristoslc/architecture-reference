#!/usr/bin/env python3
"""Validate a constraint baseline YAML file against the JSON Schema.

Usage: python3 scripts/validate-baseline.py <baseline.yaml> [--schema <schema.json>]

Exit codes:
  0 — valid
  1 — validation errors found
  2 — usage error
"""

import argparse
import json
import sys
from pathlib import Path

import jsonschema
import yaml


def main():
    parser = argparse.ArgumentParser(description="Validate a constraint baseline YAML file")
    parser.add_argument("baseline", type=Path, help="Path to the baseline YAML file")
    parser.add_argument(
        "--schema",
        type=Path,
        default=Path(__file__).parent.parent / "skills/architecture-advisor/references/constraint-baseline.schema.json",
        help="Path to the JSON Schema file",
    )
    args = parser.parse_args()

    if not args.baseline.exists():
        print(f"Error: baseline file not found: {args.baseline}", file=sys.stderr)
        sys.exit(2)

    if not args.schema.exists():
        print(f"Error: schema file not found: {args.schema}", file=sys.stderr)
        sys.exit(2)

    schema = json.loads(args.schema.read_text())
    baseline = yaml.safe_load(args.baseline.read_text())

    validator = jsonschema.Draft202012Validator(schema)
    errors = sorted(validator.iter_errors(baseline), key=lambda e: list(e.path))

    if errors:
        print(f"Validation failed for {args.baseline.name}:")
        for error in errors:
            path = ".".join(str(p) for p in error.absolute_path) or "(root)"
            print(f"  {path}: {error.message}")
        sys.exit(1)

    print(f"OK: {args.baseline.name} is valid")
    sys.exit(0)


if __name__ == "__main__":
    main()
