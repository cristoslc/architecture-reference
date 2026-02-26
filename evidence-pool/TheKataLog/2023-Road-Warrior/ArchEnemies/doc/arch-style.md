# Architecture style

We identify following architecture styles best suited for the system

- Microservices
- Event driven
- Space based

![](/doc/arch-style-evaulation.png)

Though Space based performs almost as good as others, it lacks in fault tolerance which is one of the the driving characteristic. Along with this, it is not the most affordable and the nature of the application does not warrant elasticity on the levels that of an auctioning or ticketing system, for which space-based is mostly best suited architecture style, see [ADR-0001](/doc/adr/0001-arch-style-space-based.md).  

**We decide to use **event driven** architecture style for the system.**

The decision is made based on thorough comparison between both choices and acknowledging that the current system does not have many unique services and all main system flows are triggered by an **event**. For details, see [ADR-0002](/doc/adr/0002-arch-style-microservices-vs-event-driven.md).

### Handling the lacking characteristics

Like any other architecture style, Event driven architecture performs good in some characteristics and lacks in some other; for which there are mitigation strategies which we can apply. In particular, two such areas and recommendations are shared 

#### Mitigation of difficulty in error handling

Event driven architecture works on the principle that receiver of the event will handle the error by itself. This implies that is no one-size-fit-all approach for this. However, there are many practices which can be followed per use case. Error logging and monitoring, Dead letter queue (DLQ), Circuit breakers, Retries,Time-out mechanism are few to name.   

#### Mitigation of lack of testability

Asynchronous processing is one of the key feature of event driven architecture which gives it edge in many characteristics, in particular performance and elasticity. However, this also makes it more difficult to test. Other reason contributing to the lack of testability could be distributed components or cost of producing huge data volume in lower environments. However, with state-of-the-art technologies; data mocking, integration testing, contract testing and focus on obserability can easily mitigate this risk.

| [🏠 home](../README.md#analysis) |
