# ADR-010: Use of separate AI services to anonymise and generate resume tips

## Date:
2024-09-26

## Status:
Accepted

## Context:
The system requires handling multiple tasks related to managing candidate resumes and company details, including generating improvement tips for candidates and employers, anonymizing resumes to protect PII and diversity metadata, and generating candidate stories that can later be used for comparison with job descriptions.

We wanted to balance out fast and responsive user experience for generating tips, with maintaining precision during anonymization and story generation.

Because of that, we explored usage of various third party models that could cover both cases from less resource-intensive providing good UX during resume and company details improvements, to the ones robust enough for anonymization and generating detailed candidate stories.

## Decision:
We have decided to use two separate AI models to handle the different tasks in the system:

1. **Lightweight and Responsive AI:** This AI will focus on generating improvement tips for both resumes and job descriptions. It will be designed to provide quick feedback without generating excessive operational costs, making it ideal for real-time user interactions.

2. **Slower but More Precise AI:** This AI will handle more complex tasks such as anonymizing resumes and generating detailed candidate stories. It will prioritize precision over speed, ensuring that PII and diversity metadata are fully removed from resumes, and that candidate stories are detailed enough for accurate comparison with job descriptions.

## Consequences:
### Pros:
1. **Improved Anonymization and Story Generation:** The slower, more precise AI ensures that sensitive data is accurately anonymized, while also generating detailed candidate stories that can be tokenized for accurate matching with job descriptions.
2. **Enhanced User Experience:** The responsive AI allows candidates and employers to quickly improve their resumes and job descriptions, while the precise AI focuses on ensuring high-quality results for complex processes like anonymization.
5. **Separation of Concerns:** Using two AIs allows the system to specialize each model for its respective task, ensuring that each AI can be fine-tuned for specific requirements without compromising performance or accuracy.

### Cons:
1. **Increased System Complexity:** Managing two separate AI models adds complexity to the system architecture, as the team will need to coordinate the interaction between both AIs and ensure that each is performing its role as expected.
2. **Slower Performance for Precision Tasks:** While the lightweight AI provides quick feedback, the slower AI used for anonymization and story generation may take longer to complete, which could impact user experience for when waiting to see if any matches are available.