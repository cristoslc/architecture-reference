# Components Diagram (C3) - HR Integration

In the C4 model, the C3 diagrams highlights how the components within a container operate and interact.

For the HR Integration container we want to show how we incorporate the characteristics *interoperability* and *fault tolerance*.

### HR System Integration Overview

- **Asynchronous Decoupling**  
   The HR system is decoupled through asynchronous integration, as described in [ADR-005](/ADR/ADR-005-async-with-external-systems.md). It leverages the `Matches` topic for data exchange.

- **HR System Adapters**  
   For each HR system (e.g., SAP SuccessFactors, Workday), a dedicated adapter is developed, as outlined in [ADR-023](/ADR/ADR-023-adapters-for-hr-systems.md). These adapters operate in multiple threads and run asynchronously to handle different HR systems concurrently.

-  **Fault Tolerance and Reliability**  
   To ensure a fault-tolerant integration, a retry mechanism is implemented using dead-letter queues with an exponential backoff strategy, as described in [ADR-023](/ADR/ADR-023-adapters-for-hr-systems.md). This setup guarantees message reprocessing in case of transient failures and prevents data loss.

![Components Diagram (C3) - HR Integration](/C4/images/C3-components-hr-integration.svg)

## Data flow

### Adding an HR Integration for an Employer

1. The **Employer** container facilitates the addition or updating of an HR integration for a specific employer.
2. Credentials and information related to the HR integration (such as system details and employer identification) are sent to the **HR Integration API** component.
3. The **HR System Orchestrator** stores non-sensitive information in the database while credentials are securely saved in the key store.

**Important**: An employer cannot create a new adapter for an unsupported HR system. This functionality must be implemented by the **Clear View** team.

### Uploading the Resume

1. The **Matches Subscriber** monitors the ``Matches`` topic for any changes.
2. When a match is unlocked, it triggers a call to the **HR System Orchestrator**.
3. The **HR System Orchestrator** checks for one or more configured HR integrations for the employer, selects the appropriate adapter(s), and retrieves the job candidate's resume.
4. The **HR System Orchestrator** then calls the selected adapter(s) asynchronously for the respective HR system(s).
5. The **HR System Adapter** uploads the resume to the employer's HR system.
6. In the event of a failure, the **HR System Orchestrator** pushes the upload request to a dead-letter queue, where it is retried using an exponential backoff strategy. If failures persist, requests are escalated to a higher retry queue until no further attempts are made.

*Hint*: Future enhancements may include the addition of email notifications for status updates.
