# Vitals Monitoring System

The device sensors are the key component which will be used to read the patient's vitals, however these are hardware components and will not have the intrinsic ability to store the data for long term and also syncronize the data for long term storage. This is where building a reliable application ecosystem around the sensor to manage the data integrity and synscronization charecteristics is really important.

***Vitals Monitoring System*** is the software system which will be deployed on the devices which will be used to capture the patient vitals information.

Below is the high level architecture view of ***Vitals Monitoring System***.

![](https://github.com/infy-archs-katas/monitorme/blob/main/diagrams/VMS-C4ContainerView.png)

## Component Details

| Component Name  | Component Description | Technology Choices |
| ------------- | ------------- | ------------- |
| **Background Worker***  | Worker service which connects to the sensor to read the data based on configured intervals and save the data into database.  | Go or Rust based worker service.  |
| ***Database***  | Timeseries based NoSQL database which is used to store the patient vitals data. The data can be stored in the device for 24 hours. | Influx DB or Couchbase Lite  |
| ***Vitals UI Application***  | UI dashboard which the patient can use to view the vitals information. This is a limited dashboard to accomodate within the device display area.  | Grafana.  |
| ***Vitals API & Worker***  | Syncronization service which will read the data from database and push the data into Push into an IOT device gateway using standard IOT protocols like MQTT.  | Go or Rust based worker service. Also API endpoint exposed.   |
| ***Admin API Application***  | API service which is used to configure any settings related data on the device.  | Go or Rust based API service.  |


## Architectural Characteristics

| Characteristics  | Decisions |
| ------------- | ------------- |
| Fault Tolerance  | Applications need to implement proper resiliency patterns like retries, circuit-breaker patterns as applicable to ensure it handles all failure scenarios with appropriate fallback logic and without impact on the overall performance.  |
| Recoverability  | Applications running inside edge devices should have the ability to recover from unexpected failures or crash. This can be achived by having an external orchestrator which can restart the applications automatically whenever applications crashes in unexpected way. Please refer this ADR [Use K3s as orchestrator platform within devices.md](https://github.com/infy-archs-katas/monitorme/blob/main/ADRs/Use%20K3s%20as%20orchestrator%20platform%20within%20devices.md) |
| Security  | Patient vitals information is a secure data. The data should be encrypted at rest and transit.  |
| Deployability  | New changes implemented on the applications should be rolled out to all devices quickly. This can be achived by implementing Gitops model for continuous deployment. Please refer this ADR [Gitops approach for deployment](https://github.com/infy-archs-katas/monitorme/blob/main/ADRs/Gitops%20approach%20for%20deployment.md) |
| Maintainability & Monitoring  | New devices should be onboarded faster and also all edge devices needs to be monitored centrally to identify failures ahead. Please refer this ADR [Rancher for monitoring K3s clusters on edge devices](https://github.com/infy-archs-katas/monitorme/blob/main/ADRs/Rancher%20for%20monitoring%20K3s%20clusters%20on%20edge%20devices.md) |


## Architectural Choice

- Microservices

## Deployment View
Below is the deployment view based on the architecture choice and this ADR [Use K3s as orchestrator platform within devices.md](https://github.com/infy-archs-katas/monitorme/blob/main/ADRs/Use%20K3s%20as%20orchestrator%20platform%20within%20devices.md)

![](https://github.com/infy-archs-katas/monitorme/blob/main/diagrams/VMS-DeploymentView.png)

## Devops Model
Below is the devops approach following the gitops approach as decided in this ADR [Gitops approach for deployment](https://github.com/infy-archs-katas/monitorme/blob/main/ADRs/Gitops%20approach%20for%20deployment.md)

![](https://github.com/infy-archs-katas/monitorme/blob/main/diagrams/VMS-DevopsView.png)


