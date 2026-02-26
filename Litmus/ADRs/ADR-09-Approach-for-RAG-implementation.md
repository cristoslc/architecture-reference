# Architecture Decision Record (ADR)

## ADR 09: Approach for RAG implementation

### Status

- ACCEPTED

### Context

The goal is to architect a Retrieval-Augmented Generation (RAG) system that can efficiently and effectively handle complex tasks by retrieving relevant data to support AI models in generating more accurate outputs. This system should leverage scalable, robust, and cost-effective cloud infrastructure. AWS offers native services that could potentially streamline this implementation, but alternative solutions should also be considered.

### Decision

The decision is to explore an architecture using AWS native services, particularly AWS Bedrock for AI model deployment and Step Functions for orchestration, to implement the RAG system. This approach aims to integrate seamlessly into existing AWS infrastructure, leveraging its scalability and reliability.

![Architectural diagram](./images/ADR-09.png)

### Alternatives Considered

#### 1. AWS Native Services with Bedrock and Step Functions

*Description*:

This approach uses AWS Bedrock to host and manage LLMs, providing scalable and flexible AI deployment. AWS Step Functions are utilized to orchestrate the workflow, coordinating between data retrieval, AI processing, and output generation. By leveraging AWS's robust infrastructure, this option promises seamless integration, high availability, and reduced operational overhead.

*Pros*:
- **Seamless Integration**: Leverages existing AWS services for a cohesive architecture.
- **Scalability and Reliability**: AWS infrastructure provides scalable solutions with high availability and resilience.

*Cons*:
- **Vendor Lock-In**: Dependency on AWS services may limit flexibility and increase costs over time.

#### 2. Custom Orchestration Framework with Open-Source Tools

*Description*:

This approach involves building a custom orchestration framework using open-source tools like Apache Airflow for workflow management, along with open-source retrieval libraries and AI models. This architecture allows for customization and potentially lower costs if managed effectively.

*Pros*:
- **Flexibility**: Offers high customization to tailor the system to specific needs.
- **Cost Control**: Potentially lower costs by using open-source tools and avoiding vendor lock-in.

*Cons*:
- **Development Overhead**: Requires significant development effort and expertise to implement and maintain.
- **Support and Maintenance**: Relies on community support, which may not be as reliable as commercial alternatives.

#### 3. Hybrid Approach Using Cloud-Agnostic Tools

*Description*:

A hybrid approach utilizing cloud-agnostic tools such as Terraform for infrastructure management and Kubernetes for orchestration, allowing the RAG system to run on multiple cloud platforms or on-premises.

*Pros*:
- **Cloud Agnosticism**: Provides flexibility to switch between cloud providers or use multi-cloud strategies.
- **Portability**: Easy migration and deployment across different environments.

*Cons*:
- **Complexity**: Increased complexity in managing and orchestrating across multiple cloud environments.
- **Resource Intensive**: Requires expertise in multi-cloud or hybrid cloud operations.

### References

### Date
02/12/2025
