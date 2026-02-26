# Provisioning System

Date: 21/02/2024

## Status

Approved

## Context

Per hospital, we will deploy several system, which require to have a consistency across all nurse stations. 
The system for our Edge-Gateway should be simple to set up and may handle time critical operations with a high grade on performance.

In addition to that our Edge-Gateways do not need to change often if set up once.

Furthermore, we need to ensure system stability and maintainability. 

## Decision

- We will use a combination of Event-Driven Architecture and Service-Based Architecture


## Consequences

Positive:

- We keep our Edge-Gateway simple 
- We ensure that time critical operations like sending notifications are handled quickly
- We can easily adapt to gathered learnings StayHealthy, Inc. encountered


Negative:

- Not one specific architectural style across the system

---
[> Home](../README.md)    [> Architecture Decision Records](README.md)
[< Prev](06-ProvisioningService.md)  |  [Next >](08-Telegraf.md)