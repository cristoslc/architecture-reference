# Architecture Report: aws-serverless-airline-booking

**Date:** 2026-03-11
**Repo:** https://github.com/aws-samples/aws-serverless-airline-booking (archive branch)
**Classification:** Serverless, Microservices, Event-Driven
**Confidence:** 0.95
**Method:** deep-analysis (archive branch — all source code examined)

---

## Summary

AWS Serverless Airline Booking is a complete reference application demonstrating AWS-native serverless patterns for a flight booking platform. It implements four independently deployed services — Catalog, Booking, Payment, and Loyalty — all built on AWS managed services (Lambda, AppSync, Step Functions, DynamoDB, SNS, API Gateway). The system is a textbook example of Serverless architecture with Microservices decomposition and Event-Driven inter-service communication.

---

## Evidence Overview

The archive branch contains the full source organized as:

```
src/
  backend/
    catalog/       — Flight search via AppSync/DynamoDB + VTL resolvers
    booking/       — Step Functions state machine + Python Lambda + SNS
    payment/       — Python Lambda wrapping Stripe via SAR app
    loyalty/       — TypeScript Lambda + API Gateway REST + SNS subscriber
    shared/libs/   — Shared Lambda Layer (Python middleware, models)
  frontend/        — Vue.js + Quasar SPA using Amplify for Auth and GraphQL
amplify/
  backend/
    api/           — GraphQL schema (AppSync)
    auth/          — Cognito user pool
```

Each backend service has its own `template.yaml` (AWS SAM) and is deployed as an independent CloudFormation stack via dedicated `make` targets.

---

## Styles Identified

### 1. Serverless (Primary)

**Evidence:**

- All five `template.yaml` files use `Transform: AWS::Serverless-2016-10-31`, confirming AWS SAM deployment.
- Compute is entirely AWS Lambda: `ConfirmBooking`, `CancelBooking`, `ReserveBooking`, `NotifyBooking` (Python 3.7), `IngestFunc`, `GetFunc` (Node.js 14), `CollectPayment`, `RefundPayment` (Python 3.7).
- Storage is DynamoDB with `BillingMode: PAY_PER_REQUEST` (on-demand, no servers to manage).
- API surface is managed: AppSync (GraphQL) for Catalog and Booking, API Gateway (REST) for Loyalty.
- Orchestration is AWS Step Functions — a fully managed state machine service.
- Authentication and authorization via AWS Cognito (managed identity provider).
- Payment integration via AWS Serverless Application Repository (`api-lambda-stripe-charge`).
- No persistent server processes anywhere in the stack; every compute unit is function-as-a-service or fully managed.
- X-Ray tracing enabled across all Lambda functions via `Tracing: Active`.
- AWS Lambda Powertools used throughout (`Logger`, `Tracer`, `Metrics`) — a pattern idiomatic to serverless observability.

### 2. Microservices (Secondary)

**Evidence:**

- Four distinct services with separate ownership of data and deployment artifacts:
  - **Catalog**: Flight data in its own DynamoDB table (`FlightTable`), managed by Amplify/AppSync. Functions `ReserveFlight` and `ReleaseFlight` live in `src/backend/catalog/`.
  - **Booking**: Its own DynamoDB table (`BookingTable`), SAM stack in `src/backend/booking/`, exposes `processBooking` GraphQL mutation.
  - **Payment**: Isolated in `src/backend/payment/`, wraps external Stripe API, exposes collect/refund Lambda ARNs via SSM Parameter Store for cross-service discovery.
  - **Loyalty**: Separate DynamoDB table (`Airline-LoyaltyData-${Stage}`), separate API Gateway REST endpoint, TypeScript runtime — independently deployable as shown by `make deploy.loyalty`.
- No shared database: each service owns its data store.
- Cross-service API contracts use SSM Parameter Store for runtime service discovery (Lambda ARNs, API URLs) rather than compile-time coupling.
- Independent deployment: `Makefile` deploys each service as a separate target (`deploy.booking`, `deploy.payment`, `deploy.loyalty`, `deploy.shared-lambda-layers`).
- Distinct technology stacks per service: Python 3.7 (Booking, Payment, Catalog), TypeScript/Node.js 14 (Loyalty), Apache VTL (Catalog resolvers), Vue.js (frontend).

### 3. Event-Driven (Secondary)

**Evidence:**

- SNS pub/sub for inter-service communication: `NotifyBooking` Lambda publishes to `BookingTopic` (SNS) with a `Booking.Status` message attribute.
- Loyalty service subscribes to `BookingTopic` via SNS event filter on `Booking.Status: confirmed`, decoupling the Booking and Loyalty domains.
  ```yaml
  Events:
    Listener:
      Type: SNS
      Properties:
        Topic: !Ref BookingSNSTopic
        FilterPolicy:
          Booking.Status:
            - confirmed
  ```
- Step Functions state machine (`Airline-ProcessBooking-${Stage}`) orchestrates the booking workflow as a sequence of event-driven tasks: Reserve Flight → Reserve Booking → Collect Payment → Confirm Booking → Notify Booking Confirmed.
- Dead-letter queue (SQS `BookingsDLQ`) catches failed state machine executions — event-driven error handling.
- The `processBooking` GraphQL mutation triggers Step Functions via an AppSync HTTP data source, making API mutations event sources for the workflow.
- Saga pattern: compensating transactions (CancelBooking, RefundPayment, Release Flight Seat) are triggered by failure events in the state machine.

---

## Quality Attributes

| Attribute | Justification |
|---|---|
| **Scalability** | All compute is Lambda (auto-scales per request) and DynamoDB (PAY_PER_REQUEST mode). No capacity planning required. |
| **Resilience** | Step Functions state machine implements Saga pattern with compensating transactions. DynamoDB operations include retry policies with exponential backoff. SQS DLQ captures permanently failed bookings. |
| **Observability** | AWS Lambda Powertools provides structured logging, distributed tracing (X-Ray), and custom metrics (`ServerlessAirline` namespace). Every service emits cold start, success, and failure metrics. |
| **Security** | Cognito JWT authentication. AppSync fine-grained authorization (owner-based, group-based). Loyalty API uses AWS IAM auth. Stripe keys injected via SSM Parameter Store (not hardcoded). Security headers on frontend (CSP, HSTS, X-Frame-Options). |
| **Loose Coupling** | Services discover each other exclusively via SSM Parameter Store at deploy time. SNS filter policies allow Loyalty to subscribe without Booking knowing about it. |
| **Operational Simplicity** | No servers to patch. SAM templates abstract CloudFormation complexity. Amplify handles frontend CI/CD and backend auth/API provisioning. |
| **Testability** | Loyalty service has dedicated test files (`ingest.test.ts`, `get.test.ts`, `integration.test.ts`). Shared Lambda layer has unit tests. End-to-end tests referenced in documentation. |
| **Cost Efficiency** | Serverless pricing model (pay-per-invocation). DynamoDB on-demand mode. No idle capacity charges. |

---

## Classification Reasoning

The dominant architectural pattern is **Serverless**. Every compute unit is an AWS Lambda function or fully managed service; there are no long-running processes, no server provisioning, and no capacity management. The deployment model (SAM + Amplify) and the technology choices (Lambda, AppSync, Step Functions, DynamoDB on-demand, Cognito) are all serverless-first.

**Microservices** is the second most strongly evidenced pattern. Four bounded-context services (Catalog, Booking, Payment, Loyalty) each own their data, deploy independently from separate SAM stacks, and expose contracts via GraphQL, REST, or Lambda ARN. Different languages per service reinforce decentralization.

**Event-Driven** is the third pattern, manifested through SNS pub/sub (Booking → Loyalty), Step Functions orchestration, and the Saga pattern for distributed transaction management. The booking workflow is entirely asynchronous — the `processBooking` mutation returns `PENDING` immediately and the state machine runs independently.

Styles considered and rejected:
- **Pipeline**: No ETL or data transformation pipeline structure. The Step Functions state machine is a business workflow, not a data pipeline.
- **CQRS**: AppSync provides GraphQL queries and mutations, but there is no separate read/write model or distinct event store.
- **Hexagonal Architecture**: Lambda handlers interact directly with AWS SDKs and DynamoDB; there is no explicit ports-and-adapters structure or application core isolation (though the shared libs layer provides some separation).
- **Service-Based**: This pattern typically implies a shared database and coarser service granularity; here services have isolated data stores and fine-grained decomposition.
- **Domain-Driven Design**: Bounded contexts are present (Booking, Catalog, Payment, Loyalty), but there is no evidence of DDD tactical patterns (aggregates, value objects, domain events as first-class objects, ubiquitous language enforcement).
