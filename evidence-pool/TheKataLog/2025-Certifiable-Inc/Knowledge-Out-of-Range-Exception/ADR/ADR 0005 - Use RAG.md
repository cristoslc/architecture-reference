# 0005 Use RAG (Retrieval Augmented Generation)

## Context

AI-aided grading with low confidence leads to increased human involvement in the process. This can result in inefficiencies and potential inconsistencies in grading. To reduce incorrect grades made by AI and improve the overall accuracy of the system, we need a strategy that incorporates previous errors into future evaluations.

## Decision

We will implement Retrieval Augmented Generation (RAG) to enhance the accuracy of AI responses. RAG involves retrieving relevant data to provide context for the AI, which can help reduce the occurrence of false positives and improve the reliability of the grading system.

Initially, each question will be validated by a human to create a dataset of incorrectly graded questions (user answer, AI grade). This dataset will be used to guide the AI by indicating: "For this question, these answers are not correct."

## Technique Description

Retrieval Augmented Generation (RAG) is a hybrid approach that combines retrieval-based and generation-based methods. In RAG, the AI model first retrieves relevant documents or pieces of information from a large corpus based on the input query. These retrieved documents provide additional context and are then used to inform the generation of the final response. This approach helps the AI model generate more accurate and contextually relevant answers by grounding its responses in real-world information.

The process involves the following steps:

1. **Initial Human Validation**: Each question is initially validated by a human to create a dataset of incorrectly graded questions.
2. **Retrieval**: For each new question, the AI retrieves relevant pieces of information, including the dataset of previous errors.
3. **Generation**: The AI uses the retrieved information to generate a response, incorporating the additional context to improve accuracy.
4. **Continuous Improvement**: The retrieval corpus is continuously updated with new data and previous errors, allowing the AI to learn from its mistakes and improve over time.

The data used for RAG will be kept in plain text format and can utilize a RDBMS for storage. Sample types of data:
1. Keywords - a question can contain a set of keywords that need to be mentioned in the answer
2. Historical answers that have been graded by humans as a result of an incorrect AI grading (e.g. `As an example, this answer: <...> should have a minimal grade of <...>`)

## Justification

By following this process, we can ensure that the AI model generates more accurate and contextually relevant responses, reducing the likelihood of incorrect grades and improving the overall reliability of the grading system.

## Consequences

By using RAG, we can leverage additional context to improve the accuracy of AI responses. This will help reduce incorrect grading and increase the overall reliability of the system. Additionally, incorporating previous errors into the retrieval process will allow the AI to learn from past mistakes and improve over time.

## Tradeoffs

We need extra infrastructure and extra components that will manage data for RAG. That means both increased development, maintenance and operational costs.
If instead, we'd fine tune our models, the prompts would not need augmentation and the results should have higher quality. Cost of fine tuning would require an up-front investment that would (most likely) exceed the cost of using RAG.  
Training a custom LLM is discarded because of an even greater up-front cost.
