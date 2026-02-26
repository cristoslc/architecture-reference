# 0003 Use multiple prompts for obtaining AI grade

## Context

The current LLM's suffer from hallucinations, which means that the responses we get from them cannot be treated as 100% correct.
In order to preserve credibility of our certificates, we need to develop strategies that will help to mitigate that risk. 

## Decision

We will send multiple prompts to the same LLM and verify that the response is coherent despite the prompt being different.
The final result will be an average of all results.

## Technique Description

1. **Multiple Prompt Generation**: For each question, generate multiple variations of the prompt to be sent to the LLM using different prompting strategies. This could incorporate changing the sequence of question/answer (LLMs tend to favor the last given information), rephrasing the prompt or using personas. For example:
  - Ordering strategy:  
    > On a scale of 0 to 10, grade the following answer: <submitted answer> to the question: <question>

    vs

    > For the question: <question> grade the following answer: <submitted answer> on a scale of 0 to 10.
  - Persona strategy:  
    > You are a college professor. You ask the student: <question> and hear the answer: <submitted answer>. Grade it on a scale of 0 to 10


    vs

    > You are a principal architect who is interviewing a candidate. The interview question is: <question> and the candidates answer is: <submitted answer>. How would you grade it on a scale of 0 - 10?
3. **Response Collection**: Send each prompt variation to the LLM and collect the responses.
4. **Coherence Verification**: Compare the responses to ensure they are coherent and consistent. If the responses are not consistent, flag the question for human review.
5. **Final Grading**: Use the consistent responses to determine the final grade for the question.

## Consequences

By sending multiple prompts to the LLM, we're increasing the cost of the service. This increase may either be visible
by literally a bigger amount on the invoice, or by reaching the monthly token limit faster.  
We are also increasing the time it takes to gather all the required responses, though with parallel processing, we're doing to be as fast as the slowest component - which is acceptable given the gain of increased certainty.
