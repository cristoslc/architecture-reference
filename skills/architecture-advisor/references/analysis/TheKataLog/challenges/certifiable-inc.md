# Certifiable Inc. -- Comparative Analysis

> **Kata Season:** Winter 2025 | **Teams:** 3 | **Theme:** AI-enabled architecture for certification grading
> **Challenge:** Design how Generative AI can be integrated into a software architecture certification system (SoftArchCert) to automate manual grading processes, reduce costs, and scale operations to handle a 5-10X increase in certification demand.

## Challenge Overview

The Certifiable Inc. kata is the second AI-focused challenge in the O'Reilly Architecture Katas series and the most recent kata at time of analysis. It asks teams to redesign the SoftArchCert certification platform -- which processes 200 candidates per week through a two-stage exam (an aptitude test with short-answer questions and an architecture case study submission) -- to handle a projected 5-10X surge in demand driven by international expansion. The core tension: grading is labor-intensive (11 expert-hours per candidate at $50/hour), accuracy is non-negotiable (careers depend on it), and the $800 exam fee leaves thin margins.

Unlike the ShopWise kata (Fall 2024), which dealt with AI for retail recommendations where occasional errors are low-stakes, Certifiable Inc. places AI in a high-stakes, high-accountability domain. This distinction forced teams to grapple with questions that do not arise in typical AI integration scenarios: How much autonomy should an AI grader have? How do you validate subjective assessments? What happens when an AI system's error can derail someone's career?

Three teams placed: ZAITects (1st), Litmus (2nd), and Software Architecture Guild (3rd).

## Team Comparison Matrix

| Dimension | ZAITects (1st) | Litmus (2nd) | SW Arch Guild (3rd) |
|---|---|---|---|
| **Architecture Style** | Service-based + event-driven + hybrid AI-human pipeline | Service-based | Microkernel (plug-in) + service-based |
| **Team Size** | 5 | 5 | 5 |
| **ADR Count** | 18 | 18 | 6 |
| **Top Quality Attrs** | Accuracy, scalability, cost efficiency | Testability, data integrity, fault tolerance | Cost, evolvability, simplicity |
| **RAG Usage** | Yes (core to grading) | Yes (ensemble for Test 2) | Offered as one of six variants |
| **Human-in-the-Loop** | Confidence-based escalation | Low-confidence escalation | All decisions require expert sign-off |
| **Feasibility Analysis** | Yes (detailed cost modeling) | Yes (financial, security, privacy, environmental) | Yes (Rozanski-Woods perspectives) |
| **C4 Diagrams** | C2, C3 | C1, C2 | C2, C3 |
| **Video** | No | Yes | Yes |
| **Rejected Ideas (documented)** | Agentic AI | AI anti-cheating agent, LLM caching | N/A (few ADRs but high-quality) |

## Architecture Style Choices

### The Service-Based Foundation

All three placing teams chose a service-based architecture as their primary style. The reasoning was consistent: the existing SoftArchCert platform was assumed to already follow a service-based pattern, and the constraint to "seamlessly integrate" AI components made it unwise to re-architect the entire system. Service-based architecture also scores well on feasibility and maintainability -- critical when the primary goal is adding AI capabilities, not rebuilding the platform.

### The Microkernel Differentiator

**Software Architecture Guild** (3rd place) made the most distinctive architectural choice: a **microkernel (plug-in) architecture** for their AI assistant (ADR-6). The rationale was that AI is "continuously evolving" and the architecture must support easy integration of new AI models or replacement of existing ones. This enabled their most innovative contribution -- running six different AI solution variants in parallel (text search, RAG, in-context learning, direct prompting, automatic prompt optimization, LLM-powered structured parsing) and selecting the best performer based on real-world data.

This was not just an abstract architectural preference. Their ADR-1 (AI/ML Development Principles) codified the philosophy: "Multiple AI/ML solutions must be developed in parallel rather than assuming a single model will be optimal." The microkernel architecture was the structural embodiment of that principle.

### Event-Driven Elements

**ZAITects** incorporated event-driven patterns alongside their service-based foundation, using event-driven processing for batch inference. This reduced cloud costs by processing grading requests in optimized batches -- a targeted application of the right pattern for a specific problem rather than adopting it as a platform-wide style.

## What Distinguished the Top Teams

### 1. Production Readiness Beyond Conceptual Design

The most striking quality shared by the top three teams was the depth of **production operationalization**. These teams did not just show how AI grading would work -- they showed how it would be deployed, monitored, secured, governed, and rolled back.

**ZAITects** (1st) assembled a comprehensive LLM production stack covering: an AI Gateway pattern for centralized LLM governance (ADR-001), LLM observability via Langwatch (ADR-011), guardrails with hybrid rule-based filters (ADR-010), OWASP Top 10 security analysis (ADR-016), governance strategies (ADR-017), and a phased rollout plan (MVP parallel grading, Growth AI-primary, Matured minimal human involvement). This is the kind of operational thinking that distinguishes a deployable system from a proof of concept.

**Litmus** (2nd) went beyond architecture into **product implementation decisions**, producing separate assessments for security, privacy, environmental impact, and operational/financial analysis. Their research section included actual prompt engineering simulations, a RAG experimental application, and detailed LLM cost calculations -- evidence of hands-on validation rather than theoretical design.

**Software Architecture Guild** (3rd) brought a different form of production readiness through their Rozanski-Woods feasibility perspectives, demonstrating systematic evaluation of their design's viability across multiple dimensions.

### 2. Disciplined Decision-Making (Including What Not to Build)

All three teams demonstrated architectural maturity by explicitly documenting what they rejected and why.

**ZAITects** produced a detailed anti-pattern analysis explaining why Agentic AI was deliberately avoided for structured certification workflows: "Agents, being probabilistic, can occasionally make incorrect decisions -- unacceptable in a high-stakes certification process." They noted that Agentic AI would be suitable for analytics but not for grading workflows.

**Litmus** rejected two features with full ADRs: an AI anti-cheating agent (ADR-10, rejected for MVP due to dataset labeling complexity and privacy concerns) and LLM caching (ADR-12, rejected because "the variability in candidate answers makes it infeasible to cache results effectively"). These rejection ADRs showed that the team evaluated ideas rigorously rather than including everything possible.

**Software Architecture Guild** took a different approach, producing fewer ADRs (6 vs. 18 for both ZAITects and Litmus) but ensuring each was high-quality and architecturally significant. Their ADR-1 on parallel AI solutions and ADR-2 on expert compensation reform reflect decisions that shaped the entire system design.

### 3. Concrete Metrics and Cost Analysis

The top teams backed their designs with numbers, each approaching cost analysis from a different angle.

**ZAITects** projected specific business outcomes: 5X productivity increase (19K to 3.7K expert hours/week), 80% cost reduction ($940K to $190K grading costs/week), and 4X efficiency improvement. These were not aspirational targets but outputs of their detailed cost analysis document.

**Litmus** provided a multi-dimensional feasibility analysis spanning financial projections, security costs, privacy compliance overhead, and even environmental impact -- the broadest scope of any team's analysis.

**Software Architecture Guild** approached costs differently -- through the lens of incentive alignment. Their ADR-2 (Expert Compensation Model) identified that paying experts hourly actively discourages efficiency. Their solution: transition to per-evaluation payments where an expert grading an aptitude test would earn $100 per test instead of $150 over 3 hours, but could now complete two tests in the same period using AI assistance, earning $200. This non-technical insight was unique across all submissions.

### 4. Grader/Judge Separation and Evaluation Strategy

**ZAITects** introduced a clean architectural separation between the **ASAS Grader** (which evaluates submissions) and the **ASAS Judge** (which assigns confidence scores to the grader's output). As they noted: "Splitting the Grader and Judge into separate components allows us to improve/test one component while keeping the other component constant." This mirrors the emerging LLM-as-a-Judge pattern and enables independent iteration on each concern.

Their ADR-009 (LLM Evaluation Strategy) was among the most thorough evaluation frameworks in any submission, combining automated metrics (BLEU, ROUGE, GPTScore), rubric-based LLM evaluation, LLM-as-a-Judge for deep analysis, and human-in-the-loop review -- with a PrOACT decision matrix scoring each approach across eight criteria.

## Common Patterns

Despite their differences, all three teams converged on several patterns:

### 1. Confidence-Based Escalation

Every team implemented some form of confidence scoring to determine when AI grading should be accepted automatically vs. escalated to human review. The specific thresholds varied, but the pattern was universal: high-confidence AI grades are auto-finalized, low-confidence grades are routed to expert architects, and the boundary is configurable.

### 2. Differentiated Treatment of Test 1 vs. Test 2

All teams recognized that short-answer grading (Test 1) and architecture case study evaluation (Test 2) require fundamentally different AI approaches. Test 1 has narrower answer ranges and more objective correctness criteria. Test 2 involves nuanced, multi-dimensional evaluation of complex artifacts.

Teams uniformly predicted higher AI automation rates for Test 1 (50-80% automation) and lower rates for Test 2 (30-50%), reflecting the genuine difficulty gap.

### 3. Content Generation as a Secondary Use Case

Beyond grading automation, the teams identified AI-assisted generation of new exam questions and case studies as a valuable secondary use case. **ZAITects** dedicated a full use case to this (ADR-004), using web search combined with RAG to ingest the latest architecture techniques and generate new questions on demand. **Litmus** covered it in ADR-07. Recognizing content generation as a high-value, lower-risk application of AI -- compared to the high-stakes grading pipeline -- was a common thread.

### 4. Human-in-the-Loop as Non-Negotiable

No team proposed fully autonomous AI grading. The high-stakes nature of the domain -- where a wrong grade can affect someone's career -- made human oversight universal. The variation was in degree: **Software Architecture Guild** took the strongest stance (ADR-3: "AI/ML will only function as an assistant, never as a fully automated decision-maker"), while ZAITects and Litmus allowed AI to auto-finalize high-confidence grades with spot-check validation.

## Unique Innovations Worth Highlighting

### ZAITects: Anti-Pattern Analysis of Agentic AI

ZAITects' deliberate rejection of Agentic AI was both technically sound and pedagogically valuable. While agentic approaches are increasingly popular, the team argued that Certifiable Inc.'s grading workflows are "structured, predictable steps where deterministic AI models are more efficient and reliable." They acknowledged that agentic patterns would be suitable for the analytics use case (identifying candidate performance trends) but inappropriate for the high-accuracy, low-error-tolerance grading pipeline. This nuanced, context-specific evaluation of when not to use a trendy pattern is exactly the kind of thinking the kata is designed to surface.

### Software Architecture Guild: Six Parallel AI Solutions via Microkernel

Rather than committing to a single AI approach, the Guild proposed running six distinct solutions simultaneously:
- **Solution 1a** (Text Search) -- Full-text search against historical graded answers
- **Solution 1b** (RAG) -- Retrieval-augmented generation with vector embeddings
- **Solution 2** (In-Context Learning) -- Few-shot examples provided directly in prompts
- **Solution 3a** (Direct Prompting) -- Structured prompts with grading criteria
- **Solution 3b** (Automatic Prompt Optimization) -- ML-optimized prompts
- **Solution 4** (LLM-Powered Structured Parsing) -- Parsing submissions into structured formats before evaluation

The microkernel architecture makes this practical: each solution is a plug-in that can be independently deployed, tested, and replaced. This is perhaps the most architecturally sophisticated response to the inherent uncertainty of AI system performance.

### Software Architecture Guild: Expert Compensation Reform (ADR-2)

This was the only submission to address the human incentive problem. The hourly pay model means experts have no financial motivation to adopt AI-assisted tools. The proposed per-evaluation model, with worked examples showing both higher expert earnings and lower company costs, demonstrated systems thinking beyond the technical architecture. This decision directly influenced the viability of their "AI as assistant" approach -- if experts are not incentivized to use the assistant, the architecture fails regardless of its technical merits.

### Litmus: Event Storming as Discovery Method

Litmus was the only team to use **Event Storming** as a formal domain discovery method before designing AI components. This process-first approach helped them identify domain boundaries, interactions, and the specific points where AI integration would have the highest impact. It also grounded their architecture in observed workflows rather than assumed ones -- a methodological distinction that likely contributed to their second-place finish.

## Lessons for Practitioners

### 1. In High-Stakes AI Integration, What You Reject Matters as Much as What You Build

The top teams earned differentiation not just through novel features but through disciplined exclusion. ZAITects' rejection of Agentic AI and Litmus' rejection of AI anti-cheating and LLM caching were each accompanied by rigorous rationale. For practitioners: document your rejected alternatives with the same rigor as your accepted decisions. It demonstrates architectural maturity and helps future teams understand the trade-off landscape.

### 2. AI System Architecture Requires a Production Operations Story

A consistent theme across all three placing teams was operational depth. ZAITects' coverage of security (OWASP), observability (Langwatch), guardrails, governance, fitness functions, and phased rollout was decisive. Litmus' hands-on prompt engineering simulations and RAG experiments grounded their design in evidence. Software Architecture Guild's Rozanski-Woods feasibility perspectives ensured systematic evaluation. For practitioners integrating AI into existing systems: the AI model is maybe 30% of the work. The remaining 70% is monitoring, evaluation, security, governance, rollback mechanisms, and phased adoption.

### 3. Separate the Grader from the Judge

ZAITects' architectural separation of the Grader (evaluates submissions) and Judge (validates grading quality) is a pattern worth adopting broadly. It enables: independent testing of each component, different iteration cycles, different model choices for each concern, and a clear audit trail. This maps to the emerging "LLM-as-a-Judge" pattern in the broader AI engineering community.

### 4. Consider the Incentive Architecture, Not Just the Technical Architecture

Software Architecture Guild's ADR-2 on expert compensation reform was a unique insight. AI-assisted workflows fail if the humans in the loop have no incentive to use them. Hourly pay actively discourages efficiency gains from AI adoption. For practitioners: when introducing AI into human workflows, map the incentive structures first. A per-outcome compensation model aligned with AI-assisted efficiency can be the difference between adoption and resistance.

### 5. The RAG Decision Is Context-Dependent

The three placing teams took notably different stances on RAG: ZAITects used it as a core grading component, Litmus employed it as part of an ensemble approach for Test 2, and Software Architecture Guild offered it as one of six parallel AI solutions. This spectrum illustrates that RAG is not a universal solution for AI grading. Practitioners should evaluate whether their domain rewards conformity to known patterns (RAG-friendly) or rewards novel approaches (where RAG may introduce bias toward historically accepted answers).

### 6. Design for AI Uncertainty with Architectural Flexibility

Software Architecture Guild's microkernel approach -- running six AI solutions in parallel as swappable plug-ins -- is perhaps the most forward-looking architectural pattern in these submissions. AI capabilities are evolving rapidly. An architecture that commits to a single AI approach risks obsolescence. An architecture that treats AI solutions as replaceable modules can adapt to new models, techniques, and capabilities without structural changes. The Guild's ADR-1 principle ("Multiple AI/ML solutions must be developed in parallel") should be a default principle for any AI-integrated system architecture.

### 7. Feasibility Analysis Is Table Stakes for AI Katas

Every placing team included substantive feasibility analysis -- whether through detailed cost projections (ZAITects), multi-dimensional impact assessment (Litmus), or systematic architectural perspectives (Software Architecture Guild). For AI-focused architecture katas, demonstrating that the proposed system is financially and operationally viable is not optional -- it is a prerequisite for credibility.

---

*Analysis based on submissions to the O'Reilly Architecture Katas, Winter 2025 season. All team materials are available in their respective repository directories.*
