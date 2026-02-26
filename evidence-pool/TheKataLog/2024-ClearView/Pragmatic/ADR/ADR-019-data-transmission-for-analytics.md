# ADR-019: Data transmission for analytics

## Date:
2024-09-26

## Status:
Accepted

## Context:
Data Point 5 (Demographic Information) needs to be transferred to Analytics & Reporting service.

- Opt 1: Analytics reads directly from job candidate DB
fault tolerance, separation of concern. operational vs. analytics. But direct access to sensitive information.
- Opt 2: Job candidate sends to Analytics. Stronger privacy of job candidate DB. But strong coupling (fault-intolerance) to Analytics & Reporting.
- Opt 3: Asynchronous delivery via topic. Like 2, but with weaker coupling, better fault-tolerance.

## Decision:
Opt 1: Analytics may read directly from job candidate DB

## Consequences:

### Strengthened characteristics:
- Simplicity
- Maintainability
- Performance

### Weakened characteristics:
- Security (since it can access and holds most data)
