#!/usr/bin/env bash
# llm-review.sh — Automated LLM classification of catalog entries
#
# Uses the `llm` CLI to classify repos via multi-turn conversations where the
# LLM can request additional context (files, directory trees, grep results).
#
# Usage:
#   pipeline/llm-review.sh [OPTIONS]
#
# Options:
#   --mode <review|deep-analysis>  Classification mode (default: deep-analysis)
#   --tier <1|2|3|all>   Confidence band to process (review mode only)
#   --max-turns <N>      Max LLM turns per repo (default: 6)
#   --max-retries <N>    Max parse retries per turn (default: 2)
#   --model <ID>         LLM model (default: openrouter/google/gemini-3-flash-preview)
#   --clone-dir <PATH>   Directory for cached repo clones
#   --dry-run            List entries without processing
#   --limit <N>          Process at most N entries
#   --offset <N>         Skip first N entries (default: 0)
#   --catalog <PATH>     Catalog directory (default: evidence-analysis/Discovered/docs/catalog)
#   --verbose            Show detailed progress

set -uo pipefail

# ── Defaults ──────────────────────────────────────────────────────────────────
MODE="deep-analysis"
TIER="all"
MAX_TURNS=6
MAX_PARSE_RETRIES=2
MODEL="openrouter/google/gemini-3-flash-preview"
CLONE_DIR=".clone-cache"
DRY_RUN=false
LIMIT=0
OFFSET=0
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
    --mode)         MODE="$2"; shift 2 ;;
    --tier)         TIER="$2"; shift 2 ;;
    --max-turns)    MAX_TURNS="$2"; shift 2 ;;
    --max-retries)  MAX_PARSE_RETRIES="$2"; shift 2 ;;
    --model)        MODEL="$2"; shift 2 ;;
    --clone-dir)    CLONE_DIR="$2"; shift 2 ;;
    --dry-run)      DRY_RUN=true; shift ;;
    --limit)        LIMIT="$2"; shift 2 ;;
    --offset)       OFFSET="$2"; shift 2 ;;
    --catalog)      CATALOG_DIR="$2"; shift 2 ;;
    --verbose)      VERBOSE=true; shift ;;
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

# ── Portability: timeout command ──────────────────────────────────────────────
if command -v gtimeout &>/dev/null; then
  TIMEOUT_CMD="gtimeout"
elif command -v timeout &>/dev/null; then
  TIMEOUT_CMD="timeout"
else
  TIMEOUT_CMD=""
fi

# ── Logging ───────────────────────────────────────────────────────────────────
log() { echo "[$(date +%H:%M:%S)] $*" >&2; }
verbose() { [[ "$VERBOSE" == "true" ]] && log "$*" || true; }

# ── scan_entries: find catalog entries matching criteria ──────────────────────
scan_entries() {
  local entries=()

  for yaml_file in "$CATALOG_DIR"/*.yaml; do
    [[ -f "$yaml_file" ]] || continue

    if [[ "$MODE" == "deep-analysis" ]]; then
      # Deep-analysis mode: find pending entries
      if ! grep -q "^classification_status: pending" "$yaml_file"; then
        continue
      fi
    else
      # Review mode: find review_required entries
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

  # On-demand shallow clone to cache dir (120s timeout)
  if [[ -n "$CLONE_DIR" ]]; then
    mkdir -p "$CLONE_DIR"
    if ${TIMEOUT_CMD:+$TIMEOUT_CMD 120} git clone --depth 1 --quiet "$repo_url" "$CLONE_DIR/$repo_name" 2>/dev/null; then
      echo "$CLONE_DIR/$repo_name"
      return
    fi
  fi

  # Fallback: temp dir
  local tmp_dir
  tmp_dir=$(mktemp -d)
  if ${TIMEOUT_CMD:+$TIMEOUT_CMD 120} git clone --depth 1 --quiet "$repo_url" "$tmp_dir/$repo_name" 2>/dev/null; then
    echo "$tmp_dir/$repo_name"
  else
    rm -rf "$tmp_dir"
    echo ""
  fi
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
    | head -300 \
    | sed "s|$clone_path/||"
}

# ── assemble_context: build Turn 1 payload ────────────────────────────────────
assemble_context() {
  local yaml_file="$1"
  local clone_path="$2"
  local context=""

  # In deep-analysis mode, do NOT include catalog YAML — clean slate, no anchoring
  if [[ "$MODE" != "deep-analysis" ]]; then
    context+="## Catalog Entry (YAML)\n\n\`\`\`yaml\n"
    context+="$(cat "$yaml_file")"
    context+="\n\`\`\`\n\n"
  fi

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

    # Repo map (depth 4 for deep-analysis, 3 for review)
    local map_depth=3
    [[ "$MODE" == "deep-analysis" ]] && map_depth=4
    context+="## Repository Map (depth $map_depth)\n\n\`\`\`\n"
    context+="$(repo_map "$clone_path" "." "$map_depth")"
    context+="\n\`\`\`\n\n"
  else
    context+="## Note\n\nNo local clone available. Classify based on available metadata only, or return needs_info to request specific files.\n\n"
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
        if [[ "$req_pattern" == */* ]]; then
          matches=$(cd "$clone_path" && find . -path "./.git" -prune -o -path "./$req_pattern" -print 2>/dev/null | head -20)
        else
          matches=$(cd "$clone_path" && find . -path "./.git" -prune -o -name "$req_pattern" -print 2>/dev/null | head -20)
        fi
        if [[ -n "$matches" ]]; then
          fulfilled+="Matching files:\n\`\`\`\n$matches\n\`\`\`\n"
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
# Fallback: try JSON in code block
if result is None:
    m = re.search(r'\x60\x60\x60(?:json)?\s*\n(.*?)\n\x60\x60\x60', text, re.DOTALL)
    if m:
        try:
            d = json.loads(m.group(1))
            if isinstance(d, dict):
                result = d
        except: pass
# Fallback 2: try bare JSON object
if result is None:
    stripped = text.strip()
    if stripped.startswith('{'):
        try:
            d = json.loads(stripped)
            if isinstance(d, dict) and 'verdict' in d:
                result = d
        except: pass
# Fallback 3: try old-style JSON (entire response is JSON, even without verdict)
if result is None:
    try:
        d = json.loads(text)
        if isinstance(d, dict):
            result = d
    except: pass
json.dump(result if result else {}, sys.stdout)
" 2>/dev/null
}

# ── is_parse_empty ────────────────────────────────────────────────────────────
is_parse_empty() {
  local parsed="$1"
  [[ -z "$parsed" || "$parsed" == "{}" || "$parsed" == "null" ]]
}

# ── get_verdict ───────────────────────────────────────────────────────────────
get_verdict() {
  echo "$1" | python3 -c "import sys,json; print(json.load(sys.stdin).get('verdict','error'))" 2>/dev/null || echo "error"
}

# ── extract_requests_json ─────────────────────────────────────────────────────
extract_requests_json() {
  local parsed_json="$1"
  echo "$parsed_json" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(json.dumps(d.get('requests', [])))
" 2>/dev/null || echo "[]"
}

# ── extract_prose_reasoning: get text after YAML frontmatter ──────────────────
extract_prose_reasoning() {
  local response="$1"
  echo "$response" | python3 -c "
import sys, re
text = sys.stdin.read()
# Find the closing --- of YAML frontmatter and return everything after
m = re.search(r'(?:^|\n)\s*---\s*\n.*?\n\s*---\s*\n(.*)', text, re.DOTALL)
if m:
    prose = m.group(1).strip()
    if prose:
        print(prose)
        sys.exit(0)
# If no frontmatter, return everything (for JSON responses, the prose may follow)
m = re.search(r'\x60\x60\x60(?:json)?\s*\n.*?\n\x60\x60\x60\s*\n(.*)', text, re.DOTALL)
if m:
    prose = m.group(1).strip()
    if prose:
        print(prose)
        sys.exit(0)
# Fallback: try notes field from old JSON format
print('')
" 2>/dev/null
}

# ── retry_parse: ask model to reformat on parse failure ───────────────────────
retry_parse() {
  local raw_response="$1" retry_num="$2" model_flag="$3"
  log "    Parse retry $retry_num: asking model to reformat..."
  local retry_response
  retry_response=$(echo "Your previous response could not be parsed as valid YAML frontmatter or JSON. Here is your raw response:

---BEGIN RAW RESPONSE---
$raw_response
---END RAW RESPONSE---

Please reformat your response. Start with valid YAML frontmatter between --- delimiters, like this:

---
verdict: classified
primary_style: StyleName
secondary_styles:
  - Style2
confidence: 0.85
---

Your analysis text here...

IMPORTANT: Each YAML key must appear exactly once. Do not write 'type: type: file' — write 'type: file'." | llm $model_flag -c 2>/dev/null || echo "ERROR: llm retry call failed")
  echo "$retry_response"
}

# ── apply_classification: write results to catalog YAML ───────────────────────
apply_classification() {
  local yaml_file="$1"
  local parsed_json="$2"
  local reasoning="$3"

  local primary_style secondary_styles_csv confidence

  # Extract from YAML frontmatter format (primary_style + secondary_styles)
  primary_style=$(echo "$parsed_json" | python3 -c "
import sys,json
d=json.load(sys.stdin)
# Try YAML frontmatter format
ps = d.get('primary_style','')
if ps:
    print(ps)
else:
    # Fallback: old JSON format (styles array)
    styles = d.get('styles',[])
    print(styles[0] if styles else '')
" 2>/dev/null)

  secondary_styles_csv=$(echo "$parsed_json" | python3 -c "
import sys,json
d=json.load(sys.stdin)
ss = d.get('secondary_styles',[])
if ss:
    print(','.join(ss))
else:
    # Fallback: old JSON format (styles array minus first)
    styles = d.get('styles',[])
    if len(styles) > 1:
        print(','.join(styles[1:]))
    else:
        print('')
" 2>/dev/null)

  confidence=$(echo "$parsed_json" | python3 -c "
import sys,json; print(json.load(sys.stdin).get('confidence',0.0))
" 2>/dev/null)

  # Build styles list
  local all_styles="$primary_style"
  if [[ -n "$secondary_styles_csv" ]]; then
    all_styles="$primary_style,$secondary_styles_csv"
  fi

  local summary notes
  summary=$(echo "$parsed_json" | python3 -c "
import sys,json; print(json.load(sys.stdin).get('summary',''))
" 2>/dev/null)
  notes=$(echo "$parsed_json" | python3 -c "
import sys,json; print(json.load(sys.stdin).get('notes',''))
" 2>/dev/null)

  # For deep-analysis mode, pass reasoning and model info
  local method_arg="llm-review"
  local extra_args=()
  if [[ "$MODE" == "deep-analysis" ]]; then
    method_arg="deep-analysis"
    extra_args+=(--reasoning "$reasoning")
    extra_args+=(--classification-model "$MODEL")
  fi

  local cmd=(python3 "${SCRIPT_DIR}/apply-review.py"
    --entry "$yaml_file"
    --confidence "$confidence"
    --method "$method_arg"
  )

  if [[ -n "$all_styles" ]]; then
    cmd+=(--styles "$all_styles")
  fi

  if [[ -n "$summary" ]]; then
    cmd+=(--summary "$summary")
  fi

  if [[ -n "$notes" && -z "$reasoning" ]]; then
    cmd+=(--notes "$notes")
  elif [[ -n "$reasoning" ]]; then
    # Use first 500 chars of reasoning as notes if no explicit notes
    local short_notes
    short_notes=$(echo "$reasoning" | head -10 | cut -c1-500)
    cmd+=(--notes "$short_notes")
  else
    cmd+=(--notes "Classified by $MODEL")
  fi

  cmd+=("${extra_args[@]}")

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
  local parse_retries=0
  local total_llm_calls=0
  local model_flag="-m $MODEL"

  verbose "Turn $turn: calling LLM..."
  local response
  response=$(echo "$context" | llm $model_flag -s "$(cat "$SYSTEM_PROMPT")" 2>/dev/null || echo '{"verdict":"error"}')
  total_llm_calls=$((total_llm_calls + 1))

  # Parse with retry
  local parsed
  parsed=$(parse_yaml_frontmatter "$response")
  while is_parse_empty "$parsed" && [[ $parse_retries -lt $MAX_PARSE_RETRIES ]]; do
    parse_retries=$((parse_retries + 1))
    response=$(retry_parse "$response" "$parse_retries" "$model_flag")
    total_llm_calls=$((total_llm_calls + 1))
    parsed=$(parse_yaml_frontmatter "$response")
  done

  local verdict
  if is_parse_empty "$parsed"; then
    verdict="error"
    log "  Parse failed after $parse_retries retries"
  else
    verdict=$(get_verdict "$parsed")
  fi
  verbose "Turn $turn verdict: $verdict (parse_retries=$parse_retries)"

  # Multi-turn loop
  while [[ "$verdict" == "needs_info" && $turn -lt $MAX_TURNS ]]; do
    turn=$((turn + 1))
    parse_retries=0

    local requests
    requests=$(extract_requests_json "$parsed")

    local fulfilled
    fulfilled=$(fulfill_requests "$requests" "$clone_path")

    verbose "Turn $turn: fulfilling requests and calling LLM..."
    response=$(echo "Here is the additional information you requested:

$fulfilled

Please classify this repository now." | llm $model_flag -c 2>/dev/null || echo '{"verdict":"error"}')
    total_llm_calls=$((total_llm_calls + 1))

    parsed=$(parse_yaml_frontmatter "$response")
    while is_parse_empty "$parsed" && [[ $parse_retries -lt $MAX_PARSE_RETRIES ]]; do
      parse_retries=$((parse_retries + 1))
      response=$(retry_parse "$response" "$parse_retries" "$model_flag")
      total_llm_calls=$((total_llm_calls + 1))
      parsed=$(parse_yaml_frontmatter "$response")
    done

    if is_parse_empty "$parsed"; then
      verdict="error"
      log "  Parse failed on turn $turn after $parse_retries retries"
      break
    fi

    verdict=$(get_verdict "$parsed")
    verbose "Turn $turn verdict: $verdict (parse_retries=$parse_retries)"
  done

  # Extract prose reasoning (text after YAML frontmatter)
  local reasoning=""
  if [[ "$verdict" == "classified" ]]; then
    reasoning=$(extract_prose_reasoning "$response")
  fi

  # Route verdict
  local result_status="unknown"
  case "$verdict" in
    classified)
      apply_classification "$yaml_file" "$parsed" "$reasoning"
      result_status="classified"
      ;;
    unclassifiable)
      local reason
      reason=$(echo "$parsed" | python3 -c "import sys,json; print(json.load(sys.stdin).get('reason',''))" 2>/dev/null)
      log "  Unclassifiable: $reason"
      python3 "${SCRIPT_DIR}/apply-review.py" \
        --entry "$yaml_file" \
        --confidence 0.0 \
        --notes "LLM review: unclassifiable — $reason" \
        --method "$([[ "$MODE" == "deep-analysis" ]] && echo "deep-analysis" || echo "llm-review")" >&2
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

  # Clean up temp clone if we created one (not from cache)
  if [[ -n "$clone_path" && "$clone_path" == /tmp/* ]]; then
    rm -rf "$(dirname "$clone_path")"
  fi

  # Output result as JSON for report aggregation
  local styles_json="[]"
  local conf="0"
  if [[ "$verdict" == "classified" ]]; then
    styles_json=$(echo "$parsed" | python3 -c "
import sys,json
d=json.load(sys.stdin)
ps = d.get('primary_style','')
ss = d.get('secondary_styles',[])
styles = d.get('styles',[])
if ps:
    result = [ps] + (ss if ss else [])
elif styles:
    result = styles
else:
    result = []
print(json.dumps(result))
" 2>/dev/null)
    conf=$(echo "$parsed" | python3 -c "import sys,json; print(json.load(sys.stdin).get('confidence',0))" 2>/dev/null)
  fi

  echo "{\"entry\":\"$(basename "$yaml_file")\",\"project\":\"$project_name\",\"verdict\":\"$result_status\",\"turns\":$turn,\"parse_retries\":$parse_retries,\"styles\":$styles_json,\"confidence\":$conf,\"llm_calls\":$total_llm_calls}"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  log "LLM Classification Pipeline"
  log "  Mode: $MODE"
  log "  Model: $MODEL"
  log "  Max turns: $MAX_TURNS"
  log "  Max parse retries: $MAX_PARSE_RETRIES"
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

  local total_count
  total_count=$(echo "$entries_list" | wc -l | tr -d ' ')
  log "Found $total_count entries to process"

  # Apply offset
  if [[ $OFFSET -gt 0 ]]; then
    entries_list=$(echo "$entries_list" | tail -n +$((OFFSET + 1)))
    local remaining
    remaining=$(echo "$entries_list" | wc -l | tr -d ' ')
    log "Offset $OFFSET: $remaining entries remaining"
  fi

  # Apply limit
  local entry_count
  entry_count=$(echo "$entries_list" | wc -l | tr -d ' ')
  if [[ $LIMIT -gt 0 && $entry_count -gt $LIMIT ]]; then
    entries_list=$(echo "$entries_list" | head -"$LIMIT")
    entry_count=$LIMIT
    log "Limited to $LIMIT entries"
  fi

  # Dry run: just list entries
  if [[ "$DRY_RUN" == "true" ]]; then
    log "Entries that would be processed:"
    echo "$entries_list" | while read -r entry; do
      local name
      name=$(grep "^project_name:" "$entry" | awk '{print $2}')
      echo "  $name — $entry"
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

    # Progress summary every 10 entries
    if (( processed % 10 == 0 )); then
      log "Progress: $classified classified, $unclassifiable unclassifiable, $errors errors out of $processed processed"
    fi
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
    'mode': '$MODE',
    'model': '$MODEL',
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
