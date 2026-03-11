#!/usr/bin/env bash
# classify-tooluse.sh — Classify a repo using native LLM tool-calling
#
# System prompt is assembled at runtime from the discover skill (ADR-005):
#   skills/discover-architecture/SKILL.md + references/styles.md +
#   references/catalog-entry.template.j2
#
# Usage:
#   pipeline/classify-tooluse.sh --repo <URL> --name <project> [OPTIONS]
#
# Options:
#   --repo <URL>       Repository URL to clone
#   --name <NAME>      Project name (for output)
#   --model <ID>       Model to use (default: openrouter/z-ai/glm-5)
#   --chain-limit <N>  Max tool-calling rounds (default: 15)
#   --clone-dir <DIR>  Clone cache directory (default: .clone-cache)
#   --verbose          Show tool debug output
#   --dry-run          Show what would be done without calling the model
#   --show-prompt      Print the assembled system prompt and exit

set -uo pipefail

MODEL="openrouter/z-ai/glm-5"
CHAIN_LIMIT=15
CLONE_DIR=".clone-cache"
VERBOSE=false
DRY_RUN=false
SHOW_PROMPT=false
REPO_URL=""
PROJECT_NAME=""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
TOOLS_FILE="${SCRIPT_DIR}/tools/repo_tools.py"

# Discover skill files (ADR-005: single source of truth)
SKILL_DIR="${REPO_ROOT_DIR}/skills/discover-architecture"
SKILL_FILE="${SKILL_DIR}/SKILL.md"
STYLES_FILE="${SKILL_DIR}/references/styles.md"
CATALOG_TEMPLATE="${SKILL_DIR}/references/catalog-entry.template.j2"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)         REPO_URL="$2"; shift 2 ;;
    --name)         PROJECT_NAME="$2"; shift 2 ;;
    --model)        MODEL="$2"; shift 2 ;;
    --chain-limit)  CHAIN_LIMIT="$2"; shift 2 ;;
    --clone-dir)    CLONE_DIR="$2"; shift 2 ;;
    --verbose)      VERBOSE=true; shift ;;
    --dry-run)      DRY_RUN=true; shift ;;
    --show-prompt)  SHOW_PROMPT=true; shift ;;
    -h|--help)      head -20 "$0" | grep '^#' | sed 's/^# \?//'; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [[ "$SHOW_PROMPT" != "true" ]] && [[ -z "$REPO_URL" || -z "$PROJECT_NAME" ]]; then
  echo "Error: --repo and --name are required" >&2
  exit 1
fi

if [[ "$SHOW_PROMPT" != "true" ]] && ! command -v llm &>/dev/null; then
  echo "Error: 'llm' CLI not found" >&2
  exit 1
fi

log() { echo "[$(date +%H:%M:%S)] $*" >&2; }

# ── Prompt assembly (ADR-005) ────────────────────────────────────────────────
# Reads the discover skill files and assembles them into a system prompt
# for non-Anthropic models via the llm CLI.
assemble_system_prompt() {
  for f in "$SKILL_FILE" "$STYLES_FILE" "$CATALOG_TEMPLATE"; do
    if [[ ! -f "$f" ]]; then
      echo "Error: discover skill file not found: $f" >&2
      exit 1
    fi
  done

  # Extract SKILL.md body (strip YAML frontmatter)
  local skill_body
  skill_body=$(awk 'BEGIN{f=0} /^---$/{f++; next} f>=2{print}' "$SKILL_FILE")

  local styles_content
  styles_content=$(cat "$STYLES_FILE")

  local catalog_template
  catalog_template=$(cat "$CATALOG_TEMPLATE")

  cat <<PROMPT
You are an expert software architect classifying repository architectures.
You have tool access to a cloned repository — use the tools to explore
the codebase and determine its architecture style(s).

## Your tools

- \`directory_tree(path, depth)\` — explore directory structure
- \`read_file(path, max_lines)\` — read source files, configs, READMEs
- \`find_files(pattern)\` — glob search for files (e.g. \`**/*.proto\`, \`**/Dockerfile\`)
- \`search_content(pattern, path, file_glob)\` — grep for code patterns
- \`shell_command(command)\` — run shell commands (ls, wc, head, find, etc.)

## Classification Methodology

${skill_body}

## Style Reference (full definitions and frequency data)

${styles_content}

## Catalog Entry Output Schema

When you have gathered sufficient evidence, produce your final classification
as YAML matching this schema, followed by your full analysis as markdown:

\`\`\`yaml
${catalog_template}
\`\`\`

Replace the Jinja2 placeholders with actual values. The pipeline will inject
\`classification_model\`, \`classification_method\`, and \`classification_date\`
at write time — you do not need to include these.

Produce the YAML as frontmatter (between \`---\` delimiters) at the start of
your final response, followed by the full analysis report as markdown body.
PROMPT
}

# ── Clone repo ────────────────────────────────────────────────────────────────
clone_repo() {
  local url="$1" name="$2"
  local clone_path="${CLONE_DIR}/${name}"

  if [[ -d "$clone_path/.git" ]]; then
    log "Using cached clone: $clone_path"
  else
    log "Cloning $url → $clone_path"
    mkdir -p "$CLONE_DIR"
    git clone --depth 1 "$url" "$clone_path" 2>/dev/null
  fi

  echo "$clone_path"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  local system_prompt
  system_prompt=$(assemble_system_prompt)

  if [[ "$SHOW_PROMPT" == "true" ]]; then
    echo "$system_prompt"
    exit 0
  fi

  local clone_path
  clone_path=$(clone_repo "$REPO_URL" "$PROJECT_NAME")

  if [[ ! -d "$clone_path" ]]; then
    echo "Error: clone failed for $REPO_URL" >&2
    exit 1
  fi

  local user_prompt="Classify the architecture of the **${PROJECT_NAME}** repository.

The repository is cloned and available via your tools. Start exploring and classify when you have sufficient evidence.

Repository: ${REPO_URL}"

  if [[ "$DRY_RUN" == "true" ]]; then
    log "DRY RUN — would classify $PROJECT_NAME"
    log "  Model: $MODEL"
    log "  Repo: $REPO_URL"
    log "  Clone: $clone_path"
    log "  Chain limit: $CHAIN_LIMIT"
    log "  Prompt source: discover skill (ADR-005)"
    exit 0
  fi

  log "Classifying $PROJECT_NAME with $MODEL (chain-limit=$CHAIN_LIMIT)"
  log "  Prompt: assembled from discover skill (ADR-005)"

  local tool_debug_flag=""
  if [[ "$VERBOSE" == "true" ]]; then
    tool_debug_flag="--td"
  fi

  # Run classification with native tool-calling
  REPO_ROOT="$clone_path" llm prompt \
    -m "$MODEL" \
    -s "$system_prompt" \
    --functions "$TOOLS_FILE" \
    --chain-limit "$CHAIN_LIMIT" \
    $tool_debug_flag \
    "$user_prompt" 2>/dev/null

  local exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    log "Error: llm exited with code $exit_code"
    exit $exit_code
  fi
}

main "$@"
