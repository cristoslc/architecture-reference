# Components Diagram (C3) - Story

In the C4 model, the C3 diagrams highlight how components within a container operate and interact. For the **Story Processing** container, we focus on the incorporation of **automation** and **data anonymization**, ensuring secure and efficient handling of job candidate data.

### Story Processing Overview

- **AI-Driven Automation**  
  The story processing pipeline leverages AI-based adapters to automate the anonymization of job candidate resumes,
 following the decision of [ADR-006: AI Models run on separate containers](/ADR/ADR-006-ai-models-run-on-separate-containers.md). 
 This ensures consistency, scalability, and efficiency in processing and anonymizing data.

- **Asynchronous Event Handling**  
  The system operates asynchronously, using events to process stories, ensuring decoupling between services, as described in [ADR-005: Asynchronous Communication with External Systems](/ADR/ADR-005-async-with-external-systems.md).

![Components Diagram (C3) - Story Processing](/C4/images/C3-components-story.svg)


## Data flow

### Sending a Resume for Story

1. The **Job candidate** submits, which communicates with the **Story API**.
2. The **Story API** forwards the resume to the **Resume Service**.
3. The **Resume Service** sends the resume to the **AI Anonymize Adapter** asynchronously.
4. The **AI Anonymize Adapter** passes the resume to the **AI Anonymize System**, which runs on separate containers.
5. The **AI Anonymize System** anonymizes the resume, ensuring that no personally identifiable information is stored.

### Storing the Story

1. Once the **AI Anonymize System** anonymizes the resume, it returns the processed story to the **AI Anonymize Adapter**, which sends the story back to the **Resume Service**.
2. The **Resume Service** stores the anonymized story directly in the **Shared Database**.
3. In case of processing failures, the resume is queued for retry, ensuring no data is lost during the process.


