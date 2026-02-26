<img src="https://www.pngkit.com/png/full/53-536659_software-architecture-and-design-back-end-web-development.png" align="right" height="64px" />

# Architecture Style

## Project scope

MonitorMe aims to provide instantaneous alerts to medical professionals by leveraging received vital data, enabling swift responses to potential problems with a patient. The system's [core](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/1.Requirements/CoreRequirements.md) functionality revolves around real-time monitoring of vital signs, ensuring that healthcare providers receive timely notifications, facilitating prompt and effective interventions when necessary.

Choosing an appropriate architectural style is essential for ensuring that the system's structure aligns with the business specific needs.

## Identified architectural characteristics

In the requirements analysis phase, the team identified Performance, Responsiveness, and Fault Tolerance as pivotal architectural characteristics for the MonitorMe system. 

#### Responsiveness
It is imperative for medical professionals to instantly discern any potential  indicated by a patient's vital data. To meet this crucial requirement, our focus will be on constructing a system that ensures a rapid response. The emphasis will be on building a solution that enables immediate identification of anomalies in vital signs, allowing healthcare providers to promptly address and respond to any emergent situations.

#### Performance
The component responsible for data analysis and the decision-making process regarding alert generation must possess robust performance support. Achieving optimal performance is critical for ensuring that alerts are sent promptly. This necessitates fast and reliable reception of data. The selected architectural style plays a pivotal role in determining the system's performance, encompassing aspects such as response time, throughput, and efficient resource utilization. 

#### Fault-tolerance

In addition to prioritizing performance, fault tolerance is a crucial aspect of the system's architecture, particularly in a healthcare environment where reliability is paramount. Fault tolerance ensures the system can gracefully handle and recover from potential failures or disruptions. 

#### Other considerations
Over the system's lifecycle, changes and updates will be inevitable, especially since it's a new line of business. An architectural style that supports maintainability and extensibility simplifies the process of introducing new features or additional medical devices or also making modifications without causing major disruptions.

## Architecture styles evaluation

Event-driven architecture focuses on the flow of events within a system or between different systems, often in the form of messages or notifications. Various components of a system communicate and react to events asynchronously, rather than through direct, synchronous method calls. Events can represent various occurrences, changes in state, or triggers within a system.

Event-driven architecture is commonly used in various applications, including:
- Real-time data processing
- Microservices-based systems
- IoT (Internet of Things) applications
- Systems that require high levels of concurrency and responsiveness

After conducting a thorough assessment utilizing the [Architecture Styles Worksheet](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/2.ArchitectureVisualization/ArchitectureStylesWorksheet.png), the team has arrived at the decision that the most fitting architectural solution for the MonitorMe system is the adoption of an event-driven architecture. This conclusion is based on the alignment of the event-driven paradigm with the identified [project requirements](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/1.Requirements/ClientInitialRequirements.md) and essential [architectural characteristics](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/1.Requirements/CrossFunctionalRequirements.md). The team foresees that embracing an event-driven architecture will effectively address the dynamic nature of vital sign monitoring, offering scalability and responsiveness crucial for the system's success.

We also tool in consideration a Microservice architecture approach, and while Microservices offer numerous benefits, including agility, scalability, and ease of maintenance, they may introduce certain challenges in terms of performance, especially in scenarios where low latency is crucial, such as providing fast alerts in healthcare systems.
Given the emphasis on providing fast alerts in our scenario, Event-driven architecture style was preferred.

## Rationale and benefits

The rationale for choosing an event-driven architecture for the MonitorMe system is based on several key factors identified during the assessment and evaluation process.

#### Real-time Responsiveness
Event-driven architectures excel at providing real-time responsiveness. In the context of MonitorMe, where timely alerts for potential patient issues are critical, the event-driven model aligns with the need for instantaneously processing vital sign data and triggering alerts.

#### Adaptability to Changes
Event-driven architecture is adaptable and facilitate the addition of new features and integrations without major disruptions. In a healthcare environment where evolving technology and changing requirements are common, this adaptability is crucial for the long-term success of the system.

#### Seamless Integration
Event-driven systems can easily integrate with external services, making communication with other systems like the Device Gateway for example, seamless. This capability is essential for MonitorMe to efficiently exchange data with external entities, contributing to comprehensive patient monitoring.

#### Loose Coupling
Event-driven architectures typically promote loose coupling between components. This can enhance system flexibility, making it easier to modify or update individual components without affecting the entire system. This aligns with the need for maintainability and extensibility in the healthcare monitoring context.

#### Efficient Use of Resources
Event-driven architectures can optimize resource utilization by triggering actions only when relevant events occur. This efficiency is crucial for a system like MonitorMe, where the focus is on processing vital sign data efficiently and promptly without unnecessary resource consumption.

#### Facilitating Parallel Processing
The event-driven model allows for parallel processing of events, enabling the system to handle multiple concurrent events simultaneously. This can contribute to improved overall system performance and responsiveness.

#### Enhanced Fault Tolerance
Event-driven architectures can enhance fault tolerance by allowing the system to gracefully handle faults or disruptions. This is critical for ensuring continuous monitoring and alerting capabilities, especially in a healthcare setting where system reliability is paramount.

By considering these factors, the team has determined that an event-driven architecture aligns well with the specific requirements and goals of the MonitorMe system, making it a suitable choice for the project.

## Project constraints

#### Learning Curve
Introducing an event-driven architecture may require the development team to acquire new skills and practices. Training and adaptation to the new paradigm may be a constraint, especially if the team is not already familiar with event-driven development. Providing training and resources for the team to acquire the necessary skills and bringing in experts or mentors with experience in event-driven development are some of the actions considered to mitigate this consraint.

#### Operational Practices
Managing a distributed event-driven system demands robust operational practices. Ensuring that operational teams are well-versed in handling event-driven architectures is crucial for system stability and performance.
We will implement robust operational practices, monitoring, and automation tools to streamline system management and also invest in training or hiring personnel with expertise in system operations.

## Risks and mitigations

#### Data Consistency
Risk: Ensuring data consistency across distributed components can be challenging, and improper handling could lead to data discrepancies.
Mitigation: Implement mechanisms for data validation and consistency checks. Use transactions or compensating transactions where appropriate to maintain data integrity.

#### Complex Event Routing Logic
Risk: The complex event routing logic may be difficult to manage and debug, potentially causing errors or delays.
Mitigation: Thoroughly document and test event routing logic. Implement logging and monitoring to quickly identify and address any issues. Consider using tools that provide visualization of event flows for better debugging.

#### Security Concerns:
Risk: Event-driven architectures may introduce security concerns, such as unauthorized event consumption or tampering.
Mitigation: Implement robust authentication and authorization mechanisms. Use secure communication protocols, and encrypt sensitive data. Regularly conduct security audits and assessments.

#### Operational Monitoring Challenges:
Risk: Monitoring a distributed event-driven system can be challenging, leading to difficulties in identifying performance or operational issues.
Mitigation: Invest in comprehensive monitoring tools and practices. Implement centralized logging and monitoring solutions to track system behavior. Conduct regular performance testing to identify and address potential issues proactively.

## Architecture visualisation
The [C4 diagram](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/2.ArchitectureVisualization/C4Diagram.md) visually illustrates a high level overview of the system and the infrastructure is high-lighted 

The [Infrastructure diagram](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/2.ArchitectureVisualization/Infrastructure.md)m provides a visual representation of the physical or virtual components that make up the underlying infrastructure of a system. It typically focuses on servers, networks, storage, and other key elements that support the deployment and operation of software components.

## Architecture style worksheet:
![ArchitectureStyle](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/2.ArchitectureVisualization/ArchitectureStylesWorksheet.png)

## Relevant Architecture Decision Records
[ADR0012-EventDrivenArchitecture](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR012-EventDrivenArchitecture.md)


