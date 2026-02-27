# Ticket_Service_Decomposition

*Extracted text labels from `Ticket_Service_Decomposition.drawio`*

- The Sysops Squad MigrationBreaking down the Ticketing Service into a finer grained microservice deployed in the cloud
- DB
- Ticket Lifecycle Management
- Ticket Creation
- Ticket Completion
- Ticket Processing
- Ticket Assignment
- Ticket Routing
- Customer
- Expert
- Ticket Creation & Ticket Completion are grouped together in a single deployable entity because they are both front end facing and share the need for the same architectural characteristics ofHigh AvailabilityScalabilityElasticity
- Ticket Assignment & Ticket Routing are grouped together in a single deployable entity because they are both back end processing components with tight semantic coupling i.e. all tickets assigned to an expert are routed immediately.
- Ticket Lifecycle Management & Ticket Processing are separated to handle occasional spikes of Customer requests that can throttled while Experts are finishing up with tickets in the backlog.
