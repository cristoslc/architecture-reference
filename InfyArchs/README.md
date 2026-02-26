This repository is created for solution created by team ***InfyArchs*** as part of the ***O'Reilly Architecture Katas Winter 2024 edition***. This has the solution proposal for "MonitorMe" usecase identified for this Katas event.

Team Members:
- [***Bhagwandas Gupta***](https://www.linkedin.com/in/bhagwan-das-gupta-93b333121/)
- [***Christophe Pillot***](https://www.linkedin.com/in/christophe-pillot-ba361b178/)
- [***Kishore Allwynraj Arul Gnanaraj***](https://www.linkedin.com/in/kishoregnanaraj/)
- [***Rami Chalhoub***](https://www.linkedin.com/in/chalhoubrami/)

---

# MonitorMe

## Business Context

StayHealthy, Inc. is a large and highly successful medical software compamny located in San Francisco, California, US. They currently have two popular cloud-based SAAS products: ***MonitorThem*** and ***MyMedicalData***.

***MonitorThem*** a comprehensive data analytics platform that is used for hospital trend and performance analytics—alert response times, patient health problem analytics, patient recovery analysis, and so on.

***MyMedicalData*** is a comprehensive cloud-based patient medical records system used by doctors, nurses, and other heath professionals to record and track a patients heath records with guaranteed partitioning between patient records.

StayHealthy, Inc. is now expanding into the medical monitoring market, and is in need of a new medical patient monitoring system for hospitals that monitors a patients vital signs using proprietary medical monitoring devices built by StayHealthy, Inc.

## Business Requirements

| BR No  | Description |
| ------------- | ------------- |
| BR1  | ***MonitorMe*** reads data from eight different patient-monitoring equipment vital sign input sources: heart rate, blood pressure, oxygen level, blood sugar, respiration rate, electrocardiogram (ECG), body temperature, and sleep status (sleep or awake). It then sends the data to a consolidated monitoring screen (per nurses station) with an average response time of 1 second or less. The consolidated monitoring screen displays each patients vital signs, rotating between patients every 5 seconds. There is a maximum of 20 patients per nurses station.  |
| BR2  | For each vital sign, ***MonitorMe*** must record and store the past 24 hours of all vital sign readings. A medical professional can review this history, filtering on time range as well as vital sign.  |
| BR3  | ***MonitorMe*** software must also analyze each patient’s vital signs and alert a medical professional if it detects an issue (e.g., decrease in oxygen level) or reaches a preset threshold (e.g., temperature has reached 104 degrees F).  |
| BR4  | Some trend and threshold analysis is dependent on whether the patient is awake or asleep. For example, if the blood pressure drops, the system should notice that the patient is asleep and adjust its alerts accordingly. The same is true with the respiration rate and heart rate. For example, all of these vital signs are reduced when the patient is asleep, but if awake something might be wrong.  |
| BR5  | Medical professionals receive alert push notifications of a potential problem based on raw data analysis to a StayHeathy mobile app on their smart phone as well as the consolidated monitoring screen in each nurses station.  |
| BR6  | If any of vital sign device (or software) fails, ***MonitorMe*** must still function for other vital sign monitoring (monitor, record, analyze, and alert).  |
| BR7  | Medical staff can generate holistic snapshots from a patients consolidated vital signs at any time. Medical staff can then upload the patient snapshot to ***MyMedicalData***. The upload functionality is within the scope of the ***MonitorMe*** functionality and is done through a secure HTTP API call within ***MyMedicalData***.  |
| BR8  | StayHealthy, Inc. is looking towards adding more vital sign monitoring devices for ***MonitorMe*** in the future. As this is a new line of business for StayHealthy, they expect a lot of change as they learn more about this new market.  |

## Technical Requirements

| TR No  | Description |
| ------------- | ------------- |
| TR1  | Each patient monitoring device transmits vital sign readings at a different rate: Heart rate: every 500ms, Blood pressure: every hour, Oxygen level: every 5 seconds,  Blood sugar: every 2 minutes, Respiration: every second, ECG: every second, Body temperature: every 5 minutes, Sleep status: every 2 minutes |
| TR2  | MonitorMe will be deployed as an on-premises system. Each physical hospital location will have its own installation of the complete MonitorMe system (including the recorded raw monitoring data). StayHealthy. Inc. will be providing a comprehensive hardware and software for this system. |
| TR3  | Maximum number of patients per physical MonitorMe instance: 500  |
| TR4  | StayHealthy, Inc. has always taken patient confidentially seriously. ***MonitorMe*** should be no exception to this rule. While patient monitoring data must be secure, ***MonitorMe*** does not have to meet any government regulatory requirements (e.g., HIPPA).  |


---

# High Level Architecture

Below is the proposed high level architecture for implementing the ***MonitorMe*** solution.

![](https://github.com/infy-archs-katas/monitorme/blob/main/diagrams/C4-SystemContext.png)

Below are the different systems involved in realizing this solution.

| System Name  | System Description |
| ------------- | ------------- |
| [Vitals Monitoring System](https://github.com/infy-archs-katas/monitorme/blob/main/SoftwareSystems/VitalsMonitoringSystem.md)  | Software running on the physical devices connected to patient. This system reads the patient vitals through the sensors on the device and sync the data to a centralized system for further monitoring.  |
| [Metrics Capturing System](https://github.com/infy-archs-katas/monitorme/blob/main/SoftwareSystems/MetricsCapturingSystem.md)  | Captures patient vitals information in raw format and persist the data. This system also provides capability for multiple systems to subscribe and filter and retrieve the vitals information for real-time monitoring.   |
| [Hospital System](https://github.com/infy-archs-katas/monitorme/blob/main/SoftwareSystems/HospitalSystem.md)  | The primary system used by medical professionals working in hospitals. This system is used for monitoring patient vitals and also get alerted whenever any anamolies are detected based on the captured raw vitals data.  |
| [Administration System](https://github.com/infy-archs-katas/monitorme/blob/main/SoftwareSystems/AdminSystem.md)  | An admin interface using which hospitals can be onboarded into the MonitorMe system. Also used to configure physical devices before shipping them to hospitals for monitoring patient vitals.  |
| [Alerting System](https://github.com/infy-archs-katas/monitorme/blob/main/SoftwareSystems/AlertingSystem.md)  | A system used to receive alerts based on anamolies detected using the raw data. This system is responsible for delivering the alerts into all subscribed consumers or devices.  |

---

# Solution Characteristics

![](https://github.com/infy-archs-katas/monitorme/blob/main/diagrams/SolutionCharacteristics.png)

| Architecture Characteristics  | Business Needs |
| ------------- | ------------- |
| Fault Tolerance  | If any of vital sign device (or software) fails, ***MonitorMe*** must still function for other vital sign monitoring (monitor, record, analyze, and alert).  |
| Availability  | The system should be up and available with 99.9% rate since we deal with patient vitals and lives are at stake here.  |
| Data Integrity  | Data captured by the MonitoreMe system should be accurate and without any data loss.  |
| Performance  | The medical professionals and nurses should be able to view the patient data and their history details without huge delays. Page should display the results in under a second.  |
| Recoverability  | Software ande devices running in this distributed environments should be able to recover from unexpected failures and be able to restart from where it left-off. |
| Deployability  | ***MonitorMe*** is a new market and expects lot of changes. The system should have the ability to publish new features to all distributed environments in less time. |
| Configurability  | ***MonitorMe*** system utilizes lot of devices and the system should be able to configure them with ease and also push configuration updates easily. |
| Security  | The data generated by the ***MonitorMe*** system are stored in variety of places (like devices/on-premise servers) and transmitted for various operations. The data needs to be secured at rest and in transit. |
| Maintainability  | The system even though running in distributed environment should be managed and monitored with minimal effort. |
| Observability  | ***MonitorMe*** system running in distributed environment across multiple hospital locations needs to be monitored from a single pane of glass. |
