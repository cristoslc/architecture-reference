#!/usr/bin/env bash
# llm-review.sh — Automated LLM classification of Indeterminate catalog entries
#
# Uses the `llm` CLI to classify repos that the heuristic classifier could not
# resolve (review_required: true). Supports multi-turn conversations where the
# LLM can request additional context (files, directory trees, grep results).
#
# Usage:
#   pipeline/llm-review.sh [OPTIONS]
#
# Options:
#   --tier <1|2|3|all>   Confidence band to process (default: all)
#   --max-turns <N>      Max LLM turns per repo (default: 4)
#   --model <ID>         LLM model (default: claude-sonnet-4-6)
#   --clone-dir <PATH>   Directory for cached repo clones
#   --dry-run            List entries without processing
#   --limit <N>          Process at most N entries
#   --catalog <PATH>     Catalog directory (default: evidence-analysis/Discovered/docs/catalog)
#   --verbose            Show detailed progress

set -uo pipefail

# ── Defaults ──────────────────────────────────────────────────────────────────
TIER="all"
MAX_TURNS=4
MODEL=""
CLONE_DIR=""
DRY_RUN=false
LIMIT=0
CATALOG_DIR="evidence-analysis/Discovered/docs/catalog"
VERBOSE=false

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPTS_DIR="${SCRIPT_DIR}/prompts"
REPORTS_DIR="${SCRIPT_DIR}/reports"
SYSTEM_PROMPT="${PROMPTS_DIR}/system-prompt.md"

# ── Repo map exclusion list ───────────────────────────────────────────────────
FIND_PRUNE_DIRS=(
  .git .svn .hg
  node_modules
  __pycache__ .venv venv .tox .eggs
  target .gradle build .mvn
  bin obj packages
  vendor
  .bundle
  _build deps
  .build DerivedData Pods
  dist out .next .nuxt .output
  .idea .vs .vscode .eclipse
  .cache .tmp coverage .nyc_output __snapshots__
)

# ── CLI parsing ───────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --tier)       TIER="$2"; shift 2 ;;
    --max-turns)  MAX_TURNS="$2"; shift 2 ;;
    --model)      MODEL="$2"; shift 2 ;;
    --clone-dir)  CLONE_DIR="$2"; shift 2 ;;
    --dry-run)    DRY_RUN=true; shift ;;
    --limit)      LIMIT="$2"; shift 2 ;;
    --catalog)    CATALOG_DIR="$2"; shift 2 ;;
    --verbose)    VERBOSE=true; shift ;;
    -h|--help)
      head -20 "$0" | grep '^#' | sed 's/^# \?//'
      exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

# ── Validation ────────────────────────────────────────────────────────────────
if ! command -v llm &>/dev/null; then
  echo "Error: 'llm' CLI not found. Install with: pip install llm" >&2
  exit 1
fi

if [[ ! -d "$CATALOG_DIR" ]]; then
  echo "Error: catalog directory not found: $CATALOG_DIR" >&2
  exit 1
fi

if [[ ! -f "$SYSTEM_PROMPT" ]]; then
  echo "Error: system prompt not found: $SYSTEM_PROMPT" >&2
  exit 1
fi

mkdir -p "$REPORTS_DIR"

# ── Logging ───────────────────────────────────────────────────────────────────
log() { echo "[$(date +%H:%M:%S)] $*" >&2; }
verbose() { [[ "$VERBOSE" == "true" ]] && log "$*" || true; }

# ── scan_entries: find catalog entries matching criteria ──────────────────────
scan_entries() {
  local entries=()

  for yaml_file in "$CATALOG_DIR"/*.yaml; do
    [[ -f "$yaml_file" ]] || continue

    # Check review_required
    if ! grep -q "^review_required: true" "$yaml_file"; then
      continue
    fi

    # Check tier filter
    if [[ "$TIER" != "all" ]]; then
      local confidence
      confidence=$(grep "^  confidence:" "$yaml_file" | head -1 | awk '{print $2}')
      if [[ -z "$confidence" ]]; then
        continue
      fi

      local in_tier=false
      case "$TIER" in
        1) # 0.70 - 0.84
          if (( $(echo "$confidence >= 0.70 && $confidence <= 0.84" | bc -l) )); then
            in_tier=true
          fi ;;
        2) # 0.50 - 0.69
          if (( $(echo "$confidence >= 0.50 && $confidence <= 0.69" | bc -l) )); then
            in_tier=true
          fi ;;
        3) # 0.30 - 0.49
          if (( $(echo "$confidence >= 0.30 && $confidence <= 0.49" | bc -l) )); then
            in_tier=true
          fi ;;
      esac

      if [[ "$in_tier" != "true" ]]; then
        continue
      fi
    fi

    entries+=("$yaml_file")
  done

  printf '%s\n' "${entries[@]}"
}

# ── ensure_clone: get local repo clone ────────────────────────────────────────
ensure_clone() {
  local yaml_file="$1"
  local repo_url

  repo_url=$(grep "^project_url:" "$yaml_file" | head -1 | sed 's/^project_url: *//' | tr -d '"')
  if [[ -z "$repo_url" ]]; then
    repo_url=$(grep "^source_url:" "$yaml_file" | head -1 | sed 's/^source_url: *//' | tr -d '"')
  fi

  if [[ -z "$repo_url" ]]; then
    echo ""
    return
  fi

  local repo_name
  repo_name=$(basename "$repo_url" .git)

  # Check cached clone
  if [[ -n "$CLONE_DIR" && -d "$CLONE_DIR/$repo_name" ]]; then
    echo "$CLONE_DIR/$repo_name"
    return
  fi

  # On-demand shallow clone to temp dir (60s timeout)
  local tmp_dir
  tmp_dir=$(mktemp -d)
  if timeout 60 git clone --depth 1 --quiet "$repo_url" "$tmp_dir/$repo_name" 2>/dev/null; then
    echo "$tmp_dir/$repo_name"
  else
    rm -rf "$tmp_dir"
    echo ""
  fi
}

# ── build_find_prune: construct find -prune expression ────────────────────────
build_find_prune() {
  local prune_expr="("
  local first=true
  for dir in "${FIND_PRUNE_DIRS[@]}"; do
    if [[ "$first" == "true" ]]; then
      prune_expr+=" -name \"$dir\""
      first=false
    else
      prune_expr+=" -o -name \"$dir\""
    fi
  done
  prune_expr+=" ) -prune"
  echo "$prune_expr"
}

# ── repo_map: generate directory tree ─────────────────────────────────────────
repo_map() {
  local clone_path="$1"
  local base_path="${2:-.}"
  local depth="${3:-3}"

  if [[ ! -d "$clone_path/$base_path" ]]; then
    echo "(directory not found: $base_path)"
    return
  fi

  local target_dir="$clone_path/$base_path"

  # Build prune expression for find
  local prune_expr=""
  local first=true
  for dir in "${FIND_PRUNE_DIRS[@]}"; do
    if [[ "$first" == "true" ]]; then
      prune_expr="-name $dir"
      first=false
    else
      prune_expr="$prune_expr -o -name $dir"
    fi
  done

  eval "find \"$target_dir\" -maxdepth \"$depth\" \\( $prune_expr \\) -prune -o -print" 2>/dev/null \
    | head -200 \
    | sed "s|$clone_path/||"
}

# ── assemble_context: build Turn 1 payload ────────────────────────────────────
assemble_context() {
  local yaml_file="$1"
  local clone_path="$2"
  local context=""

  # Catalog YAML
  context+="## Catalog Entry (YAML)\n\n\`\`\`yaml\n"
  context+="$(cat "$yaml_file")"
  context+="\n\`\`\`\n\n"

  if [[ -n "$clone_path" && -d "$clone_path" ]]; then
    # README
    local readme=""
    for f in README.md README.rst README.txt README readme.md; do
      if [[ -f "$clone_path/$f" ]]; then
        readme="$clone_path/$f"
        break
      fi
    done
    if [[ -n "$readme" ]]; then
      context+="## README (first 300 lines)\n\n"
      context+="$(head -300 "$readme")"
      context+="\n\n"
    fi

    # Repo map
    context+="## Repository Map (depth 3)\n\n\`\`\`\n"
    context+="$(repo_map "$clone_path")"
    context+="\n\`\`\`\n\n"
  else
    context+="## Note\n\nNo local clone available. Classify based on catalog metadata only, or return needs_info to request specific files.\n\n"
  fi

  echo -e "$context"
}

# ── fulfill_requests: handle needs_info responses (SPEC-011) ──────────────────
fulfill_requests() {
  local requests_json="$1"
  local clone_path="$2"
  local fulfilled=""

  if [[ -z "$clone_path" || ! -d "$clone_path" ]]; then
    echo "Cannot fulfill info requests: no local clone available."
    return
  fi

  local count
  count=$(echo "$requests_json" | python3 -c "import sys,json; print(len(json.load(sys.stdin)))" 2>/dev/null || echo "0")

  for ((i=0; i<count; i++)); do
    local req_type req_path req_pattern req_reason req_depth

    req_type=$(echo "$requests_json" | python3 -c "import sys,json; r=json.load(sys.stdin)[$i]; print(r.get('type',''))" 2>/dev/null)
    req_reason=$(echo "$requests_json" | python3 -c "import sys,json; r=json.load(sys.stdin)[$i]; print(r.get('reason',''))" 2>/dev/null)

    case "$req_type" in
      file)
        req_path=$(echo "$requests_json" | python3 -c "import sys,json; r=json.load(sys.stdin)[$i]; print(r.get('path',''))" 2>/dev/null)
        fulfilled+="\n### Requested file: $req_path\n"
        fulfilled+="(Reason: $req_reason)\n\n"
        if [[ -f "$clone_path/$req_path" ]]; then
          fulfilled+="\`\`\`\n$(head -500 "$clone_path/$req_path")\n\`\`\`\n"
        else
          fulfilled+="(File not found: $req_path)\n"
        fi
        ;;

      tree)
        req_path=$(echo "$requests_json" | python3 -c "import sys,json; r=json.load(sys.stdin)[$i]; print(r.get('path','.'))" 2>/dev/null)
        req_depth=$(echo "$requests_json" | python3 -c "import sys,json; r=json.load(sys.stdin)[$i]; print(r.get('depth',2))" 2>/dev/null)
        fulfilled+="\n### Requested tree: $req_path (depth $req_depth)\n"
        fulfilled+="(Reason: $req_reason)\n\n"
        fulfilled+="\`\`\`\n$(repo_map "$clone_path" "$req_path" "$req_depth")\n\`\`\`\n"
        ;;

      glob)
        req_pattern=$(echo "$requests_json" | python3 -c "import sys,json; r=json.load(sys.stdin)[$i]; print(r.get('pattern',''))" 2>/dev/null)
        fulfilled+="\n### Requested glob: $req_pattern\n"
        fulfilled+="(Reason: $req_reason)\n\n"
        local matches
        matches=$(cd "$clone_path" && find . -path "./.git" -prune -o -name "$req_pattern" -print 2>/dev/null | head -20)
        if [[ -n "$matches" ]]; then
          fulfilled+="Matching files:\n\`\`\`\n$matches\n\`\`\`\n"
          # Cat the first match
          local first_match
          first_match=$(echo "$matches" | head -1)
          if [[ -f "$clone_path/$first_match" ]]; then
            fulfilled+="\nContents of $first_match:\n\`\`\`\n$(head -500 "$clone_path/$first_match")\n\`\`\`\n"
          fi
        else
          fulfilled+="(No files matching pattern: $req_pattern)\n"
        fi
        ;;

      grep)
        req_pattern=$(echo "$requests_json" | python3 -c "import sys,json; r=json.load(sys.stdin)[$i]; print(r.get('pattern',''))" 2>/dev/null)
        req_path=$(echo "$requests_json" | python3 -c "import sys,json; r=json.load(sys.stdin)[$i]; print(r.get('path','.'))" 2>/dev/null)
        fulfilled+="\n### Requested grep: '$req_pattern' in $req_path\n"
        fulfilled+="(Reason: $req_reason)\n\n"
        local grep_results
        grep_results=$(grep -rn "$req_pattern" "$clone_path/$req_path" 2>/dev/null \
          | grep -v "\.git/" \
          | head -50 \
          | sed "s|$clone_path/||")
        if [[ -n "$grep_results" ]]; then
          fulfilled+="\`\`\`\n$grep_results\n\`\`\`\n"
        else
          fulfilled+="(No matches for pattern: $req_pattern)\n"
        fi
        ;;

      *)
        fulfilled+="\n(Unknown request type: $req_type)\n"
        ;;
    esac
  done

  echo -e "$fulfilled"
}

# ── parse_response: extract and validate LLM JSON response ───────────────────
parse_response() {
  local response="$1"

  # Extract JSON from response (handle potential markdown wrapping)
  local json
  json=$(echo "$response" | python3 -c "
import sys, json, re

text = sys.stdin.read()

# Try parsing directly
try:
    obj = json.loads(text)
    print(json.dumps(obj))
    sys.exit(0)
except json.JSONDecodeError:
    pass

# Try extracting from markdown code block
match = re.search(r'\`\`\`(?:json)?\s*\n(.*?)\n\`\`\`', text, re.DOTALL)
if match:
    try:
        obj = json.loads(match.group(1))
        print(json.dumps(obj))
        sys.exit(0)
    except json.JSONDecodeError:
        pass

# Try finding JSON object in text
match = re.search(r'\{.*\}', text, re.DOTALL)
if match:
    try:
        obj = json.loads(match.group(0))
        print(json.dumps(obj))
        sys.exit(0)
    except json.JSONDecodeError:
        pass

print('{}')
sys.exit(1)
" 2>/dev/null)

  echo "$json"
}

# ── get_verdict: extract verdict from parsed JSON ─────────────────────────────
get_verdict() {
  echo "$1" | python3 -c "import sys,json; print(json.load(sys.stdin).get('verdict','error'))" 2>/dev/null || echo "error"
}

# ── apply_classification: call apply-review.py ────────────────────────────────
apply_classification() {
  local yaml_file="$1"
  local json_response="$2"

  local styles confidence summary notes entry_type

  styles=$(echo "$json_response" | python3 -c "
import sys,json
d=json.load(sys.stdin)
print(','.join(d.get('styles',[])))
" 2>/dev/null)

  confidence=$(echo "$json_response" | python3 -c "
import sys,json; print(json.load(sys.stdin).get('confidence',0.0))
" 2>/dev/null)

  summary=$(echo "$json_response" | python3 -c "
import sys,json; print(json.load(sys.stdin).get('summary',''))
" 2>/dev/null)

  notes=$(echo "$json_response" | python3 -c "
import sys,json; print(json.load(sys.stdin).get('notes',''))
" 2>/dev/null)

  entry_type=$(echo "$json_response" | python3 -c "
import sys,json; print(json.load(sys.stdin).get('entry_type','repo'))
" 2>/dev/null)

  local cmd=(python3 "${SCRIPT_DIR}/apply-review.py"
    --entry "$yaml_file"
    --confidence "$confidence"
    --notes "$notes"
  )

  if [[ -n "$styles" ]]; then
    cmd+=(--styles "$styles")
  fi

  if [[ -n "$summary" ]]; then
    cmd+=(--summary "$summary")
  fi

  if [[ "$entry_type" == "ecosystem" ]]; then
    cmd+=(--entry-type ecosystem)
  fi

  "${cmd[@]}" >&2
}

# ── process_entry: full classification pipeline for one entry ─────────────────
process_entry() {
  local yaml_file="$1"
  local project_name
  project_name=$(grep "^project_name:" "$yaml_file" | head -1 | awk '{print $2}')

  log "Processing: $project_name ($yaml_file)"

  # Get clone
  local clone_path
  clone_path=$(ensure_clone "$yaml_file")
  verbose "Clone: ${clone_path:-none}"

  # Assemble context
  local context
  context=$(assemble_context "$yaml_file" "$clone_path")

  # Turn 1: initial LLM call
  local turn=1
  local response json verdict
  local total_llm_calls=0

  verbose "Turn $turn: calling LLM..."
  local model_flag=""
  [[ -n "$MODEL" ]] && model_flag="-m $MODEL"
  response=$(echo "$context" | llm $model_flag -s "$(cat "$SYSTEM_PROMPT")" 2>/dev/null || echo '{"verdict":"error"}')
  total_llm_calls=$((total_llm_calls + 1))

  json=$(parse_response "$response")
  verdict=$(get_verdict "$json")
  verbose "Turn $turn verdict: $verdict"

  # Multi-turn loop
  while [[ "$verdict" == "needs_info" && $turn -lt $MAX_TURNS ]]; do
    turn=$((turn + 1))

    local requests
    requests=$(echo "$json" | python3 -c "import sys,json; print(json.dumps(json.load(sys.stdin).get('requests',[])))" 2>/dev/null)

    local fulfilled
    fulfilled=$(fulfill_requests "$requests" "$clone_path")

    verbose "Turn $turn: fulfilling ${requests} and calling LLM..."
    response=$(echo "Here is the additional information you requested:

$fulfilled

Please classify this repository now." | llm $model_flag -c 2>/dev/null || echo '{"verdict":"error"}')
    total_llm_calls=$((total_llm_calls + 1))

    json=$(parse_response "$response")
    verdict=$(get_verdict "$json")
    verbose "Turn $turn verdict: $verdict"
  done

  # Route verdict
  local result_status="unknown"
  case "$verdict" in
    classified)
      apply_classification "$yaml_file" "$json"
      result_status="classified"
      ;;
    unclassifiable)
      local reason
      reason=$(echo "$json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('reason',''))" 2>/dev/null)
      log "  Unclassifiable: $reason"
      # Mark as reviewed but keep Indeterminate
      local unclass_confidence
      unclass_confidence=$(echo "$json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('confidence',0.5))" 2>/dev/null)
      python3 "${SCRIPT_DIR}/apply-review.py" \
        --entry "$yaml_file" \
        --confidence "$unclass_confidence" \
        --notes "LLM review: unclassifiable — $reason" >&2
      result_status="unclassifiable"
      ;;
    needs_info)
      log "  Escalation failure: max turns ($MAX_TURNS) exceeded without classification"
      result_status="escalation_failure"
      ;;
    *)
      log "  Error: invalid response from LLM"
      result_status="error"
      ;;
  esac

  # Clean up temp clone if we created one
  if [[ -n "$clone_path" && "$clone_path" == /tmp/* ]]; then
    rm -rf "$(dirname "$clone_path")"
  fi

  # Output result as JSON for report aggregation
  local styles_json="[]"
  local conf="0"
  if [[ "$verdict" == "classified" ]]; then
    styles_json=$(echo "$json" | python3 -c "import sys,json; print(json.dumps(json.load(sys.stdin).get('styles',[])))" 2>/dev/null)
    conf=$(echo "$json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('confidence',0))" 2>/dev/null)
  fi

  echo "{\"entry\":\"$(basename "$yaml_file")\",\"verdict\":\"$result_status\",\"turns\":$turn,\"styles\":$styles_json,\"confidence\":$conf,\"llm_calls\":$total_llm_calls}"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  log "LLM Review Pipeline"
  log "  Model: ${MODEL:-default ($(llm models default 2>/dev/null))}"
  log "  Tier: $TIER"
  log "  Max turns: $MAX_TURNS"
  log "  Catalog: $CATALOG_DIR"
  [[ -n "$CLONE_DIR" ]] && log "  Clone dir: $CLONE_DIR"
  [[ "$DRY_RUN" == "true" ]] && log "  Mode: DRY RUN"

  # Scan entries
  local entries_list
  entries_list=$(scan_entries)

  if [[ -z "$entries_list" ]]; then
    log "No entries matching criteria. Nothing to do."
    exit 0
  fi

  local entry_count
  entry_count=$(echo "$entries_list" | wc -l | tr -d ' ')
  log "Found $entry_count entries to process"

  # Apply limit
  if [[ $LIMIT -gt 0 && $entry_count -gt $LIMIT ]]; then
    entries_list=$(echo "$entries_list" | head -"$LIMIT")
    entry_count=$LIMIT
    log "Limited to $LIMIT entries"
  fi

  # Dry run: just list entries
  if [[ "$DRY_RUN" == "true" ]]; then
    log "Entries that would be processed:"
    echo "$entries_list" | while read -r entry; do
      local name conf
      name=$(grep "^project_name:" "$entry" | awk '{print $2}')
      conf=$(grep "^  confidence:" "$entry" | head -1 | awk '{print $2}')
      echo "  $name (confidence: ${conf:-unknown}) — $entry"
    done
    exit 0
  fi

  # Process entries
  local results=()
  local classified=0 unclassifiable=0 escalation_failures=0 errors=0
  local total_llm_calls=0
  local processed=0

  while IFS= read -r entry; do
    processed=$((processed + 1))
    log "[$processed/$entry_count] Processing..."

    local result
    result=$(process_entry "$entry")
    results+=("$result")

    # Parse result for counters
    local entry_verdict entry_calls
    entry_verdict=$(echo "$result" | python3 -c "import sys,json; print(json.load(sys.stdin)['verdict'])" 2>/dev/null)
    entry_calls=$(echo "$result" | python3 -c "import sys,json; print(json.load(sys.stdin)['llm_calls'])" 2>/dev/null)
    total_llm_calls=$((total_llm_calls + entry_calls))

    case "$entry_verdict" in
      classified) classified=$((classified + 1)) ;;
      unclassifiable) unclassifiable=$((unclassifiable + 1)) ;;
      escalation_failure) escalation_failures=$((escalation_failures + 1)) ;;
      *) errors=$((errors + 1)) ;;
    esac
  done <<< "$entries_list"

  # Generate report
  local run_id
  run_id=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local report_file="${REPORTS_DIR}/run-$(date +%Y%m%d-%H%M%S).json"

  local results_json="["
  local first=true
  for r in "${results[@]}"; do
    if [[ "$first" == "true" ]]; then
      results_json+="$r"
      first=false
    else
      results_json+=",$r"
    fi
  done
  results_json+="]"

  python3 -c "
import json, sys

report = {
    'run_id': '$run_id',
    'model': '$MODEL',
    'tier': '$TIER',
    'max_turns': $MAX_TURNS,
    'entries_processed': $processed,
    'classified': $classified,
    'unclassifiable': $unclassifiable,
    'escalation_failures': $escalation_failures,
    'errors': $errors,
    'total_llm_calls': $total_llm_calls,
    'results': json.loads('''$results_json''')
}

with open('$report_file', 'w') as f:
    json.dump(report, f, indent=2)

print(json.dumps(report, indent=2))
" 2>/dev/null

  log ""
  log "Run complete."
  log "  Processed: $processed"
  log "  Classified: $classified"
  log "  Unclassifiable: $unclassifiable"
  log "  Escalation failures: $escalation_failures"
  log "  Errors: $errors"
  log "  Total LLM calls: $total_llm_calls"
  log "  Report: $report_file"
}

main "$@"
