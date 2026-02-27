# TSS_Migration

*Extracted text labels from `TSS_Migration.drawio`*

## Phase-1

- Admin
- Expert
- Customer
- Manager
- CSR
- DB
- LoginService
- Support Contract
- Customer Profile
- BillingService
- Expert Profile
- User Maintenance
- KBService
- Survey Management
- ReportingService
- NotificationService
- TicketingService
- The Sysops Squad MigrationPhase 1: Coarse Grained Services with Shared DB and a Message Broker for service interaction

## Phase-2

- Admin
- Expert
- Customer
- Manager
- CSR
- Customer LoginService
- Customer Profile
- Expert Profile
- User Maintenance
- BillingService
- Support Contract
- KBService
- Survey Management
- ReportingService
- NotificationService
- TicketingService
- The Sysops Squad MigrationPhase 2: Creating a bounded context for certain services and sharing DB with some others
- DB
- DB
- DB
- DB
- DB
- Internal User LoginService
- DB
- DB
- Separated Customer Login from Internal User Login to be able to maintain and manage them separately
- Customer Micro-frontend
- Internal User Micro-frontend
- DB

## Phase-3

- The Sysops Squad MigrationPhase 3: Break down Ticketing Service into a Microservice and host it on a cloud platform(with the rest of the architecture remaining untouched)
- DB
- Ticket Lifecycle Management
- TicketCreation
- TicketCompletion
- Ticket Processing
- TicketAssignment
- TicketRouting
- Customer
- Expert
- Ticket Creation & Ticket Completion are grouped together in a single deployable entity because they are both front end facing and share the need for the same architectural characteristics ofHigh AvailabilityScalabilityElasticity
- Ticket Assignment & Ticket Routing are grouped together in a single deployable entity because they are both back end processing components with tight semantic coupling i.e. all tickets assigned to an expert are routed immediately.
- Customer Micro-frontend
- Internal User Micro-frontend
