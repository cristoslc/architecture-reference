# ADR-012: Validating AI anonimization output

## Date:
2024-09-27

## Status:
Accepted

## Context:
As part of the system’s anonymization process for candidate resumes, team considered several options to ensure that PII (Personally Identifiable Information) and diversity-related metadata are properly removed. Initially, tertiary AI model was explored to verify the results of the primary anonymization process. This third AI would check a small number of anonymized resumes to confirm that all sensitive information had been effectively removed.

The benefit of this approach was that it provided an automated quality assurance step, ensuring the anonymization process was consistently accurate. However, this solution introduced significant costs, as running a third AI service would require additional resources. Given the system’s overall cost constraints, we also considered alternative methods that would maintain accuracy without incurring high operational costs.

Another option involved relying on manual verification, where both the job candidate and the potential employer would tag any missed PII or diversity-related information in anonymized resumes. This tagged data would then be reviewed by system administrators to ensure accuracy and prevent abuse of the tagging process. This method allows for cost savings but introduces a manual workflow that may impact scalability and response times.

## Decision:
Due to cost constraints, a manual review process will be implemented. Both the job candidate and the potential employer can tag any remaining PII or diversity-related data that was not properly anonymized. These tagged resumes will be reviewed by system administrators to prevent abuse of the tagging process.

<img src="images/ADR-012-compliance-events.png">

## Consequences:
### Pros:
- **Cost Efficiency:** By opting for a manual review process, the system avoids the costs associated with running a third AI model. This decision aligns with the system’s overall cost constraints while still ensuring that anonymization errors are identified and corrected.
- **Improved Anonymization Accuracy Over Time:** Feedback from manual reviews, conducted by system administrators, will be used to fine-tune AI anonymization prompts, leading to better anonymization results over time.
- **Involvement of Key Stakeholders:** Allowing both job candidates and potential employers to participate in the tagging process ensures that any potential anonymization errors are caught from multiple perspectives, improving the quality and fairness of the anonymization process.

### Cons:
- **Manual Process is Time-Consuming:** The manual review of tagged resumes by system administrators may slow down the overall process, especially if the volume of anonymized resumes grows over time. This could introduce delays in job candidate evaluations and employer feedback loops.
- **Potential for Subjectivity:** While system administrators will review tagged resumes to avoid abuse, the manual review process still introduces potential for subjectivity in determining whether PII or diversity-related metadata has been properly anonymized.
- **Accuracy Dependent on User Feedback:** The success of the manual review process heavily depends on the diligence and accuracy of the job candidates and employers when tagging anonymization issues. Inaccurate or incomplete feedback from users could impact the effectiveness of the fine-tuning process.
