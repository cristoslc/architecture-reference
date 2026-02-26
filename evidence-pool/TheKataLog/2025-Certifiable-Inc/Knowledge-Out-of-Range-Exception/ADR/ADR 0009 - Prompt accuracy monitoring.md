# 0009 Prompt accuracy monitoring

## Context

We use multiple prompts to increase the accuracy of AI-assisted assessment of each test question answer. Since a poorly defined prompt may significantly affect our results, it is crucial to monitor them as well. If a given prompt frequently gives low confidence, it should be rephrased.

## Decision

We will implement a monitoring system for prompt accuracy. This system will track the confidence levels of AI responses for each prompt version. If the average confidence for a prompt falls below a certain threshold, the prompt will be flagged for review by moderators and administrators. 

## Technique Description

We will use the same data as mentioned in [ADR 0006](ADR%200006%20-%20AI%20Response%20Evaluation%20Process.md). Each time an architect reviews a question, the system will recalculate metrics (accuracy, flags) for the prompts and models that were used to get its automated grade suggestion. These metrics will then be saved in the database.  
Sample data:

Answers
| model  | prompt | question | suggested grade | review result |
| ------ | ------ | -------- | --------------- | ------------- |
| gpt-o1 | P123   | Q456     | 7               | 8             |

Operatives
| model  | prompt | accuracy | needs attention |
| -----  | ------ | -------- | --------------- |
| gpt-o1 | P123   | 0.92     | 0               |

## Consequences

This will keep the prompt metrics up to date and will provide data that can be later used to change the models as well as  refine or augment the prompts.
It will also allow the system to respond to changes in newer versions of used models and provide a way to compare them.
