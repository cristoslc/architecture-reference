# 🏗 Architecture Decision Records (ADRs) - AI-Powered Candidate Experience

## **ADR-015: AI-Driven Grading for Faster Evaluation**

### 📅 Date: 2025-02-16
### 🎯 Status: ✅ Approved

### **📌 Context**
Manual grading for Test 2 (Architecture Submission) is **slow and resource-intensive**, causing delays and frustration for candidates. To enhance efficiency, **AI-driven grading** should be implemented to automate **80% of the grading process**.

### **💡 Decision**
Adopt an **AI-powered grading engine** using **NLP for textual responses** and **computer vision for architecture diagram analysis**.

### **🛠 Technologies**
- **AI Model:** OpenAI GPT-4, Hugging Face Transformers
- **Computer Vision:** YOLO, Detectron2
- **Processing Pipeline:** FastAPI, Python

### **🚀 Consequences**
✅ **Speeds up grading turnaround by 50-70%**  
✅ **Ensures structured & consistent grading**  
❗ **Requires continuous AI model fine-tuning for fairness**

### **📌 Alternatives Considered**
1️⃣ **Manual Grading Only** – Slow & inconsistent ❌  
2️⃣ **Hybrid AI + Human Review (Chosen Approach)** – Best balance of speed & accuracy ✅

---

## **ADR-016: Real-Time Candidate Support via AI Chatbot**

### 📅 Date: 2025-02-16
### 🎯 Status: ✅ Approved

### **📌 Context**
Candidates face **uncertainty about their test status and submission deadlines** due to lack of real-time support. This leads to **increased support tickets and candidate frustration**.

### **💡 Decision**
Deploy an **AI-driven chatbot** integrated with the grading system to provide **real-time updates, FAQs, and live expert escalation**.

### **🛠 Technologies**
- **Chatbot Framework:** Microsoft Bot Framework, Dialogflow
- **Live Support:** Twilio API, WebSockets
- **Database:** MongoDB for candidate interaction logs

### **🚀 Consequences**
✅ **Reduces support ticket volume by 40-60%**  
✅ **Enhances candidate experience with instant responses**  
❗ **Requires training & monitoring for chatbot accuracy**

### **📌 Alternatives Considered**
1️⃣ **Traditional Email Support** – Slow response times ❌  
2️⃣ **AI Chatbot + Live Expert Escalation (Chosen)** – Best balance of automation & human oversight ✅

---

## **ADR-017: Adaptive Deadline Extensions Using AI**

### 📅 Date: 2025-02-16
### 🎯 Status: ✅ Approved

### **📌 Context**
Strict deadlines without flexibility discourage candidates who face **genuine challenges**. A **smart deadline extension system** is required to balance **fairness and certification standards**.

### **💡 Decision**
Implement an **AI-driven adaptive deadline system** that evaluates candidate performance and automatically adjusts deadlines in **exceptional cases**.

### **🛠 Technologies**
- **Machine Learning Model:** Adaptive Learning Algorithm
- **Backend Service:** FastAPI, Python
- **Database:** PostgreSQL, Redis for real-time storage

### **🚀 Consequences**
✅ **Provides fairness while maintaining certification integrity**  
✅ **Boosts candidate satisfaction & retention**  
❗ **Requires monitoring to prevent misuse**

### **📌 Alternatives Considered**
1️⃣ **Fixed Deadlines** – No flexibility, discourages candidates ❌  
2️⃣ **AI-Based Dynamic Extensions (Chosen Approach)** – Best for balancing fairness & standards ✅

---
