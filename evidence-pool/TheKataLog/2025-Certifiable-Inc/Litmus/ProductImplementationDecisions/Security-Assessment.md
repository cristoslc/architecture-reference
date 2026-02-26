## Security Assessment

### Status
- ACCEPTED

### Context
Our system currently stores intellectual property that sets Certifiable Inc. ahead of our competitors and maintains a strong reputation with candidates and employers hiring candidates. We need to ensure that our future solution provides robust security for our intellectual property and candidate data, especially in light of potential data breaches and regulatory compliance requirements.

### Decision
- Data in transit will be encrypted using OAuth 2.0, ensuring secure authentication and authorization.
- Data at rest will be encrypted using AES (Advanced Encryption Standard) for sensitive data to prevent unauthorized access.
- Implement comprehensive logging and monitoring to ensure traceability of user actions and system events, facilitating quicker incident response and audits.
- Perform a Threat Model against our system design, using the Microsoft STRIDE approach to identify and mitigate potential security threats proactively.

### Alternatives Considered
Using HTTPS without OAuth: While HTTPS provides encryption for data in transit, it lacks the robust authentication and authorization features that OAuth provides. This was deemed insufficient for our security needs, especially regarding access control.

Storing Sensitive Data Unencrypted: This option was rejected due to the high risk of data breaches and the potential legal implications regarding data privacy regulations (e.g., GDPR, CCPA).

Limited Logging and Monitoring: A decision was made against having a minimalistic approach to logging. While it would reduce complexity, it does not provide adequate oversight to identify security incidents in a timely manner.

### References
- OAuth 2.0 Specification: RFC 6749
- AES Encryption Overview: National Institute of Standards and Technology
- Microsoft STRIDE Threat Modeling Approach: Microsoft Docs on STRIDE
- GDPR Compliance Guidelines: General Data Protection Regulation (GDPR)
- CCPA Overview: California Consumer Privacy Act (CCPA)

### Date
02/18/2025
