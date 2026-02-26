# ADR-015: Schema ownership and permissions

## Date:
2024-09-26

## Status:
Accepted

## Context:

[(ADR-014)](/ADR/ADR-014-multiple-services-on-same-database.md) may quickly lead to chaotic coupling. We introduce the additional rule:

## Decision:
- For each object in a DB only one service has the right to write to the database.
  It is the owner of the schema. This makes schema changes more predictable and maintainable.
- This should be enforced with DB permissions.

## Consequences:
- Documentation effort for schema ownerships
- Configuration effort for DB permissions

### Strengthened characteristics:
- Maintainability
- Adaptability
- Data integrity
- Testability

### Weakened characteristics:
