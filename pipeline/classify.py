#!/usr/bin/env python3
"""Heuristic architecture classifier for the dataset scaling pipeline.

Reads signal YAML (from extract-signals.sh) on stdin.
Outputs a catalog YAML entry on stdout conforming to catalog-schema.yaml.

Codifies the rules from skills/discover-architecture/references/signal-rules.md
into an algorithmic classifier. No LLM required.

Usage:
    bash extract-signals.sh /path/to/repo | python3 classify.py
    bash extract-signals.sh /path/to/repo | python3 classify.py --domain "E-Commerce"
"""

import sys
import json
import argparse
from datetime import datetime, timezone

# ---------------------------------------------------------------------------
# YAML handling — try PyYAML, fall back to a minimal parser
# ---------------------------------------------------------------------------

try:
    import yaml

    def parse_yaml(text):
        return yaml.safe_load(text)

    def dump_yaml(data):
        return yaml.dump(data, default_flow_style=False, sort_keys=False, allow_unicode=True)

except ImportError:
    # Minimal YAML parser for the structured signal report format.
    # Handles flat key: value, lists with "- item", nested objects, and booleans.
    def parse_yaml(text):
        """Parse the structured signal YAML from extract-signals.sh."""
        result = {}
        stack = [(result, -1)]  # (dict, indent_level)

        for line in text.splitlines():
            stripped = line.lstrip()
            if not stripped or stripped.startswith("#"):
                continue

            indent = len(line) - len(stripped)

            # Pop stack to find parent at correct indent level
            while len(stack) > 1 and stack[-1][1] >= indent:
                stack.pop()

            parent = stack[-1][0]

            if stripped.startswith("- "):
                # List item
                value = _parse_value(stripped[2:].strip())
                if isinstance(parent, list):
                    parent.append(value)
                elif isinstance(parent, dict) and len(parent) == 0 and len(stack) >= 2:
                    # Empty dict placeholder should be a list — convert it
                    grandparent = stack[-2][0]
                    if isinstance(grandparent, dict):
                        for k, v in grandparent.items():
                            if v is parent:
                                lst = [value]
                                grandparent[k] = lst
                                stack[-1] = (lst, stack[-1][1])
                                break
                continue

            if ":" in stripped:
                key, _, val = stripped.partition(":")
                key = key.strip()
                val = val.strip()

                if not val:
                    # Nested object — check next line to determine if list or dict
                    # Peek ahead not possible; default to dict, convert if needed
                    child = {}
                    parent[key] = child
                    stack.append((child, indent))
                elif val.startswith("[") and val.endswith("]"):
                    # Inline list
                    items = [_parse_value(v.strip().strip('"').strip("'"))
                             for v in val[1:-1].split(",") if v.strip()]
                    parent[key] = items
                elif val.startswith("- "):
                    # First list item on same line as key
                    lst = [_parse_value(val[2:].strip())]
                    parent[key] = lst
                    stack.append((lst, indent))
                else:
                    parent[key] = _parse_value(val)

        return result

    def _parse_value(v):
        v = v.strip().strip('"').strip("'")
        if v.lower() == "true":
            return True
        if v.lower() == "false":
            return False
        try:
            return int(v)
        except (ValueError, TypeError):
            pass
        try:
            return float(v)
        except (ValueError, TypeError):
            pass
        return v

    def dump_yaml(data, indent=0):
        """Minimal YAML serializer."""
        lines = []
        prefix = "  " * indent
        if isinstance(data, dict):
            for k, v in data.items():
                if isinstance(v, (dict,)):
                    lines.append(f"{prefix}{k}:")
                    lines.append(dump_yaml(v, indent + 1))
                elif isinstance(v, list):
                    lines.append(f"{prefix}{k}:")
                    for item in v:
                        if isinstance(item, dict):
                            lines.append(f"{prefix}  -")
                            lines.append(dump_yaml(item, indent + 2))
                        else:
                            lines.append(f"{prefix}  - {_format_value(item)}")
                else:
                    lines.append(f"{prefix}{k}: {_format_value(v)}")
        return "\n".join(lines)

    def _format_value(v):
        if isinstance(v, bool):
            return str(v).lower()
        if isinstance(v, str):
            if any(c in v for c in ":#{}[]|>&*!%@"):
                return f'"{v}"'
            return f'"{v}"' if v == "" else v
        return str(v)


# ---------------------------------------------------------------------------
# Signal accessors — safely navigate the parsed signal dict
# ---------------------------------------------------------------------------

def sig(signals, *path, default=0):
    """Navigate nested signal dict. Returns default if path missing."""
    node = signals
    for key in path:
        if isinstance(node, dict):
            node = node.get(key, default)
        else:
            return default
    return node


def sig_bool(signals, *path):
    """Navigate to a boolean signal. Handles string 'true'/'false'."""
    v = sig(signals, *path, default=False)
    if isinstance(v, str):
        return v.lower() == "true"
    return bool(v)


# ---------------------------------------------------------------------------
# Classification rules (from signal-rules.md)
# ---------------------------------------------------------------------------

STYLES = [
    "Microservices",
    "Event-Driven",
    "Modular Monolith",
    "Domain-Driven Design",
    "Hexagonal Architecture",
    "CQRS",
    "Serverless",
    "Layered",
    "Service-Based",
    "Space-Based",
    "Pipe-and-Filter",
    "Multi-Agent",
    "Plugin/Microkernel",
]

THRESHOLDS = {
    "Microservices": 0.4,
    "Event-Driven": 0.3,
    "Modular Monolith": 0.4,
    "Domain-Driven Design": 0.3,
    "Hexagonal Architecture": 0.3,
    "CQRS": 0.3,
    "Serverless": 0.4,
    "Layered": 0.3,
    "Service-Based": 0.4,
    "Space-Based": 0.4,
    "Pipe-and-Filter": 0.3,
    "Multi-Agent": 0.4,
    "Plugin/Microkernel": 0.3,
}


def score_microservices(s):
    c = 0.0
    # Strong signals (+0.3)
    if sig(s, "container_orchestration", "dockerfiles") >= 2:
        c += 0.3
    if sig(s, "container_orchestration", "k8s_manifests") > 0 or sig(s, "container_orchestration", "helm_charts") > 0:
        c += 0.3
    if sig(s, "api_specs", "api_gateway") > 0:
        c += 0.3
    openapi = sig(s, "api_specs", "openapi")
    grpc = sig(s, "api_specs", "grpc")
    if (openapi + grpc) >= 2:
        c += 0.3
    # Supporting signals (+0.1)
    if sig(s, "container_orchestration", "docker_compose_services") >= 3:
        c += 0.1
    if sig(s, "test_structure", "contract_tests") > 0:
        c += 0.1
    if sig(s, "package_manifests", "ecosystem_count") >= 2:
        c += 0.1
    if sig(s, "directory_patterns", "service_projects") >= 2:
        c += 0.1
    return c


def score_event_driven(s):
    c = 0.0
    # Strong signals (+0.3)
    if sig(s, "messaging", "kafka") or sig(s, "messaging", "rabbitmq") or sig(s, "messaging", "nats") or sig(s, "messaging", "sns_sqs"):
        c += 0.3
    if sig(s, "messaging", "event_schemas") > 0:
        c += 0.3
    if sig(s, "messaging", "domain_events") > 0:
        c += 0.3
    # Supporting signals (+0.1)
    if sig(s, "messaging", "asyncapi") > 0:
        c += 0.1
    return c


def score_modular_monolith(s):
    c = 0.0
    # Strong signals (+0.3)
    if sig(s, "container_orchestration", "dockerfiles") <= 1:
        c += 0.3
    if sig_bool(s, "directory_patterns", "modules_dir"):
        c += 0.3
    # Supporting signals (+0.1)
    if not sig(s, "api_specs", "api_gateway"):
        c += 0.1
    return c


def score_ddd(s):
    c = 0.0
    # Strong signals (+0.3)
    if sig_bool(s, "directory_patterns", "ddd_tactical"):
        c += 0.3
    if sig(s, "messaging", "domain_events") > 0:
        c += 0.3
    # Supporting signals (+0.1)
    if sig_bool(s, "directory_patterns", "ports_and_adapters") or sig_bool(s, "directory_patterns", "clean_layers"):
        c += 0.1
    return c


def score_hexagonal(s):
    c = 0.0
    # Strong signals (+0.3)
    if sig_bool(s, "directory_patterns", "ports_and_adapters"):
        c += 0.3
    if sig_bool(s, "directory_patterns", "clean_layers"):
        c += 0.3
    # Supporting signals (+0.1)
    if sig_bool(s, "directory_patterns", "ddd_tactical"):
        c += 0.1
    return c


def score_cqrs(s):
    c = 0.0
    # Strong signals (+0.3)
    if sig_bool(s, "directory_patterns", "cqrs_separation"):
        c += 0.3
    # Supporting signals (+0.1)
    if sig(s, "messaging", "domain_events") > 0:
        c += 0.1
    if sig(s, "messaging", "event_schemas") > 0:
        c += 0.1
    return c


def score_serverless(s):
    c = 0.0
    # Strong signals (+0.3)
    if sig(s, "infrastructure_as_code", "serverless_framework") > 0 or sig(s, "infrastructure_as_code", "sam_template") > 0:
        c += 0.3
    if sig(s, "infrastructure_as_code", "lambda_dirs") > 0:
        c += 0.3
    if sig(s, "infrastructure_as_code", "azure_functions") > 0 or sig(s, "infrastructure_as_code", "func_host_json") > 0:
        c += 0.3
    # Supporting signals (+0.1)
    if sig(s, "infrastructure_as_code", "cdk") > 0:
        c += 0.1
    return c


def score_layered(s):
    c = 0.0
    # Strong signals (+0.2 — note: layered uses 0.2 per rules)
    if sig_bool(s, "directory_patterns", "layers"):
        c += 0.2
    # Supporting signals (+0.1)
    if sig(s, "container_orchestration", "dockerfiles") <= 1:
        c += 0.1
    if sig(s, "messaging", "count") == 0:
        c += 0.1
    return c


def score_service_based(s):
    c = 0.0
    # Strong signals — SBA-specific indicators
    # Monorepo packages: 2+ coarse-grained service packages (SBA hallmark)
    monorepo_pkgs = sig(s, "service_based", "monorepo_packages")
    if monorepo_pkgs >= 2:
        c += 0.3
    # Shared database configs (SBA hallmark: services share databases)
    db_configs = sig(s, "service_based", "db_config_count")
    if db_configs >= 1:
        c += 0.2
    # Docker Compose services without k8s (SBA uses compose, MS uses k8s)
    compose_services = sig(s, "container_orchestration", "docker_compose_services")
    k8s = sig(s, "container_orchestration", "k8s_manifests")
    if compose_services >= 3 and k8s == 0:
        c += 0.2
    # Moderate signals
    # Service projects in moderate range (coarse-grained, not micro)
    service_projects = sig(s, "directory_patterns", "service_projects")
    if 2 <= service_projects <= 8:
        c += 0.2
    # Supporting signal
    if sig_bool(s, "directory_patterns", "services_dir") and k8s == 0:
        c += 0.1
    return c


def score_space_based(s):
    c = 0.0
    # We can only detect space-based from IaC/messaging patterns hinting at
    # in-memory grids. This is inherently weak for heuristic-only classification.
    # Repos that ARE data grids (hazelcast, ignite, redis) will have distinctive
    # directory structures but won't show the "usage" signals.
    # For data-grid repos themselves, the presence of processing-unit or
    # partition-aware patterns is a signal.
    if sig(s, "messaging", "kafka") and sig_bool(s, "directory_patterns", "modules_dir"):
        c += 0.3
    return c


def score_pipe_and_filter(s):
    c = 0.0
    # Strong signals (+0.3)
    if sig_bool(s, "directory_patterns", "pipeline_stages"):
        c += 0.3
    return c


def score_multi_agent(s):
    c = 0.0
    # Strong signals — detected via directory patterns and project signals
    # Multi-agent repos typically have agent configs, AGENTS.md, etc.
    # Since extract-signals.sh doesn't have a dedicated agent category,
    # we rely on directory patterns and documentation signals.
    if sig(s, "documentation", "architecture_md") > 0:
        c += 0.1
    return c


def score_plugin_microkernel(s):
    c = 0.0
    # Strong signals (+0.2 each)
    # Plugin/extension directories with actual plugin subdirectories
    if sig_bool(s, "plugin_microkernel", "has_plugin_dirs"):
        c += 0.2
        if sig(s, "plugin_microkernel", "plugin_dir_count") >= 5:
            c += 0.1  # Many plugins = stronger signal
    # Plugin manifest files (plugin.json, extension.json)
    if sig(s, "plugin_microkernel", "plugin_manifests") > 0:
        c += 0.2
    # Plugin loader/registry patterns in code
    if sig(s, "plugin_microkernel", "plugin_loader_patterns") > 0:
        c += 0.2
    return c


SCORERS = {
    "Microservices": score_microservices,
    "Event-Driven": score_event_driven,
    "Modular Monolith": score_modular_monolith,
    "Domain-Driven Design": score_ddd,
    "Hexagonal Architecture": score_hexagonal,
    "CQRS": score_cqrs,
    "Serverless": score_serverless,
    "Layered": score_layered,
    "Service-Based": score_service_based,
    "Space-Based": score_space_based,
    "Pipe-and-Filter": score_pipe_and_filter,
    "Multi-Agent": score_multi_agent,
    "Plugin/Microkernel": score_plugin_microkernel,
}


# ---------------------------------------------------------------------------
# Conflict resolution
# ---------------------------------------------------------------------------

def resolve_conflicts(scores, signals=None):
    """Apply conflict rules from signal-rules.md."""
    ms = scores.get("Microservices", 0)
    mm = scores.get("Modular Monolith", 0)
    sb = scores.get("Service-Based", 0)
    pm = scores.get("Plugin/Microkernel", 0)

    # Microservices vs Modular Monolith: if both signal, prefer Microservices
    # if Kubernetes/Helm present (already reflected in score), otherwise Modular Monolith
    if ms >= THRESHOLDS["Microservices"] and mm >= THRESHOLDS["Modular Monolith"]:
        if ms >= mm:
            scores["Modular Monolith"] = 0
        else:
            scores["Microservices"] = 0

    # Microservices vs Service-Based: use discriminating heuristics
    if ms >= THRESHOLDS["Microservices"] and sb >= THRESHOLDS["Service-Based"]:
        if signals:
            dockerfiles = sig(signals, "container_orchestration", "dockerfiles")
            compose_svcs = sig(signals, "container_orchestration", "docker_compose_services")
            k8s = sig(signals, "container_orchestration", "k8s_manifests")
            svc_projects = sig(signals, "directory_patterns", "service_projects")
            # Favor SBA when: fewer Dockerfiles, compose-based, fewer service projects
            sba_hints = 0
            if dockerfiles < 8:
                sba_hints += 1
            if compose_svcs >= 3:
                sba_hints += 1
            if k8s == 0:
                sba_hints += 1
            if svc_projects <= 5:
                sba_hints += 1
            if sba_hints >= 3:
                scores["Microservices"] = 0
            elif ms >= sb:
                scores["Service-Based"] = 0
            else:
                scores["Microservices"] = 0
        else:
            if ms >= sb:
                scores["Service-Based"] = 0
            else:
                scores["Microservices"] = 0

    # Plugin/Microkernel vs Modular Monolith: plugin signals disambiguate
    if pm >= THRESHOLDS["Plugin/Microkernel"] and mm >= THRESHOLDS["Modular Monolith"]:
        # Both can coexist — plugin architecture is often also modular.
        # Only suppress MM if plugin signal is strong (loader patterns found).
        if signals and sig(signals, "plugin_microkernel", "plugin_loader_patterns"):
            scores["Modular Monolith"] = 0

    return scores


# ---------------------------------------------------------------------------
# Quality attribute inference
# ---------------------------------------------------------------------------

QUALITY_RULES = [
    # (condition_fn, attribute)
    (lambda s: sig(s, "container_orchestration", "k8s_manifests") > 0, "Scalability"),
    (lambda s: sig(s, "test_structure", "integration_tests") > 0, "Fault Tolerance"),
    (lambda s: sig(s, "ci_cd", "count") > 0, "Deployability"),
    (lambda s: sig(s, "test_structure", "contract_tests") > 0, "Interoperability"),
    (lambda s: sig(s, "adrs", "count") > 0, "Evolvability"),
    (lambda s: sig_bool(s, "directory_patterns", "modules_dir"), "Modularity"),
    (lambda s: sig(s, "documentation", "c4_diagrams") > 0, "Observability"),
]


def infer_quality_attributes(signals):
    return [attr for check, attr in QUALITY_RULES if check(signals)]


# ---------------------------------------------------------------------------
# Technology detection
# ---------------------------------------------------------------------------

def detect_technologies(signals):
    techs = []
    pm = signals.get("package_manifests", {})
    if pm.get("package_json", 0):
        techs.append("Node.js")
    if pm.get("go_mod", 0):
        techs.append("Go modules")
    if pm.get("pom_xml", 0):
        techs.append("Maven")
    if pm.get("build_gradle", 0):
        techs.append("Gradle")
    if pm.get("requirements_txt", 0):
        techs.append("Python/pip")
    if pm.get("csproj", 0):
        techs.append(".NET")
    if pm.get("cargo_toml", 0):
        techs.append("Rust/Cargo")

    co = signals.get("container_orchestration", {})
    if co.get("dockerfiles", 0):
        techs.append("Docker")
    if co.get("k8s_manifests", 0) or co.get("helm_charts", 0):
        techs.append("Kubernetes")
    if co.get("docker_compose", 0):
        techs.append("Docker Compose")

    iac = signals.get("infrastructure_as_code", {})
    if iac.get("terraform", 0):
        techs.append("Terraform")
    if iac.get("serverless_framework", 0) or iac.get("sam_template", 0):
        techs.append("Serverless Framework")
    if iac.get("azure_functions", 0) or iac.get("func_host_json", 0):
        techs.append("Azure Functions")

    msg = signals.get("messaging", {})
    if msg.get("kafka", 0):
        techs.append("Kafka")
    if msg.get("rabbitmq", 0):
        techs.append("RabbitMQ")
    if msg.get("nats", 0):
        techs.append("NATS")

    api = signals.get("api_specs", {})
    if api.get("openapi", 0):
        techs.append("OpenAPI")
    if api.get("grpc", 0):
        techs.append("gRPC")
    if api.get("graphql", 0):
        techs.append("GraphQL")

    ci = signals.get("ci_cd", {})
    if ci.get("github_actions", 0):
        techs.append("GitHub Actions")
    if ci.get("gitlab_ci", 0):
        techs.append("GitLab CI")

    return techs


# ---------------------------------------------------------------------------
# Strength / gap assessment
# ---------------------------------------------------------------------------

def assess_strengths_gaps(signals, matched_styles):
    strengths = []
    gaps = []

    s_total = sig(signals, "total_detected")
    if s_total >= 15:
        strengths.append("Rich signal profile with strong architectural indicators")
    elif s_total >= 8:
        strengths.append("Moderate signal profile with identifiable patterns")

    if sig(signals, "adrs", "count") >= 3:
        strengths.append("Well-documented architecture decisions (ADRs)")
    elif sig(signals, "adrs", "count") == 0:
        gaps.append("No architecture decision records found")

    if sig(signals, "test_structure", "count") >= 3:
        strengths.append("Comprehensive test infrastructure")
    elif sig(signals, "test_structure", "count") == 0:
        gaps.append("No test infrastructure detected")

    if sig(signals, "ci_cd", "count") > 0:
        strengths.append("CI/CD automation present")
    else:
        gaps.append("No CI/CD configuration detected")

    if sig(signals, "documentation", "c4_diagrams") > 0:
        strengths.append("Architecture diagrams (C4/PlantUML)")

    if sig(signals, "documentation", "architecture_md") > 0:
        strengths.append("Architecture documentation present")
    else:
        gaps.append("No architecture documentation (ARCHITECTURE.md)")

    if len(matched_styles) >= 2:
        strengths.append(f"Multi-style composition ({len(matched_styles)} styles)")

    return strengths[:5], gaps[:5]


# ---------------------------------------------------------------------------
# Main classification
# ---------------------------------------------------------------------------

def classify(signal_data, domain_override=None):
    """Classify a repo from its signal report. Returns a catalog entry dict."""
    project = signal_data.get("project", {})
    signals = signal_data.get("signals", {})

    # Score each style
    scores = {}
    for style in STYLES:
        scorer = SCORERS[style]
        scores[style] = scorer(signals)

    # Apply conflict resolution
    scores = resolve_conflicts(scores, signals)

    # Filter styles that meet their threshold
    matched = [(style, score) for style, score in scores.items()
                if score >= THRESHOLDS[style]]
    matched.sort(key=lambda x: -x[1])

    # Overall confidence calculation
    CONFIDENCE_THRESHOLD = 0.85

    if not matched:
        overall_confidence = max(scores.values()) if scores else 0.0
        primary_confidence = overall_confidence
        heuristic_candidates = []
    else:
        overall_confidence = matched[0][1]
        primary_confidence = matched[0][1]
        heuristic_candidates = [{"style": style, "score": round(score, 2)}
                                for style, score in matched]

        # Layered-only cap
        if len(matched) == 1 and matched[0][0] == "Layered":
            overall_confidence = min(overall_confidence, 0.5)

        # Multi-style bonus
        if len(matched) >= 2:
            overall_confidence = min(overall_confidence + 0.1, 1.0)

    # Clamp
    overall_confidence = round(min(max(overall_confidence, 0.0), 1.0), 2)
    primary_confidence = round(min(max(primary_confidence, 0.0), 1.0), 2)

    # Below threshold: emit Indeterminate, preserve heuristic guesses in metadata
    if overall_confidence < CONFIDENCE_THRESHOLD:
        architecture_styles = ["Indeterminate"]
        classification_method = "heuristic-inconclusive"
    else:
        architecture_styles = [style for style, _ in matched]
        classification_method = "heuristic"

    # Detect technologies and quality attributes
    key_technologies = detect_technologies(signals)
    quality_attributes = infer_quality_attributes(signals)
    strengths, gaps_list = assess_strengths_gaps(signals, matched)

    # Build one-line summary
    styles_str = ", ".join(architecture_styles[:3])
    lang = project.get("primary_language", "Unknown")
    summary = f"{lang} project exhibiting {styles_str} patterns"

    # Domain — use override if provided, else "Unknown"
    domain = domain_override or "Unknown"

    # Count directory pattern booleans for signal_breakdown
    dp = signals.get("directory_patterns", {})
    dir_count = sum(1 for k, v in dp.items()
                    if k != "service_projects" and (v is True or v == "true"))
    dir_count += 1 if sig(signals, "directory_patterns", "service_projects") >= 2 else 0

    now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

    catalog_entry = {
        "project_name": project.get("name", "unknown"),
        "source": "Discovered",
        "source_url": project.get("git_remote", ""),
        "project_url": project.get("git_remote", "") or project.get("path", ""),
        "evidence_type": "automated-discovery",
        "discovered_at": now,
        "discovered_by": "discover-architecture",
        "discovery_version": "1.0.0",
        "domain": domain,
        "language": lang,
        "languages": project.get("languages", [lang]),
        "architecture_styles": architecture_styles,
        "key_technologies": key_technologies,
        "quality_attributes": quality_attributes,
        "notable_strengths": strengths,
        "notable_gaps": gaps_list,
        "one_line_summary": summary,
        "discovery_metadata": {
            "confidence": overall_confidence,
            "signals_detected": sig(signals, "total_detected"),
            "signals_evaluated": 10,
            "classification_method": classification_method,
            "primary_style_confidence": primary_confidence,
            "heuristic_candidates": heuristic_candidates,
            "signal_breakdown": {
                "package_manifests": sig(signals, "package_manifests", "count"),
                "container_orchestration": sig(signals, "container_orchestration", "count"),
                "infrastructure_as_code": sig(signals, "infrastructure_as_code", "count"),
                "messaging": sig(signals, "messaging", "count"),
                "api_specs": sig(signals, "api_specs", "count"),
                "adrs": sig(signals, "adrs", "count"),
                "ci_cd": sig(signals, "ci_cd", "count"),
                "test_structure": sig(signals, "test_structure", "count"),
                "documentation": sig(signals, "documentation", "count"),
                "directory_structure": dir_count,
            },
        },
    }

    # Add review flag for inconclusive entries
    if overall_confidence < CONFIDENCE_THRESHOLD:
        catalog_entry["review_required"] = True

    return catalog_entry


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="Classify architecture from signal YAML (stdin -> catalog YAML stdout)")
    parser.add_argument("--domain", default=None,
                        help="Override the domain field in the output")
    parser.add_argument("--json", dest="output_json", action="store_true",
                        help="Output as JSON instead of YAML")
    args = parser.parse_args()

    raw = sys.stdin.read()
    if not raw.strip():
        print("Error: no input on stdin", file=sys.stderr)
        sys.exit(1)

    signal_data = parse_yaml(raw)
    entry = classify(signal_data, domain_override=args.domain)

    if args.output_json:
        print(json.dumps(entry, indent=2))
    else:
        print(dump_yaml(entry))


if __name__ == "__main__":
    main()
