# Packaging SPA in Containers from Kubernetes Platform

## Status
ACCEPTED

## Context
The Hospital Software System includes a Single Page Application (SPA) that serves as the user interface for medical professionals and administrators. Traditionally, static assets of SPAs are hosted externally or in dedicated web servers. However, the option to package the SPA within containers from the Kubernetes (K8s) platform is considered.

## Decision
We choose to package the SPA within containers from the Kubernetes platform. The decision is based on the advantages of leveraging Kubernetes for managing containerized applications, which aligns with our overall containerization strategy. By incorporating the SPA directly into Kubernetes containers, we consolidate the deployment process and benefit from the unified management capabilities that Kubernetes provides.

## Consequences
Packaging the SPA within Kubernetes containers streamlines the deployment process, providing a consistent and portable runtime environment. This decision enhances maintainability an
