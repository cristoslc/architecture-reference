# Context
This is a high level overview of the system, meant to show what other systems and roles MonitorMe will interact with.
![infrastructure](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/C4/Context%20Diagram.jpg)

# Containers
Zooming in, we can see which containers build up the MonitorMe system and we hint at the technologies used.
![infrastructure](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/C4/Containers%20Diagram.jpg)

# Components
On an even lower abstraction level, the behavrior of the MonitorMe system becomes more clear; we can see how the componentent of the system will interact with each other.

### Processing vital sign device data 

The Device Gateway has several Device processors, specific to vital sign monitoring devices. This is an extensibility point of the architecture, in case other vital sign devices need to be supported. We can add new Device processors that will take the data transmitted by the new monitoring device, convert it to our preferred format (if it’s the case) and then publish the message over the Event Messaging System. 

The Event Messaging system will distribute the message over several dedicated queues, each vital sign data has its dedicated distribution channels. 
The consumers that attach to the Event Messaging System, will have specific responsibilities. On one hand, these messages are persisted by the Monitoring Data module, residing in the WebApi container. On another hand, the messages are consumed by the Data Analysis Module in order to determine if there is an alert to be published. We plan on [caching](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR010-InMemoryCaching.md) the other vital signs for a patient in the Data Analysis Module, so the decision of alerting can be made as fast as possible. 


![infrastructure](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/C4/Components%20Diagram.jpg)

### Relevant Architecture Decision Records 
- [Using Device Gateway to push vital sign device data into the system](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR006-DeviceGateway.md)
- [Using a Messaging Broker to facilitate communication between components](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR007-MessagingBrokerForDeviceGateway.md)
- [Using NoSQL as persistance](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR009-NoSQLOnPrem.md)
- [Using Event driven architectural style](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR012-EventDrivenArchitecture.md)
- [Using in memory caching to enhance alert time](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR010-InMemoryCaching.md)

