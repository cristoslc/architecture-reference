# Rancher for monitoring K3s clusters on edge devices

## Status
ACCEPTED

## Context
Kubernetes clusters running on Hospital locations and K3s clusters running on devices needs to be managed and monitored centrally.

## Decision
We use [Rancher](https://www.rancher.com/) for importing kubernetes clusters running across different hospital location, edge devices and cloud for monitoring and managing from one central location.

## Consequences
Single control plane to monitor and manage all kubernetes cluster eases the operational effort and cost.
