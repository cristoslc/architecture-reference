# 🏗 Architecture Decision Records (ADRs) - Scalable Microservices Architecture

## **ADR-009: Migration to Microservices Architecture**

### 📅 Date: 2025-02-16
### 🎯 Status: ✅ Approved

### **📌 Context**
The existing monolithic system at Certifiable Inc. is unable to scale effectively to handle a **5-10X increase in candidate volume**. The system suffers from **performance bottlenecks, slow test processing, and downtime risks** due to increased workloads.

### **💡 Decision**
We will migrate from a **monolithic architecture to a microservices-based architecture**, allowing for better **scalability, modularity, and resilience**. This will enable **independent scaling of components** such as authentication, test submission, grading, and notifications.

### **🛠 Technologies**
- **Microservices Framework:** Node.js, FastAPI, Spring Boot
- **Containerization & Orchestration:** Docker, Kubernetes (AKS/EKS)
- **API Gateway & Load Balancing:** Azure Front Door, AWS ALB, Nginx
- **Database Management:** PostgreSQL, Azure CosmosDB, AWS DynamoDB

### **🚀 Consequences**
✅ **High scalability** – Enables modular expansion based on demand.  
✅ **Improved fault isolation** – Failures in one service do not impact others.  
✅ **Faster deployments** – Independent service updates with CI/CD.  
❗ **Requires investment in API management & service orchestration.**

### **📌 Alternatives Considered**
1️⃣ **Retain Monolithic System** – Limited scalability & high downtime risks ❌  
2️⃣ **Hybrid Monolithic + Microservices** – Reduces risks but not fully scalable ❌  
3️⃣ **Full Microservices Migration (Chosen Approach)** – Best for future-proofing ✅

---

## **ADR-010: Adoption of Event-Driven Architecture for Asynchronous Processing**

### 📅 Date: 2025-02-16
### 🎯 Status: ✅ Approved

### **📌 Context**
The grading process and test submissions currently rely on **synchronous operations**, leading to **slow performance and bottlenecks** when candidate volume spikes. A **more scalable approach** is needed for **handling test processing asynchronously** without affecting system performance.

### **💡 Decision**
We will implement an **Event-Driven Architecture (EDA)** using **Kafka / Azure Event Grid / AWS SQS** to decouple services and allow **asynchronous task processing** for test submissions, grading, and notifications.

### **🛠 Technologies**
- **Event Streaming:** Apache Kafka, Azure Event Grid, AWS SQS
- **Task Processing:** Celery, AWS Lambda, Azure Functions
- **Message Queueing:** RabbitMQ, Redis Streams

### **🚀 Consequences**
✅ **Faster system response times** – Decouples front-end interactions from backend processing.  
✅ **Better resource utilization** – Services scale independently based on demand.  
✅ **Improved fault tolerance** – Failed tasks can be retried asynchronously.  
❗ **Requires event monitoring & debugging tools for observability.**

### **📌 Alternatives Considered**
1️⃣ **Synchronous API Calls** – Slows down processing, poor user experience ❌  
2️⃣ **Basic Background Jobs** – Works but lacks robust scaling ❌  
3️⃣ **Event-Driven Architecture (Chosen Approach)** – Best for scalability & performance ✅

---

## **ADR-011: Implementation of Kubernetes-Based Auto-Scaling**

### 📅 Date: 2025-02-16
### 🎯 Status: ✅ Approved

### **📌 Context**
With a rapidly growing user base, the system must handle unpredictable workloads efficiently. **Manually scaling infrastructure** is inefficient and **may lead to downtime or excessive costs** during peak usage.

### **💡 Decision**
We will implement **Kubernetes Horizontal Pod Autoscaling (HPA) and Cluster Autoscaler** to dynamically **scale services based on CPU, memory, and queue length**. This ensures **optimal resource allocation** during high-traffic periods.

### **🛠 Technologies**
- **Container Orchestration:** Kubernetes (AKS/EKS)
- **Autoscaling:** Kubernetes HPA, AWS Auto Scaling Groups
- **Load Balancing:** Nginx, Azure Front Door, AWS ALB
- **Infrastructure as Code (IaC):** Terraform, Helm Charts

### **🚀 Consequences**
✅ **Improved system resilience** – Auto-scales services without downtime.  
✅ **Cost-efficient resource utilization** – Allocates resources dynamically.  
✅ **Handles high traffic surges effectively.**  
❗ **Complex monitoring setup required to fine-tune scaling policies.**

### **📌 Alternatives Considered**
1️⃣ **Static Server Provisioning** – Inefficient for handling peak loads ❌  
2️⃣ **Manual Scaling** – Time-consuming & prone to errors ❌  
3️⃣ **Kubernetes Auto-Scaling (Chosen Approach)** – Best for cost & performance ✅

---

## 🔥 **Final Thoughts**
These **ADRs document the key technical decisions** that ensure **Certifiable Inc.'s certification system remains scalable, efficient, and secure**. 🚀
