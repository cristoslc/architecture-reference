# Architecture style characteristics

The project team identified the key characteristics to ensure the system meets its functional, performance, and operational requirements. Given the complexity of the system and its expected growth, we had to select a maximum of seven characteristics to avoid overcomplicating the architecture. This lets us ensure that we concentrated on the most critical aspects of the system.

We picked three of those seven characteristics that were later used to pick the best architecture for the designed system.

## Selecting characteristics
During event storming, we identified several key system components that were later visualized on C4 diagrams.

Out of these, we picked core three components (two AI engines and, HR integration orchestrator) and two that have special security requirements:
- **Resume and candidate management** component that handles PII and diversity data that can be linked to the candidate
- **Analytics & reporting** processing large amounts hiring and candidate diversity data that are not directly linked to the candidates, but to the job postings and companies instead.

Even though security is emphasized, it was not considered when picking the Top 3 since it's one of the implicit characteristics.

Integration characteristic is assigned only to one of the components, but it was selected as Top 3 characteristic because of the business model and possible large count of HR systems this system can integrate with.

<img src="images/picked-characteristics.png" />

Below are listed all picked characteristics sorted from the most important to the least.

## Top 3 characteristics

### 1. Cost
- **Definition:** Refers to the total resources required to build, maintain, and operate a system, including expenses related to development, infrastructure, and ongoing support.
- **Importance:** For the system, particularly given its non-profit context, it is essential to control both the development and operational costs while scaling efficiently over time.

### 2. Abstraction
- **Definition:** Level at which parts of the system are isolated from other parts.
- **Importance:** Abstraction is essential to enable seamless integration with multiple HR systems and other external services, including AI models.

### 3. Integration
- **Definition:** The ability of a system to seamlessly connect and interact with other systems, tools, or services.
- **Importance:** The system’s business model relies on pushing candidate data to various HR systems, making integration a key requirement.

## Auxiliary characteristics

### 4. Security
- **Definition:** Protecting the system and its data from unauthorized access or harm.
- **Importance:** Ensuring secure handling of sensitive candidate PII and diversity data is vital to comply with regulations and maintain user trust.

### 5. Evolvability
- **Definition:** How easy and risk-free it is to update or release the system.
- **Importance:** Given the rapidly evolving AI landscape, evolvability allows the system to integrate new models, AI providers, or HR system connectors as needed, ensuring long-term viability.

### 6. Performance
- **Definition:** How fast a system can complete tasks to process a specific user requests.
- **Importance:** Ensuring high performance of AI tasks is critical to provide a fluid, delay-free experience during the matching process.

### 7. Scalability
- **Definition:** **Definition:** As user numbers or requests increase in the system, responsiveness, performance, and error rates remain constant.
- **Importance:** System is expected to grow in terms of both user base and connected systems, necessitating an architecture that can scale with demand.

## Benefits of each selected characteristic

### Cost
- **Cost Efficiency:** By focusing on minimizing costs, the system can deliver high-quality services without exceeding the financial limits set by the client, particularly important given the non-profit context.

### Abstraction
- **Modularity and Reusability:** Abstraction allows for the system to be easily extended and maintained. New components (e.g., additional HR system connectors or AI services) can be integrated with minimal disruption to existing functionality.
- **Compliance with Requirements:** This characteristic also helps to achieve the system’s need to handle multiple HR system integrations without overly complex or tightly coupled code.

### Integration
- **Seamless Communication:** Integration ensures that the system can easily connect to various HR platforms and AI services. This allows for pushing resumes to employers and have a stable influx of cash fundamental to the business model, making the system self-sustainable in terms of costs.
- **Expandability:** As the system grows, integration allows for the connection of additional platforms without needing to rework the entire architecture.

### Security
- **Protection of Sensitive Data:** Security measures such as encryption and access control safeguard candidate PII and diversity metadata, ensuring compliance with privacy laws like CCPA while protecting the system from data breaches.
- **Trust and Compliance:** Ensuring robust security helps maintain trust with both candidates and employers.

### Evolvability
- **Adaptability to Future Changes:** Evolvability enables the system to integrate new features, adapt to future AI models, or add new HR systems without needing significant redesigns.
- **Long-Term Sustainability:** This characteristic ensures that the system remains relevant and capable of integrating with new technologies as they emerge, preventing technological stagnation.

### Performance:
- **Quick Response Times:** High performance ensures the system can process candidate data, anonymize resumes, and push updates to HR systems in a timely manner, even under high loads.
- **Enhanced User Experience:** Performance optimization directly impacts user satisfaction, ensuring that both employers and candidates experience minimal delays when interacting with the system.

### Scalability
- **Support for Growth:** Scalability ensures that as the system gains more users, processes more resumes, and integrates more HR systems, it can continue to operate effectively without slowing down or requiring major rework.
- **Efficient Resource Usage:** A scalable architecture can dynamically allocate resources based on demand, ensuring cost-effectiveness even as the system expands.
