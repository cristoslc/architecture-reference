# 5. One Analytics Generator for yearly user report and other analytics

Date: 2023-09-15

## Status

Accepted

## Context

There are 2 main business flows to support with analytics: yearly reports to users and analytics exports to 3rd parties. The two flows have different technical requirements.

## Decision

We will use a single component for both generating data reports and analytical metrics. Metric generation for both flows is logically similar, generating yearly reports are much smaller and less frequent workloads.


## Consequences

### Positive
*  Simplified architecture with potential cost savings.
*  Reduced complexity and coordination overhead

### Negative
* Varying levels of elasticity are needed for two flows
  

| [🏠 home](../../README.md#adr) | [<< **ADR** Storing agency contact details for help ](./0004-store-agency-contact-for-help.md) | [**ADR** Analytics generator and Analytics exporter >>](./0006-analytics-generator-and-analytics-exporter.md) |