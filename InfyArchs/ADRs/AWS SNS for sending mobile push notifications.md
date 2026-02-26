# AWS SNS for sending mobile push notifications

## Status
ACCEPTED

## Context
Medical professional needs to receive mobile push notifications. The number of users will be increasing as the ***MonitorMe*** application is rolled out to new hospitals.

## Decision
We use [AWS SNS](https://docs.aws.amazon.com/sns/latest/dg/sns-mobile-application-as-subscriber.html) as the notification platform to send mobile push notification to ***StayHealthy mobile app***. Applications running on-premise can send the notifications to ***AWS SNS*** by using an [API Gateway integration](https://docs.aws.amazon.com/apigateway/latest/developerguide/getting-started-aws-proxy.html).

## Consequences
Mobile push notifications can be sent to apps running in iOS and Android devices with less overhead. Also using cloud based service provides better scalability.
