## Prompt Research

Research was undertaken to understand what mature AI capabilites, architecture patterns, practices, and approaches are currently available in the industry.

Specifically we wanted to understand:

- The RAG pattern, how can it be applied, and what cloud-based services can be availed of.
- Prompt engineering to craft appropriate prompts that produce the desired grading and feedback of exam submissions.

![RAG Pattern](./rag-pattern.png)

### Experiment 1: Test 1 Short Answer Question Context Loading & Prompting

We started with a low fidelity experiment using ChatGPT web interface directly to simulate the RAG retrieval (by pasting contextual source material into the prompt), and crafting an appropriate prompt around the contextual information that included the exam question and the candidates answer to the exam question. The following is the prompt that we crafted with contextual information, and the resultant output from the LLM:

#### The prompt

```
You are grading a software engineer on their automation testing knowledge. The question presented to the sofware engineer was: "what techniques would you use to ensure a sufficient level of test coverage for an API endpoint ensuring faster time-to-market". The answer provided by the software engineer is: "I would use a combination of unit testing with code coverage of at least 60%, and end-to-end testing to ensure the API endpoint is behaving as intended".

Please provide a grade for the answer on a scale of 0 to 10, and detailed feedback on how their answer met, or did not meet expectations taking the following context into strict account:

<context information on good testing practices was inserted here>
```

#### The response

```
Based on the context and expectations provided, here's a grading and detailed feedback for the software engineer's response:

Grade: 4 out of 10

Feedback:

Unit Testing and Coverage:

The engineer mentions using unit tests with a code coverage of at least 60%. While unit testing is a crucial part of the testing pyramid and serves as a foundation for test coverage, the suggested threshold of 60% is quite low. Testing excellence suggests optimizing testing cycle times while ensuring meaningful test coverage, which generally implies aiming for higher coverage, especially for critical components.

End-to-End Testing:

Including end-to-end testing is beneficial as it ensures the API endpoint behaves as intended when integrated into the broader system. However, relying heavily on end-to-end tests can be costly and time-consuming. The engineer's response lacks emphasis on optimizing test cycles by suggesting more efficient testing methods earlier in the development process (lower in the pyramid), which aligns with the goals of testing excellence.

Lack of Preventative Techniques:

The response does not address preventative measures to avoid introducing bugs in the first place, a key aspect of the Testing Manifesto. Techniques such as Test-Driven Development (TDD) or Behavior-Driven Development (BDD) were not mentioned, nor was there a discussion on involving the team in quality assurance from the start.

Missing Types of Testing:

The engineer's answer does not mention other testing strategies that could contribute to comprehensive coverage, such as consumer-driven contract testing, integration testing, or component testing. These tests could provide confidence in API functionality in isolation and in interaction with other components, reducing reliance on more expensive end-to-end testing.

Collaboration and Team Responsibility:

The response does not reflect a whole-team approach to quality, where developers are primarily responsible for writing and maintaining acceptance and unit tests. There is no indication of collaborative practices that ensure quality is built into the product continuously throughout the software development lifecycle.

Optimization and Automation in Workflow:

The answer lacks any reference to automation practices such as continuous integration/continuous deployment (CI/CD), which are crucial for ensuring fast feedback and integrating automated tests into the delivery pipeline. Ensuring that all tests run automatically on each pipeline trigger is key for faster time-to-market.
In summary, while the software engineer has a basic understanding of some testing strategies, their response lacks depth in preventative techniques, collaborative practices, and optimized automation processes crucial for achieving testing excellence in line with the context provided.
```

This allowed us to quickly test and iterate on different prompting and context loading styles to fine tune the grading and feedback of the LLM. This also allowed us to get a rough estimate on the number of input and output tokens required to process a single Test 1 Short Answer question.


### Experiment 2

In this experiment we wanted to play around with structured formatting of the output and evaluating the answer across multiple dimensions:

#### The prompt

```
You are an expert software architect grading an architecture examination submission. The question presented to the candidate is: 

“ What are architectural characteristics within software systems, at what point in the architecture design process to you identify architecture characteristics, and how would you go about identifying architectural characteristics of a software system”. 

The answer provided by the candidate is:

 "Architecture characteristics are the non-functional requirements of the systems otherwise known as architecture quality attributes, or the ‘-ilities’ of a software system such as scalability, feasibility, or reliability. The describe the non-functional aspects of the system that stakeholders have determined to be the truly important aspects of the architecture from a domain perspective. Architecture Characteristics are one of the first steps in creating an architecture or determining the validity of an existing architecture. An architect uncovers architecture in at least 3 ways by extracting from domain concerns, requirements, and implicit domain knowledge".

 Please provide an overall grade for the answer between 0 and 100 percent, broken down by technical accuracy and clarity, and with detailed feedback on how their answer met, or did not meet expectations, in a json structure with the overall score in an attribute named “overallScore”, the technical accuracy in an attribute named “technicalScore”, the clarity score in an attribute called “clarityScore”, and the detailed overall feedback in a single attribute named “detailedFeedback”. Do all the above while taking the following context into strict account:

 <context loaded from Chapter 5. Indentifying Architectural Characteristics in the book Fundamentals of Software Architecture by Mark Richards and Neal Ford available through the O'Reilly platform>
 ```

#### The response

```json
{
  "overallScore": 75,
  "technicalScore": 80,
  "clarityScore": 70,
  "detailedFeedback": "The candidate's response demonstrates a reasonable understanding of architectural characteristics, correctly identifying them as non-functional requirements or 'quality attributes' of a software system, including their common reference as the '-ilities' (e.g., scalability, reliability). They also correctly state that these characteristics should be identified early in the architecture design process to create or validate an architecture. This aligns with the provided context, where identifying driving architectural characteristics is described as one of the first steps in the architecture process. The candidate mentions that architectural characteristics are uncovered from domain concerns, requirements, and implicit domain knowledge, which is consistent with the provided context. However, the candidate's explanation lacks depth and clarity in describing how to effectively identify these characteristics, missing the nuances around translating domain concerns into architectural characteristics and the importance of stakeholder collaboration. The answer could be improved by emphasizing the importance of understanding domain goals and prioritizing characteristics, as well as the potential complexities and trade-offs in supporting multiple characteristics. The response could also benefit from greater detail on how architects translate domain-specific language into architectural characteristics and examples to illustrate these processes. Overall, the candidate demonstrates a basic understanding but could improve the explanation with more specifics and clearer articulation."
}
```

We found that there is some leakage of information from the source material that may compromise the examination process, so this would have to be investigated further and an optimal approach taken such that the feedback is accurate, useful, but does not reveal too much information about the examination source material.

#### Making things up

We also found that without explicitly specifying the desired json attritubes in the output, the LLM can sometimes add unwanted elements, in this case splitting the overall feedback into separate attributes: `technicalFeedback`, `clarityFeedback`, and `contextualFeedback`:

```json
{
  "overallScore": 85,
  "technicalScore": 90,
  "clarityScore": 80,
  "detailedFeedback": {
    "technicalFeedback": "The candidate's answer accurately identifies architectural characteristics as non-functional requirements, also referred to as quality attributes or the '-ilities' of a system. This aligns well with the source material, which emphasizes the importance of scalability, reliability, and other similar attributes. The candidate correctly notes that identifying these characteristics is one of the first steps in the architecture design process. Additionally, the three methods of uncovering these characteristics—domain concerns, requirements, and implicit domain knowledge—are correctly mentioned. However, the candidate could have expanded on these points by providing more detailed examples or scenarios to better illustrate their understanding of how these methods translate to practical architectural decisions.",
    "clarityFeedback": "The explanation provided is generally clear but could be more concise and structured. The candidate could improve clarity by explicitly defining terms like 'domain concerns' and giving brief examples to illustrate each method of uncovering architecture characteristics. Additionally, some attributes such as 'feasibility' are mentioned in passing as '-ilities', which might cause confusion since it is not typically listed among the common architectural characteristics like scalability or reliability. Furthermore, the candidate could improve by elaborating on the interaction between architects and stakeholders, explaining potential challenges in aligning technical and domain perspectives, which was well covered in the provided context.",
    "contextualFeedback": "The candidate successfully captures the essence of identifying architectural characteristics early in the process, as discussed in the context. However, the candidate could better align their answer with the emphasis on translating domain concerns into architecture characteristics. The example of avoiding over-specifying characteristics (as in the Vasa story) could be further highlighted to demonstrate understanding of the trade-offs and prioritization challenges that architects face. Additionally, mentioning common pitfalls like 'lost in translation' between architects and stakeholders would have further demonstrated a deeper understanding of the material."
  }
}
```

Also, the scoring changed by up to 10% across similar prompts with the exact same candidate answer. Therefore this reinforces the need for optmising for accuracy in the system.