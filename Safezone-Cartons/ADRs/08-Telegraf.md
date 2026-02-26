# Telegraf for data processing

Date: 21/02/2024

## Status

Approved

## Context

We need to support a variety of input devices with different inout structure.  
The company also will add new devices in the future or may change devices.

## Decision

- We will use Telegraf from InfluxDB


## Consequences

Positive:

- We only need one technology to prepare for upcoming changes in the industry
- It offers a wide range of flexibility due its plugin support
- It can handle various input protocols our medical devices can use
- When used with InfluxDB, Telegraf enables centralized and scalable storage for time-series data, simplifying querying, analysis, and visualization across multiple devices.

Negative:

- Additional setup required upfront

---
[> Home](../README.md)    [> Architecture Decision Records](README.md)
[< Prev](07-ArchitectureDecision.md)  |  [Next >](09-InfluxDB.md)