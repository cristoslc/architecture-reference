# InfluxDB for storing Short-Term data

Date: 21/02/2024

## Status

Approved

## Context

As our system needs to process a specific amount of data from various input devices we need to store them for a limited time frame  
of 24 hours for processing.

We already know that we'd require ~1.09GB of data so we can keep it in memory.

## Decision

- We will use InfluxDB for local data storage to keep system simple
- We will sync the data to a permanent storage to our System Hub


## Consequences

Positive:

- InfluxDB works seamlessly together with Telegraf [ADR 08](08-Telegraf.md)
- We can keep data in memory as we only need it for 24 hours at max

Negative:

-


---
[> Home](../README.md)    [> Architecture Decision Records](README.md)
[< Prev](08-Telegraf.md)  |  [Next >](10-SystemHardware.md)
