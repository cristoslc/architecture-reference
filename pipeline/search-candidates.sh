#!/usr/bin/env bash
# search-candidates.sh — Search GitHub for architecture catalog candidates
#
# Searches GitHub via `gh search repos`, deduplicates against manifest.yaml,
# and outputs ranked results as TSV.
#
# Usage:
#   pipeline/search-candidates.sh <style> [--min-stars N] [--limit N]
#
# Styles: Service-Based, Space-Based, Multi-Agent
#
# Output: TSV sorted by stars (name, stars, forks, language, URL, description)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="$SCRIPT_DIR/manifest.yaml"

# --- Defaults ---
MIN_STARS=500
LIMIT=30

# --- Parse args ---
STYLE="${1:-}"
shift || true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --min-stars) MIN_STARS="$2"; shift 2 ;;
    --limit)    LIMIT="$2"; shift 2 ;;
    *)          echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$STYLE" ]]; then
  echo "Usage: $0 <style> [--min-stars N] [--limit N]" >&2
  echo "Styles: Service-Based, Space-Based, Multi-Agent" >&2
  exit 1
fi

# --- Check gh is available ---
if ! command -v gh &>/dev/null; then
  echo "Error: gh CLI not found. Install from https://cli.github.com/" >&2
  exit 1
fi

# --- Extract manifest URLs for dedup ---
manifest_urls() {
  grep -E '^\s+- url:' "$MANIFEST" | sed 's/.*url:\s*//' | tr -d '"' | tr -d "'"
}

MANIFEST_URLS=$(manifest_urls)

is_in_manifest() {
  local url="$1"
  echo "$MANIFEST_URLS" | grep -qF "$url"
}

# --- Search functions ---
gh_search() {
  local query="$1"
  gh search repos "$query" \
    --stars ">=${MIN_STARS}" \
    --limit "$LIMIT" \
    --json fullName,stargazersCount,forksCount,language,url,description \
    --jq '.[] | [.fullName, (.stargazersCount | tostring), (.forksCount | tostring), (.language // "Unknown"), .url, (.description // "")] | @tsv' \
    2>/dev/null || true
}

gh_search_topic() {
  local topic="$1"
  gh search repos "topic:${topic}" \
    --stars ">=${MIN_STARS}" \
    --limit "$LIMIT" \
    --json fullName,stargazersCount,forksCount,language,url,description \
    --jq '.[] | [.fullName, (.stargazersCount | tostring), (.forksCount | tostring), (.language // "Unknown"), .url, (.description // "")] | @tsv' \
    2>/dev/null || true
}

# --- Style-specific search strategies ---
search_service_based() {
  echo "# Searching for Service-Based candidates..." >&2

  # Track 1: Single-repo platforms with multi-service docker-compose
  gh_search "docker-compose services backend self-hosted"
  gh_search "backend-as-a-service self-hosted"
  gh_search_topic "self-hosted"
  gh_search_topic "backend-as-a-service"

  # Track 2: Ecosystem / coordination platforms
  gh_search "media server automation stack"
  gh_search "homelab services integration"
  gh_search_topic "homelab"
  gh_search_topic "media-server"
  gh_search_topic "devops-platform"
}

search_space_based() {
  echo "# Searching for Space-Based candidates..." >&2

  gh_search_topic "data-grid"
  gh_search_topic "in-memory-database"
  gh_search_topic "distributed-cache"
  gh_search_topic "actor-model"
  gh_search_topic "virtual-actor"
  gh_search "in-memory data grid"
  gh_search "distributed cache framework"
  gh_search "actor framework virtual"
}

search_multi_agent() {
  echo "# Searching for Multi-Agent candidates..." >&2

  gh_search_topic "multi-agent"
  gh_search_topic "ai-agents"
  gh_search_topic "agent-framework"
  gh_search_topic "llm-agents"
  gh_search "multi-agent system framework"
  gh_search "agent orchestration LLM"
  gh_search "agentic framework"
}

# --- Run search based on style ---
case "$STYLE" in
  Service-Based|service-based)
    raw=$(search_service_based) ;;
  Space-Based|space-based)
    raw=$(search_space_based) ;;
  Multi-Agent|multi-agent)
    raw=$(search_multi_agent) ;;
  *)
    echo "Error: unknown style '$STYLE'" >&2
    echo "Supported: Service-Based, Space-Based, Multi-Agent" >&2
    exit 1 ;;
esac

# --- Deduplicate and filter ---
echo -e "NAME\tSTARS\tFORKS\tLANGUAGE\tURL\tDESCRIPTION"

seen=()
echo "$raw" | sort -t$'\t' -k2 -rn | while IFS=$'\t' read -r name stars forks lang url desc; do
  [[ -z "$name" ]] && continue

  # Skip if already in manifest
  if is_in_manifest "$url"; then
    echo "# SKIP (in manifest): $name" >&2
    continue
  fi

  # Skip duplicates
  skip=false
  for s in "${seen[@]+"${seen[@]}"}"; do
    if [[ "$s" == "$url" ]]; then
      skip=true
      break
    fi
  done
  $skip && continue

  seen+=("$url")
  echo -e "${name}\t${stars}\t${forks}\t${lang}\t${url}\t${desc}"
done
