# Alerting System

***Alerting System*** is the software system which will be deployed on hybrid mode which will have some set of components which will be deployed at hostpital side and some components in cloud to support mobile push notification usecase.

Below is the high level architecture view of ***Alerting System***.

![](https://github.com/infy-archs-katas/monitorme/blob/main/diagrams/Alerts-C4ContainerView.png)

## Component Details

| Component Name  | Component Description | Technology Choices |
| ------------- | ------------- | ------------- |
| ***Alerts API Application***  | API application which will be invoked by the ***Metrics Capturing System*** to trigger the alerts identified as part of anamoly detection.  | .NET or Java based microservice.  |
| ***Message Broker***  | Message broker which supports pub-sub mechanism. The broker is also backed by persistence storage to avoid data loss. Any consumer who wish to receive alerts can subscribe itself to the topics registered to receive alerts. | RabbitMQ or any similar MQ providers  |
| ***Mobile Push Worker***  | A Background Worker client which subscribes itself to the message broker to receive alerts. The alerts received are then sent to another Notification Service which manages sending mobile push notifications.  | .NET or Java based microservice.  |
| ***Notification Service***  | Cloud based notification platform which has the ability to register mobile device endpoints based on device tokens registered with it, so that it can send push notifications whenever alerts needs to be sent.  | AWS SNS or similar services from other hyperscalers.   |

## Architectural Characteristics

| Characteristics  | Decisions |
| ------------- | ------------- |
| Performance  |  The microservice components involved does not perform any long running syncronous operations for sending alerts notifications and instead relies of event-driven patterns to choreograph the operations. |
| Scalability  |  The alerts generated has to be sent to medical professionals who are using the ***StayHealthy mobile app***. The number of users who will be using this mobile app will be increasing as the ***MonitorMe*** service is rolled out to new hospitals. The notification service should be able to scale with growing user base and able to operate without any performance degradation. Please refer this ADR [AWS SNS for sending mobile push notifications.md](https://github.com/infy-archs-katas/monitorme/blob/main/ADRs/AWS%20SNS%20for%20sending%20mobile%20push%20notifications.md) |
| Interoperability  | The ***Alerting System*** uses different broker technologies both on-prem and cloud for different usecases, however the interface which it expose for clients to interface will use the standard REST/GRPC protocols.  |

## Architectural Choice

- Microservices
- Event-driven

## Deployment View
Below is the deployment view based on the architecture choice and this ADR [AWS SNS for sending mobile push notifications.md](https://github.com/infy-archs-katas/monitorme/blob/main/ADRs/AWS%20SNS%20for%20sending%20mobile%20push%20notifications.md)

![](https://github.com/infy-archs-katas/monitorme/blob/main/diagrams/Alerts-DeploymentView.png)
