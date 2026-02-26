# ADR-014: Secure storage of PII data

## Date:
2024-09-27

## Status:
Accepted

## Context:
The system will store Personally Identifiable Information (PII), such as candidate details, company data, and other sensitive information, in the general data store. Ensuring the security and privacy of this sensitive data is critical, particularly in compliance with data privacy regulations such as CCPA.

## Decision:
To securely store PII data in the general data store, we will implement the following security mechanisms:

1. **Data Encryption:** Sensitive data fields will be encrypted at rest using industry-standard encryption algorithms such as AES-256. This ensures that only authorized users or system components with the correct decryption keys can access the PII in its plaintext form.
2. **Decryption Keys:** Authorized system components that require access to PII data (e.g., candidate management or match management) will have access to the necessary decryption keys. These keys will be securely stored and managed in a secure key store.
3. **Field-level Access Control:** Access to PII will be restricted at the field level using role-based access control (RBAC). This ensures that only authorized system components or users with specific roles will be able to query or access fields that contain sensitive information. Least privilege principles will be enforced.
4. **Access Logging and Monitoring:** All access to encrypted PII fields will be logged and monitored to track which system components or users are accessing sensitive data. This ensures visibility into how the data is used and provides an audit trail in case of any security incidents.

## Consequences:
### Pros:
1. **Strong Data Security:** Field-level encryption ensures that sensitive data is protected both at rest and in transit, making it difficult for unauthorized users to access PII, even in the event of a data breach. The use of AES-256 encryption guarantees a high level of security.
2. **Granular Access Control:** By implementing role-based access control (RBAC) at the field level, the system enforces least privilege access, ensuring that only authorized users and components can view or modify sensitive PII data.
3. **Auditability and Monitoring:** Access logging and monitoring provide a full audit trail of which users or components accessed encrypted PII data, making it easier to detect and respond to potential security incidents or misuse.

### Cons:
1. **Management of Encryption Keys:** The system will need to securely manage encryption keys and ensure that only authorized components have access to them. This introduces complexity around key management, particularly when keys need to be rotated or updated regularly.
2. **Increased Complexity in Access Control:** Implementing field and table-level access controls increases the complexity of RBAC management, especially as the system scales. Managing roles and ensuring that the correct permissions are granted to each component or user will require ongoing administration.
3. **Potential Performance Overhead:** Although column-level encryption minimizes the performance impact compared to full-database encryption, there will still be some overhead associated with encrypting and decrypting data on demand, particularly when handling large datasets.
4. **Decryption Key Risks:** If decryption keys are not properly protected or if they are compromised, unauthorized users could potentially gain access to sensitive PII. This highlights the importance of strict security around key management and access policies.
