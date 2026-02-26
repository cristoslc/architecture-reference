# ADR-009: Storing PII and diversity data

## Date:
2024-09-26

## Status:
Accepted

## Context:
The system will gather and store sensitive information, including Personally Identifiable Information (PII) such as names, contact details, and diversity metadata (e.g., ethnicity, gender, disability status) about candidates. This data is crucial for hiring managers and diversity, equity, and inclusion (DEI) analysts as part of the recruitment process and for supporting analytics related to diversity reporting.

PII and diversity information will be gathered using surveys, AI analytics during resume anonymisation process and during user registration.

Because the PII and diversity metadata will be frequently accessed by key stakeholders in the hiring process, the system design must include measures to ensure security without compromising usability for authorized personnel.

## Decision:
The following security measures will be implemented:
- **Encryption:** All PII and diversity metadata will be encrypted at rest using industry-standard encryption algorithms (e.g., AES-256). In-transit encryption will be enforced using TLS (Transport Layer Security) to protect data during communication between system components and external services.
- **Role-Based Access Control (RBAC):** A role-based access control (RBAC) system will be implemented to ensure that only authorized roles, such as system administrators and employers, have access to sensitive PII and diversity data. Access will be controlled using least privilege principles, ensuring that each user only has access to the data necessary for their role.
- **Access via Secure Authentication:** Multi-factor authentication (MFA) will be enforced for users with access to PII and diversity data to ensure an extra layer of protection for these sensitive data sets.
- **Data Retention:** Data will be stored as long as necessary for recruitment and DEI reporting purposes. Retention policies will ensure that data remains accessible and available for authorized users without unnecessary restrictions.
- **Auditing:** The system will include audit logging to track access and modifications to PII and diversity metadata. This will provide transparency into who accessed the data and when, enabling compliance with regulatory requirements and offering visibility for internal oversight.

## Consequences:
### Pros:
- **Accountability and Transparency with Auditing:** Audit logging provides full visibility into who accessed PII and diversity metadata and when. This ensures accountability and compliance, particularly in sensitive environments where handling candidate information must be tracked for regulatory reasons.
- **Compliance with Data Privacy Regulations:**	The system will be able to comply with privacy laws like CCPA, ensuring that users’ rights around data access, modification, and deletion are respected. Retention policies will further protect user data by ensuring unnecessary data is removed after a defined period.
- **Secure and Controlled Access:**	By implementing various security mechanisms, the system will provide a strong layer of protection for PII and diversity metadata. Data will be encrypted at rest and in transit, ensuring that only authorized users—such as hiring managers and DEI analysts—can access sensitive information.

### Cons:
- **Performance Overhead from Encryption and Logging:** Encryption and audit logging can introduce slight performance overhead, particularly in high-traffic environments where frequent access to large volumes of PII or diversity data is required. This may affect response times in certain use cases.
- **Cost of Implementing Security and Compliance Tools:** The integration of encryption, MFA, RBAC, and auditing tools may result in increased operational costs, which need to be carefully managed to stay within budget.
- **User Friction from MFA:** Requiring multi-factor authentication (MFA) for accessing PII and diversity data may add friction for users who frequently access the system, potentially slowing down workflows.
- **Management of Audit Logs:** Without a clear process for managing audit logs, the system may generate large volumes of data that need to be securely stored, analyzed, and, where necessary, purged. Ensuring that this process is efficient and does not impact performance will require additional effort.