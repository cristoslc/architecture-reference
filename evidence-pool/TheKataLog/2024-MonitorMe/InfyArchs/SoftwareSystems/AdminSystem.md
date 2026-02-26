# Admin System

***Admin System*** is the software system which will is used to configure Hospital onboarding and registering devices associated to the hospitals. It will also
be used to configure the devices before the Monitoring system are being shipped and deployed in the Hospital.

Below is the high level architecture view of ***Admin System***.

![](https://github.com/infy-archs-katas/monitorme/blob/main/diagrams/MAS-C4ContainerView.png)

## Component Details

| Component Name  | Component Description | Technology Choices |
| ------------- | ------------- | ------------- |
| ***Monitor Admin Web and SPA***  | Web application that will deliver the SPA to administrators where the Onboarding of hospitals and devices registration UI resides. | ASP.Net MVC | 
| ***Database***  | NoSQL database which is used to store the hospital onboarding and devices registration metadata. | Mongo Db  |
| ***Admin API Application***  | API service which is used to do the interaction between the SPA and the database, and also with the Vitals Monitoring System  | .NET API service.  |


## Architectural Characteristics

| Characteristics  | Decisions |
| ------------- | ------------- |
| Fault Tolerance  | Applications need to implement proper resiliency patterns like retries, circuit-breaker patterns as applicable to ensure it handles all failure scenarios with appropriate fallback logic and without impact on the overall performance.  |
| Recoverability  | Applications have the ability to recover from unexpected failures or crash. This is achived by having an external orchestrator which can restart the applications automatically whenever applications crashes in unexpected way. |
| Security  |  The data are encrypted at transit.  |


## Architectural Choice

- Microservices

## Deployment View
Below is the deployment view based on the architecture choice and this ADR [Deploy Admin System in cloud.md](https://github.com/infy-archs-katas/monitorme/blob/main/ADRs/Deploy%20Admin%20System%20in%20cloud.md)

![](https://github.com/infy-archs-katas/monitorme/blob/main/diagrams/MAS-DeploymentView.png)



