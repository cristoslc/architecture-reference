____________________________

# 🏗 Architecture Decision Records (ADR) - AI-Powered Certification Evaluation System

## **ADR-002: Selection of AI Model for Automated Grading**

### 📅 Date: 2025-02-16
### 🎯 Status: ✅ Accepted

### **📌 Context**
Manual grading of certification submissions is **slow, inconsistent, and unscalable**. To improve efficiency, **an AI-powered grading system** is needed to automate evaluations while ensuring **fairness and explainability**.

### **💡 Decision**
We will use **GPT-4** for analyzing text-based responses and **Graph Neural Networks (GNNs)** for evaluating architecture diagrams. The AI grading system will be supplemented with **human review for low-confidence cases**.

### **🛠 Technologies**
- **NLP Models:** GPT-4, Hugging Face Transformers (BERT, T5, RoBERTa)
- **Diagram Analysis:** YOLO/Detectron2 for architecture recognition
- **Model Hosting:** Azure OpenAI / AWS SageMaker

### **🚀 Consequences**
✅ Faster grading (~80-90% reduction in grading time)  
✅ Standardized and unbiased evaluations  
✅ Reduces expert workload by focusing on edge cases  
❗ Requires cloud hosting and periodic retraining

### **📌 Alternatives Considered**
1️⃣ **Fully Manual Grading** – Slow, costly, and not scalable ❌  
2️⃣ **Rule-Based AI** – Limited adaptability, hard to maintain ❌  
3️⃣ **Hybrid AI + Human Review (Chosen Approach)** – Best balance of speed and quality ✅

---