#!/usr/bin/env bash
# extract-signals.sh — Scan a repository and output a structured signal report
#
# Usage:
#   bash scripts/extract-signals.sh /path/to/repo
#
# Output:
#   YAML signal report to stdout. Consumed by the agent for classification
#   using the rules in references/signal-rules.md.
#
# Requires: git, find, grep
# Does NOT modify the target repository.

set -uo pipefail

# Note: -e is intentionally omitted. Many detection commands use grep which
# returns non-zero when no match is found — that's expected, not an error.

if [ $# -lt 1 ]; then
  echo "Usage: bash scripts/extract-signals.sh /path/to/repo" >&2
  exit 1
fi

REPO_PATH="$1"

if [ ! -d "$REPO_PATH" ]; then
  echo "Error: directory not found: $REPO_PATH" >&2
  exit 1
fi

cd "$REPO_PATH"

# --- Helpers ---

count_glob() {
  # Count files matching a glob pattern (recursive)
  local pattern="$1"
  find . -path './.git' -prune -o -name "$pattern" -print 2>/dev/null | grep -v '^\./\.git' | wc -l | tr -d ' '
}

count_path() {
  # Count files under a path pattern
  local pattern="$1"
  find . -path './.git' -prune -o -path "$pattern" -print 2>/dev/null | grep -v '^\./\.git' | wc -l | tr -d ' '
}

dir_exists() {
  # Check if any directory matching pattern exists (case-insensitive)
  local pattern="$1"
  find . -path './.git' -prune -o -path './node_modules' -prune -o -path './vendor' -prune -o -type d -iname "$pattern" -print 2>/dev/null | grep -v '^\./\.git' | head -1 | grep -q .
}

file_contains() {
  # Check if any file matching glob contains a pattern
  local glob="$1" pattern="$2"
  find . -path './.git' -prune -o -name "$glob" -print 2>/dev/null | grep -v '^\./\.git' | head -20 | xargs grep -l "$pattern" 2>/dev/null | head -1 | grep -q .
}

# --- Git metadata ---
PROJECT_NAME="$(basename "$REPO_PATH")"
GIT_REMOTE=""
if [ -d .git ] || git rev-parse --git-dir >/dev/null 2>&1; then
  GIT_REMOTE="$(git remote get-url origin 2>/dev/null || echo "")"
fi

# --- GitHub metadata (with retry, backoff, wait on rate limit, and optional token) ---
GITHUB_STARS=0
GITHUB_FORKS=0
GITHUB_OPEN_ISSUES=0
GITHUB_WATCHERS=0
GITHUB_LICENSE=""

# Check for GitHub token in environment (set GITHUB_TOKEN=xxx before running)
# Without token: 60 requests/hour, with token: 5000 requests/hour
if [[ "$GIT_REMOTE" == *"github.com"* ]]; then
    GITHUB_REPO="$(echo "$GIT_REMOTE" | sed -E 's|.*github\.com/||; s|\.git$||')"
    
    # Try up to 3 times with exponential backoff
    delay=2
    for attempt in 1 2 3; do
        # Build curl command dynamically
        if [[ -n "${GITHUB_TOKEN:-}" ]]; then
            response="$(curl -s --max-time 30 -H "Accept: application/vnd.github.v3+json" -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_REPO")"
        else
            response="$(curl -s --max-time 30 -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$GITHUB_REPO")"
        fi
        
        # Skip if empty or looks like error
        if [[ -z "$response" || "$response" == "<"* ]]; then
            sleep $delay
            delay=$((delay * 2))
            continue
        fi
        
        # Success - parse the data (check if valid JSON first)
        if echo "$response" | python3 -c "import sys,json; json.load(sys.stdin)" 2>/dev/null; then
            GITHUB_STARS="$(echo "$response" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('stargazers_count',0))" 2>/dev/null || echo "0")"
            GITHUB_FORKS="$(echo "$response" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('forks_count',0))" 2>/dev/null || echo "0")"
            GITHUB_OPEN_ISSUES="$(echo "$response" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('open_issues_count',0))" 2>/dev/null || echo "0")"
            GITHUB_WATCHERS="$(echo "$response" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('watchers_count',0))" 2>/dev/null || echo "0")"
            GITHUB_LICENSE="$(echo "$response" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('license',{}).get('spdx_id',''))" 2>/dev/null || echo "")"
            break
        fi
        
        sleep $delay
        delay=$((delay * 2))
    done
fi

# --- Primary language detection ---
# Count files by extension, map to language names, deduplicate
detect_language() {
  case "$1" in
    ts|tsx) echo "TypeScript" ;;
    js|jsx|mjs|cjs) echo "JavaScript" ;;
    py) echo "Python" ;;
    java|kt|kts) echo "Java/Kotlin" ;;
    go) echo "Go" ;;
    cs|fs) echo "C#" ;;
    rs) echo "Rust" ;;
    rb) echo "Ruby" ;;
    php) echo "PHP" ;;
    swift) echo "Swift" ;;
    cpp|cc|cxx|c|h|hpp) echo "C/C++" ;;
    *) ;;
  esac
}

# Get top extensions by file count (excluding vendored dirs)
TOP_EXTS="$(find . -path './.git' -prune -o -path './node_modules' -prune -o -path './vendor' -prune -o -path './.next' -prune -o -path './dist' -prune -o -path './build' -prune -o -type f -name '*.*' -print 2>/dev/null | grep -v '^\./\.git' | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -20 | awk '{print $2}')"

LANGUAGES_YAML=""
PRIMARY_LANGUAGE=""
SEEN_LANGS=""
for ext in $TOP_EXTS; do
  lang="$(detect_language "$ext")"
  if [ -n "$lang" ]; then
    # Deduplicate
    case "$SEEN_LANGS" in
      *"|${lang}|"*) continue ;;
    esac
    SEEN_LANGS="${SEEN_LANGS}|${lang}|"
    if [ -z "$PRIMARY_LANGUAGE" ]; then
      PRIMARY_LANGUAGE="$lang"
    fi
    LANGUAGES_YAML="${LANGUAGES_YAML}
  - ${lang}"
  fi
done

# --- Signal extraction ---

# 1. Package manifests
PACKAGE_JSON=$(count_glob "package.json")
GO_MOD=$(count_glob "go.mod")
POM_XML=$(count_glob "pom.xml")
BUILD_GRADLE=$(( $(count_glob "build.gradle") + $(count_glob "build.gradle.kts") ))
REQUIREMENTS_TXT=$(( $(count_glob "requirements.txt") + $(count_glob "pyproject.toml") + $(count_glob "Pipfile") ))
CSPROJ=$(count_glob "*.csproj")
SLN=$(count_glob "*.sln")
CARGO_TOML=$(count_glob "Cargo.toml")
SETUP_PY=$(count_glob "setup.py")

MANIFEST_COUNT=0
ECOSYSTEM_COUNT=0
[ "$PACKAGE_JSON" -gt 0 ] && MANIFEST_COUNT=$((MANIFEST_COUNT + PACKAGE_JSON)) && ECOSYSTEM_COUNT=$((ECOSYSTEM_COUNT + 1))
[ "$GO_MOD" -gt 0 ] && MANIFEST_COUNT=$((MANIFEST_COUNT + GO_MOD)) && ECOSYSTEM_COUNT=$((ECOSYSTEM_COUNT + 1))
[ "$POM_XML" -gt 0 ] && MANIFEST_COUNT=$((MANIFEST_COUNT + POM_XML)) && ECOSYSTEM_COUNT=$((ECOSYSTEM_COUNT + 1))
[ "$BUILD_GRADLE" -gt 0 ] && MANIFEST_COUNT=$((MANIFEST_COUNT + BUILD_GRADLE)) && ECOSYSTEM_COUNT=$((ECOSYSTEM_COUNT + 1))
[ "$REQUIREMENTS_TXT" -gt 0 ] && MANIFEST_COUNT=$((MANIFEST_COUNT + REQUIREMENTS_TXT)) && ECOSYSTEM_COUNT=$((ECOSYSTEM_COUNT + 1))
[ "$CSPROJ" -gt 0 ] && MANIFEST_COUNT=$((MANIFEST_COUNT + CSPROJ)) && ECOSYSTEM_COUNT=$((ECOSYSTEM_COUNT + 1))
[ "$CARGO_TOML" -gt 0 ] && MANIFEST_COUNT=$((MANIFEST_COUNT + CARGO_TOML)) && ECOSYSTEM_COUNT=$((ECOSYSTEM_COUNT + 1))

# 2. Container orchestration
DOCKERFILES=$(count_glob "Dockerfile")
# Also count Dockerfile.* variants
DOCKERFILES=$((DOCKERFILES + $(find . -path './.git' -prune -o -name 'Dockerfile.*' -print 2>/dev/null | grep -v '^\./\.git' | wc -l | tr -d ' ') ))
DOCKER_COMPOSE=$(( $(count_glob "docker-compose.yml") + $(count_glob "docker-compose.yaml") + $(count_glob "compose.yml") + $(count_glob "compose.yaml") ))
DOCKER_COMPOSE_SERVICES=0
if [ "$DOCKER_COMPOSE" -gt 0 ]; then
  # Count services defined in compose files
  DOCKER_COMPOSE_SERVICES=$(find . -path './.git' -prune -o \( -name 'docker-compose.yml' -o -name 'docker-compose.yaml' -o -name 'compose.yml' -o -name 'compose.yaml' \) -print 2>/dev/null | grep -v '^\./\.git' | head -1 | xargs grep -c '^\s\+[a-z]' 2>/dev/null || echo 0)
fi
K8S_MANIFESTS=$(grep -rl 'kind: Deployment\|kind: Service\|kind: StatefulSet\|kind: DaemonSet' --include='*.yaml' --include='*.yml' . 2>/dev/null | grep -v '\.git/' | wc -l | tr -d ' ')
HELM_CHARTS=$(count_glob "Chart.yaml")

CONTAINER_COUNT=$((DOCKERFILES + DOCKER_COMPOSE + K8S_MANIFESTS + HELM_CHARTS))

# 3. Infrastructure as Code
TERRAFORM=$(count_glob "*.tf")
CLOUDFORMATION=0
if grep -rql 'AWSTemplateFormatVersion' --include='*.yaml' --include='*.json' . --exclude-dir=.git 2>/dev/null; then CLOUDFORMATION=1; fi
PULUMI=$(count_glob "Pulumi.yaml")
BICEP=$(count_glob "*.bicep")
CDK_JSON=$(count_glob "cdk.json")
SERVERLESS_YML=$(( $(count_glob "serverless.yml") + $(count_glob "serverless.ts") ))
SAM_TEMPLATE=0
if grep -rql 'AWS::Serverless' --include='template.yaml' . --exclude-dir=.git 2>/dev/null; then SAM_TEMPLATE=1; fi
LAMBDA_DIRS=$(find . -path './.git' -prune -o -type d \( -name 'lambda' -o -name 'lambdas' -o -name 'functions' \) -print 2>/dev/null | grep -v '^\./\.git' | wc -l | tr -d ' ')
# Azure Functions / Google Cloud Functions detection
AZURE_FUNCTIONS=$(find . -path './.git' -prune -o -path './node_modules' -prune -o -type d -iname '*functionapp*' -print 2>/dev/null | grep -v '^\./\.git' | wc -l | tr -d ' ')
FUNC_HOST_JSON=$(find . -path './.git' -prune -o -path './node_modules' -prune -o -name 'host.json' -print 2>/dev/null | grep -v '^\./\.git' | head -5 | xargs grep -l 'extensionBundle\|Microsoft.Azure.Functions' 2>/dev/null | wc -l | tr -d ' ')

IAC_COUNT=$((TERRAFORM + CLOUDFORMATION + PULUMI + BICEP + CDK_JSON + SERVERLESS_YML + SAM_TEMPLATE + AZURE_FUNCTIONS + FUNC_HOST_JSON))

# 4. Messaging — use grep -r for simple keyword detection
KAFKA=0; RABBITMQ=0; NATS=0; SNS_SQS=0; AZURE_SB=0; EVENT_SCHEMAS=0; DOMAIN_EVENTS=0
SEARCH_EXTS="--include=*.yaml --include=*.yml --include=*.json --include=*.ts --include=*.js --include=*.java --include=*.cs --include=*.go --include=*.py --include=*.xml --include=*.properties --include=*.toml"

if grep -rqi $SEARCH_EXTS 'kafka' . --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=vendor 2>/dev/null; then KAFKA=1; fi
if grep -rqi $SEARCH_EXTS 'rabbitmq\|amqplib\|pika' . --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=vendor 2>/dev/null; then RABBITMQ=1; fi
if grep -rqi $SEARCH_EXTS '"nats"\|nats-server\|nats\.connect' . --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=vendor 2>/dev/null; then NATS=1; fi
if grep -rqi $SEARCH_EXTS 'AWS::SNS\|AWS::SQS\|sns\.publish\|sqs\.send' . --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=vendor 2>/dev/null; then SNS_SQS=1; fi

AVRO_SCHEMAS=$(count_glob "*.avsc")
PROTO_FILES=$(count_glob "*.proto")
ASYNCAPI=$(( $(count_glob "asyncapi.yaml") + $(count_glob "asyncapi.json") + $(count_glob "asyncapi.yml") ))
EVENT_SCHEMAS=$((AVRO_SCHEMAS + ASYNCAPI))
DOMAIN_EVENTS=$(find . -path './.git' -prune -o -path './node_modules' -prune -o -path './vendor' -prune -o -type f -name '*Event.*' -print 2>/dev/null | grep -v '^\./\.git' | grep -v 'node_modules\|vendor\|\.git' | wc -l | tr -d ' ')
MESSAGING_COUNT=$((KAFKA + RABBITMQ + NATS + SNS_SQS + EVENT_SCHEMAS + DOMAIN_EVENTS))

# 5. API specifications
OPENAPI=$(( $(count_glob "openapi.yaml") + $(count_glob "openapi.yml") + $(count_glob "openapi.json") + $(count_glob "swagger.yaml") + $(count_glob "swagger.json") ))
GRPC=$PROTO_FILES
GRAPHQL=$(( $(count_glob "schema.graphql") + $(count_glob "*.graphql") ))
API_GATEWAY=0
if [ "$(count_glob "kong.yml")" -gt 0 ] || [ "$(count_glob "envoy.yaml")" -gt 0 ] || [ "$(count_glob "gateway.yaml")" -gt 0 ]; then API_GATEWAY=1; fi
API_COUNT=$((OPENAPI + GRPC + GRAPHQL + ASYNCAPI + API_GATEWAY))

# 6. ADRs
ADR_COUNT=0
for adr_dir in docs/adr docs/decisions adr doc/adr doc/decisions; do
  if [ -d "$adr_dir" ]; then
    ADR_COUNT=$((ADR_COUNT + $(find "$adr_dir" -name '*.md' 2>/dev/null | wc -l | tr -d ' ') ))
  fi
done

# 7. CI/CD
GH_ACTIONS=$(find .github/workflows -name '*.yml' -o -name '*.yaml' 2>/dev/null | wc -l | tr -d ' ')
GITLAB_CI=$(count_glob ".gitlab-ci.yml")
JENKINSFILE=$(count_glob "Jenkinsfile")
CICD_COUNT=$((GH_ACTIONS + GITLAB_CI + JENKINSFILE))

# 8. Test structure
TEST_DIRS=0
for td in test tests __tests__ spec; do
  dir_exists "$td" && TEST_DIRS=$((TEST_DIRS + 1))
done
INTEGRATION_TESTS=0
for itd in integration-test integration-tests e2e test/integration tests/integration; do
  [ -d "$itd" ] && INTEGRATION_TESTS=$((INTEGRATION_TESTS + 1))
done
CONTRACT_TESTS=0
count_glob "*.pact.json" | grep -q '[1-9]' && CONTRACT_TESTS=1 || true
TEST_COUNT=$((TEST_DIRS + INTEGRATION_TESTS + CONTRACT_TESTS))

# 9. Documentation
C4_DIAGRAMS=0
ARCHITECTURE_MD=0
[ -f "ARCHITECTURE.md" ] && ARCHITECTURE_MD=1
dir_exists "architecture" && ARCHITECTURE_MD=$((ARCHITECTURE_MD + 1))
find . -path './.git' -prune -o -name '*.puml' -print 2>/dev/null | grep -v '^\./\.git' | head -1 | grep -q . && C4_DIAGRAMS=1 || true
find . -path './.git' -prune -o -name 'workspace.dsl' -print 2>/dev/null | grep -v '^\./\.git' | head -1 | grep -q . && C4_DIAGRAMS=$((C4_DIAGRAMS + 1)) || true
DOC_COUNT=$((C4_DIAGRAMS + ARCHITECTURE_MD + ADR_COUNT))

# 10. Directory structure analysis
HAS_PORTS_ADAPTERS=false
HAS_DDD_DIRS=false
HAS_MODULES_DIR=false
HAS_SERVICES_DIR=false
HAS_LAYERS=false
HAS_CQRS_DIRS=false
HAS_PIPELINE_DIRS=false

# Ports/adapters: match plural and singular (buckpal uses adapter/port)
(dir_exists "ports" || dir_exists "port") && (dir_exists "adapters" || dir_exists "adapter") && HAS_PORTS_ADAPTERS=true
# DDD: also check for value-objects or valueobjects
(dir_exists "domain" && (dir_exists "aggregates" || dir_exists "entities" || dir_exists "value-objects" || dir_exists "valueobjects" || dir_exists "bounded-contexts")) && HAS_DDD_DIRS=true
dir_exists "modules" && HAS_MODULES_DIR=true
(dir_exists "services" || dir_exists "apps") && HAS_SERVICES_DIR=true
(dir_exists "controllers" && dir_exists "services") && HAS_LAYERS=true
(dir_exists "commands" && dir_exists "queries") && HAS_CQRS_DIRS=true
(dir_exists "pipeline" || dir_exists "stages" || dir_exists "filters") && HAS_PIPELINE_DIRS=true

# Clean layers pattern: application/infrastructure/domain (hexagonal / clean architecture)
HAS_CLEAN_LAYERS=false
(dir_exists "application" && dir_exists "infrastructure" && dir_exists "domain") && HAS_CLEAN_LAYERS=true

# Service decomposition: count top-level directories ending in .API, -service, -svc
# (strong microservices signal even without Dockerfiles/k8s)
SERVICE_PROJECTS=0
SERVICE_PROJECTS=$(find . -path './.git' -prune -o -path './node_modules' -prune -o -maxdepth 3 -type d \( -iname '*.api' -o -iname '*-service' -o -iname '*-svc' -o -iname '*Service' \) -print 2>/dev/null | grep -v '^\./\.git' | grep -v 'node_modules' | wc -l | tr -d ' ')

# --- Compute totals ---
TOTAL_SIGNALS=$((MANIFEST_COUNT + CONTAINER_COUNT + IAC_COUNT + MESSAGING_COUNT + API_COUNT + ADR_COUNT + CICD_COUNT + TEST_COUNT + DOC_COUNT))

# --- Output YAML report ---
cat <<YAML
# Architecture Signal Report
# Generated by extract-signals.sh
# Target: ${REPO_PATH}

project:
  name: "${PROJECT_NAME}"
  path: "${REPO_PATH}"
  git_remote: "${GIT_REMOTE}"
  primary_language: "${PRIMARY_LANGUAGE}"
  languages:
${LANGUAGES_YAML}
  ecosystem_count: ${ECOSYSTEM_COUNT}

github:
  stars: ${GITHUB_STARS}
  forks: ${GITHUB_FORKS}
  open_issues: ${GITHUB_OPEN_ISSUES}
  watchers: ${GITHUB_WATCHERS}
  license: "${GITHUB_LICENSE}"

signals:
  total_detected: ${TOTAL_SIGNALS}

  package_manifests:
    count: ${MANIFEST_COUNT}
    ecosystem_count: ${ECOSYSTEM_COUNT}
    package_json: ${PACKAGE_JSON}
    go_mod: ${GO_MOD}
    pom_xml: ${POM_XML}
    build_gradle: ${BUILD_GRADLE}
    requirements_txt: ${REQUIREMENTS_TXT}
    csproj: ${CSPROJ}
    cargo_toml: ${CARGO_TOML}

  container_orchestration:
    count: ${CONTAINER_COUNT}
    dockerfiles: ${DOCKERFILES}
    docker_compose: ${DOCKER_COMPOSE}
    docker_compose_services: ${DOCKER_COMPOSE_SERVICES}
    k8s_manifests: ${K8S_MANIFESTS}
    helm_charts: ${HELM_CHARTS}

  infrastructure_as_code:
    count: ${IAC_COUNT}
    terraform: ${TERRAFORM}
    cloudformation: ${CLOUDFORMATION}
    pulumi: ${PULUMI}
    bicep: ${BICEP}
    cdk: ${CDK_JSON}
    serverless_framework: ${SERVERLESS_YML}
    sam_template: ${SAM_TEMPLATE}
    lambda_dirs: ${LAMBDA_DIRS}
    azure_functions: ${AZURE_FUNCTIONS}
    func_host_json: ${FUNC_HOST_JSON}

  messaging:
    count: ${MESSAGING_COUNT}
    kafka: ${KAFKA}
    rabbitmq: ${RABBITMQ}
    nats: ${NATS}
    sns_sqs: ${SNS_SQS}
    event_schemas: ${EVENT_SCHEMAS}
    avro_schemas: ${AVRO_SCHEMAS}
    proto_files: ${PROTO_FILES}
    asyncapi: ${ASYNCAPI}
    domain_events: ${DOMAIN_EVENTS}

  api_specs:
    count: ${API_COUNT}
    openapi: ${OPENAPI}
    grpc: ${GRPC}
    graphql: ${GRAPHQL}
    asyncapi: ${ASYNCAPI}
    api_gateway: ${API_GATEWAY}

  adrs:
    count: ${ADR_COUNT}

  ci_cd:
    count: ${CICD_COUNT}
    github_actions: ${GH_ACTIONS}
    gitlab_ci: ${GITLAB_CI}
    jenkinsfile: ${JENKINSFILE}

  test_structure:
    count: ${TEST_COUNT}
    test_dirs: ${TEST_DIRS}
    integration_tests: ${INTEGRATION_TESTS}
    contract_tests: ${CONTRACT_TESTS}

  documentation:
    count: ${DOC_COUNT}
    c4_diagrams: ${C4_DIAGRAMS}
    architecture_md: ${ARCHITECTURE_MD}

  directory_patterns:
    ports_and_adapters: ${HAS_PORTS_ADAPTERS}
    ddd_tactical: ${HAS_DDD_DIRS}
    modules_dir: ${HAS_MODULES_DIR}
    services_dir: ${HAS_SERVICES_DIR}
    layers: ${HAS_LAYERS}
    clean_layers: ${HAS_CLEAN_LAYERS}
    cqrs_separation: ${HAS_CQRS_DIRS}
    pipeline_stages: ${HAS_PIPELINE_DIRS}
    service_projects: ${SERVICE_PROJECTS}
YAML
