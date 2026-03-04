#!/usr/bin/env bash
# validate-review.sh — Validate LLM classification accuracy against gold standard
#
# Usage:
#   pipeline/validate-review.sh [OPTIONS]
#
# Options:
#   --gold-standard <PATH>  Gold standard YAML (default: pipeline/gold-standard/gold-standard.yaml)
#   --catalog <PATH>        Catalog directory (default: evidence-analysis/Discovered/docs/catalog)
#   --run-report <PATH>     Run report JSON (for spot-check mode)
#   --spot-check <N>        Randomly sample N classified entries for manual review
#   --output <PATH>         Output report path (default: pipeline/reports/validation-<timestamp>.json)
#   --verbose               Show detailed comparison

set -euo pipefail

GOLD_STANDARD="pipeline/gold-standard/gold-standard.yaml"
CATALOG_DIR="evidence-analysis/Discovered/docs/catalog"
RUN_REPORT=""
SPOT_CHECK=0
OUTPUT=""
VERBOSE=false

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --gold-standard) GOLD_STANDARD="$2"; shift 2 ;;
    --catalog)       CATALOG_DIR="$2"; shift 2 ;;
    --run-report)    RUN_REPORT="$2"; shift 2 ;;
    --spot-check)    SPOT_CHECK="$2"; shift 2 ;;
    --output)        OUTPUT="$2"; shift 2 ;;
    --verbose)       VERBOSE=true; shift ;;
    -h|--help)       head -12 "$0" | grep '^#' | sed 's/^# \?//'; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [[ ! -f "$GOLD_STANDARD" ]]; then
  echo "Error: gold standard not found: $GOLD_STANDARD" >&2
  exit 1
fi

mkdir -p "${SCRIPT_DIR}/reports"
[[ -z "$OUTPUT" ]] && OUTPUT="${SCRIPT_DIR}/reports/validation-$(date +%Y%m%d-%H%M%S).json"

# Run the validation via Python
export GOLD_STANDARD CATALOG_DIR OUTPUT VERBOSE RUN_REPORT SPOT_CHECK

exec python3 "${SCRIPT_DIR}/validate-review.py" \
  --gold-standard "$GOLD_STANDARD" \
  --catalog "$CATALOG_DIR" \
  --output "$OUTPUT" \
  ${VERBOSE:+--verbose} \
  ${RUN_REPORT:+--run-report "$RUN_REPORT"} \
  ${SPOT_CHECK:+--spot-check "$SPOT_CHECK"}
