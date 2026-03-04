#!/usr/bin/env bash
# llm-validate.sh — Deep-context classification validation
#
# Re-validates catalog classifications by cloning repos and feeding actual
# source files, config files, and architecture docs to the LLM. Compares
# new classifications against existing ones to produce verification verdicts.
#
# Usage:
#   pipeline/llm-validate.sh [OPTIONS]
#
# Options:
#   --priority <1|2|3|4|all>  Population to validate (default: all)
#   --limit <N>               Process at most N entries
#   --entry <name.yaml>       Process a single specific entry
#   --model <ID>              LLM model (default: from llm config)
#   --clone-dir <PATH>        Directory for cached repo clones
#   --dry-run                 List entries without processing
#   --catalog <PATH>          Catalog directory
#   --verbose                 Show detailed progress

set -uo pipefail

# ── Defaults ──────────────────────────────────────────────────────────────────
PRIORITY="all"
LIMIT=0
SINGLE_ENTRY=""
MODEL=""
CLONE_DIR=""
DRY_RUN=false
CATALOG_DIR="evidence-analysis/Discovered/docs/catalog"
VERBOSE=false

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPTS_DIR="${SCRIPT_DIR}/prompts"
REPORTS_DIR="${SCRIPT_DIR}/reports"
SYSTEM_PROMPT="${PROMPTS_DIR}/system-prompt.md"
VALIDATION_PROMPT="${PROMPTS_DIR}/validation-prompt.md"

# ── Repo map exclusion list (shared with llm-review.sh) ──────────────────────
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

# ── Deep context config files to look for ────────────────────────────────────
DEEP_CONFIG_FILES=(
  docker-compose.yml docker-compose.yaml
  Dockerfile
  serverless.yml serverless.yaml
  ARCHITECTURE.md
  Makefile
)

DEEP_CONFIG_GLOBS=(
  "k8s/*.yaml" "kubernetes/*.yaml" "deploy/*.yaml"
  "terraform/*.tf"
  "*/Dockerfile"
  "docs/adr/*.md" "docs/ADR/*.md"
)

# ── CLI parsing ───────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --priority)   PRIORITY="$2"; shift 2 ;;
    --limit)      LIMIT="$2"; shift 2 ;;
    --entry)      SINGLE_ENTRY="$2"; shift 2 ;;
    --model)      MODEL="$2"; shift 2 ;;
    --clone-dir)  CLONE_DIR="$2"; shift 2 ;;
    --dry-run)    DRY_RUN=true; shift ;;
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

if [[ ! -f "$VALIDATION_PROMPT" ]]; then
  echo "Error: validation prompt not found: $VALIDATION_PROMPT" >&2
  exit 1
fi

mkdir -p "$REPORTS_DIR"
[[ -n "$CLONE_DIR" ]] && mkdir -p "$CLONE_DIR"

# ── Logging ───────────────────────────────────────────────────────────────────
log() { echo "[$(date +%H:%M:%S)] $*" >&2; }
verbose() { [[ "$VERBOSE" == "true" ]] && log "$*" || true; }

# ── get_classification_method: read method from catalog YAML ─────────────────
get_classification_method() {
  local yaml_file="$1"
  grep "classification_method:" "$yaml_file" 2>/dev/null | head -1 | awk '{print $2}' | tr -d '"'
}

# ── get_confidence: read confidence from catalog YAML ────────────────────────
get_confidence() {
  local yaml_file="$1"
  grep "^  confidence:" "$yaml_file" 2>/dev/null | head -1 | awk '{print $2}'
}

# ── get_styles: read architecture_styles from catalog YAML ───────────────────
get_styles() {
  local yaml_file="$1"
  python3 -c "
import sys
styles = []
in_styles = False
for line in open('$yaml_file'):
    line = line.rstrip()
    if line == 'architecture_styles:':
        in_styles = True
        continue
    if in_styles and line.startswith('  - '):
        styles.append(line.strip('- ').strip())
        continue
    if in_styles and not line.startswith('  '):
        break
print(','.join(styles))
" 2>/dev/null
}

# ── scan_entries: find catalog entries matching priority criteria ─────────────
scan_entries() {
  local entries=()

  # Single entry mode
  if [[ -n "$SINGLE_ENTRY" ]]; then
    local path="$SINGLE_ENTRY"
    if [[ ! -f "$path" ]]; then
      path="$CATALOG_DIR/$SINGLE_ENTRY"
    fi
    if [[ -f "$path" ]]; then
      echo "$path"
    fi
    return
  fi

  for yaml_file in "$CATALOG_DIR"/*.yaml; do
    [[ -f "$yaml_file" ]] || continue

    local method confidence styles review_required
    method=$(get_classification_method "$yaml_file")
    confidence=$(get_confidence "$yaml_file")
    styles=$(get_styles "$yaml_file")
    review_required=$(grep "^review_required:" "$yaml_file" | head -1 | awk '{print $2}')

    local matches=false

    case "$PRIORITY" in
      1) # Heuristic-only: never LLM-reviewed, not indeterminate
        if [[ "$method" != "llm-review" && "$review_required" != "true" && "$styles" != "Indeterminate" ]]; then
          matches=true
        fi
        ;;
      2) # LLM-classified, low confidence (< 0.85)
        if [[ "$method" == "llm-review" && -n "$confidence" ]]; then
          if (( $(echo "$confidence < 0.85" | bc -l) )); then
            matches=true
          fi
        fi
        ;;
      3) # LLM-classified, high confidence (>= 0.85)
        if [[ "$method" == "llm-review" && -n "$confidence" ]]; then
          if (( $(echo "$confidence >= 0.85" | bc -l) )); then
            matches=true
          fi
        fi
        ;;
      4) # Unclassifiable: indeterminate + not review_required
        if [[ "$styles" == "Indeterminate" && "$review_required" != "true" ]]; then
          matches=true
        fi
        ;;
      all)
        # Everything that has been classified (not still review_required)
        if [[ "$review_required" != "true" ]]; then
          matches=true
        fi
        ;;
    esac

    if [[ "$matches" == "true" ]]; then
      entries+=("$yaml_file")
    fi
  done

  printf '%s\n' "${entries[@]}"
}

# ── ensure_clone: always clone — this is the key difference from llm-review ──
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
    verbose "Using cached clone: $CLONE_DIR/$repo_name"
    echo "$CLONE_DIR/$repo_name"
    return
  fi

  # Clone to cache dir if provided, otherwise temp
  local target_dir
  if [[ -n "$CLONE_DIR" ]]; then
    target_dir="$CLONE_DIR"
  else
    target_dir=$(mktemp -d)
  fi

  verbose "Cloning $repo_url..."
  if timeout 120 git clone --depth 1 --quiet "$repo_url" "$target_dir/$repo_name" 2>/dev/null; then
    echo "$target_dir/$repo_name"
  else
    [[ -z "$CLONE_DIR" ]] && rm -rf "$target_dir"
    echo ""
  fi
}

# ── repo_map: generate directory tree (depth 4 for deep context) ─────────────
repo_map() {
  local clone_path="$1"
  local base_path="${2:-.}"
  local depth="${3:-4}"

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

# ── deep_context_files: collect config files and architecture docs ───────────
deep_context_files() {
  local clone_path="$1"
  local context=""

  # Direct config files
  for f in "${DEEP_CONFIG_FILES[@]}"; do
    if [[ -f "$clone_path/$f" ]]; then
      local lines
      lines=$(wc -l < "$clone_path/$f" | tr -d ' ')
      context+="\n### $f ($lines lines)\n\n\`\`\`\n"
      context+="$(head -200 "$clone_path/$f")"
      context+="\n\`\`\`\n"
    fi
  done

  # Glob-matched files
  for pattern in "${DEEP_CONFIG_GLOBS[@]}"; do
    local matches
    matches=$(cd "$clone_path" && find . -path "./.git" -prune -o -path "./$pattern" -print 2>/dev/null | head -5)
    if [[ -n "$matches" ]]; then
      while IFS= read -r match; do
        [[ -z "$match" ]] && continue
        local clean_path="${match#./}"
        if [[ -f "$clone_path/$clean_path" ]]; then
          context+="\n### $clean_path\n\n\`\`\`\n"
          context+="$(head -100 "$clone_path/$clean_path")"
          context+="\n\`\`\`\n"
        fi
      done <<< "$matches"
    fi
  done

  echo -e "$context"
}

# ── source_structure: summarize top-level source dirs with file counts ───────
source_structure() {
  local clone_path="$1"
  local structure=""

  # Count files by extension in top-level directories
  structure+="### Source File Counts by Directory\n\n"
  structure+="\`\`\`\n"

  for dir in "$clone_path"/*/; do
    [[ -d "$dir" ]] || continue
    local dirname
    dirname=$(basename "$dir")

    # Skip pruned directories
    local skip=false
    for prune in "${FIND_PRUNE_DIRS[@]}"; do
      if [[ "$dirname" == "$prune" ]]; then
        skip=true
        break
      fi
    done
    [[ "$skip" == "true" ]] && continue

    local count
    count=$(find "$dir" -type f 2>/dev/null | wc -l | tr -d ' ')
    if [[ $count -gt 0 ]]; then
      # Get top 3 extensions
      local exts
      exts=$(find "$dir" -type f -name "*.*" 2>/dev/null \
        | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -3 \
        | awk '{printf "%s(%d) ", $2, $1}')
      structure+="$dirname/ — $count files [$exts]\n"
    fi
  done

  structure+="\`\`\`\n"
  echo -e "$structure"
}

# ── assemble_deep_context: build payload with cloned repo context ────────────
assemble_deep_context() {
  local yaml_file="$1"
  local clone_path="$2"
  local context=""

  # Catalog YAML with existing classification
  context+="## Catalog Entry (YAML)\n\n\`\`\`yaml\n"
  context+="$(cat "$yaml_file")"
  context+="\n\`\`\`\n\n"

  if [[ -z "$clone_path" || ! -d "$clone_path" ]]; then
    context+="## Note\n\nFailed to clone repository. Cannot perform deep-context validation.\n\n"
    echo -e "$context"
    return
  fi

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

  # Repo map (depth 4, not 3)
  context+="## Repository Map (depth 4)\n\n\`\`\`\n"
  context+="$(repo_map "$clone_path")"
  context+="\n\`\`\`\n\n"

  # Deep context: config files, Dockerfiles, k8s, terraform, architecture docs
  context+="## Deep Context: Configuration & Architecture Files\n"
  context+="$(deep_context_files "$clone_path")"
  context+="\n"

  # Source structure summary
  context+="## Source Structure Summary\n\n"
  context+="$(source_structure "$clone_path")"
  context+="\n"

  echo -e "$context"
}

# ── build_validation_prompt: fill in the validation prompt template ──────────
build_validation_prompt() {
  local yaml_file="$1"

  local existing_styles existing_confidence existing_method existing_notes

  existing_styles=$(get_styles "$yaml_file")
  [[ -z "$existing_styles" ]] && existing_styles="Indeterminate"

  existing_confidence=$(get_confidence "$yaml_file")
  [[ -z "$existing_confidence" ]] && existing_confidence="unknown"

  existing_method=$(get_classification_method "$yaml_file")
  [[ -z "$existing_method" ]] && existing_method="heuristic"

  existing_notes=$(grep "^review_notes:" "$yaml_file" 2>/dev/null | head -1 | sed 's/^review_notes: *//' | tr -d '"')
  [[ -z "$existing_notes" ]] && existing_notes="none"

  # Read template and substitute
  local prompt
  prompt=$(cat "$VALIDATION_PROMPT")
  prompt="${prompt//\{\{EXISTING_STYLES\}\}/$existing_styles}"
  prompt="${prompt//\{\{EXISTING_CONFIDENCE\}\}/$existing_confidence}"
  prompt="${prompt//\{\{EXISTING_METHOD\}\}/$existing_method}"
  prompt="${prompt//\{\{EXISTING_NOTES\}\}/$existing_notes}"

  echo "$prompt"
}

# ── parse_response: extract and validate LLM JSON response ───────────────────
parse_response() {
  local response="$1"

  echo "$response" | python3 -c "
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
" 2>/dev/null
}

# ── get_verdict: extract verdict from parsed JSON ─────────────────────────────
get_verdict() {
  echo "$1" | python3 -c "import sys,json; print(json.load(sys.stdin).get('verdict','error'))" 2>/dev/null || echo "error"
}

# ── compute_validation_verdict: compare new vs existing classification ───────
compute_validation_verdict() {
  local yaml_file="$1"
  local json_response="$2"

  python3 -c "
import sys, json

existing_styles = set('$(get_styles "$yaml_file")'.split(','))
existing_styles.discard('')

response = json.loads('''$json_response''')
verdict = response.get('verdict', 'error')

if verdict == 'unclassifiable':
    if existing_styles and existing_styles != {'Indeterminate'}:
        print('downgraded')
    else:
        print('confirmed')
    sys.exit(0)

if verdict != 'classified':
    print('error')
    sys.exit(0)

new_styles = set(response.get('styles', []))

# Use LLM's own validation_verdict if provided
llm_verdict = response.get('validation_verdict', '')
if llm_verdict in ('confirmed', 'reclassified', 'downgraded', 'upgraded', 'promoted'):
    print(llm_verdict)
    sys.exit(0)

# Compute verdict from style comparison
if existing_styles == {'Indeterminate'} and new_styles:
    print('promoted')
elif new_styles == existing_styles:
    print('confirmed')
elif len(new_styles) < len(existing_styles) and new_styles.issubset(existing_styles):
    print('downgraded')
elif len(new_styles) > len(existing_styles) and existing_styles.issubset(new_styles):
    print('upgraded')
else:
    print('reclassified')
" 2>/dev/null || echo "error"
}

# ── apply_override: decide whether to apply new classification (SPEC-014) ────
apply_override() {
  local yaml_file="$1"
  local json_response="$2"
  local validation_verdict="$3"

  local existing_method existing_confidence new_confidence
  existing_method=$(get_classification_method "$yaml_file")
  existing_confidence=$(get_confidence "$yaml_file")
  new_confidence=$(echo "$json_response" | python3 -c "import sys,json; print(json.load(sys.stdin).get('confidence',0))" 2>/dev/null)

  # Override rules (SPEC-014)
  local decision="defer"

  if [[ "$validation_verdict" == "confirmed" ]]; then
    decision="auto-accept"
  elif [[ -n "$new_confidence" ]] && (( $(echo "$new_confidence >= 0.85" | bc -l) )); then
    if [[ "$existing_method" != "llm-review" ]]; then
      # High-confidence LLM overrides heuristic
      decision="auto-accept"
    elif [[ -n "$existing_confidence" ]] && (( $(echo "$existing_confidence < 0.70" | bc -l) )); then
      # High-confidence deep review overrides low-confidence shallow review
      decision="auto-accept"
    elif [[ -n "$existing_confidence" ]] && (( $(echo "$existing_confidence >= 0.70" | bc -l) )); then
      # Genuine disagreement between two LLM passes
      decision="flag-for-review"
    fi
  elif [[ -n "$new_confidence" ]] && (( $(echo "$new_confidence < 0.70" | bc -l) )); then
    decision="defer"
  else
    decision="flag-for-review"
  fi

  echo "$decision"
}

# ── apply_classification: call apply-review.py with --method flag ────────────
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
    --method "deep-validation"
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

# ── process_entry: full validation pipeline for one entry ────────────────────
process_entry() {
  local yaml_file="$1"
  local project_name
  project_name=$(grep "^project_name:" "$yaml_file" | head -1 | awk '{print $2}')

  log "Processing: $project_name ($yaml_file)"

  # Always clone
  local clone_path
  clone_path=$(ensure_clone "$yaml_file")
  if [[ -z "$clone_path" || ! -d "$clone_path" ]]; then
    log "  SKIP: could not clone repository"
    echo "{\"entry\":\"$(basename "$yaml_file")\",\"verdict\":\"clone_failed\",\"validation_verdict\":\"error\",\"override_decision\":\"defer\",\"styles\":[],\"confidence\":0}"
    return
  fi
  verbose "Clone: $clone_path"

  # Assemble deep context
  local context
  context=$(assemble_deep_context "$yaml_file" "$clone_path")

  # Build validation-specific prompt
  local val_prompt
  val_prompt=$(build_validation_prompt "$yaml_file")

  # Combine system prompt + validation instructions
  local combined_system
  combined_system="$(cat "$SYSTEM_PROMPT")

---

$val_prompt"

  # Call LLM
  verbose "Calling LLM..."
  local model_flag=""
  [[ -n "$MODEL" ]] && model_flag="-m $MODEL"
  local response
  response=$(echo "$context" | llm $model_flag -s "$combined_system" 2>/dev/null || echo '{"verdict":"error"}')

  local json verdict
  json=$(parse_response "$response")
  verdict=$(get_verdict "$json")
  verbose "LLM verdict: $verdict"

  # Compute validation verdict
  local validation_verdict
  validation_verdict=$(compute_validation_verdict "$yaml_file" "$json")
  verbose "Validation verdict: $validation_verdict"

  # Apply override rules
  local override_decision="defer"
  if [[ "$verdict" == "classified" ]]; then
    override_decision=$(apply_override "$yaml_file" "$json" "$validation_verdict")
    verbose "Override decision: $override_decision"

    if [[ "$override_decision" == "auto-accept" ]]; then
      apply_classification "$yaml_file" "$json"
    fi
  fi

  # Clean up temp clone if we created one (not in CLONE_DIR)
  if [[ -n "$clone_path" && -z "$CLONE_DIR" && "$clone_path" == /tmp/* ]]; then
    rm -rf "$(dirname "$clone_path")"
  fi

  # Output result as JSON for report aggregation
  local styles_json="[]"
  local conf="0"
  local existing_styles_str
  existing_styles_str=$(get_styles "$yaml_file")
  if [[ "$verdict" == "classified" ]]; then
    styles_json=$(echo "$json" | python3 -c "import sys,json; print(json.dumps(json.load(sys.stdin).get('styles',[])))" 2>/dev/null)
    conf=$(echo "$json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('confidence',0))" 2>/dev/null)
  fi

  local validation_notes
  validation_notes=$(echo "$json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('validation_notes',''))" 2>/dev/null || echo "")

  echo "{\"entry\":\"$(basename "$yaml_file")\",\"verdict\":\"$verdict\",\"validation_verdict\":\"$validation_verdict\",\"override_decision\":\"$override_decision\",\"existing_styles\":\"$existing_styles_str\",\"new_styles\":$styles_json,\"confidence\":$conf,\"validation_notes\":\"$validation_notes\"}"
}

# ── generate_disagreement_report: markdown report for flagged entries ────────
generate_disagreement_report() {
  local results_json="$1"
  local report_file="${REPORTS_DIR}/disagreements-$(date +%Y%m%d-%H%M%S).md"

  python3 -c "
import json, sys

results = json.loads('''$results_json''')
flagged = [r for r in results if r.get('override_decision') == 'flag-for-review']

if not flagged:
    sys.exit(0)

lines = ['# Deep-Context Validation Disagreements\n']
lines.append(f'Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")')
lines.append(f'Entries flagged: {len(flagged)}\n')

for r in flagged:
    lines.append(f'## {r[\"entry\"]}\n')
    lines.append('| | Existing | Deep-Validation |')
    lines.append('|---|----------|----------------|')
    lines.append(f'| Styles | {r.get(\"existing_styles\", \"?\")} | {\", \".join(r.get(\"new_styles\", []))} |')
    lines.append(f'| Confidence | ? | {r.get(\"confidence\", \"?\")} |')
    lines.append(f'| Verdict | — | {r.get(\"validation_verdict\", \"?\")} |')
    lines.append(f'| Notes | — | {r.get(\"validation_notes\", \"\")} |')
    lines.append('')

with open('$report_file', 'w') as f:
    f.write('\n'.join(lines))

print(f'Disagreement report: $report_file', file=sys.stderr)
" 2>/dev/null

  echo "$report_file"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  log "Deep-Context Validation Pipeline"
  log "  Model: ${MODEL:-default ($(llm models default 2>/dev/null || echo 'unknown'))}"
  log "  Priority: $PRIORITY"
  log "  Catalog: $CATALOG_DIR"
  [[ -n "$CLONE_DIR" ]] && log "  Clone dir: $CLONE_DIR"
  [[ -n "$SINGLE_ENTRY" ]] && log "  Single entry: $SINGLE_ENTRY"
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
      local name styles method conf
      name=$(grep "^project_name:" "$entry" | awk '{print $2}')
      styles=$(get_styles "$entry")
      method=$(get_classification_method "$entry")
      conf=$(get_confidence "$entry")
      echo "  $name — styles=[$styles] method=${method:-heuristic} conf=${conf:-?} — $entry"
    done
    exit 0
  fi

  # Process entries
  local results=()
  local confirmed=0 reclassified=0 downgraded=0 upgraded=0 promoted=0 errors=0 clone_failures=0
  local auto_accepted=0 flagged=0 deferred=0
  local processed=0

  while IFS= read -r entry; do
    processed=$((processed + 1))
    log "[$processed/$entry_count] Processing..."

    local result
    result=$(process_entry "$entry")
    results+=("$result")

    # Parse result for counters
    local val_verdict override_dec
    val_verdict=$(echo "$result" | python3 -c "import sys,json; print(json.load(sys.stdin).get('validation_verdict','error'))" 2>/dev/null)
    override_dec=$(echo "$result" | python3 -c "import sys,json; print(json.load(sys.stdin).get('override_decision','defer'))" 2>/dev/null)

    case "$val_verdict" in
      confirmed) confirmed=$((confirmed + 1)) ;;
      reclassified) reclassified=$((reclassified + 1)) ;;
      downgraded) downgraded=$((downgraded + 1)) ;;
      upgraded) upgraded=$((upgraded + 1)) ;;
      promoted) promoted=$((promoted + 1)) ;;
      error) errors=$((errors + 1)) ;;
    esac

    case "$override_dec" in
      auto-accept) auto_accepted=$((auto_accepted + 1)) ;;
      flag-for-review) flagged=$((flagged + 1)) ;;
      defer) deferred=$((deferred + 1)) ;;
    esac

    # Check for clone failures
    local entry_verdict
    entry_verdict=$(echo "$result" | python3 -c "import sys,json; print(json.load(sys.stdin).get('verdict','error'))" 2>/dev/null)
    [[ "$entry_verdict" == "clone_failed" ]] && clone_failures=$((clone_failures + 1))
  done <<< "$entries_list"

  # Build results JSON
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

  # Generate verification report
  local report_file="${REPORTS_DIR}/validation-deep-$(date +%Y%m%d-%H%M%S).json"

  python3 -c "
import json

report = {
    'run_id': '$(date -u +"%Y-%m-%dT%H:%M:%SZ")',
    'model': '$MODEL',
    'priority': '$PRIORITY',
    'entries_processed': $processed,
    'verdicts': {
        'confirmed': $confirmed,
        'reclassified': $reclassified,
        'downgraded': $downgraded,
        'upgraded': $upgraded,
        'promoted': $promoted,
        'errors': $errors,
        'clone_failures': $clone_failures,
    },
    'override_decisions': {
        'auto_accepted': $auto_accepted,
        'flagged_for_review': $flagged,
        'deferred': $deferred,
    },
    'results': json.loads('''$results_json''')
}

with open('$report_file', 'w') as f:
    json.dump(report, f, indent=2)
" 2>/dev/null

  # Generate disagreement report if any flagged
  if [[ $flagged -gt 0 ]]; then
    generate_disagreement_report "$results_json"
  fi

  log ""
  log "Validation complete."
  log "  Processed:      $processed"
  log "  Clone failures: $clone_failures"
  log ""
  log "  Verdicts:"
  log "    Confirmed:     $confirmed"
  log "    Reclassified:  $reclassified"
  log "    Downgraded:    $downgraded"
  log "    Upgraded:      $upgraded"
  log "    Promoted:      $promoted"
  log "    Errors:        $errors"
  log ""
  log "  Override decisions:"
  log "    Auto-accepted:    $auto_accepted"
  log "    Flagged for review: $flagged"
  log "    Deferred:         $deferred"
  log ""
  log "  Report: $report_file"
}

main "$@"
