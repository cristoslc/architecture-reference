# Architecture Decision Record (ADR)

## ADR 12: Utilizing LLM Caching in the System

### Status
- REJECTED

### Context
The integration of Generative AI and Large Language Models (LLMs) presents an opportunity to enhance efficiency in exam 
question generation and grading processes. However, the computational demands of running LLMs can lead to increased latency 
and resource consumption. To address these challenges, leveraging LLM caching can improve system performance, reduce costs, 
and enhance user experience, especially in light of the anticipated demand increase.

### Decision
We have determined that caching LLM results is not applicable for our use case. Specifically, the variability in 
candidate answers makes it infeasible to cache results effectively. The integration of context and the unique nature of 
each candidate's response means that any cached results would likely be invalid or misleading.

LLM caching strategies evaluated for reference:
- Caching AI-Generated Questions:
Store and reuse LLM-generated architecture exam questions to eliminate redundant computations and improve response times.

- Caching Responses for Grading:
Implement caching for AI-generated feedback or evaluations related to similar candidate submissions, allowing for quicker 
grading and consistency in evaluations.

- Contextual Responses for User Interactions:
Cache common queries and responses about the certification process, ensuring quick access for candidates and reducing the 
load on support staff.

- Storing Model Inference Results:
Maintain a cache of outputs from various analyses performed by the LLM, facilitating quicker retrieval of insights for 
similar submissions.

- Improving Adaptive Learning Systems:
Use caching to store historical performance data of questions and submissions to better inform adaptive testing and 
personalize candidate experiences.

- Caching Meta Information for Compliance:
Store information regarding previously evaluated submissions and audit trails to streamline compliance audits and quality 
assurance processes.

- User Training and Feedback:
Cache previous training materials and insights provided to candidates to facilitate continuous improvement in their 
understanding of certification requirements.

### Alternatives Considered
- **Option 1:** No Caching Mechanism:
Operating without LLM caching was considered; however, this approach would lead to increased latency and resource 
consumption, ultimately degrading user experience and system efficiency.

- **Option 2:** Basic Caching for Exam Questions Only:
Limiting caching to only AI-generated questions was evaluated. While this would improve efficiency, it would not leverage 
the full potential of LLM caching to enhance grading and user interactions.

- **Option 3:** Caching Full Submissions:
Caching entire candidate submissions was considered; however, it raises concerns about data privacy and storage 
requirements, making this approach less viable.

### References


### Date
02/14/2025
