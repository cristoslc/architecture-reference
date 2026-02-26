# 🏗 Architecture Decision Records (ADRs) for User Authentication Flow

## **ADR-001: OAuth 2.0 + JWT for User Authentication**

### **📅 Date:** 19th Feb 2025
### **🎯 Status:** ✅ Approved

### **📌 Context**
The system requires a **secure authentication mechanism** for candidates, admins, and hiring companies to:
- ✅ Securely authenticate users.
- ✅ Provide access tokens to microservices.
- ✅ Support role-based access control (RBAC).
- ✅ Integrate with cloud-based authentication (Azure AD).

The decision was to **adopt OAuth 2.0 + JWT (JSON Web Tokens)** for all microservices.

### **💡 Decision**
- ✅ Use **OAuth 2.0 with OpenID Connect (OIDC)** for authentication.
- ✅ Generate **JWT Access Tokens** with a 15-minute expiry.
- ✅ Use **Refresh Tokens** with a 24-hour expiry.
- ✅ Implement Role-Based Access Control (RBAC).

### **💥 Trade-offs Considered**
| Option        | Pros                                                                 | Cons                                                                 |
|---------------|----------------------------------------------------------------------|-----------------------------------------------------------------------|
| ✅ OAuth 2.0 + JWT (Selected) | High scalability, stateless architecture.           | Short-lived tokens need continuous refreshing.                      |
| Session-Based Auth | Easy to manage.                                                   | Breaks microservices stateless design, doesn't scale well.            |
| API Keys     | Simple for public APIs.                                              | No user authentication, vulnerable to key leakage.                   |

### **🚀 Consequences**
- ✅ Microservices will now verify JWT tokens without storing sessions.
- ✅ Tokens can be securely passed through the API Gateway.
- ✅ High scalability with stateless token architecture.

### **💭 Why Did We Reject Other Options?**
- ❌ **Session-Based Auth**: Would require centralized session management, limiting scalability.
- ❌ **API Keys**: Does not provide user-level authentication, which is critical.

### **✅ Final Choice:** OAuth 2.0 + JWT (with refresh tokens).

---

## **ADR-002: API Gateway Selection (Kong vs. Azure API Gateway vs. Nginx)**

### **📅 Date:** 19th Feb 2025
### **🎯 Status:** ✅ Approved

### **📌 Context**
The architecture requires an **API Gateway** to:
- ✅ Handle authentication.
- ✅ Route traffic to microservices.
- ✅ Enforce rate limiting.
- ✅ Improve security.

We compared **three options**: Kong Gateway, Azure API Gateway, and Nginx.

### **💡 Decision**
- ✅ Use **Kong API Gateway** for:
    - ✅ Rate limiting.
    - ✅ JWT token verification.
    - ✅ Load balancing.

### **💥 Trade-offs Considered**
| Option                | Pros                                                                 | Cons                                                                 |
|---------------------|-----------------------------------------------------------------------|-----------------------------------------------------------------------|
| ✅ Kong API Gateway  | Open-source, high performance, native JWT verification.              | Slightly higher learning curve.                                      |
| Azure API Gateway   | Fully managed, native Azure integration.                             | Higher operational costs.                                            |
| Nginx Gateway       | Lightweight, simple to use.                                           | Lacks built-in JWT token verification.                              |

### **🚀 Consequences**
- ✅ Lower infrastructure costs.
- ✅ High scalability with minimal latency.
- ✅ Full support for JWT authentication.

### **💭 Why Did We Reject Other Options?**
- ❌ **Azure API Gateway**: Adds unnecessary cost without significant added value.
- ❌ **Nginx**: Does not natively support JWT verification.

### **✅ Final Choice:** Kong API Gateway.

---

## **ADR-003: Token Storage Mechanism (Redis vs. Keycloak vs. Database)**

### **📅 Date:** 19th Feb 2025
### **🎯 Status:** ✅ Approved

### **📌 Context**
The system requires a storage mechanism for:
- ✅ Access Tokens.
- ✅ Refresh Tokens.
- ✅ User session tracking.

We evaluated **three options**: Redis, Keycloak, and traditional database.

### **💡 Decision**
- ✅ Use **Redis Cache** for:
    - ✅ Fast token lookups.
    - ✅ Session caching.
    - ✅ Token expiry management.

### **💥 Trade-offs Considered**
| Option                | Pros                                                                 | Cons                                                                 |
|---------------------|-----------------------------------------------------------------------|-----------------------------------------------------------------------|
| ✅ Redis Cache      | Ultra-fast token lookups, scalable, auto-expiry.                     | Slightly higher infrastructure cost.                                 |
| Keycloak            | Built-in user management, no custom development.                    | Heavy dependency, complex setup.                                      |
| PostgreSQL          | Simple to use, widely adopted.                                        | Slow token lookup, prone to downtime.                                |

### **🚀 Consequences**
- ✅ Fast authentication response times.
- ✅ Stateless architecture maintained.
- ✅ Low infrastructure footprint.

### **💭 Why Did We Reject Other Options?**
- ❌ **Keycloak**: Introduces unnecessary complexity.
- ❌ **PostgreSQL**: Will cause token lookup delays.

### **✅ Final Choice:** Redis Cache.

---

## **ADR-004: Cloud Platform Selection (Azure vs. AWS vs. GCP)**

### **📅 Date:** 19th Feb 2025
### **🎯 Status:** ✅ Approved

### **📌 Context**
We needed a cloud platform that:
- ✅ Supports AI (GPT-4, OpenAI).
- ✅ Offers managed Kubernetes services.
- ✅ Integrates well with enterprise identity providers.

We evaluated **three platforms**: Azure, AWS, and GCP.

### **💡 Decision**
- ✅ Use **Azure Cloud** for:
    - ✅ Seamless integration with Azure AD.
    - ✅ Native AI services like Azure OpenAI.
    - ✅ Lower operational complexity.

### **💥 Trade-offs Considered**
| Option                | Pros                                                                 | Cons                                                                 |
|---------------------|-----------------------------------------------------------------------|-----------------------------------------------------------------------|
| ✅ Azure Cloud      | Native integration with OpenAI & Azure AD.                          | Slightly higher pricing.                                             |
| AWS Cloud           | Highly scalable, global availability.                               | Requires complex IAM management.                                      |
| Google Cloud        | Excellent AI support.                                                | No enterprise-grade identity integration.                           |

### **🚀 Consequences**
- ✅ Full native integration with Azure OpenAI.
- ✅ Reduced infrastructure complexity.
- ✅ Easy identity management via Azure AD.

### **💭 Why Did We Reject Other Options?**
- ❌ **AWS**: Would require complex infrastructure setup.
- ❌ **GCP**: Lacks deep integration with enterprise identity providers.

### **✅ Final Choice:** Azure Cloud.

---
<sub>*Added by Data Arch Evanglist Team For Winter 2025 Kata: Architecture & AI on 17th March 2025*</sub>