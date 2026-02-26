## Privacy Assessment

### Status
- ACCEPTED

### Context

Our system currently stores details of employees of Certifiable Inc. and a large number of candidates (customers). As we expand into several new legal jurisdictions globally, we must ensure compliance with various data protection regulations and provide transparency to affected individuals regarding their personal data. The introduction of AI models also introduces additional privacy considerations, especially when using personally identifiable information (PII).

### Decision
**Perform a Privacy Impact Assessment (PIA):** Conduct a thorough assessment to evaluate how our data handling practices align with privacy laws and identify potential risks to personal data.

**Candidate Consent for Data Use** - Ensure that candidate provide consent for their test data to be used as part of any AI model training.

**Data Privacy:** Implement data anonymization techniques where appropriate to reduce the risk associated with processing PII, particularly in AI training datasets.

**Data Governance:** Establish a framework to ensure compliance with relevant laws and regulations for each jurisdiction we operate in, including GDPR (EU), CCPA (California), and others.

**Data Integrity:** Maintain accurate and complete data records and establish mechanisms for expert employees who manage the expert Consultants list.

**Data Storage and Transmission:** Ensure that all data is securely stored and transmitted. Implement encryption and access controls to prevent unauthorized access.

**Data Retention and Disposal:** Define clear policies regarding data retention, including how long we retain both failed and passed test data and feedback. Implement secure disposal methods for data that is no longer needed.

**Audits:** Schedule regular privacy audits to ensure compliance with our privacy policies and applicable regulations. This includes reviewing data handling practices, retention schedules, and user consent processes.

### Alternatives Considered
Skip PIA and Rely on Best Practices: This option was dismissed due to the lack of accountability and oversight that comes with a structured assessment. A PIA is necessary to identify and mitigate specific risks.

Store Data Without Anonymization: While retaining full data fidelity can be beneficial for certain applications, this approach was rejected due to the increased risk of exposing sensitive personal information.

Implement a One-Size-Fits-All Data Governance Policy: This approach was considered but ultimately rejected, as it does not account for the varied legal requirements in different jurisdictions, which could lead to non-compliance.

Neglect Data Retention and Disposal Policies: This was not considered viable due to potential legal repercussions and the ethical obligation to protect personal data.

### References
- GDPR Compliance Guidelines: General Data Protection Regulation (GDPR)
- CCPA Overview: California Consumer Privacy Act (CCPA)
- Anonymization Techniques: NIST Special Publication 800-188
- Privacy Impact Assessment Guidelines: Office of the Privacy Commissioner of Canada
- Data Retention Policy Guidelines: National Archives and Records Administration

### Date
2025-02-18
