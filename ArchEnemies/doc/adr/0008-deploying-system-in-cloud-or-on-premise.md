# 8. Deploying system in cloud or on premise

Date: 2023-09-15

## Status

Accepted

## Context

We have to provide guidance if deploying system in cloud or on-premise would have certain benefits and which one is preferred based on system requirements

We analysed both options - cloud and on-premise. Though we considered products from leading cloud providers , we did not consider any particular cloud provider for this discussion. Selecting a particular cloud provider, if need be, will be a separate decision and may be impacted be non-technical factors like corporate discount. 

## Decision

We recommend to deploy the system into cloud using managed services.

## Consequences

### Positive

- **Managed services** : Cloud providers offer a wide range of managed services for almost all use cases. It let team focus on core functionality by reducing operational overhead
- **Elasticity and Scalability** : Cloud providers offer auto-scaling capabilities in almost all their services with system defined boundaries. This optimizes the resource cost of the system in low load time and maintains availability and responsiveness to scale up in time of heavy load. 
- **Global Reach** : All major cloud providers already present globally and in our case it helps with high responsiveness required of the system and in some cases where data has to be stored locally, GDPR too.
- **Security** : Cloud providers work globally with managed services and invest heavily in security and compliance to reduce security and compliance overhead from their clients as much as possible. In particular, cloud providers take care of GDPR, encryption and access control to some extent or provide easy way to do so. This also helps our system to be present globally by meeting compliance requirements with less security overhead and more focus on core functionalities
- **Extreme analytics capabilities** : Cloud providers have launched state-of-the-art analytics products meeting the growing demand of data analytics. These products, combine with other benefits of cloud services, get analytics engines up and running in no time. 
- **Integration** : Cloud providers offer a wide range of integration services which benefits our system in integrating with agencies and our analytics clients.

### Negative
- **Customization** : Managed services from cloud providers have certain limitation on customization
- **Can be costlier in long term** : In some cases, cloud services are proved to be costlier in long term than their counter part on-premise
- **Predictable cost** : With positive of scalability and elasticity, we have negative of associated cost to it.


| [🏠 home](../../README.md#adr) | [<< **ADR** Efficiency oriented algorithm for booking tracker ](./0007-efficient-oriented-algorithm-for-booking-tracker.md) |