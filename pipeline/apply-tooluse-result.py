#!/usr/bin/env python3
"""Parse a GLM-5 tool-calling classification result and apply it to a catalog YAML entry.

Usage:
    python3 pipeline/apply-tooluse-result.py \
      --result pipeline/reports/glm5-results/AFFiNE.txt \
      --entry evidence-analysis/Discovered/docs/catalog/AFFiNE.yaml \
      --model openrouter/z-ai/glm-5
"""

import argparse
import os
import re
import sys
from datetime import datetime, timezone

try:
    import yaml
except ImportError:
    print("Error: PyYAML required", file=sys.stderr)
    sys.exit(1)


def parse_result(result_path):
    """Parse YAML frontmatter + reasoning from a classification result file."""
    with open(result_path) as f:
        text = f.read()

    if not text.strip():
        return None, "empty result file"

    # Extract YAML frontmatter containing verdict/primary_style.
    # The model's intermediate text may contain stray '---' lines, so we
    # collect ALL ---...--- blocks (strict then relaxed) and pick the one
    # with 'verdict:'.
    blocks = list(re.finditer(r'(?:^|\n)\s*---\s*\n(.*?)\n\s*---', text, re.DOTALL))
    # Also try relaxed regex (--- may appear inline after tool output text)
    blocks += list(re.finditer(r'---\s*\n(.*?)\n\s*---', text, re.DOTALL))
    if not blocks:
        return None, "no YAML frontmatter found"

    d = None
    m = None
    for candidate in blocks:
        body = candidate.group(1)
        if 'verdict' not in body:
            continue
        try:
            parsed = yaml.safe_load(body)
        except Exception:
            continue
        if isinstance(parsed, dict) and parsed.get("verdict"):
            d = parsed
            m = candidate
            break

    if d is None:
        return None, "no YAML frontmatter with verdict found"

    verdict = d.get("verdict", "")
    if verdict != "classified":
        return None, f"verdict is '{verdict}', not 'classified'"

    primary = d.get("primary_style", "")
    if not primary:
        return None, "no primary_style in frontmatter"

    secondary = d.get("secondary_styles", [])
    if secondary is None:
        secondary = []

    confidence = d.get("confidence", 0)

    # Extract reasoning (everything after the closing --- of the matched block)
    reasoning = ""
    if m:
        reasoning = text[m.end():].strip()

    # Cap reasoning at 5000 chars
    if len(reasoning) > 5000:
        reasoning = reasoning[:5000] + "\n\n[truncated]"

    return {
        "primary_style": primary,
        "secondary_styles": secondary,
        "confidence": float(confidence),
        "reasoning": reasoning,
    }, None


def apply_to_entry(entry_path, parsed, model):
    """Apply parsed classification to a catalog YAML entry."""
    with open(entry_path) as f:
        entry = yaml.safe_load(f)

    if not entry or not isinstance(entry, dict):
        return False, f"could not parse {entry_path}"

    # Build styles list
    styles = [parsed["primary_style"]]
    for s in parsed.get("secondary_styles", []):
        if s and s not in styles:
            styles.append(s)

    entry["architecture_styles"] = styles
    entry["classification_status"] = "classified"
    entry["classification_method"] = "deep-analysis-tooluse"
    entry["classification_confidence"] = parsed["confidence"]
    entry["classification_model"] = model
    entry["classification_date"] = datetime.now(timezone.utc).strftime(
        "%Y-%m-%dT%H:%M:%SZ"
    )
    entry["classification_reasoning"] = parsed["reasoning"]

    # Remove old calibration data (no longer needed with GLM-5)
    entry.pop("confidence_calibration", None)

    # Clear review_required if classified
    if styles and styles[0] != "Indeterminate":
        entry["review_required"] = False

    with open(entry_path, "w") as f:
        yaml.dump(entry, f, default_flow_style=False, sort_keys=False, allow_unicode=True)

    project = entry.get("project_name", os.path.basename(entry_path))
    style_str = ", ".join(styles)
    print(f"Updated {project}: {style_str} (confidence={parsed['confidence']})")
    return True, None


def main():
    parser = argparse.ArgumentParser(
        description="Apply GLM-5 tool-calling classification result to catalog YAML"
    )
    parser.add_argument("--result", required=True, help="Path to result text file")
    parser.add_argument("--entry", required=True, help="Path to catalog YAML file")
    parser.add_argument(
        "--model", default="openrouter/z-ai/glm-5", help="Model identifier"
    )
    args = parser.parse_args()

    if not os.path.exists(args.result):
        print(f"Error: result file not found: {args.result}", file=sys.stderr)
        sys.exit(1)

    if not os.path.exists(args.entry):
        print(f"Error: entry file not found: {args.entry}", file=sys.stderr)
        sys.exit(1)

    parsed, err = parse_result(args.result)
    if err:
        print(f"Parse error: {err}", file=sys.stderr)
        sys.exit(1)

    ok, err = apply_to_entry(args.entry, parsed, args.model)
    if not ok:
        print(f"Apply error: {err}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
