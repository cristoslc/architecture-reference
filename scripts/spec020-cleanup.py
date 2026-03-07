#!/usr/bin/env python3
"""SPEC-020: Catalog Cleanup and Taxonomy Tagging

Parses SPIKE-001 taxonomy-classification.md and applies:
1. Removal list (43 entries: 36 library + 7 non-software)
2. Taxonomy tags (scope + use_type) to remaining entries
3. Handles reclassifications noted in the document

Usage: python3 scripts/spec020-cleanup.py [--dry-run]
"""

import re
import sys
import os
import shutil
import yaml

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CATALOG_DIR = os.path.join(REPO_ROOT, "evidence-analysis/Discovered/docs/catalog")
SIGNALS_DIR = os.path.join(REPO_ROOT, "evidence-analysis/Discovered/signals")
ARCHIVE_DIR = os.path.join(REPO_ROOT, "evidence-analysis/Discovered/signals-archive-removed")

# === Classification data from SPIKE-001 taxonomy-classification.md ===

REMOVE_LIBRARY = [
    "abp", "aspnetboilerplate", "AxonFramework", "CQRSlite", "MassTransit",
    "MediatR", "NServiceBus", "Rebus", "Zappa", "actix", "akka", "aspire",
    "autogen", "aws-lambda-powertools-python", "beam", "camel", "chalice",
    "crewAI", "e2b", "ehcache3", "eventuate-tram-core", "go-micro", "kedro",
    "lambda-api", "langchain", "nest", "llama_index", "phidata",
    "protoactor-go", "semantic-kernel", "serverless-express", "smolagents",
    "superagent", "swarm", "typeorm",
    "serverless",  # Reclassified: CLI dev tool, not deployed
]

REMOVE_NONSOFTWARE = [
    "anthropic-cookbook", "ddd-starter-modelling-process", "eShopOnContainers",
    "examples", "project-layout", "realworld", "serverless-patterns",
]

REMOVE_ALL = set(REMOVE_LIBRARY + REMOVE_NONSOFTWARE)

# Production / Platform (65 entries)
PRODUCTION_PLATFORM = [
    "AutoGPT", "EventStore", "OrchardCore", "airflow", "appwrite",
    "argo-workflows", "azure-functions-host", "backstage", "cockroach",
    "conductor", "consul", "dagster", "dapr", "debezium", "dify", "directus",
    "discourse", "dragonfly", "elasticsearch", "envoy", "erxes", "flink",
    "geode", "gitlabhq", "gitpod", "grafana", "hazelcast", "ignite",
    "infinispan", "istio", "jellyfin", "kafka", "keycloak", "letta",
    "linkerd2", "livekit", "localstack", "luigi", "mage-ai", "mattermost",
    "medusa", "n8n", "nats-server", "nextflow", "nhost", "nifi", "nocodb",
    "nopCommerce", "pachyderm", "pipeline", "prefect", "pulsar", "qdrant",
    "rabbitmq-server", "redis", "redpanda", "self-hosted",
    "snakemake", "spark", "strapi", "supabase", "temporal", "traefik",
    "zadig", "zuul",
    # Reclassified from Reference/Platform -> Production/Platform
    "eureka", "memcached",
]

# Production / Application (19 entries after reclassifications)
# eShop, modular-monolith-with-ddd, ddd-forum reclassified to Reference/App
PRODUCTION_APPLICATION = [
    "cal.com", "chatwoot", "dbt-core", "forem", "ghostfolio",
    "library", "mastodon", "MetaGPT", "maybe", "openproject", "outline",
    "overseerr", "ralph", "saleor", "server", "shopware", "solidus",
    "spree", "squidex", "zammad", "orbit",
]

# Reference / Application (36 entries after reclassifications)
REFERENCE_APPLICATION = [
    "CleanArchitecture", "EventSourcing.NetCore", "IDDD_Samples",
    "NorthwindTraders", "Practical.CleanArchitecture",
    "aws-serverless-airline-booking", "bank-of-anthos",
    "clean-architecture-dotnet", "clean-architecture-example",
    "clean-architecture-manga", "domain-driven-hexagon", "dotnet-starter-kit",
    "eShopOnWeb", "ftgo-application", "full-stack-fastapi-template",
    "go-backend-clean-architecture", "go-clean-arch", "go-clean-template",
    "go-ecommerce-microservices", "go-food-delivery-microservices",
    "kotlin-fullstack-sample", "m-r", "microservices-demo", "ngx-admin",
    "sample-dotnet-core-cqrs-api", "sample-spring-microservices-new",
    "spring-petclinic", "spring-petclinic-microservices",
    "wild-workouts-go-ddd-example",
    # Reclassified from Production/App -> Reference/App
    "eShop", "modular-monolith-with-ddd", "ddd-forum",
    # 'library' project is in Production/Application (it's a library mgmt system)
]

# Build taxonomy lookup
TAXONOMY = {}
for name in PRODUCTION_PLATFORM:
    TAXONOMY[name] = ("platform", "production")
for name in PRODUCTION_APPLICATION:
    TAXONOMY[name] = ("application", "production")
for name in REFERENCE_APPLICATION:
    TAXONOMY[name] = ("application", "reference")


def find_yaml_file(catalog_dir, project_name):
    """Find the YAML file for a project, handling case variations."""
    exact = os.path.join(catalog_dir, f"{project_name}.yaml")
    if os.path.exists(exact):
        return exact
    # Try case-insensitive match
    lower = project_name.lower()
    for f in os.listdir(catalog_dir):
        if f.lower() == f"{lower}.yaml":
            return os.path.join(catalog_dir, f)
    return None


def find_signal_file(signals_dir, project_name):
    """Find the signal file for a project."""
    exact = os.path.join(signals_dir, f"{project_name}.signals.yaml")
    if os.path.exists(exact):
        return exact
    lower = project_name.lower()
    for f in os.listdir(signals_dir):
        if f.lower() == f"{lower}.signals.yaml":
            return os.path.join(signals_dir, f)
    return None


def main():
    dry_run = "--dry-run" in sys.argv

    # Validate all entries are accounted for
    all_classified = REMOVE_ALL | set(TAXONOMY.keys())
    catalog_files = [f[:-5] for f in os.listdir(CATALOG_DIR) if f.endswith(".yaml")]

    unclassified = set(catalog_files) - all_classified
    missing = all_classified - set(catalog_files)

    if unclassified:
        print(f"WARNING: {len(unclassified)} unclassified entries: {sorted(unclassified)}")
    if missing:
        print(f"WARNING: {len(missing)} classified but missing from catalog: {sorted(missing)}")

    print(f"\nClassification summary:")
    print(f"  Remove: {len(REMOVE_ALL)} ({len(REMOVE_LIBRARY)} library + {len(REMOVE_NONSOFTWARE)} non-software)")
    print(f"  Keep:   {len(TAXONOMY)} (production/platform: {len(PRODUCTION_PLATFORM)}, "
          f"production/app: {len(PRODUCTION_APPLICATION)}, reference/app: {len(REFERENCE_APPLICATION)})")
    print(f"  Total:  {len(all_classified)}")
    print(f"  Catalog files: {len(catalog_files)}")

    if dry_run:
        print("\n[DRY RUN] No changes will be made.\n")

    # Task 1.2: Archive signal files for removed entries
    os.makedirs(ARCHIVE_DIR, exist_ok=True)
    archived = 0
    for name in sorted(REMOVE_ALL):
        sig_file = find_signal_file(SIGNALS_DIR, name)
        if sig_file:
            dest = os.path.join(ARCHIVE_DIR, os.path.basename(sig_file))
            if dry_run:
                print(f"  [archive] {os.path.basename(sig_file)} -> signals-archive-removed/")
            else:
                shutil.move(sig_file, dest)
            archived += 1
        else:
            print(f"  [skip] No signal file for {name}")
    print(f"\nArchived {archived} signal files")

    # Task 1.3: Delete catalog YAML files for removed entries
    deleted = 0
    for name in sorted(REMOVE_ALL):
        yaml_file = find_yaml_file(CATALOG_DIR, name)
        if yaml_file:
            if dry_run:
                print(f"  [delete] {os.path.basename(yaml_file)}")
            else:
                os.remove(yaml_file)
            deleted += 1
        else:
            print(f"  [skip] No catalog file for {name}")
    print(f"\nDeleted {deleted} catalog files")

    # Task 1.4: Add scope and use_type fields to remaining entries
    tagged = 0
    errors = []
    for name in sorted(TAXONOMY.keys()):
        yaml_file = find_yaml_file(CATALOG_DIR, name)
        if not yaml_file:
            errors.append(f"Missing catalog file for {name}")
            continue

        scope, use_type = TAXONOMY[name]

        if dry_run:
            print(f"  [tag] {os.path.basename(yaml_file)}: scope={scope}, use_type={use_type}")
        else:
            with open(yaml_file, 'r') as f:
                content = f.read()

            # Parse YAML to check if fields already exist
            data = yaml.safe_load(content)
            if data.get('scope') == scope and data.get('use_type') == use_type:
                tagged += 1
                continue

            # Add fields after project_name line
            lines = content.split('\n')
            new_lines = []
            inserted = False
            for line in lines:
                new_lines.append(line)
                if line.startswith('project_name:') and not inserted:
                    new_lines.append(f'scope: {scope}')
                    new_lines.append(f'use_type: {use_type}')
                    inserted = True

            with open(yaml_file, 'w') as f:
                f.write('\n'.join(new_lines))

        tagged += 1

    print(f"\nTagged {tagged} entries with scope/use_type")
    if errors:
        print(f"Errors: {errors}")

    print(f"\nDone! Summary:")
    print(f"  Archived: {archived} signal files")
    print(f"  Deleted:  {deleted} catalog files")
    print(f"  Tagged:   {tagged} entries")
    remaining = len(catalog_files) - deleted
    print(f"  Remaining catalog entries: {remaining}")


if __name__ == "__main__":
    main()
