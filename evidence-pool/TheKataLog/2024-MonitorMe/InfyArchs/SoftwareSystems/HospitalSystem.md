
# Hospital Software System Architecture

## Overview

The Hospital Software System is designed to facilitate comprehensive patient monitoring, including real-time metrics capturing and alerting. It interacts with the MonitorMe Metrics Capturing System for retrieving patient vital metrics and the MonitorMe Alerting System for receiving alerts based on real-time anomaly detection.

| Feature | WHY | WHAT | HOW |
| --- | --- | --- | --- |
| Vital Monitoring Dashboard for Nurse Station with Real-Time Alerts | WHY: Timely responsiveness is critical for patient monitoring, and swift awareness of vital signs can be life-saving in emergencies. | WHAT: Real-time monitoring and alerting system for vital signs at nurse stations. | HOW: Implement HTTP-based polling mechanism for retrieving vital signs data periodically. Adopt a WebSocket-based approach for bidirectional communication, ensuring instant push notifications to nurse stations upon detecting anomalies. Leverage WebSocket protocol for reduced latency in alert delivery. |
| Patient Vital Profile Consolidation (point in time) | WHY: Comprehensive patient care requires consolidated vital profiles, and seamless integration with MyMedicalData enhances overall healthcare management. | WHAT: UI application for medical staff to generate consolidated patient vital profiles and upload data to MyMedicalData. | HOW: Implement a React-based Single Page Application (SPA) for the UI. Develop secure REST services (Node.js) for exposing vital measurements using HTTP-based polling. Integrate with MyMedicalData through secure HTTP API calls. |
| Mobile App Access for Historical Patient Vital Profiles | WHY: Accessibility to historical vital profiles on mobile enhances flexibility and convenience for medical professionals, allowing them to make informed decisions. | WHAT: Evolve mobile app to add feature for medical professionals to view historical patient vital profiles. | HOW: Integrate the existing mobile app with secure REST services (Node.js) to fetch and display historical patient vital profiles. Implement secure HTTP API calls to retrieve data and ensure seamless integration with the mobile app. |


## High Level Architecture

![](https://github.com/infy-archs-katas/monitorme/blob/main/diagrams/C2-HospitalSystem.png)

## Component Details

| Component Name  | Component Description | Technology Choices |
| ------------- | ------------- | ------------- |
| **Administration UI Application**  | An application for hospital administrators to perform tasks such as adding patients for monitoring, assigning monitoring devices, assigning nurses to nurse stations, and mapping patients to nurse stations.  | Single Page Application using React [ADR]([ADR](https://github.com/infy-archs-katas/monitorme/blob/main/ADRs/Serving%20SPA%20from%20container.md))  |
| **Database**  | Database component to store data related to patients, monitoring devices, nurses, and nurse stations.  | PostgreSQL  |
| **Nurse Station UI Application**  | UI application for nurses to monitor patient vital metrics. It utilizes React with embedded Grafana dashboards for a visual representation of vital metrics.  | React with embedded Grafana dashboards [ADR](https://github.com/infy-archs-katas/monitorme/blob/main/ADRs/Choosing%20Grafana%20Embedded%20in%20SPA%20for%20Visualizing%20Metrics%20Data.md) [ADR]([ADR](https://github.com/infy-archs-katas/monitorme/blob/main/ADRs/Serving%20SPA%20from%20container.md)) |
| **Vitals UI Application**  | UI application for medical staff to generate consolidated patient's vital profile for a requested time period. It includes upload functionality to MyMedicalData for a given patient.  | React Single Page Application [ADR](https://github.com/infy-archs-katas/monitorme/blob/main/ADRs/Serving%20SPA%20from%20container.md)  |
| **API Component - Vitals REST Service**  | REST service for exposing vital measurements per vital type. [ADR](https://github.com/infy-archs-katas/monitorme/blob/main/ADRs/Polling%20Mechanism%20for%20Monitoring%20Dashboard.md) | Node.js  |
| **API Component - Real-Time Alerts WebSocket Service**  | WebSocket service for pushing real-time alerts to single-page clients (web clients).[ADR](https://github.com/infy-archs-katas/monitorme/blob/main/ADRs/Websocket%20for%20Alerts.md)  | Node.js  |
| **API Component - Snapshot REST Service**  | REST service for exposing snapshotting and snapshot upload functions, with secure integration with MyMedicalData via HTTP interface.  | Node.js  |


## Architectural Characteristics
| Characteristics  | Business Need  | Recommendations  |
| ---------------- | --------------- | ----------------- |
| **Fault Tolerance**  | Ensure continuous monitoring of vital signs even if any monitoring device or software fails  | - Distributed Architecture (Micro-service). Each Vital metric served by dedicated http endpoint.  |
| **Availability**  | The system should be up and available with a 99.9% rate since we deal with patient vitals and lives are at stake here  | - Distributed Architecture (Micro-service). - Redundancy - Load balancing - Failover - Continuous monitoring  |
| **Data Integrity**  | Data captured by the MonitorMe system should be accurate and without any data loss.  | - Apply best practices like synchronization token, idempotency, robust error and retry mechanisms. - For snapshot uploads, ensure a checksum-based mechanism is incorporated to maintain integrity.  |
| **Performance**  | Medical professionals and nurses should be able to view the patient data and their history details without huge delays. The page should display the results in under a second.  | - Metrics retrievals should apply efficient time series data querying. - Frontend metrics monitoring dashboard should apply optimized frontend rendering.  |
| **Recoverability**  | Software and devices running in these distributed environments should be able to recover from unexpected failures and be able to restart from where it left off.  | - Ensure Health vital metrics microservices are stateless. - Components are immutable. - Use resilient communication patterns, such as circuit breakers and retries, to handle communication failures between microservices. - Implement fallback mechanisms to provide support in case of communication issues.  |
| **Deployability**  | MonitorMe is a new market and expects a lot of changes. The system should have the ability to publish new features to all distributed environments in less time.  | - Micro-service architecture helps introduce new vital additions for monitoring.  |
| **Security**  | The data generated by the MonitorMe system is stored in a variety of places (like devices/on-premise servers) and transmitted for various operations. The data needs to be secured at rest and in transit.  | - Ensure access control is applied for monitoring apps. - Ensure data transmission is secure.  |
| **Maintainability**  | The system, even though running in a distributed environment, should be managed and monitored with minimal effort.  | - Robust software version controls and build and deployment pipelines. - Automated monitoring and alerting using centralized dashboards.  |
| **Observability**  | MonitorMe system running in a distributed environment across multiple hospital locations needs to be monitored from a single pane of glass.  | - Automated monitoring and alerting using centralized dashboards.  |
| **Configurability**  | MonitorMe system utilizes a lot of devices, and the system should be able to configure them with ease and also push configuration updates easily.  | - New nurse station addition should be quickly added through minimum configurations. - UI-based configurations, templates & dynamic configuration loading.  |


## Architectural Choice

- **Microservices:**
  The decision to adopt a microservices architecture stems from the need for a scalable, modular, and maintainable system in the design of the Hospital Software System. By breaking down the overall application into smaller, independent microservices, each responsible for a specific functionality, we can achieve improved scalability and flexibility. Microservices enable individual components to scale independently, allowing for efficient resource utilization based on demand. Additionally, the modular nature of microservices promotes ease of maintenance and updates, as changes to one service do not necessarily impact others. The use of a container platform, such as Docker, complements the microservices architecture by providing a consistent and isolated runtime environment for each service. Containerization ensures seamless deployment across various environments, streamlining the development and deployment processes. The combination of microservices and containerization aligns with modern software development practices, fostering agility, fault isolation, and improved resource management in the context of the Hospital Software System.


## Deployment View
Below is the deployment view based on the architecture choice 

![](https://github.com/infy-archs-katas/monitorme/blob/main/diagrams/HSDeployment-view.png)

## Devops Model
Below is the devops approach following the gitops approach 

![](https://github.com/infy-archs-katas/monitorme/blob/main/diagrams/HospitalSystemDevOps.png)

