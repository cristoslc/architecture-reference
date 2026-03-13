# Feasibility & Cost Analysis Guide: The Strongest Predictor of Kata Success

## Why This Matters Most

Feasibility analysis is the single strongest predictor of placement in O'Reilly Architecture Katas. The data shows that **50% of top-2 finishing teams** include substantive feasibility or cost analysis, compared to only **11% of runners-up**. No other factor -- not ADRs, not C4 diagrams, not event storming -- correlates as strongly with winning.

Why? Because feasibility analysis forces teams to move from abstract boxes-and-arrows to concrete, defensible claims. Judges can tell immediately whether a team has actually thought through whether their architecture can be built, operated, and paid for. It transforms an architecture proposal from "this could work" to "here is evidence that this will work."

This guide extracts the best frameworks from teams that did this well, organized as reusable templates.

---

## Types of Feasibility Analysis Observed

### 1. Infrastructure Cost Estimation (Three-Scenario Model)

**Exemplar: ArchColider (1st Place, Fall 2020)**

ArchColider's cost analysis for Farmacy Food is the gold standard in kata submissions. They modeled three growth scenarios with line-item AWS pricing for every service, then summarized the annual total cost of ownership (TCO) across all three:

**The Three Scenarios:**

| Scenario | Daily Requests | Monthly Requests | Label |
|----------|---------------|-----------------|-------|
| MIN | 500 | 15,000 | Conservative / survival mode |
| PROJECTED | 1,000 | 31,000 | Expected growth trajectory |
| RAPID | 10,000 | 310,000 | Aggressive / best-case growth |

**Summary Table (1-Year TCO):**

| Service | MIN | PROJECTED | RAPID |
|---------|-----|-----------|-------|
| EC2 (8-16 instances) | $3,114.96 | $3,114.96 | $6,230.04 |
| Amazon MQ | $508.32 | $546.72 | $1,203.36 |
| Amazon S3 | $262.32 | $524.52 | $5,245.20 |
| DynamoDB | $3,072.00 | $3,072.00 | $3,072.00 |
| Kafka Managed Streams | $138.72 | $138.72 | $138.72 |
| Tableau | $1,440.00 | $1,440.00 | $2,880.00 |
| DataDog | $3,336.00 | $3,336.00 | $3,336.00 |
| SNS | $366.12 | $366.12 | $366.12 |
| **TOTAL** | **$12,247.57** | **$12,548.17** | **$22,480.57** |

**Why this works:** Every line item shows the calculation formula (e.g., `8 instances x 0.0376 USD x 730 hours = 219.58 USD`). Judges can verify every number. The three scenarios acknowledge uncertainty without hand-waving.

**Key design principle from ArchColider:**
> "While selecting infrastructure and third party systems, we were governed preliminary by costs of the solution and limited budget of the client. In rare cases we decided to pick more expensive solutions -- the reason for that was convenience of chosen service to exceed its monetary value."

#### Template: Three-Scenario Cost Model

```
## Cost Analysis

### Estimation Basis
- All prices in USD, totaled per month, summarized per year
- Region: [AWS region and justification]
- Scenario MIN: [X] requests/day ([rationale])
- Scenario PROJECTED: [Y] requests/day ([rationale])
- Scenario RAPID: [Z] requests/day ([rationale])

### Service-by-Service Breakdown

#### [Service Name]
##### Scenario MIN
[quantity] x [unit price] x [time unit] = [total] USD
##### Scenario PROJECTED
[quantity] x [unit price] x [time unit] = [total] USD
##### Scenario RAPID
[quantity] x [unit price] x [time unit] = [total] USD

### Annual TCO Summary

| Service | 1-Year MIN | 1-Year PROJECTED | 1-Year RAPID |
|---------|-----------|-----------------|-------------|
| ... | ... | ... | ... |
| **TOTAL** | **$X** | **$Y** | **$Z** |
```

---

### 2. Data Volume & Payload Sizing

**Exemplars: ArchColider (1st, Fall 2020), It-Depends (Runner-up, Fall 2022)**

#### ArchColider: Bottom-Up Data Modeling

ArchColider built a spreadsheet (`Data&PayloadsEstimates.xlsx`) that calculated the byte-level size of every data type in their domain model:

| Entity | Fields | Size (bytes) |
|--------|--------|-------------|
| Meal | Id (guid, 16B) + Description (string, 2000B) + Nutrition (8 float pairs) + Ingredients (4000B) + Allergens (8B) | 6,200 |
| Order | order_id + user_id + meal_ids + time + source + promo_ids + type + state + feedback_id | 139 |
| Feedback | id + order_id + date + rating + description (4000B) | 4,043 |
| User | id + name + login + payment_info + type + preferences | 7,364 |

From these, they derived **database growth projections**:

| Records/Day | Records/Month | Storage Growth |
|------------|--------------|---------------|
| 500 | 15,000 | 1.98 GiB/month |
| 1,000 | 30,000 | 3.96 GiB/month |
| 5,000 | 150,000 | 19.80 GiB/month |
| 10,000 | 300,000 | 39.61 GiB/month |

And **traffic projections** per API call type, including image uploads:

- Make Order Request: 2,664 bytes per request -> at 1,000 requests/day = 71.1 MiB/month
- Review Order (with 4 MiB image): at 100 reviews/day = 11.2 GiB/month
- Total monthly traffic at projected growth: ~16.5 GiB (before compression)

> "This number is on the higher end of estimation because it assumes that the traffic to the application is distributed uniformly. In reality the proposed number could be even 60% smaller."

#### It-Depends: Top-Down Volumetric Analysis

It-Depends took a different approach for the HeyBlue app, starting from population-level assumptions and working down to transactions per second:

**Assumptions:**
- 700,000 officers in the USA (with 5-year growth)
- ~10 million civilians (5% of adult population target)
- 300 active days per year, 16 effective hours per day

**Connection Manager Volume:**
- 1.2 billion connections expected per year
- Divided by 300 days x 16 hours x 3600 seconds
- Average: 70 TPS, Peak: 140 TPS

**Notification Manager Volume:**
- 1 out of 20 notifications converts to a connection
- 1.2B x 20 = 24 billion notifications/year
- Average: 1,400/sec, Peak: 2,800/sec

**Geographic Info System Volume:**
- 10.7 million users x location refresh every 5 minutes x 4 hours/day
- 513.6 million location checks/year
- Average: 30 TPS, Peak: 60 TPS

#### Template: Data Volume Estimation

```
## Data Volume & Payload Analysis

### Entity Sizing
| Entity | Key Fields | Size per Record | Notes |
|--------|-----------|----------------|-------|
| [Entity A] | [field list with types] | [X] bytes | |
| [Entity B] | [field list with types] | [Y] bytes | |

### Database Growth Projection
| Scenario | Records/Day | Records/Month | Storage/Month |
|----------|-----------|--------------|--------------|
| MIN | | | GiB |
| PROJECTED | | | GiB |
| RAPID | | | GiB |

### API Traffic Projection
| Endpoint | Payload Size | Requests/Day | Bandwidth/Month |
|----------|-------------|-------------|----------------|
| [Endpoint A] | [X] bytes | [N] | [M] MiB |
| [Endpoint B] | [Y] bytes | [N] | [M] MiB |

### Peak Load Estimation
| Component | Average TPS | Peak TPS | Derivation |
|-----------|------------|---------|-----------|
| [Component A] | | | [formula from user counts] |
```

---

### 3. Fitness Functions & Quantitative Validation

**Exemplar: BluzBrothers (1st Place, Winter 2024)**

BluzBrothers went beyond claiming their architecture would meet performance requirements -- they proved it with an end-to-end latency calculation for their patient monitoring system (StayHealthy).

**Infrastructure Sizing:**

Throughput per patient (7 sensor types):

| Sensor | Signals/Second |
|--------|---------------|
| Heart rate | 2 |
| Blood pressure | 0.000278 |
| Oxygen level | 0.2 |
| Blood sugar | 0.00833 |
| Respiration | 1 |
| ECG | 1 |
| Body temperature | 0.00333 |
| Sleep status | 0.00833 |
| **Total** | **4.22** |

With 500 patients max, assuming 1kB per signal:
- **Average throughput:** 4.2 x 500 = 2,100 req/s = 2.1 MB/s
- **Peak throughput:** 8 x 500 = 4,000 req/s = 4 MB/s

**End-to-End Latency Proof:**

They then validated each step against real-world benchmarks:

| Step | Technology | Benchmark Source | Time |
|------|-----------|-----------------|------|
| Vital Sign Recorder | 3 instances, 20 patients each | 160 signals/sec x 2ms each | 320ms |
| Vital Sign Streamer | 3 instances, same math | Same calculation | 320ms |
| Save to DB | InfluxDB | Medium.com benchmark: 237,871 events/s | 16ms |
| Publish to Kafka | Apache Kafka on m5.xlarge | AWS benchmark for 4MB/s | 5ms |
| LAN Transfer | 1Gb/s hospital LAN | 4MB / 1Gbps | 32ms |
| **Total** | | | **693ms** |

This proves the system meets its performance requirements with margin to spare. Each step cites an external benchmark, not just an assumption.

#### Template: Quantitative Validation / Fitness Function

```
## Performance Fitness Function: [Name]

### Requirement
[Target metric, e.g., "Sensor data must reach nurse station within 1 second"]

### Throughput Calculation
| Input | Value | Derivation |
|-------|-------|-----------|
| Users/devices | [N] | [source of number] |
| Events per user per second | [X] | [breakdown by type] |
| Payload size | [Y] KB | [measured/estimated] |
| **Total throughput** | [Z] req/s / [W] MB/s | |

### Latency Budget
| Step | Component | Benchmark Source | Budget |
|------|-----------|-----------------|--------|
| 1 | [Component] | [URL or citation] | [X]ms |
| 2 | [Component] | [URL or citation] | [Y]ms |
| N | [Component] | [URL or citation] | [Z]ms |
| **Total** | | | **[sum]ms** |

### Conclusion
[Total] < [Requirement], with [margin]% headroom.
```

---

### 4. AI/LLM Cost Projection

**Exemplar: ZAITects (1st Place, Winter 2025)**

ZAITects designed an AI-powered certification grading system and produced a detailed cost comparison between manual and AI-assisted evaluation. This is the template for any kata involving AI or LLM components.

**Manual Baseline (200 candidates/week):**
- Test 1 (short answers): 200 candidates x 3 hrs each = 600 hours
- Test 2 (case studies): 200 x 0.8 pass rate x 8 hrs each = 1,280 hours
- Total: 1,880 hours at $50/hr = **$94,000/week ($470/candidate)**

**AI-Assisted Model (with 20% human review factor):**

| Scaling Factor | Candidates/Week | Expert Review Cost | LLM Cost | Total Cost | Cost/Candidate |
|---------------|----------------|-------------------|----------|-----------|---------------|
| 5x | 1,000 | $94,550 | $1,350 | $95,900 | **$95.90** |
| 10x | 2,000 | $188,000 | $2,700 | $190,700 | **$95.35** |

**LLM Cost Formula:**
```
LLM cost = Num_LLM_calls_per_candidate x Num_candidates x
           (Input_tokens x Cost_per_input_token + Output_tokens x Cost_per_output_token)
```

**Example (Test 2, 5x scaling):**
```
10 calls x 1,000 candidates x 0.8 x (2000 x $0.000015 + 2000 x $0.00006) = $1,200
```

**Key finding:** AI-assisted grading is **~5x cheaper** ($95 vs $470 per candidate) and **~5x faster** (1.88 hrs vs 9.4 hrs per candidate). Even at 10x scale, LLM token costs remain under $3,000/week while expert costs exceed $188,000/week.

ZAITects also defined a **Cost fitness function**: a metric that compares AI grading cash burn rate versus revenue generated, scored 0-1 where 1 indicates the AI approach is cost-effective versus manual.

#### Template: AI/LLM Cost Projection

```
## AI/LLM Cost Analysis

### Manual Baseline
| Task | Volume | Time per Item | Total Hours | Cost at $[X]/hr | Cost/Unit |
|------|--------|-------------|-------------|-----------------|-----------|
| [Task A] | [N] | [T] hrs | [N*T] | $[total] | $[per unit] |

### LLM Cost Model
Cost = Calls_per_item x Items x (Input_tokens x $/input + Output_tokens x $/output)

| Task | Calls/Item | Input Tokens | Output Tokens | Model | Cost/Item |
|------|-----------|-------------|--------------|-------|-----------|
| [Task A] | [N] | [X] | [Y] | [model name] | $[Z] |

### Human-in-the-Loop Factor
- Assumed review rate: [X]% of submissions require expert review
- Expert review cost: [remaining expert hours x rate]

### Total Cost Comparison
| Approach | Volume | Expert Cost | AI Cost | Total | Per Unit |
|----------|--------|-----------|---------|-------|---------|
| Manual | [N] | $[X] | $0 | $[X] | $[X/N] |
| AI-Assisted | [N] | $[Y] | $[Z] | $[Y+Z] | $[(Y+Z)/N] |
| **Savings** | | | | **[X-(Y+Z)]** | **[X%] reduction** |
```

---

### 5. Per-User Cost of Ownership

**Exemplar: Global-Variables (3rd Place, Spring 2022)**

Global-Variables produced the most detailed per-user cost analysis observed in kata submissions. For their Spotlight App platform (a non-profit tech hub), they broke TCO into three categories:

**1. Infrastructure Cost Per User:**
- Minimum footprint (< 10 users): **under $100 USD/month**
- Per-user scaling cost: **< $0.01/month** (typical) to **< $0.002/month** (optimized)
- Maximum scenario (rich data, heavy interaction): **< $0.10/month/user**

Their calculation assumptions:
- Standard user session: under 20 screens/pages
- Average page size with caching: 160KB or less
- Average sessions: 2 per month per user

**2. Operational Costs:**
They noted that serverless architecture shifts the cost from "updating OS/servers/platform" to "updating application core libraries." Emergency incidents are rare but expensive:
> "A solution architect can run over $110 USD per hour, and that can easily double or triple for an emergency call."

**3. Security Update Costs:**
Ongoing library updates for the frontend, which they argued are "costs that are borne regardless of the architecture."

**Why this matters:** For non-profit katas (a recurring theme), demonstrating that per-user costs stay below a threshold is often more convincing than a raw infrastructure total. Global-Variables also connected their serverless architecture choice directly to cost:
> "Idle time running cost will trend downward as compared to peak. Scaling costs are reduced -- no need to prepare infrastructure for estimated peak-load."

#### Template: Per-User Cost of Ownership

```
## Per-User Cost Model

### Assumptions
- Target user base: [N] users
- Average sessions per user per month: [X]
- Average pages per session: [Y]
- Average page payload (cached): [Z] KB

### Infrastructure Cost
| User Tier | Monthly Infra Cost | Per-User/Month |
|-----------|-------------------|---------------|
| < [N1] users | $[X] | $[X/N1] |
| [N1]-[N2] users | $[Y] | $[Y/N] |
| [N2]+ users | $[Z] | $[Z/N] |

### Total Cost of Ownership Breakdown
| Category | Monthly Cost | Notes |
|----------|-------------|-------|
| Infrastructure (cloud) | $[X] | [pricing model] |
| Operational (people) | $[Y] | [FTE or contractor hours] |
| Maintenance (security/updates) | $[Z] | [frequency and effort] |
| **Total** | **$[sum]** | |
| **Per user** | **$[sum/users]** | |
```

---

### 6. Vendor Research & Real-World Pricing

**Exemplar: Jaikaturi (Runner-up, Fall 2020)**

Jaikaturi did something no other observed team attempted: they **picked up the phone and called a vendor**. For their Farmacy Food architecture, they needed to integrate with ChefTec (restaurant inventory management) but found no public API documentation.

From their README:
> "To mitigate those risks, we called ChefTec in the number they have for Consultancy Services. We wanted to better understand what it takes to integrate with that system. They were very helpful."

**Key findings from the call:**
- A pre-existing integration (e.g., QuickBooks) could be done "very quickly and with relatively low cost (~$500)"
- A completely custom integration: "$5k+", potentially 60+ days, requiring work on both sides
- "Everyone in the 'inventory game' (industry), for some unknown reason, doesn't provide APIs"

**Other vendor pricing captured by Jaikaturi:**
- ChefTec Basic: several thousand dollars for off-the-shelf solutions
- Smart Fridge setup: average $7,000 per location (vs. $500,000-$1M for a restaurant)
- Meal unit economics: $12 revenue vs. $4.25 cost to produce/package/distribute

**Why this works:** Calling a vendor takes 15 minutes and transforms a risk assumption into a validated data point. It demonstrates initiative and grounds the architecture in reality rather than speculation.

#### Template: Vendor Research

```
## Vendor Research & Integration Pricing

### Vendor: [Name]
- **Product:** [what it does]
- **Public API availability:** [Yes/No/Limited]
- **Research method:** [Called sales, emailed support, checked docs, used pricing calculator]
- **Key findings:**
  - Standard integration cost: $[X]
  - Custom integration cost: $[Y]
  - Timeline: [Z] days/weeks
  - Contract model: [per-seat, per-transaction, flat fee]
- **Risk assessment:** [High/Medium/Low] -- [explanation]

### Vendor Comparison Matrix
| Vendor | Capability | Cost | Integration Effort | Lock-in Risk |
|--------|-----------|------|-------------------|-------------|
| [A] | [desc] | $[X]/mo | [Low/Med/High] | [Low/Med/High] |
| [B] | [desc] | $[Y]/mo | [Low/Med/High] | [Low/Med/High] |
```

---

### 7. Quantitative Load Analysis with Architectural Quanta

**Exemplar: Street-Fighters (Runner-up, Fall 2023 External)**

Street-Fighters decomposed their Road Warrior travel app into 5 architectural quanta and performed load calculations for each one independently, deriving throughput from the stated requirements:

**System-Level Assumptions (from 2M weekly active users, 15M total):**
- 80% of users interact within a 4-hour working-day window
- 1.6M users in 72,000 seconds = **~25 requests/sec** (user-facing)
- 5 reservations per active user, 2-week average trip = **5M reservations/week**
- 5 updates per reservation = **25M relevant events/week**
- Capturing 5% of market means processing 20x that: **500M update events/week = ~1,000 req/s**
- Email parsing (30% opt-in, 100 emails/user/day): **150M emails/day = ~4,000 req/s**

Each quantum was then assigned its own architectural style based on its specific load characteristics:
- **Email Receiver**: Hybrid microservices + event-driven (highest throughput at 4,000 req/s)
- **Travel Updates Receiver**: Event-driven (1,000 req/s external events)
- **Reservation Orchestrator**: Hybrid with CQRS (write-heavy updates, read-heavy dashboard)
- **User Agent**: Microservices (lower throughput, but strict latency SLOs of 800ms web / 1.4s mobile)
- **Analytics Capture**: Event-driven with OLAP (batch processing, lower real-time requirements)

---

## Template: Minimum Viable Feasibility Analysis

This is the absolute minimum a kata team should produce. It takes 1-2 hours and dramatically improves placement odds.

```
# Feasibility Analysis for [System Name]

## 1. Scale Assumptions
- Target users: [N] (Year 1), [M] (Year 3)
- Active users at peak: [X]
- Requests per user per session: [Y]
- Peak concurrent users: [Z]
- Peak requests per second: [calculated]

## 2. Data Volume Estimate
- Records created per day: [N]
- Average record size: [X] bytes
- Monthly storage growth: [calculated] GiB
- Annual storage: [calculated] GiB
- Image/file storage: [if applicable]

## 3. Infrastructure Cost Estimate (Annual)
| Component | Service | Monthly Cost | Annual Cost | Notes |
|-----------|---------|-------------|------------|-------|
| Compute | [e.g., AWS Lambda / EC2] | $[X] | $[12X] | [sizing rationale] |
| Database | [e.g., DynamoDB / RDS] | $[X] | $[12X] | [storage + IOPS] |
| Storage | [e.g., S3] | $[X] | $[12X] | [based on volume est] |
| Messaging | [e.g., SQS / Kafka] | $[X] | $[12X] | |
| Monitoring | [e.g., CloudWatch] | $[X] | $[12X] | |
| CDN | [e.g., CloudFront] | $[X] | $[12X] | |
| Auth | [e.g., Cognito] | $[X] | $[12X] | |
| **TOTAL** | | **$[sum]** | **$[12*sum]** | |

## 4. Key Validation
- Can [database] handle [peak writes/sec]? [cite benchmark]
- Can [compute] handle [peak requests/sec]? [cite benchmark or sizing]
- Is annual cost within [client budget]? [Yes/No, with justification]

## 5. Risks to Feasibility
| Risk | Impact | Mitigation |
|------|--------|-----------|
| [e.g., Traffic 10x higher than projected] | [cost increase to $X] | [auto-scaling, reserved instances] |
| [e.g., Vendor API unavailable] | [feature gap] | [fallback approach] |
```

---

## Common Feasibility Mistakes

Based on patterns observed across dozens of kata submissions:

**1. No numbers at all.**
The most common failure. Teams draw beautiful C4 diagrams but never estimate whether their architecture can actually handle the stated load or fit within a budget. This is the single biggest differentiator between winners and runners-up.

**2. Overly optimistic estimates.**
Assuming best-case throughput without accounting for peak load, retry storms, or seasonal variation. ArchColider mitigated this by explicitly noting their estimates assumed uniform traffic distribution and could be "60% smaller" in practice -- but they budgeted for the higher number.

**3. Missing operational costs.**
Infrastructure is only part of TCO. Global-Variables explicitly called out that a cloud architect "can run over $110 USD per hour" for incident response. Teams that only list compute costs miss monitoring, observability (DataDog alone was $3,336/year in ArchColider's estimate), alerting, and maintenance labor.

**4. Ignoring the cost of observability.**
ArchColider's cost analysis reveals that DataDog ($3,336/year) and Tableau ($1,440-$2,880/year) together can exceed compute costs. Monitoring is not free, especially for startups.

**5. Hand-waving about AI costs.**
For AI-heavy katas, teams often say "we'll use an LLM" without estimating token costs. ZAITects showed the formula: calls x tokens x price-per-token, and demonstrated that even at 10x scale, LLM costs stay manageable ($2,700/week) while expert costs explode ($188,000/week).

**6. Not citing external benchmarks.**
BluzBrothers cited specific InfluxDB benchmarks (237,871 events/s) and AWS Kafka benchmarks to validate their throughput claims. Unsourced claims like "the database can handle it" carry no weight with judges.

**7. Treating the architecture as free to change.**
DevExperts correctly noted that choosing AWS as their cloud provider is a "one-way decision which is very difficult to change afterwards." Cost analysis should acknowledge lock-in costs and migration risks.

**8. Ignoring the non-profit / startup budget reality.**
Multiple winning teams (Global-Variables, It-Depends, DevExperts, Jaikaturi) explicitly connected their architecture choices to budget constraints. DevExperts estimated ClearView at **$8,448/year** total -- an extremely lean budget that justified every serverless choice they made.

---

## Recommended Tools and Approaches

### Cloud Pricing Calculators
- **AWS Pricing Calculator**: https://calculator.aws/ -- DevExperts linked directly to their estimate: `calculator.aws/#/estimate?id=8927b6f191aa0c4a2b0410a4508aa278014eabb8`
- **Azure Pricing Calculator**: https://azure.microsoft.com/pricing/calculator/
- **GCP Pricing Calculator**: https://cloud.google.com/products/calculator

### Quick Estimation Heuristics
- **Storage**: S3 at ~$0.023/GB/month; DynamoDB at ~$0.25/GB/month; RDS varies by instance
- **Compute**: Lambda at ~$0.20 per 1M requests + duration; EC2 t3.small at ~$0.02/hour
- **Data transfer**: First 1 GB free; then ~$0.09/GB outbound (AWS)
- **Messaging**: SQS at ~$0.40 per 1M requests; Kafka managed at ~$0.015/shard-hour
- **LLM tokens**: GPT-4o-mini ~$0.15/$0.60 per 1M tokens (input/output); Claude 3.5 Sonnet similar range

### The "Back of Envelope" Method
1. Start with user count and activity frequency
2. Derive requests per second (average and peak)
3. Estimate payload sizes per request type
4. Multiply out monthly storage and bandwidth
5. Map to cloud services using pricing calculators
6. Add 20-30% buffer for overhead, retries, and monitoring

### Validation Approach
- For databases: search "[database name] benchmark throughput" and cite the result
- For message brokers: check vendor documentation for published throughput per node
- For networks: calculate from bandwidth (e.g., 4MB over 1Gbps LAN = 32ms)
- For serverless: check cold start latency and concurrency limits
- For vendor integrations: **call the vendor** (Jaikaturi method -- 15 minutes, high-impact)

---

## Source Teams Reference

| Team | Placement | Kata | Key Contribution |
|------|-----------|------|-----------------|
| ArchColider | 1st, Fall 2020 | Farmacy Food | Three-scenario cost model, payload sizing spreadsheet |
| BluzBrothers | 1st, Winter 2024 | StayHealthy | End-to-end latency fitness function with benchmarks |
| ZAITects | 1st, Winter 2025 | Certification AI | AI cost projection, manual-vs-AI comparison |
| Global-Variables | 3rd, Spring 2022 | Spotlight App | Per-user cost of ownership, serverless TCO |
| Jaikaturi | Runner-up, Fall 2020 | Farmacy Food | Vendor phone call research (ChefTec), unit economics |
| It-Depends | Runner-up, Fall 2022 | HeyBlue | Population-to-TPS volumetric analysis |
| Street-Fighters | Runner-up, Fall 2023 | Road Warrior | Per-quantum load analysis from requirements |
| DevExperts | Runner-up, Fall 2024 | ClearView | $8,448/year lean estimate with AWS Calculator link |
