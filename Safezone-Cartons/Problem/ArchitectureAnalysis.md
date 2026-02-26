# Architecture Analysis

## Key Characteristics

We can determine the least-worst option by first determining the essential architectural features of this solution. The recommended approach is to list no more than seven.  
These will then influence the MonitorMe system's overall architecture, along with the implicit architecture features.


---

### Selected Characteristics

| Top 3 | Characteristics  | Description                                                                                                                                                                                                                                                                                                          |
|-------|------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 2     | Performance      | Medical professionals can't always be physically at a patients bed and will get informed in case of any anomalies detected for a patient.<br/>As this is a time critical thing and data needs to be visible as quickly as possible performance is one of the important characteristics for the system.               |
|       | Scalability      | The system load is easy to forecast due to the defined maximum devices and patients per nurse station. However the system needs to be capable of handling additional load, when extending the range of available viral sign devices.<br/>It's also required to replicate this setup multiple in different hospitals. |
| 1     | Availability     | The systems needs to have a high level vor availability due to the fact it monitors patients.<br/>An outage of critical components would put lives of the patients at risk.                                                                                                                                          |
|       | Flexibility      | The overall system should be easy to be extended or adapted. Eventually different technology preferences are set when expanding oversees.<br/>This flexibility shall be provided however it's not the most important characteristic.                                                                                 |
|       | Fault tolerance  | Fault tolerance is a critical factor for the system as it needs to function also on outages. This covered by implementing redundancy within critical components and pays into the Availability characteristics                                                                                                       |
|       | Workflow         | The application needs to have the ability to make decisions for anomaly detection and notification which we consider with this characteristic.                                                                                                                                                                       |
| 3     | Agility          | One of the most important business requirements is the ability to quickly adapt to new learnings or to extend the system by new vital sign devices which get developed within the industry.<br/>The system needs to be able to handle these frequent learnings StayHealthy Inc. will encounter.                      |
|       | Interoperability | Event that the system is limited to some external systems, medical vital devices need to be replaced easily                                                                                                                                                                                                          |


### Implicit Characteristics

The following architecture characteristics may not directly affect the structure on the overall system
however they will feed into this

- Maintainability
- Security
- Flexibility
- *Recoverability*


---
[> Home](../README.md)    [>  Problem Background](README.md)
[< Prev](StakeholderConcerns.md)  |  [Next >](ActorsActions.md)