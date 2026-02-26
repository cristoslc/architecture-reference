# Provisioning System

Date: 19/02/2024

## Status

Approved

## Context

Per hospital, we will deploy several system, which require to have a consistency across all nurse stations. 

Furthermore, we need to ensure system stability and maintainability through automation. 

## Decision

- We will use *Ansible* to automate the instance setup
- We will use *Ansible* to automate the deployment process
- We will use *AWX* to execute the provision process
- We will use *AWX* to execute the deployment process


## Consequences

Positive:

- Ensure system consistency
- Ensure maintainability and stability
- Automation of processes 


Negative:

- additional 


--- 
[> Home](../README.md)    [> Architecture Decision Records](README.md)
[< Prev](05-DeployementSystem.md)  |  [Next >](07-ArchitectureDecision.md)

