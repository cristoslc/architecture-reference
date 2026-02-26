# ADR-011: Matching engine solution

## Date:
2024-09-27

## Status:
Accepted

## Context:
The system needs a robust method to match candidate resumes with job offers, ensuring that the best-fit candidates are highlighted for each role. One of the key challenges is to accurately compare the content of the anonymised resumes and job descriptions, which are typically unstructured text, and determine how well a candidate’s skills and experience align with the job requirements.

We explored several potential solutions to address this challenge. Semantic analysis was one option considered, where the system would use natural language processing (NLP) techniques to derive the meaning of sentences and phrases from resumes and job descriptions. This approach would allow for a deeper understanding of context, identifying synonyms or related terms even if the specific keywords didn’t match exactly. While semantic analysis promised high accuracy and flexibility, it introduced significant complexity and computational cost, especially as it would require training sophisticated models or using external services, which would increase operational expenses.

Another approach considered was basic keyword matching, where the system would simply compare the presence of keywords in resumes and job descriptions. This method is straightforward and computationally light, but it lacked the nuanced comparison needed to accurately evaluate the quality and depth of skills. Keyword matching often leads to false positives, where resumes are deemed a good fit based on superficial matches without considering the relevance or importance of those keywords.

## Decision:

We have decided to implement a solution that tokenizes both the resume and the job offer and then applies a weighted token comparison to determine the best fit. In this approach:

1. **Tokenization:** The system will break down both the candidate resume and the job description into smaller units, or tokens (typically words or short phrases).
2. **Weighted Token Comparison:** Each token will be assigned a weight based on its relevance to the job. Specifically, technical keywords (e.g., programming languages, tools, frameworks, and hard skills) will carry higher weights than more generic tokens (e.g., soft skills or general descriptors). Tokens with higher weights will have a greater influence on the overall matching score between the resume and the job description.
3. **Best Fit Calculation:** The system will compare the tokens from both the resume and the job description. A similarity score will be calculated based on the weighted comparison, and candidates with higher similarity scores will be considered better fits for the job.
4. **Fine-Tuning:** The weights assigned to tokens will be adjusted over time based on feedback and performance metrics, ensuring that the system improves its accuracy in identifying the best candidates for each role.

## Consequences:
### Pros:
1. **Accurate Matching for Technical Roles:** By giving higher weights to technical keywords (e.g., technology names, programming languages, tools), the system ensures that hard skills are prioritized in the matching process, which is critical for technical job roles.
2. **Improved Matching Over Time:** The ability to fine-tune token weights based on feedback ensures that the matching algorithm will improve over time, providing more accurate results as it learns from real-world data and outcomes.
3. **Scalability:** The tokenization and weighted comparison approach is scalable and can handle a growing database of resumes and job descriptions without significant performance degradation. This ensures that the system can maintain efficiency even as the user base and job postings increase.
4. **Customizable Matching Criteria:** The system allows for customizable weighting schemes, meaning that the importance of specific tokens can be adjusted depending on the job type, allowing system to be rolled out in future to support job hunting in other industries (e.g., STEM, healthcare).

### Cons:
1. **Initial Complexity in Weight Assignment:** Determining the appropriate weights for different tokens, particularly technical terms versus soft skills, may require significant initial setup and refinement. Incorrect weights could lead to suboptimal matches early in the process.
2. **Maintaining the Token Dictionary:** The system will require ongoing updates to its token dictionary, particularly to capture emerging technologies, new tools, and industry-specific terms. This adds a layer of maintenance to ensure the dictionary remains up to date.
3. **Handling Ambiguous or Misspelled Keywords:** Tokenization may not always handle misspelled or ambiguous keywords well, which could lead to missed matches if key skills are not recognized correctly. This may require additional preprocessing, such as spelling correction or token standardization.