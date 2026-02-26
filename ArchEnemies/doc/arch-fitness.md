## Architecture Fitness

Architecture fitness implies two main objectives
- System adheres to the architecture during implementation and expansion over time
- System meets the criteria which were driving and critical for choosing the particular architecture

These objectives are achieved by implementing fitness functions. 

>**Architectural Fitness Function** : any mechanism that performs an objective integrity assessment of some architecture characteristic or combination of architecture characteristics.

In this system, we will measure following criteria to ensure that architecture continuously meets the standards it is designed for

**Responsiveness** : System has explicit requirement of responsiveness of its web and app versions (800ms for web and 1.4s for mobile). That has to be measured along the time and release. System performance KPIs, measured by system monitoring can deliver this.

**Fault-tolerance** : System is designed to meet certain criteria in terms of availability and fault-tolerance. It is allowed to have maximum 5 minutes per month downtime.

**Performance** : User must reflect updates in booking within 5 minutes after it is received by system. 


For above, system must build functions and evaluate continuously. In particular, for **Performance** an integration test which injects an update into the system and measures the time when the update is reflected as notification on frontend. Another test on frontend UI can measure **Responsiveness**. Implementing fitness tests into system in lower environment is essential, however it must be complimented by respective monitoring in production environments. 


The concrete implementation of fitness functions for these and other criteria can be done in many ways, depending on tools, technologies and team expertise, however it is recommended to embed fitness functions into devOps process and implementing these functions as code. 


There are some characteristics of each architecture which are not measurable as is, for example, agility or operation efficiency. For such cases, we can map some process KPIs with these and measure them. In particular, deployment time and deployment efficiency can be some good indicators of measuring operating efficiency. 

| [🏠 home](../README.md#architectural-fitness) |
