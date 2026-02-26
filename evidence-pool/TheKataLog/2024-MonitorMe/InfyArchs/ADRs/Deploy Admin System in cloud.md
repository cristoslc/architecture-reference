# Deploy Admin System in Cloud

## Status
ACCEPTED

## Context
The Admin System is intended to be used by StayHealthy,Inc administrators in their office. 

## Decision
The Admin System will be in the cloud along with other SAAS applications (MonitorThem and MyMedicalData).


### Choices Considered:

1. **Deployment in OnPremise**
   - *Explanation:* Deploying the Admin System on OnPremise preinstalled server in the Company datacenter.
   - *Consideration:* While deploying applications OnPremise can be possible, it's not relevant as the Company strategy is already to have their applications deployed on Cloud. OnPremise deployment will require investment in hardware, software and also a support team to maintain it.

2. **Deployment in Cloud**
   - *Explanation:* Deploying the Admin System in Cloud in orchestrated and containerized environment.
   - *Consideration:* Deploying in Cloud will take benefit from existing CI/CD workflow which are in place for owned SAAS applications like MonitorThem and MyMedicalData, but also will benefit from Cloud infrastucture advantages in term of monitoring, recoverability, availability etc..

## Consequences
The Admin System will be benefiting from the cloud infrastructure (monitoring, recoverability etc..).