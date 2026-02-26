## Deployment


We have proposed a tool agnostic architecture which can be implemented with any available tools that fit the architecture guidance on premise or in cloud.

We have designed system architecture based on unique components which take part in certain actions. 

Having said that, given nature of the system and its ecosystem, in particular, global presence with multiple user interfaces and high responsiveness, required fault tolerance and elasticity suggests that cloud would be a good choice to deploy the system, see [ADR-0008 - Deploying system in cloud or on premise](/doc/adr/0008-deploying-system-in-cloud-or-on-premise.md)

From our system architecture, we can identify some components which can be implemented using cloud products offered by leading cloud providers.

| Component/Container | AWS product(s)             | Azure product(s)                                 | GCP product(s)          |
|---------------------|----------------------------|--------------------------------------------------|-------------------------|
| CDN                 | Amazon CloudFront          | Azure Content Delivery Network, Azure Front Door | Cloud CDN               |
| API Gateway         | Amazon API Gateway         | Azure API Management                             | Apigee                  |
| Booking Tracker     | Lambda                     | Azure Functions                                  | Cloud Functions         |
| Analytics           | Amazon S3, Amazon Redshift | Cloud Storage, Azure Event Hubs                  | Cloud Storage, BigQuery |

| [🏠 home](../README.md#deployment) |
