# 0002 Selected models for AI-assisted grading

## Context

Following the decision to use AI in ADR 0001, we need to select which models/services to use. The requirements we have are:
1. The AI needs to be able to grade answers as correct/incorrect, as well as give points in the range of 1-10.
2. The AI needs to be able to respond to a question "on a scale of 1 to 100, how certain are you that your grade is correct?".

A sample prompt producing the desired response could be:

> Given the question:  
> \<test question\>  
> where the keywords are:  
> \<question dependent keywords\>  
> and the answer:  
> \<user submitted answer\>  
> produce a grade containing the following information:  
> 1. Score on a scale of 1 to 10, where 1 means the answer is incorrect and 10 means the answer is correct and mentiones all keywords
> 2. Number on a scale o 0 to 100 which indicates how certain you are of your grade.

## Decision

For the initial release, we will use ChatGPT 4, Gemini 1.5 Pro and Claude 3.5 Sonnet.

## Consequences

The selected models fulfill the requirements and as a bonus, they are considered as the leading LLMs in the market.
All of them have a subscription service and are widely available.

## Tradeoffs

Other models considered:
* Github Copilot - did not pass the 'desired response' test
* DeepSeek (and any reasoning model) - too verbose for this usage
