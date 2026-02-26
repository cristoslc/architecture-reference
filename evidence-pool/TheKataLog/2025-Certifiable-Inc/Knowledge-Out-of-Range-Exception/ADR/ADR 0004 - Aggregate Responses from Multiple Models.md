# 0004 Aggregate responses from multiple models

## Context

Relying on a single AI model for grading can lead to inconsistent results and potential biases. To improve the reliability and accuracy of AI-assisted grading, we need a strategy that leverages the strengths of multiple AI models.

## Decision

We will implement a system that aggregates responses from multiple AI models to determine the average response confidence level. This approach will help mitigate the weaknesses of individual models and provide a more robust and reliable grading system.

## Justification

Each question will be evaluated by multiple AI models, and their responses will be aggregated to calculate an average confidence level. This aggregated confidence level will then be used to make the final grading decision.

The process of aggregating responses from multiple AI models involves the following steps:

1. Each question is submitted to multiple AI models for evaluation.
2. Each model provides a response along with a confidence level.
3. The responses and confidence levels are aggregated to calculate an average response confidence level.
4. The final grading decision is made based on the aggregated confidence level.

This technique leverages the diversity of multiple AI models to provide a more accurate and reliable grading system. By combining the strengths of different models, we can reduce the likelihood of incorrect grades.

## Consequences

By using multiple AI models, we can reduce the impact of individual model biases and errors. Aggregating responses will provide a more balanced and accurate assessment of each question. This approach will also allow us to identify and address discrepancies between models, further improving the overall reliability of the grading system.

At the same time, we're increasing the cost of the service, but that is justifiable as a loss in credibility could be catastrophic to the core business.
