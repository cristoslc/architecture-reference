# DeviceGateway for Data Transmission

## Context
Considering the use of multiple medical devices which each transmit data and different intervals, 
a sort of messaging component would be needed, in order to facilitate this. 

## Status
Proposed

## Decision
The decision is to implement a message broker physical component, which would facilitate data transmission between various types of devices and
consumers, over wired and wireless communication.

## Consequences
 * Improved Communication: DeviceGateway will act as a hub for seamless communication between various components in our ecosystem, enabling efficient data exchange over both wired and wireless channels.
 * Flexibility: DeviceGateway's support for multiple messaging protocols and message persistence will provide flexibility for integrating with various systems, protocols, and message formats, ensuring compatibility with existing and future devices and systems.
 * Scalability: DeviceGateway's ability to handle large volumes of messages and maintain high availability will support scalability as our ecosystem grows.
 * Security: DeviceGateway provides robust security features, such as access control lists (ACLs), SSL/TLS encryption, and user authentication, ensuring secure communication between components.
 * Monitoring and Management: DeviceGateway offers extensive monitoring and management capabilities, allowing us to track message delivery, monitor queues, and troubleshoot issues, ensuring the overall health and performance of our ecosystem's communication.
 * Cost-Effectiveness: The adoption of DeviceGateway may involve initial costs for setup and configuration, as well as ongoing costs for maintenance and support. However, the benefits of improved communication, flexibility, scalability, and security are expected to outweigh these costs in the long term.
   
## Options
  * Cloud-Based Message Brokering: We could explore using a cloud-based message broker service instead of a physical component. Cloud-based solutions offer scalability, redundancy, and easier maintenance, potentially reducing infrastructure costs and management overhead.

## Usefull links 
- [Infrastructure page](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/2.ArchitectureVisualization/Infrastructure.md)
- [C4 Diagram](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/2.ArchitectureVisualization/C4Diagram.md)
