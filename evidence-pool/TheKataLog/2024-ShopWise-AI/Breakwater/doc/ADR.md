# AI Katas chatbot architectural decisions 

For prototyping the ShopWise AI assistant N8n cloud with OpenAI and Postgres were chosen.
The architecture is three agent topology with a main assistant and two specialists one tweaked for product and other for logistics. Below is the list of the main architectural decisions.

## N8n for building the ShopWise chatbot prototype

### Status 
Accepted

### Context 
The goal is to have a single place for building the structure of the chatbot and testing it.

### Decision 
Great for prototyping. Built on top of langchain framework. Industry standard, easy to migrate to code-based solution, when scalability is needed.

### Consequence
Quickly got the first versions running and started testing the solution.

## Groq for the language model.

### Status 
Superceded

### Context 
Affordable language model cloud solution for prototyping.

### Decision 
Hit the quota limits during testing

### Consequence
Decision to choose alternative language model to avoid issues during the evaluation checks of the chatbot capabilities after solution is submitted.

## OpenAI for the language model.

### Status 
Accepted

### Context 
Best in class language model cloud solution for prototyping.

### Decision 
Testing showed good results with possibility to tweak. Example: chat requests for comparison of items were automatically executed by the main agent as 2 separate prompts to specialist agents and then consolidated based on the replies.

### Consequence
OpenAi was chosen as the main language model.


## Three agents architecture: the main agent and 2 specialised ones. 

### Status 
Accepted

### Context
The main agent has instructions which requests to direct to which specialised agent.
  **Logistics Manager**(Orders agent): Expert on order statuses, shipping details, and delivery dates.
  **Product Consultant**: Specialist in comparing and recommending products across all categories

### Decision
Use 3 agent architecture.

### Consequence
Good results, more transparent and tweakable chat request flow.


## RAG agent instead of the SQL agent


### Status 
Superceded

### Context
Tested RAG vs SQL.

### Decision
Not to use RAG, instead use SQL (due to performance issues with RAG)

### Consequence
SQL node showed better performance than RAG.


## Postgres node instead of SQL agent 

### Status 
Accepted

### Context
During tests inconsistent behaviour of the SQL node was discovered.

### Decision
SQL agent has a bug in n8n.

### Consequence
Postgres and “SELECT statement” nodes are chosen as the mail DB nodes in the workflow.


