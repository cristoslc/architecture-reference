# 0006 AI response evaluation process

## Context

To ensure the accuracy and reliability of AI-assisted grading, it is essential to have a robust process for evaluating AI responses. This process should include mechanisms for assessing the confidence levels of AI responses and incorporating human confirmation when necessary.

## Decision

AI responses will be evaluated by comparing them with human review results.

## Technique Description

To be able to measure and improve the accuracy of our system, we will store the statistics of AI responses (question, prompt, answer) as well as human review results. This way, we can verify if the AI suggested grade matches the grade given by a human.
Initially, when we have no data, each answer will need to be reviewed by an architect. After the 'pilot' phase, we should have enough data to determine the accuracy percentage of automatically grated results.
That information can then be used to either change the model, tweak the prompt, or extend the prompt by adding examples of desired outcome for cases where the AI response did not match with reviewer response.

## Consequences

Implementing this AI response evaluation process will enhance the reliability and accuracy of AI-aided grading. By incorporating confidence levels and human confirmation, we can reduce the likelihood of incorrect grades and ensure that low-confidence responses are properly evaluated as well as improved over time.
