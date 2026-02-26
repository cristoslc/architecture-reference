# Architecture Decision Record (ADR)

## ADR 17: Validating AI Generated Answers Against Historical Data

### Status
- Accepted

### Context
With the use of AI to automate grading and provide feedback in the certification process, ensuring the accuracy 
and reliability of the AI-generated answers is critical. Inaccurate assessments can negatively impact candidates’ careers and 
compromise the credibility of Certifiable, Inc. Consequently, there is a need for validation mechanisms to enhance 
the accuracy of AI-generated results.

### Decision
We will implement a system to validate AI-generated answers against historical answers. This validation process will 
compare AI results with a curated set of historical answers, evaluating consistency and accuracy before providing feedback 
to candidates. By integrating historical data into the validation process, we aim to improve the reliability of AI-generated 
assessments and maintain high certification standards.

![Architectural diagram](./images/ADR-17.png)

### Alternatives Considered

- **Option 1:** Manual Review by Human Experts: While effective, this approach is labor-intensive and may not scale with increased certification requests.

- **Option 2:** Implementing Additional AI Training: While improving AI training could enhance accuracy, it would require significant resources and time without providing immediate validation.

- **Option 3:** Peer Review by Other AI Models: Using different AI models for peer review offers a unique angle but may complicate the system and still require human oversight.

### References
- Documentation on historical data and previous grading standards.
- [ADR-06: Architectural Submission Grader](./ADR-06-Architectural-Submission-Grader.md), which outlines the initial grading strategy.

### Date
03/06/2025
