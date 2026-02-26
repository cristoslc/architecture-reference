# Context Diagram (C1)

The context diagram offers an overview of the software system, including the users interacting with it and the external systems connected to the application.

![Context Diagram](/C4/images/C1-Context.svg)

The survey system was designated as an external system in [ADR-20](/ADR/ADR-020-externalizing-survey-processes.md). Similarly, the mail server is also considered an external system for this application.

## Persons
The persons were derived from the Actors discovered in the [EventStorming](/EventStorming).

| **Person**     | **Description**                                                              |
|----------------|------------------------------------------------------------------------------|
| Job Candidate  | A job candidate who uses the platform to find a matching position            |
| Hiring Manager | A hiring manager who uploads open roles, views matches, and unlocks resumes. |
| Employer       | Provides employer and HR Integration information                             |
| Administrator  | Administers users and employers. Has access to reports and analytics.        |


## Software Systems
- **ClearView**: The system under development.
- **HR System**: Various HR platforms, such as *SAP SuccessFactors*, *Workday*, and others.
- **AI System**: The various AI models used for generating resume tips, company information, S.M.A.R.T stories.
- **Billing System**: An external billing system responsible for payments, invoicing and billing.
- **Mail Server**: An external mail server used to send system notifications and reports.
- **Survey System**: An external service, such as SurveyMonkey, used for creating and managing surveys. [ADR-18](/ADR/ADR-018-location-of-survey-triggers.md) & [ADR-20](/ADR/ADR-020-externalizing-survey-processes.md).
