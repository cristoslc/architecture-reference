# 0007 Human verification for AI responses

## Context

Output from AI models may vary, not only between test answers but also between different models or prompts. Relying purely on AI could lead to incorrect assessments, while having human verification for all questions would significantly extend verification time. To balance accuracy and efficiency, we need a system that leverages AI capabilities while ensuring human oversight where necessary.

## Decision

We will implement a differentiated data flow for test question responses, based on the AI result confidence. AI question assessment confidence (defined as "X") will be checked against two thresholds. Depending on which of the three ranges it falls into, the system approach (and appropriate UX) will be as follows:

- **X < 60%**: AI response is rejected. This answer must go through the regular verification process (Manual Grading component).
- **60% <= X < 85%**: AI assessment is displayed as a suggestion, but human **review** is required. This test question will not be processed until human verification is in place.
- **X >= 85%**: AI result is automatically accepted. Human review is still possible, but not required. The question is already processed.

## Consequences

1. **Efficiency**: By using confidence thresholds on each question answer, we ensure that limited and costly human resources are not delegated to the most obvious results.
2. **Accuracy**: We provide fair and accurate assessments for uncommon or original, yet correct answers by requiring human verification for lower-confidence AI responses.
3. **Scalability**: The system can handle a larger volume of assessments by automating high-confidence responses and focusing human efforts on more ambiguous cases.
4. **Transparency**: Stakeholders are informed about the confidence levels of AI assessments and the involvement of human verification, ensuring trust in the system.
5. **Risk Management**: Potential risks associated with incorrect AI assessments are mitigated by incorporating human oversight for lower-confidence responses.

By implementing this approach, we strike a balance between leveraging AI for efficiency and ensuring accuracy through human verification where necessary.

## Tradeoffs

Alternatively, we could rely on AI responses entirely. This would make the process very simple and allow for even quicker assesments. Using multiple models and multiple prompts should in time yield a high confidence level, given that the quality of LLM responses does have a small, but positive trend.
The consequence of providing low quality assesments in the beginning though, is critial enough to justify the complications, because without them, we may never reach the point of 'high confidence automated responses'.
