# ShopWise AI Assistant -- Comparative Analysis

**Challenge:** AI Winter 2024 Season | 3 Teams
**Kata:** Design and build an AI-powered support assistant for ShopWise Solutions, an e-commerce platform, handling customer inquiries on products, orders, returns, and refunds through natural language understanding and seamless database integration.

---

## Challenge Overview

The ShopWise AI Assistant kata was the first AI-focused challenge in the O'Reilly Architecture Kata series. Unlike traditional katas that center on system design at the box-and-arrow level, this challenge required teams to build a *working* AI-powered customer support chatbot. The scope was deliberately end-to-end: natural language understanding, database integration for product catalogs and order management, multi-turn conversation handling, and a deployable user interface.

This made the challenge uniquely demanding. Teams had to demonstrate competence not just in software architecture, but in LLM selection, prompt engineering, data pipeline design, agent orchestration, and AI evaluation -- disciplines that many architecture practitioners are still developing fluency in.

Three teams placed. Their submissions ranged from a deeply documented multi-agent platform with formal C4 diagrams and a quantitative evaluation pipeline, to a lean low-code prototype that prioritized speed of delivery over architectural formalism, to a monolithic text-to-SQL pipeline that differentiated itself through multilingual support. The spread in approach makes this an unusually instructive set of submissions for practitioners navigating the emerging intersection of AI engineering and software architecture.

---

## Team Comparison Matrix

| Dimension | ConnectedAI (1st) | Breakwater (2nd) | Transformers (3rd) |
|---|---|---|---|
| **Architecture Style** | Multi-agent supervisor hierarchy | Workflow-orchestrated multi-agent (low-code) | Monolithic text-to-SQL pipeline |
| **Orchestration Framework** | LangGraph | n8n (visual workflow) | None (direct API calls) |
| **Primary LLM** | Claude 3.5 Sonnet (reasoning), Gemini 1.5 Flash (routing) | OpenAI GPT (via n8n) | Google Gemini Pro + OpenAI GPT |
| **Database** | MongoDB (NoSQL) + PostgreSQL | PostgreSQL | SQLite |
| **Frontend** | React.js with WebSockets | n8n built-in chat UI | Flask with Bootstrap HTML/CSS/JS |
| **Deployment** | Google Cloud Run, Firebase, Docker | Docker Compose (local) | Local only (no containerization) |
| **ADR Count** | 12 | 5 | 0 |
| **ADR Quality** | Thorough: context, options, consequences | Concise but capture real pivots | N/A |
| **Formal Diagrams** | C1, C2, C3 (full C4 hierarchy) | None | Conceptual flow diagrams only |
| **Evaluation Framework** | Ragas + LangFuse (quantitative metrics) | None | None |
| **Video Presentation** | Yes (presentation + agent demo) | No | No |
| **Team Size** | 5 (named, with roles) | Not specified | Not specified |
| **Multilingual Support** | No | No | Yes (5 languages) |
| **Cloud Deployed** | Yes (GCP) | No | No |

---

## Architecture Style Choices

### ConnectedAI: Multi-Agent Supervisor Hierarchy

ConnectedAI's architecture was the most sophisticated. They built a supervisor agent that routes incoming queries to four specialized sub-agents:

1. **Order Processing Agent** -- handles order status, shipping, return eligibility
2. **Product Attributes Agent** -- handles specifications, availability, and attribute lookups
3. **Product Comparison and Recommendation Agent** -- compares products, generates recommendations
4. **Product Range Overview Agent** -- provides catalog statistics and category-level insights

The supervisor pattern was implemented in LangGraph, chosen over CrewAI, AutoGen, and Haystack after a formal evaluation documented in ADR-005. The key decision driver was LangGraph's native support for structured workflows with conditional logic and branching -- essential for routing customer queries to the right specialist agent.

A notable architectural choice was their dual-LLM strategy (ADR-002): Claude 3.5 Sonnet handled complex reasoning and tool-calling tasks, while Gemini 1.5 Flash was used for routing and simpler tasks due to its speed and low cost. This cost-aware model selection is a pattern worth emulating.

Their data layer combined MongoDB for flexible document storage and vector embeddings (ADR-001) with PostgreSQL for analytical workloads, acknowledging that different data access patterns warrant different storage engines.

### Breakwater: Low-Code Workflow Orchestration

Breakwater took a radically different approach: they built the entire chatbot using n8n, a visual workflow automation platform. Their architecture was a three-agent topology:

1. **Main Agent** -- understands the customer's question and routes to specialists
2. **Logistics Manager** -- handles order statuses, shipping, delivery
3. **Product Consultant** -- handles comparisons, recommendations, ratings

The routing logic was embedded directly in the main agent's prompt, with detailed instructions and examples for directing queries to the appropriate specialist. Each specialist agent followed a multi-step workflow: classify the product category, extract product names, generate a SQL SELECT statement, execute it against PostgreSQL, and then use the results as context for a natural language response.

What makes this submission architecturally interesting is the explicit decision trail. Their ADRs document real pivots: they started with Groq but hit quota limits and switched to OpenAI. They tested RAG vs. SQL for data retrieval and found SQL performed better. They discovered a bug in n8n's SQL agent node and switched to direct Postgres nodes. These are the kinds of concrete, experience-driven decisions that make ADRs valuable.

### Transformers: Monolithic Text-to-SQL Pipeline

Transformers built a Flask monolith with an embedded chatbot. Their pipeline was straightforward:

1. User enters a query (with language selection)
2. Gemini Pro converts the query to SQL
3. SQL executes against SQLite
4. OpenAI GPT generates a natural language response using RAG enhancement

Their distinguishing feature was multilingual support -- a translation layer for Spanish, German, Hindi, and French -- which no other team attempted. They also invested heavily in the user-facing e-commerce frontend, building a complete product catalog browsing experience.

However, the architecture had significant limitations: a single-table SQLite schema merging products and orders, global mutable state for chat history (not session-safe), and no separation of concerns in the Flask application. There were no ADRs documenting any design decisions.

---

## What Distinguished the Top Teams

### 1. Documentation Depth and ADR Quality

The single largest differentiator was the quality and completeness of architecture documentation. ConnectedAI produced 12 well-structured ADRs following a consistent template (context, decision drivers, considered options with pros/cons, decision, consequences). Each ADR tells a story: *why* they chose MongoDB over PostgreSQL for their primary store (ADR-001), *why* LangGraph over CrewAI or AutoGen (ADR-005), *why* LangFuse over LangSmith or Phoenix Arize for evaluation (ADR-007).

Breakwater's 5 ADRs were more concise but equally valuable because they documented *real decision pivots* -- the Groq-to-OpenAI switch, the RAG-to-SQL pivot, the SQL-agent-to-Postgres-node workaround. These are the messy, honest records that help future practitioners.

Transformers had zero ADRs, which placed them at a significant disadvantage. In an architecture kata, the reasoning is the deliverable -- not just the code.

### 2. Quantitative AI Evaluation

ConnectedAI was the only team to implement a formal evaluation framework. Using Ragas for offline evaluation with LangFuse for tracing (ADR-007), they benchmarked three models (GPT-4o-mini, Claude 3.5 Sonnet, Gemini 1.5 Flash) on faithfulness and answer relevancy metrics.

Their evaluation results revealed non-obvious insights: Gemini 1.5 Flash scored high on answer relevancy but zero on faithfulness for return-eligibility queries because it asked for an order ID even when one was provided. This led to a nuanced conclusion documented in their evaluation report -- that individual metrics are insufficient and must be interpreted holistically. They ultimately chose Claude 3.5 Sonnet for production despite its higher cost, based on qualitative multi-turn conversation testing.

Neither Breakwater nor Transformers attempted any form of systematic evaluation, which is a significant gap when building AI systems where output quality is non-deterministic.

### 3. Multi-Agent Sophistication

ConnectedAI and Breakwater both implemented multi-agent architectures, but ConnectedAI's was more granular (four specialist agents vs. two) and more formally structured (supervisor hierarchy with LangGraph state management vs. prompt-based routing in n8n).

The four-agent decomposition allowed ConnectedAI to produce C3 component diagrams for each agent, making the internal architecture of each specialist transparent. Breakwater's approach was effective but less visible architecturally -- the routing logic was embedded in prompts rather than expressed in infrastructure.

Transformers used a single-pipeline architecture (text-to-SQL followed by response generation), which limited their ability to handle complex routing scenarios like "compare two products and tell me about my order for one of them."

### 4. C4 Diagram Coverage

ConnectedAI was the only team to produce a full C4 hierarchy: system context (C1), container diagrams for both the AI assistant and the responsible AI platform (C2), and component diagrams for each of the four specialist agents (C3). This made their architecture navigable at multiple levels of abstraction.

Transformers had conceptual flow diagrams that described the pipeline but did not follow any formal notation. Breakwater had no diagrams at all -- a notable gap given the visual nature of their n8n workflow approach.

---

## Common Patterns

Despite their differences, several patterns appeared across the three placing teams:

### Text-to-SQL as Core Pattern

All three teams converged on text-to-SQL as the primary mechanism for database interaction. Whether implemented through LangGraph tool-calling (ConnectedAI), n8n workflow nodes (Breakwater), or direct Gemini Pro API calls (Transformers), every team chose to have the LLM generate SQL queries rather than use vector similarity search (RAG) as the primary retrieval mechanism.

Breakwater explicitly tested RAG vs. SQL and documented that SQL outperformed RAG for their structured product/order data. This aligns with the emerging consensus that text-to-SQL is often superior to RAG for queries against well-structured relational data.

### Agent Routing via Prompt Engineering

Teams that implemented multi-agent architectures (ConnectedAI, Breakwater) both relied heavily on prompt engineering for routing decisions. Breakwater's README contains detailed routing prompts with explicit examples: "Customer asks about ratings distribution across categories -> route to Product Consultant." ConnectedAI's supervisor agent similarly used prompt-based routing, though orchestrated through LangGraph's state machine.

### PostgreSQL as the Common Denominator

Two of the three teams used PostgreSQL (Breakwater for their primary store, ConnectedAI as a secondary analytical store). Its combination of relational querying, full-text search capabilities, and general ecosystem maturity made it a natural default for structured e-commerce data. Transformers used SQLite, which introduced limitations (single-table schema, no concurrent access) but kept the deployment simple.

### Containerization for Portability

Two teams (ConnectedAI, Breakwater) containerized their solutions with Docker, though to different degrees. ConnectedAI deployed to Google Cloud Run with a full cloud-native stack; Breakwater provided a one-command `docker compose up -d` for local operation. Transformers was the only team with no containerization at all, running purely as a local Flask application.

### LLM Provider Diversity

No two teams used the exact same LLM configuration. ConnectedAI employed a dual-model strategy with Claude 3.5 Sonnet for reasoning and Gemini 1.5 Flash for routing. Breakwater used OpenAI GPT through n8n's built-in integrations. Transformers combined Google Gemini Pro for SQL generation with OpenAI GPT for response synthesis. This diversity suggests the AI assistant space has not yet consolidated around a single model provider, and teams are making pragmatic choices based on cost, capability, and platform familiarity.

---

## Unique Innovations Worth Highlighting

### ConnectedAI: Responsible AI Platform as Separate Container (C2)

ConnectedAI designed a dedicated "Responsible AI ML Ops Platform" as a separate container in their C2 diagrams, housing evaluation pipelines, monitoring, and tracing infrastructure. While the dashboard and alerts were listed as future enhancements rather than implemented features, the architectural forethought of separating observability and evaluation into its own deployment unit is a pattern that production AI systems should adopt. It prevents evaluation infrastructure from being an afterthought bolted onto the application.

### ConnectedAI: Multi-Model Cost Optimization

The dual-LLM strategy documented in ADR-002 -- using Claude 3.5 Sonnet for complex reasoning and Gemini 1.5 Flash for routing -- is a practical pattern for managing AI infrastructure costs. Routing decisions are high-volume, low-complexity tasks; using a cheaper, faster model for them while reserving expensive models for complex reasoning is an optimization that directly impacts operational viability.

### Breakwater: Low-Code as Architecture Strategy

Breakwater's choice to build entirely on n8n was the most unconventional approach. Their ADR explicitly frames it as a prototyping decision: n8n is "built on top of LangChain framework," is "industry standard," and is "easy to migrate to code-based solution when scalability is needed." This is a legitimate architectural strategy -- use visual workflow tools to rapidly validate agent topologies, then port to code when the design stabilizes. The trade-off (no formal diagrams, limited documentation) is real, but for a kata that required a working prototype, the pragmatism paid off.

### Breakwater: Documented Decision Pivots

Breakwater's "Superceded" ADRs (Groq to OpenAI, RAG to SQL) are among the most honest decision records in the entire kata set. They document what did not work and why: Groq hit quota limits, RAG had performance issues, n8n's SQL agent had a bug. These records are more valuable to practitioners than polished ADRs that only describe the final choice, because they reveal the failure modes and trade-offs encountered during real implementation.

### Transformers: Multilingual as Differentiator

Transformers was the only team to implement multilingual support (Spanish, German, Hindi, French in addition to English). While their architecture was the simplest, this feature demonstrates awareness of a real-world requirement -- global e-commerce platforms serve multilingual customers. The translation layer was implemented as a pipeline stage, wrapping the core text-to-SQL flow.

---

## Lessons for Practitioners

### 1. ADRs Matter More in AI Systems Than in Traditional Systems

In traditional software architecture, ADRs document infrastructure and framework choices that are relatively stable and well-understood. In AI systems, the decision landscape is far more volatile: models change quarterly, orchestration frameworks are immature, evaluation methods are contested, and the trade-offs between accuracy, cost, and latency are non-obvious. ConnectedAI's 12 ADRs and Breakwater's honest pivot records demonstrate that disciplined decision documentation is not just a "nice to have" -- it is essential for AI systems where decisions must be revisited frequently as the underlying technology evolves.

### 2. Evaluation is an Architectural Concern, Not an Afterthought

ConnectedAI's use of Ragas and LangFuse for quantitative evaluation was the single most sophisticated technical contribution across all submissions. Their finding that Gemini 1.5 Flash scored high on answer relevancy but zero on faithfulness illustrates a critical lesson: AI systems require evaluation infrastructure *built into the architecture*, not bolted on after deployment. The fact that neither of the other placing teams had an evaluation framework at all reflects a maturity gap in how the industry approaches AI system design.

### 3. Text-to-SQL Beats RAG for Structured Data

All three teams converged on text-to-SQL rather than vector-based RAG for querying structured product and order databases. Breakwater explicitly tested both and found SQL superior. This pattern makes intuitive sense -- RAG excels at retrieving unstructured knowledge from documents, while structured data in relational databases is better accessed through SQL generation. Practitioners building AI assistants over structured data should default to text-to-SQL and only add RAG for genuinely unstructured content.

### 4. Multi-Agent Architectures Need Formal Structure

Both ConnectedAI and Breakwater implemented multi-agent architectures, but ConnectedAI's was more maintainable because it used LangGraph's state machine to formalize agent routing, while Breakwater embedded routing logic entirely in prompts. As agent systems grow in complexity, prompt-based routing becomes fragile. Using a framework that makes agent topology explicit (LangGraph, or similar) provides better visibility, testability, and evolvability.

### 5. The Low-Code Path is Legitimate for Prototyping

Breakwater's second-place finish using n8n demonstrates that visual workflow tools can produce competitive results in a prototyping context. For teams exploring multi-agent architectures, starting with a low-code tool to validate agent topology and prompt design before committing to a code-based framework can dramatically reduce iteration time. The key is treating it as a stepping stone, not a destination -- as Breakwater's ADR explicitly acknowledges.

### 6. SQL Safety Guardrails Are Essential for Text-to-SQL Systems

When an LLM generates SQL, there is an inherent risk of producing DELETE, UPDATE, or unbounded SELECT queries. Any production text-to-SQL system should implement safety measures such as SELECT-only validation and LIMIT enforcement to prevent runaway or destructive queries. This is a minimum baseline that should be standard practice for teams adopting the text-to-SQL pattern.

### 7. Working Software Still Wins

Across all three submissions, the teams that placed highest (ConnectedAI and Breakwater) had fully working, demonstrable systems. ConnectedAI provided video demos of each test scenario. Breakwater offered a one-command Docker startup. The challenge explicitly required building, not just designing -- and the results show that architectural rigor combined with working software is the winning combination.

---

*Analysis based on team submissions to the O'Reilly Architecture Kata, AI Winter 2024 season. Team directories: `evidence-pool/TheKataLog/2024-ShopWise-AI/ConnectedAI/`, `evidence-pool/TheKataLog/2024-ShopWise-AI/Breakwater/`, `evidence-pool/TheKataLog/2024-ShopWise-AI/Transformers/`. YAML catalog entries in `docs/catalog/`.*
