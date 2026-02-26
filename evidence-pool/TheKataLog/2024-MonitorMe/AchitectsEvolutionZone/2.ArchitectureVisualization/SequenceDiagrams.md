# Sequence diagrams

### Medical professional alerting

Vital sign data is read from eight different patient-monitoring devices and received by a Device Gateway. This pushes messages with this data to an Event Bus. The Data Analysis Module analysis consumes the vital sign information and performs an analysis on it, deciding afterwards whether an alert needs to be sent. If an issue occurs or reaches a preset threshold, it will send the alert back to the Event Bus. From here, the alert messages are consumed by the CMS anf the Mobile App. The medical professional is notified of the emergency alert, by the Mobile App or it gets it displayed on the CMS.

![alerting](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/SequenceDiagrams/Medical%20professional%20alerting.png)

### CMS vital sign display

Vital sign data is read from eight different patient-monitoring devices and received by a Device Gateway that further pushes the messages to an Event Bus. CMS consumes the vital sign information and then displays it. A medical professional can see the values of the patients' vital signs on the consolidated monitoring screen.

![cms](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/SequenceDiagrams/CMS%20vital%20sign%20display.png)

### Store data

Vital sign data is read from eight different patient-monitoring devices and received by a Device Gateway. The information is pushed to an Event Bus. The Monitoring Data Module then consumes the messages and persists the vital sign data in the database.

![store](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/SequenceDiagrams/Store%20data.png)
