<img src="https://static.vecteezy.com/system/resources/previews/017/316/736/original/an-icon-of-health-monitor-in-modern-style-pulse-monitor-vector.jpg" align="right" height="64px" />

# MonitorMe

## Executive summary 
This document presents an architectural proposal done by AchitectsEvolutionZone team for the O’Reilly Winter 2024 Architectural Katas contest.
The architecture describes our approach and decisions for implementing MonitorMe, a software that will help healthcare professionals by leveraging the power of new devices to provide accurate, timely, and easy to read patient data. Helping them in diagnosing and choosing treatments will lead to faster, better, and informed decisions for healthcare professionals and faster recovery time for patients.”
A thorough requirements analysis proses was used to identify architectural characteristics, user flows, C4 diagrams, sequence diagrams, infrastructure layout, user interface mockups, and ADRs were used to describe our vision on how MonitorMe can be designed and implemented.

## Context and overview
<img src="https://clipart-library.com/8300/1931/description-clipart-description-clipart-1.jpg" align="left" height="64px" />

StayHealthy, Inc. is a large successful medical software company that already has two popular cloud-based SAAS products on the market (MonitorThem and MyMedicalData).
The next product they want to bring to life is MonitorMe, a product that will collect patient vital signs from various sources (like wearables and medical devices that measure heart rate, blood pressure, oxygen level, blood sugar, respiration rate, electrocardiogram (ECG), body temperature, and sleep status). 
This document intends to describe the architecture of MonitorMe, constraints, and considerations for building an easy-to-use, reliable, scalable, and secure system.

## Video presentation
You can find a video presentation of our design process and proposed solution [at this page](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/2.ArchitectureVisualization/VideoOverview.md).

## Table of contents
### 1. [MonitorMe story](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/man/1.Requirements/MonitorMeStory.md)
### 2. MonitorMe system overview
#### 2.1. [Client Initial requirements](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/1.Requirements/ClientInitialRequirements.md)
#### 2.2. [Requirements analysis](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/1.Requirements/Capabilities.md)
##### 2.2.1. [User journey - hospital admin](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/1.Requirements/UserJourneys/HospitalAdmin.md)
##### 2.2.2. [User journey - medical profesional](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/1.Requirements/UserJourneys/MedicalProfessional.md)
##### 2.2.3. [Requirements analysis conclusions](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/1.Requirements/CoreRequirements.md)
##### 2.2.4. [Glossary](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/1.Requirements/Glossary.md)
#### 2.3. [Cross-functional requirements](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/1.Requirements/CrossFunctionalRequirements.md)
#### 2.4. Capabilities
####   2.4.1 Consolidated Monitoring Screen
####     2.4.1.1. [Pacient Overview](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/Mocks/CMS.png)
####     2.4.1.2. [Desktop UI](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/Mocks/Desktop1.png)
####     2.4.1.3. [Entity Management](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/Mocks/Desktop2.png)
####   2.4.2 MonitorMe Mobile App
####     2.4.2.1 [Launch UI](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/Mocks/Mobile1.png)
####     2.4.2.2 [Pacient Overview](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/Mocks/Mobile2.png)
####     2.4.2.3 [Alert](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/Mocks/Mobile3.png)
### 3. Architecture visualization
#### 3.1. [OnPremise infrastructure](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/2.ArchitectureVisualization/Infrastructure.md)
#### 3.2. [C4 diagram](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/2.ArchitectureVisualization/C4Diagram.md)
#### 3.3. [Sequence diagrams](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/2.ArchitectureVisualization/SequenceDiagrams.md)
#### 3.4. [Architecture style](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/2.ArchitectureVisualization/ArchitectureStyle.md)
#### 3.5. [Deployment](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/2.ArchitectureVisualization/Deployment.md)
### 4. ADR
#### 4.1. [ADR001-WiredCommunicationGatewayToCMS](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR001-WiredCommunicationGatewayToCMS.md)
#### 4.2. [ADR002-HL7TransmissionToDeviceGateway](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR002-HL7TransmissionToDeviceGateway.md)
#### 4.3. [ADR003-WiredCommunicationGatewayToServer](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR003-WiredCommunicationGatewayToServer.md)
#### 4.4. [ADR004-WLANDataRequestsToServer](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR004-WLANDataRequestsToServer.md)
#### 4.5.  [ADR005-WLANReceiveAlertsFromServer](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR005-WLANReceiveAlertsFromServer.md)
#### 4.6. [ADR006-DeviceGateway](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR006-DeviceGateway.md)
#### 4.7. [ADR007-MessagingBrokerForDeviceGateway](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR007-MessagingBrokerForDeviceGateway.md)
#### 4.8. [ADR008-WiredCommunicationServerToCMS](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR008-WiredCommunicationServerToCMS.md)
#### 4.9. [ADR009-NoSQLOnPrem](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR009-NoSQLOnPrem.md)
#### 4.10. [ADR0010-InMemoryCaching](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR010-InMemoryCaching.md)
#### 4.11. [ADR0011-OnPremServerCluster](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR011-OnPremServerCluster.md)
#### 4.12. [ADR0012-EventDrivenArchitecture](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR012-EventDrivenArchitecture.md)

## Contributors

<img src="https://clipart-library.com/img/1558480.jpg" height="64px" />

- Alina Avram
- Ionut Burzo
- Hajni Burzo-Covaci
- Claudiu Cretu
- Mihai Todorut

We are a team of software professionals, keen to improve our software architecture  practice so that we give projects clarity, transparency, predictability, and lower the risk of project failure (not in time, scope, and budget).
### Contact Information: ArchitectsEvolutionZone@evozon.com

