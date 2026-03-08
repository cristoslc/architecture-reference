#!/usr/bin/env bash
# run-evaluation.sh — SPIKE-005 confidence calibration evaluation
# Forked from SPIKE-004/run-evaluation.sh, adapted for prompt variants.
#
# Usage:
#   ./run-evaluation.sh --model <MODEL_ID> --clone-dir <PATH> --prompt <PROMPT_FILE> --results-dir <DIR> [--max-turns N] [--verbose]
#
# Runs 6 test repos through multi-turn classification. The model can request
# additional files/trees/greps from the cloned repo (SPEC-011 protocol).
# Results saved to <results-dir>/<repo>.txt (full prose).

set -uo pipefail

# ── Config ────────────────────────────────────────────────────────────────────
MAX_TURNS=6
MODEL=""
CLONE_DIR=""
VERBOSE=false

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYSTEM_PROMPT=""
RESULTS_DIR_OVERRIDE=""

# Prune dirs for repo map
FIND_PRUNE_DIRS=(
  .git .svn .hg node_modules __pycache__ .venv venv .tox .eggs
  target .gradle build .mvn bin obj packages vendor .bundle
  _build deps .build DerivedData Pods dist out .next .nuxt .output
  .idea .vs .vscode .eclipse .cache .tmp coverage .nyc_output __snapshots__
)

# ── CLI parsing ───────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --model)       MODEL="$2"; shift 2 ;;
    --clone-dir)   CLONE_DIR="$2"; shift 2 ;;
    --prompt)      SYSTEM_PROMPT="$2"; shift 2 ;;
    --results-dir) RESULTS_DIR_OVERRIDE="$2"; shift 2 ;;
    --max-turns)   MAX_TURNS="$2"; shift 2 ;;
    --verbose)     VERBOSE=true; shift ;;
    -h|--help)    head -12 "$0" | grep '^#' | sed 's/^# \?//'; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

[[ -z "$MODEL" ]] && { echo "Error: --model is required" >&2; exit 1; }
[[ -z "$CLONE_DIR" ]] && { echo "Error: --clone-dir is required" >&2; exit 1; }
[[ -z "$SYSTEM_PROMPT" ]] && { echo "Error: --prompt is required" >&2; exit 1; }
[[ ! -f "$SYSTEM_PROMPT" ]] && { echo "Error: prompt file not found: $SYSTEM_PROMPT" >&2; exit 1; }

MODEL_SHORT=$(echo "$MODEL" | sed 's|openrouter/||; s|/|-|g')
if [[ -n "$RESULTS_DIR_OVERRIDE" ]]; then
  RESULTS_DIR="$RESULTS_DIR_OVERRIDE"
else
  RESULTS_DIR="${SCRIPT_DIR}/results/${MODEL_SHORT}"
fi
mkdir -p "$RESULTS_DIR"

log() { echo "[$(date +%H:%M:%S)] $*" >&2; }
verbose() { [[ "$VERBOSE" == "true" ]] && log "$*" || true; }

# ── repo_map ──────────────────────────────────────────────────────────────────
repo_map() {
  local clone_path="$1" base_path="${2:-.}" depth="${3:-3}"
  [[ ! -d "$clone_path/$base_path" ]] && { echo "(directory not found: $base_path)"; return; }
  local target_dir="$clone_path/$base_path"
  local prune_expr="" first=true
  for dir in "${FIND_PRUNE_DIRS[@]}"; do
    [[ "$first" == "true" ]] && { prune_expr="-name $dir"; first=false; } || prune_expr="$prune_expr -o -name $dir"
  done
  eval "find \"$target_dir\" -maxdepth \"$depth\" \\( $prune_expr \\) -prune -o -print" 2>/dev/null \
    | head -300 | sed "s|$clone_path/||"
}

# ── assemble_context ──────────────────────────────────────────────────────────
assemble_context() {
  local clone_path="$1"
  local context=""
  for f in README.md README.rst README.txt README readme.md; do
    if [[ -f "$clone_path/$f" ]]; then
      context+="## README (first 300 lines)\n\n$(head -300 "$clone_path/$f")\n\n"
      break
    fi
  done
  context+="## Repository Map (depth 3)\n\n\`\`\`\n$(repo_map "$clone_path")\n\`\`\`\n\n"
  echo -e "$context"
}

# ── fulfill_requests (SPEC-011) ───────────────────────────────────────────────
fulfill_requests() {
  local requests_json="$1" clone_path="$2"
  [[ -z "$clone_path" || ! -d "$clone_path" ]] && { echo "No clone available."; return; }

  local count fulfilled=""
  count=$(echo "$requests_json" | python3 -c "import sys,json; print(len(json.load(sys.stdin)))" 2>/dev/null || echo "0")

  for ((i=0; i<count; i++)); do
    local req_type req_path req_pattern req_reason req_depth
    req_type=$(echo "$requests_json" | python3 -c "import sys,json; r=json.load(sys.stdin)[$i]; print(r.get('type',''))" 2>/dev/null)
    req_reason=$(echo "$requests_json" | python3 -c "import sys,json; r=json.load(sys.stdin)[$i]; print(r.get('reason',''))" 2>/dev/null)

    case "$req_type" in
      file)
        req_path=$(echo "$requests_json" | python3 -c "import sys,json; r=json.load(sys.stdin)[$i]; print(r.get('path',''))" 2>/dev/null)
        fulfilled+="\n### Requested file: $req_path\n(Reason: $req_reason)\n\n"
        if [[ -f "$clone_path/$req_path" ]]; then
          fulfilled+="\`\`\`\n$(head -500 "$clone_path/$req_path")\n\`\`\`\n"
        else
          fulfilled+="(File not found: $req_path)\n"
        fi ;;
      tree)
        req_path=$(echo "$requests_json" | python3 -c "import sys,json; r=json.load(sys.stdin)[$i]; print(r.get('path','.'))" 2>/dev/null)
        req_depth=$(echo "$requests_json" | python3 -c "import sys,json; r=json.load(sys.stdin)[$i]; print(r.get('depth',2))" 2>/dev/null)
        fulfilled+="\n### Requested tree: $req_path (depth $req_depth)\n(Reason: $req_reason)\n\n"
        fulfilled+="\`\`\`\n$(repo_map "$clone_path" "$req_path" "$req_depth")\n\`\`\`\n" ;;
      glob)
        req_pattern=$(echo "$requests_json" | python3 -c "import sys,json; r=json.load(sys.stdin)[$i]; print(r.get('pattern',''))" 2>/dev/null)
        fulfilled+="\n### Requested glob: $req_pattern\n(Reason: $req_reason)\n\n"
        local matches
        if [[ "$req_pattern" == */* ]]; then
          matches=$(cd "$clone_path" && find . -path "./.git" -prune -o -path "./$req_pattern" -print 2>/dev/null | head -20)
        else
          matches=$(cd "$clone_path" && find . -path "./.git" -prune -o -name "$req_pattern" -print 2>/dev/null | head -20)
        fi
        if [[ -n "$matches" ]]; then
          fulfilled+="Matching files:\n\`\`\`\n$matches\n\`\`\`\n"
          local first_match=$(echo "$matches" | head -1)
          [[ -f "$clone_path/$first_match" ]] && fulfilled+="\nContents of $first_match:\n\`\`\`\n$(head -500 "$clone_path/$first_match")\n\`\`\`\n"
        else
          fulfilled+="(No files matching: $req_pattern)\n"
        fi ;;
      grep)
        req_pattern=$(echo "$requests_json" | python3 -c "import sys,json; r=json.load(sys.stdin)[$i]; print(r.get('pattern',''))" 2>/dev/null)
        req_path=$(echo "$requests_json" | python3 -c "import sys,json; r=json.load(sys.stdin)[$i]; print(r.get('path','.'))" 2>/dev/null)
        fulfilled+="\n### Requested grep: '$req_pattern' in $req_path\n(Reason: $req_reason)\n\n"
        local grep_results
        grep_results=$(grep -rn "$req_pattern" "$clone_path/$req_path" 2>/dev/null \
          | grep -v "\.git/" | head -50 | sed "s|$clone_path/||")
        [[ -n "$grep_results" ]] && fulfilled+="\`\`\`\n$grep_results\n\`\`\`\n" || fulfilled+="(No matches)\n" ;;
      *) fulfilled+="\n(Unknown request type: $req_type)\n" ;;
    esac
  done
  echo -e "$fulfilled"
}

# ── parse_yaml_frontmatter: extract YAML frontmatter from response ────────────
parse_yaml_frontmatter() {
  local response="$1"
  echo "$response" | python3 -c "
import sys, re, yaml, json
text = sys.stdin.read()
result = None
# Match --- delimited YAML frontmatter (at start or after whitespace)
m = re.search(r'(?:^|\n)\s*---\s*\n(.*?)\n\s*---', text, re.DOTALL)
if m and result is None:
    try:
        d = yaml.safe_load(m.group(1))
        if isinstance(d, dict):
            result = d
    except: pass
# Fallback: try JSON in code block (for models that ignore YAML instructions)
if result is None:
    m = re.search(r'\x60\x60\x60(?:json)?\s*\n(.*?)\n\x60\x60\x60', text, re.DOTALL)
    if m:
        try:
            d = json.loads(m.group(1))
            if isinstance(d, dict):
                result = d
        except: pass
json.dump(result if result else {}, sys.stdout)
" 2>/dev/null
}

# ── detect_response_type: is this a needs_info or a classification? ───────────
detect_response_type() {
  local response="$1"
  local frontmatter
  frontmatter=$(parse_yaml_frontmatter "$response")
  echo "$frontmatter" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('verdict', 'classified'))
" 2>/dev/null || echo "classified"
}

# ── extract_requests_json: pull requests array from needs_info response ───────
extract_requests_json() {
  local response="$1"
  local frontmatter
  frontmatter=$(parse_yaml_frontmatter "$response")
  echo "$frontmatter" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(json.dumps(d.get('requests', [])))
" 2>/dev/null || echo "[]"
}

# ── process_repo ──────────────────────────────────────────────────────────────
process_repo() {
  local repo_name="$1"
  local clone_path="$CLONE_DIR/$repo_name"

  [[ ! -d "$clone_path" ]] && { log "  Clone not found: $clone_path"; return 1; }

  log "  Processing: $repo_name"

  local context
  context=$(assemble_context "$clone_path")

  # Turn 1
  local turn=1
  verbose "  Turn $turn: initial call..."
  local response
  response=$(echo "$context" | llm -m "$MODEL" -s "$(cat "$SYSTEM_PROMPT")" 2>/dev/null || echo "ERROR: llm call failed")

  local response_type
  response_type=$(detect_response_type "$response")
  verbose "  Turn $turn: $response_type"

  # Multi-turn loop for needs_info
  while [[ "$response_type" == "needs_info" && $turn -lt $MAX_TURNS ]]; do
    turn=$((turn + 1))

    local requests
    requests=$(extract_requests_json "$response")
    verbose "  Turn $turn: fulfilling requests..."

    local fulfilled
    fulfilled=$(fulfill_requests "$requests" "$clone_path")

    response=$(echo "Here is the additional information you requested:

$fulfilled

Please classify this repository now." | llm -m "$MODEL" -c 2>/dev/null || echo "ERROR: llm call failed")

    response_type=$(detect_response_type "$response")
    verbose "  Turn $turn: $response_type"
  done

  # Save full response (prose reasoning, not just JSON)
  local out_file="$RESULTS_DIR/${repo_name}.txt"
  {
    echo "# $repo_name — $MODEL"
    echo "# Turns: $turn"
    echo "# Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo ""
    echo "$response"
  } > "$out_file"

  log "  $repo_name: done (turns=$turn) → $out_file"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  log "SPIKE-005 Confidence Calibration Evaluation"
  log "  Model: $MODEL ($MODEL_SHORT)"
  log "  Clone dir: $CLONE_DIR"
  log "  Max turns: $MAX_TURNS"
  log "  Results: $RESULTS_DIR"
  log ""

  for repo_name in posthog chatwoot sentry kafka consul grafana; do
    process_repo "$repo_name"
  done

  log ""
  log "All repos processed. Results in $RESULTS_DIR/"
}

main "$@"
