# Use of a Dual-Stack Edge Gateway System

Date: 19/02/2024

## Status

Approved

## Context

Due to the nature of patients safety, the system of monitoring and data ingestion should be failure tolerant and require at least one backup system to function in case one instance has a hard failure.
Even though that our monitoring devices can store data locally for a couple of minutes, in the event of a hardware failure in the monitoring system, the nurse station could not evaluate the patient's status.


## Decision

We opt for a dual stack system in for the Edge Gateway which includes a UPS for power failure for an autonomy of ~15 min uptime without electricity.

## Consequences

Positive:

- Increased system failure tolerance


Negative:

- Higher cost
- Higher system complexity 

--- 
[> Home](../README.md)    [> Architecture Decision Records](README.md)
[< Prev](03-Software.md)  |  [Next >](05-DeployementSystem.md)