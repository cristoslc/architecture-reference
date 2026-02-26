# Medical Professional Role

MonitorMe System is there to support medical professionals in providing the best care for their patients; by being able to monitor patient's vital signs and react fast when problems arise. Medical professionals are the target audience for this system. 
We've illustrated below 3 scenarios where a Medical Professional interacts with MonitorMe system and identified the [use cases](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/1.Requirements/UserJourneys/MedicalProfessional.md#use-cases) that derive from these interactions.

# Medical Professional's Journeys

## Registering patients
![registering patients](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/UserJourneys/registerPatients.png)

## Receiving alerts
![ReceiveAlers](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/UserJourneys/alertsJourney.png)

## Generating vital sign snapshots
![Medical professional](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/UserJourneys/snapshotJourney.png)

# Use cases 
- Register profile for patient in the MonitorMe system. Relevant information to collect: Name, Social Security Number, Status (hospitalized/discharged), Birth date.
- Assign patient to a hospital room and assign medical personnel that will provide medical care during his stay 
- Link vital sign monitoring devices to patient profile
- MonitorMe system reads data from medical devices 
- Display vital signs on the CMS
- CMS cycles through the vital signs of the assigned patients at a 5s interval
- Authenticate medical professional
- Send alerts to appropriate CMS and medical professionals, when patient vital sign is out of the norm
- Generate vital sign snapshot
- Upload vital sign snapshot to MyMedicalData
- A medical professional can filter trough the vital sign data of a patient by a time interval 

Out of current scope 
- MonitorMe can send alerts to the Hospital Administrator when one of the monitoring devices is not sending data 

# Identified components
Going through the user journeys and thinking on building the architecture of the system, the following components emerge: 
- Patient module, which will handle patient related info. 
- A security module, which will authenticate medical professionals in the system 
- Vital sign analysis module, will be the area that will decide if an alerts needs to be sent 
- Monitoring data module will be in charge with storing the recorded data 


