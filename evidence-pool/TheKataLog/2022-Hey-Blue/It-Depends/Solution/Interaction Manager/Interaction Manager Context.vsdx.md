# Visio Diagram: Interaction Manager Context.vsdx

## C^3 Context

**Components:**

- [Actor] Civilian / [Member] /  / A non-police officer community member
- [Component] Interaction Manager / [Software System]  / System for community members to interact for good
- [Component] Auth  / [HTTPS]
- [Component] Interactions Workflow / [HTTPS]
- [Component] Analytics Reporting / [Software System]  / Interaction and Operational data management/analytics/reporting
- [Component] Analytic Events / [mTLS]
- [Component] Officer / [Member] /  / Police Officer community member
- [Component] Geographic Information and Maps Provider / [Software System]  / External system providing GIS capabilities
- [Component] Uses / [technology]
- [Component] Donation Redemption  / And Accounting / [Software System]  / Manages Organization Relations, Donation/Redemption and Accounting
- [Component] Records Points / [Event]
- [Component] Media Management / [Software System]  / Manages Social and Other Media Interactions
- [Component] Publish Through / [Event]
- [Component] Identity Provider / [Software System]  / External System for Auth
- [Component] Auth / [technology]
- [Component] Interactions Workflow / [HTTPS]
- [Component] Auth / [HTTPS]
- [Component] [Software System] Interaction Manager  / Context Diagram

**Connections:**

- Civilian --(Auth  / [HTTPS])--> Identity Provider
- Officer --(Interactions Workflow / [HTTPS])--> Interaction Manager
- Interaction Manager --(Analytic Events / [mTLS])--> Analytics Reporting
- Officer --(Auth / [HTTPS])--> Identity Provider
- Civilian --(Interactions Workflow / [HTTPS])--> Interaction Manager
- Interaction Manager --(Auth / [technology])--> Identity Provider
- Interaction Manager --(Publish Through / [Event])--> Media Management
- Interaction Manager --(Records Points / [Event])--> Donation Redemption 
- Interaction Manager --(Uses / [technology])--> Geographic Information and Maps Provider

---
*Converted from Visio VSDX (shape text and connections extracted)*
