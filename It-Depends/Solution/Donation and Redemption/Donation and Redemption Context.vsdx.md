# Visio Diagram: Donation and Redemption Context.vsdx

**Components:**

- [Actor] Charity / [Person] /  / Member of social impact Charity
- [Actor] Civilian / [Member] /  / A non-police officer community member
- [Actor] Officer / [Member] /  / Police Officer community member
- [Actor] Business Representative /  / Administers Storefront
- [Actor] Charity Representative /  / Publicizes
- [Actor] Municipality Representative /  / Administers Incentives
- [Actor] Hey Blue! Treasurer / [Person] /  / Person doing cash and points accounting
- [Actor] Municipality / [Person] /  / Member of Municipality giving Redemptions
- [Component] Donation and Redemption  / [Software System]  / Manages Charity and Business Relations, point including Donation/Redemption, and Internal Accounting
- [Component] Business / [Person] /  / Member of  Business looking for social impact
- [Component] Redeems/Donates / [HTTPS]
- [Component] Donates / [HTTPS]
- [Component] Manages  / Presence and  / Integration / [HTTPS]
- [Component] Manage  / Presence / and Integration / [HTTPS]
- [Component] Analytics and Reporting / [Software System]  / Interaction and Operational data management/analytics/reporting
- [Component] Media Management / [Software System]  / Manages Social and Other Media Interactions
- [Component] Pushes Events / [mTLS]
- [Component] Generates / [Event]
- [Component] [System Context] Donation Redemption and Accounting System
- [Component] Retail Systems / [Software System]  / External Systems of Businesses looking to spend on positive social impact
- [Component] Integrates
- [Component] Charity Systems / [Software System]  / External Systems of Charities Looking for Engagement
- [Component] Integrates
- [Component] Municipality Systems / [Software System]  / External Systems of Municipalities Willing to Reward Positive Interaction
- [Component] Integrates
- [Component] Uses
- [Component] Uses
- [Component] Uses
- [Component] Interaction Manager / [Software System]  / System for community members to interact for good
- [Component] PointsAwarded / [Event]
- [Component] Banking System / [Software System]  / To reconcile expected affiliate payments and outbound community building paymens
- [Component] Integrates
- [Component] Accounting / [HTTPS]
- [Component] Manages  / Presence and  / Integration / [HTTPS]
- [Component] [Software System] Donation and Redemption / Context Diagram

**Connections:**

- Donation and Redemption  --(Generates / [Event])--> Media Management
- Donation and Redemption  --(Pushes Events / [mTLS])--> Analytics and Reporting
- Civilian --(Redeems/Donates / [HTTPS])--> Donation and Redemption 
- Officer --(Donates / [HTTPS])--> Donation and Redemption 
- Charity --(Manages  / Presence and  / Integration / [HTTPS])--> Donation and Redemption 
- Business --(Manage  / Presence / and Integration / [HTTPS])--> Donation and Redemption 
- Municipality --(Manages  / Presence and  / Integration / [HTTPS])--> Donation and Redemption 
- Hey Blue! Treasurer --(Accounting / [HTTPS])--> Donation and Redemption 
- Donation and Redemption  --(Integrates)--> Banking System
- Interaction Manager --(PointsAwarded / [Event])--> Donation and Redemption 
- Municipality Representative --(Uses)--> Municipality Systems
- Charity Representative --(Uses)--> Charity Systems
- Business Representative --(Uses)--> Retail Systems
- Municipality Systems --(Integrates)--> Donation and Redemption 
- Charity Systems --(Integrates)--> Donation and Redemption 
- Retail Systems --(Integrates)--> Donation and Redemption 

---
*Converted from Visio VSDX (shape text and connections extracted)*
