#!/usr/bin/env bash
# calibrate-confidence.sh — Post-hoc confidence calibration from reasoning text
#
# Reads classification_reasoning from catalog entries and uses a second LLM
# (Sonnet) to assess actual confidence by analyzing the reasoning for hedging,
# alternative styles considered, evidence strength, and discriminating signals.
#
# This implements the SPIKE-005 pivot: since Gemini assigns uniform 0.95-ish
# confidence regardless of prompting, we extract meaningful confidence from
# the reasoning text via a separate model pass.
#
# Usage:
#   pipeline/calibrate-confidence.sh [OPTIONS]
#
# Options:
#   --model <ID>       Calibration model (default: openrouter/anthropic/claude-sonnet-4-6)
#   --catalog <PATH>   Catalog directory
#   --limit <N>        Process at most N entries
#   --offset <N>       Skip first N entries
#   --dry-run          Show entries without processing
#   --verbose          Detailed output

set -uo pipefail

MODEL="openrouter/anthropic/claude-sonnet-4.6"
CATALOG_DIR="evidence-analysis/Discovered/docs/catalog"
LIMIT=0
OFFSET=0
DRY_RUN=false
VERBOSE=false

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORTS_DIR="${SCRIPT_DIR}/reports"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --model)     MODEL="$2"; shift 2 ;;
    --catalog)   CATALOG_DIR="$2"; shift 2 ;;
    --limit)     LIMIT="$2"; shift 2 ;;
    --offset)    OFFSET="$2"; shift 2 ;;
    --dry-run)   DRY_RUN=true; shift ;;
    --verbose)   VERBOSE=true; shift ;;
    -h|--help)   head -20 "$0" | grep '^#' | sed 's/^# \?//'; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if ! command -v llm &>/dev/null; then
  echo "Error: 'llm' CLI not found" >&2; exit 1
fi

mkdir -p "$REPORTS_DIR"

log() { echo "[$(date +%H:%M:%S)] $*" >&2; }
verbose() { [[ "$VERBOSE" == "true" ]] && log "$*" || true; }

CALIBRATION_PROMPT='You are a confidence calibration expert. You will read an LLM'\''s architectural classification reasoning and assess how confident the classification actually is, based on textual signals — NOT the self-reported confidence number.

Score the reasoning on these dimensions (each 0.0-1.0):

1. **evidence_strength** — How specific are the cited file paths, directory structures, and code patterns? Vague references ("it looks like") score low; exact paths and config values score high.
2. **style_clarity** — How clearly does one primary style dominate? If the reasoning struggles between two equally plausible primary styles, score low. If one style clearly wins with strong signals, score high.
3. **alternatives_dismissed** — Are alternative styles explicitly considered and rejected with reasons? More alternatives dismissed with evidence = higher score. No mention of alternatives = lower score (may indicate shallow analysis).
4. **exploration_completeness** — Did the analysis examine enough of the codebase? References to only README = low. References to multiple source directories, configs, and build files = high.

Respond with ONLY this YAML (no prose, no explanation):

---
evidence_strength: <0.0-1.0>
style_clarity: <0.0-1.0>
alternatives_dismissed: <0.0-1.0>
exploration_completeness: <0.0-1.0>
adjusted_confidence: <weighted average: 0.30*evidence + 0.30*clarity + 0.20*alternatives + 0.20*exploration>
flags: <"none" or brief note if something looks wrong, e.g. "primary style may be wrong — reasoning describes Plugin but classified as Layered">
---'

# ── Process entries ──────────────────────────────────────────────────────────
scan_entries() {
  local entries=()
  for yaml_file in "$CATALOG_DIR"/*.yaml; do
    [[ -f "$yaml_file" ]] || continue
    if grep -q "^classification_status: classified" "$yaml_file"; then
      entries+=("$yaml_file")
    fi
  done
  printf '%s\n' "${entries[@]}"
}

parse_calibration() {
  local response="$1"
  echo "$response" | python3 -c "
import sys, re, yaml, json
text = sys.stdin.read()
result = {}
m = re.search(r'(?:^|\n)\s*---\s*\n(.*?)\n\s*---', text, re.DOTALL)
if m:
    try:
        d = yaml.safe_load(m.group(1))
        if isinstance(d, dict):
            result = d
    except: pass
if not result:
    # Try bare YAML (no --- delimiters)
    try:
        d = yaml.safe_load(text)
        if isinstance(d, dict) and 'adjusted_confidence' in d:
            result = d
    except: pass
json.dump(result, sys.stdout)
" 2>/dev/null
}

process_entry() {
  local yaml_file="$1"
  local project_name reasoning original_conf

  project_name=$(python3 -c "
import yaml, sys
with open('$yaml_file') as f:
    d = yaml.safe_load(f)
print(d.get('project_name','unknown'))
" 2>/dev/null)

  reasoning=$(python3 -c "
import yaml, sys
with open('$yaml_file') as f:
    d = yaml.safe_load(f)
r = d.get('classification_reasoning', '')
if not r:
    r = d.get('review_notes', '')
# Truncate to 3000 chars to manage context
print(str(r)[:3000])
" 2>/dev/null)

  original_conf=$(python3 -c "
import yaml, sys
with open('$yaml_file') as f:
    d = yaml.safe_load(f)
print(d.get('classification_confidence', d.get('discovery_metadata',{}).get('confidence', 0)))
" 2>/dev/null)

  local styles
  styles=$(python3 -c "
import yaml, sys
with open('$yaml_file') as f:
    d = yaml.safe_load(f)
print(', '.join(d.get('architecture_styles', [])))
" 2>/dev/null)

  if [[ -z "$reasoning" || "$reasoning" == "None" ]]; then
    verbose "  $project_name: no reasoning text, skipping"
    echo "{\"project\":\"$project_name\",\"skipped\":true}"
    return
  fi

  verbose "  $project_name: sending reasoning to calibration model..."

  local context="## Classification being evaluated

**Project:** $project_name
**Classified as:** $styles
**Self-reported confidence:** $original_conf

## Reasoning text to evaluate

$reasoning"

  local response
  response=$(echo "$context" | llm -m "$MODEL" -s "$CALIBRATION_PROMPT" 2>/dev/null || echo "ERROR")

  local parsed
  parsed=$(parse_calibration "$response")

  if [[ -z "$parsed" || "$parsed" == "{}" ]]; then
    log "  $project_name: calibration parse failed"
    echo "{\"project\":\"$project_name\",\"error\":\"parse_failed\"}"
    return
  fi

  local adjusted flags
  adjusted=$(echo "$parsed" | python3 -c "import sys,json; print(json.load(sys.stdin).get('adjusted_confidence',0))" 2>/dev/null)
  flags=$(echo "$parsed" | python3 -c "import sys,json; print(json.load(sys.stdin).get('flags','none'))" 2>/dev/null)

  # Update the catalog entry
  python3 -c "
import yaml, sys

with open('$yaml_file') as f:
    d = yaml.safe_load(f)

d['classification_confidence'] = float($adjusted)
d['confidence_calibration'] = {
    'original_confidence': float($original_conf),
    'calibrated_confidence': float($adjusted),
    'calibration_model': '$MODEL',
}

# Parse dimension scores
import json
cal = json.loads('''$parsed''')
for key in ['evidence_strength', 'style_clarity', 'alternatives_dismissed', 'exploration_completeness']:
    if key in cal:
        d['confidence_calibration'][key] = float(cal[key])

flags = '''$flags'''
if flags and flags != 'none':
    d['confidence_calibration']['flags'] = flags

with open('$yaml_file', 'w') as f:
    yaml.dump(d, f, default_flow_style=False, sort_keys=False, allow_unicode=True)
" 2>/dev/null

  local delta
  delta=$(python3 -c "print(f'{float($adjusted) - float($original_conf):+.2f}')" 2>/dev/null)

  log "  $project_name: $original_conf → $adjusted ($delta) ${flags:+[$flags]}"

  echo "{\"project\":\"$project_name\",\"original\":$original_conf,\"adjusted\":$adjusted,\"delta\":$delta,\"flags\":\"$flags\"}"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  log "Confidence Calibration Pipeline"
  log "  Model: $MODEL"
  log "  Catalog: $CATALOG_DIR"

  local entries_list
  entries_list=$(scan_entries)

  if [[ -z "$entries_list" ]]; then
    log "No classified entries found."
    exit 0
  fi

  local total_count
  total_count=$(echo "$entries_list" | wc -l | tr -d ' ')
  log "Found $total_count classified entries"

  # Apply offset/limit
  if [[ $OFFSET -gt 0 ]]; then
    entries_list=$(echo "$entries_list" | tail -n +$((OFFSET + 1)))
  fi
  local entry_count
  entry_count=$(echo "$entries_list" | wc -l | tr -d ' ')
  if [[ $LIMIT -gt 0 && $entry_count -gt $LIMIT ]]; then
    entries_list=$(echo "$entries_list" | head -"$LIMIT")
    entry_count=$LIMIT
    log "Limited to $LIMIT entries"
  fi

  if [[ "$DRY_RUN" == "true" ]]; then
    log "Entries that would be calibrated:"
    echo "$entries_list" | while read -r entry; do
      local name
      name=$(grep "^project_name:" "$entry" | awk '{print $2}')
      echo "  $name — $entry"
    done
    exit 0
  fi

  local results=()
  local processed=0 adjusted_count=0 skipped=0 errors=0

  while IFS= read -r entry; do
    processed=$((processed + 1))
    log "[$processed/$entry_count]"

    local result
    result=$(process_entry "$entry")
    results+=("$result")

    # Progress every 10
    if (( processed % 10 == 0 )); then
      log "Progress: $processed/$entry_count processed"
    fi
  done <<< "$entries_list"

  # Summary stats
  python3 -c "
import json, sys

results = []
for line in '''$(printf '%s\n' "${results[@]}")'''.strip().split('\n'):
    if line.strip():
        try:
            results.append(json.loads(line))
        except: pass

adjusted = [r for r in results if 'adjusted' in r]
skipped = [r for r in results if r.get('skipped')]
errors = [r for r in results if r.get('error')]
flagged = [r for r in adjusted if r.get('flags','none') != 'none']

if adjusted:
    deltas = [r['adjusted'] - r['original'] for r in adjusted]
    print(f'Calibrated: {len(adjusted)}')
    print(f'Skipped: {len(skipped)}')
    print(f'Errors: {len(errors)}')
    print(f'Flagged: {len(flagged)}')
    print(f'Mean delta: {sum(deltas)/len(deltas):+.3f}')
    print(f'Confidence range: {min(r[\"adjusted\"] for r in adjusted):.2f} - {max(r[\"adjusted\"] for r in adjusted):.2f}')
    print(f'Spread: {max(r[\"adjusted\"] for r in adjusted) - min(r[\"adjusted\"] for r in adjusted):.2f}')
    if flagged:
        print()
        print('Flagged entries:')
        for r in flagged:
            print(f'  {r[\"project\"]}: {r[\"flags\"]}')
" >&2

  log ""
  log "Calibration complete."
}

main "$@"
