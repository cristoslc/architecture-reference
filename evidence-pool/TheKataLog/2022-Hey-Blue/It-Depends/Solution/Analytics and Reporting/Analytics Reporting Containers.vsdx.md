# Visio Diagram: Analytics Reporting Containers.vsdx

## Containers - Analytics and Reporting

**Components:**

- [Actor] SRE / [HeyBlue! Staff] /  / Systems Reliability Engineer
- [Actor] Management / [HeyBlue! Staff] /  / Organizational and Operational Management
- [Actor] Media Relations / [HeyBlue! Staff] /  / Drives Positive Data-Driven Media Interaction
- [Database] Operational Telemetry Storage / [S3 Compatible] /  / Logs, Metric, Traces and Event Store
- [Component] Analystics and Reporting [Software System]
- [Component] Telemetry Gateway / [OpenTelemetry] /  / Ingress for all Telemetry Signals
- [Component] Analytics / [Container: technology] /  / description of / database
- [Component] Analytics Engine /  / Queriers and Data Services
- [Component] Stores / [mTLS]
- [Component] Loads / [mTLS]
- [Component] ETL / [Container: technology] /  / Extracts real-time data, transforms and loads to Analytics Store
- [Component] Extracts to / [mTLS]
- [Component] Reads / [mTLS]
- [Component] Reads Data,  / Stores Analysis Results / [mTLS]
- [Component] Reporting Engine / [Container: technology] /  / Schedules, Generates and Publishes Reports
- [Component] Queries / [mTLS]
- [Component] Data Staff / [HeyBlue! Staff] /  / Data Analysts, Scientists and Engineers
- [Component] Admin / [HeyBlue! Staff] /  / Generates, Publishes, Schedules Reports
- [Component] Model Engine / [Container: technology] /  / Create, Train, Test, Deploy
- [Component] Analytics Interface / [Container: technology] /  / Manage operational data and run ad-hoc analysis
- [Component] Monitoring / Alerting / Analysis / Automation / [technology]
- [Component] Ad-Hoc Analysis / AIOps
- [Component] Pulls Data / [technology]
- [Component] Model Storage / [Container: technology] /  / Storage of ML Models
- [Component] Reports Interface / [Container: technology] /  / Supports Reading, Publishing, Generating and Scheduling
- [Component] Read / Publish / Generate / Schedule / [Event]
- [Component] Generate, Publish, Schedule / [HTTPS]
- [Component] Read / [HTTPS]
- [Component] Read/Verify / [HTTPS]
- [Component] AIOps
- [Component] CRUD / [mtlS]
- [Component] Donate Redeem / [Software System]  / Manages Charity and Business Relations and Donation/Redemption
- [Component] Interaction Management / [Software System]  / System for community members to interact for good
- [Component] Pushes Events / [mTLS]
- [Component] Pushes Events / [mTLS]
- [Component] Media Management / [Software System]  / Manages Social and Other Media Interactions
- [Component] Generates / [Event]
- [Component] All Containers of All Systems / [Container: technology]
- [Component] Push Observability Data / [technology]
- [Component] [Software System] Analytics and Reporting / Container Diagram

**Connections:**

- Analytics Engine --(Reads Data,  / Stores Analysis Results / [mTLS])--> Analytics
- Telemetry Gateway --(Stores / [mTLS])--> Operational Telemetry Storage
- ETL --(Loads / [mTLS])--> Analytics
- Operational Telemetry Storage --(Extracts to / [mTLS])--> ETL
- Analytics Engine --(Reads / [mTLS])--> Operational Telemetry Storage
- All Containers of All Systems --(Push Observability Data / [technology])--> Telemetry Gateway
- Reporting Engine --(Generates / [Event])--> Media Management
- Donate Redeem --(Pushes Events / [mTLS])--> Telemetry Gateway
- Interaction Management --(Pushes Events / [mTLS])--> Telemetry Gateway
- Model Engine --(CRUD / [mtlS])--> Model Storage
- Shape-33 --(AIOps)--> Model Engine
- Data Staff --> Shape-50
- Media Relations --(Read/Verify / [HTTPS])--> Shape-50
- Management --(Read / [HTTPS])--> Shape-48
- Admin --(Generate, Publish, Schedule / [HTTPS])--> Shape-48
- Shape-48 --(Read / Publish / Generate / Schedule / [Event])--> Reporting Engine
- Model Engine --(Pulls Data / [technology])--> Analytics Engine
- Shape-35 --> Analytics Engine
- Data Staff --(Ad-Hoc Analysis / AIOps)--> Shape-33
- SRE --(Monitoring / Alerting / Analysis / Automation / [technology])--> Shape-37
- Reporting Engine --(Queries / [mTLS])--> Analytics Engine

## Component - AnalyticsReporting - TelemetryGateway

**Components:**

- [Database] Operational Telemetry Storage / [S3 Compatible] /  / Logs, Metric, Traces and Event Store
- [Component] [Component] AnalyticsReporting System – TelemetryGateway
- [Component] TelemetryGateway [Container]
- [Component] OrganizationalIncentives / [Software System]  / Manages Charity and Business Relations and Donation/Redemption
- [Component] CommunityConnectChange / [Software System]  / System for community members to interact for good
- [Component] Pushes Telemetry / [mTLS]
- [Component] Pushes Telemetry / [mTLS]
- [Component] OpenTelemetry Collector / [Component: GOLang]  / Telemetry Collector Pipeline in Gateway Deployment. Receives/Processes/Exports
- [Component] Logs Distributor / [Component: technology]  / Accepts Log batches, distributes to ingestor. Scales horizontally
- [Component] Logs Ingestor / [Component: technology]  / Stores and indexes Logs. Scales horizontally
- [Component] Exports / [mTLS]
- [Component] Distributes / [mTLS]
- [Component] Stores/Indexes / [mTLS]
- [Component] Metrics Distributor / [Component: technology]  / Accepts Metrics batches, distributes to ingestor. Scales horizontally
- [Component] Metrics Ingestor / [Component: technology]  / Stores and indexes Metrics. Scales horizontally
- [Component] Distributes / [mTLS]
- [Component] Stores/Indexes / [mTLS]
- [Component] Trace Distributor / [Component: technology]  / Accepts Trace batches, distributes to ingestor. Scales horizontally
- [Component] Trace Ingestor / [Component: technology]  / Stores and indexes Traces. Scales horizontally
- [Component] Distributes / [mTLS]
- [Component] Stores/Indexes / [mTLS]
- [Component] EventsDistributor / [Component: technology]  / Accepts Events batches, distributes to ingestor. Scales horizontally
- [Component] Events Ingestor / [Component: technology]  / Stores and indexes Events. Scales horizontally
- [Component] Distributes / [mTLS]
- [Component] Stores/Indexes / [mTLS]
- [Component] Exports / [mTLS]
- [Component] Exports / [mTLS]
- [Component] Exports / [mTLS]

**Connections:**

- Logs Ingestor --(Stores/Indexes / [mTLS])--> Operational Telemetry Storage
- CommunityConnectChange --(Pushes Telemetry / [mTLS])--> OpenTelemetry Collector
- OrganizationalIncentives --(Pushes Telemetry / [mTLS])--> OpenTelemetry Collector
- OpenTelemetry Collector --(Exports / [mTLS])--> Logs Distributor
- Logs Distributor --(Distributes / [mTLS])--> Logs Ingestor
- OpenTelemetry Collector --(Exports / [mTLS])--> EventsDistributor
- OpenTelemetry Collector --(Exports / [mTLS])--> Trace Distributor
- OpenTelemetry Collector --(Exports / [mTLS])--> Metrics Distributor
- Events Ingestor --(Stores/Indexes / [mTLS])--> Operational Telemetry Storage
- EventsDistributor --(Distributes / [mTLS])--> Events Ingestor
- Trace Ingestor --(Stores/Indexes / [mTLS])--> Operational Telemetry Storage
- Trace Distributor --(Distributes / [mTLS])--> Trace Ingestor
- Metrics Ingestor --(Stores/Indexes / [mTLS])--> Operational Telemetry Storage
- Metrics Distributor --(Distributes / [mTLS])--> Metrics Ingestor

---
*Converted from Visio VSDX (shape text and connections extracted)*
