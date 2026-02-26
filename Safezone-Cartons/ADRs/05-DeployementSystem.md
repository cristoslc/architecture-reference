# Deployment of System components

Date: 19/02/2024

## Status

Approved

## Context

We decided to have a higher failure tollerant system, in which we deploy several instances per nurse station, together with a centralized processing hub. System updates have to be deployed without afecting the current running system. 


## Decision

Deployments in this scenario will be run on each system independently and requires to disconnect the updating system from the patient vital sign system for the period of update.

1. We will use a automated deployment process.
2. We will use a Canary-Deployment System.
2. Application will be deployed as Tagged Version to allow Fast-Switch-Back. 
3. Functional-Test is run after each deployment, and before adding the instance back to live system.


## Consequences

Positive:

- system are updated individual
- We have always one system running with the current version
- Ensure ...
- Allow to update multiple stations at once 


Negative:

- more complex update process


---

[> Home](../README.md)    [> Architecture Decision Records](README.md)
[< Prev](04-EdgeGatewaySystem.md)  |  [Next >](06-ProvisioningService.md)

