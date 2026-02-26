# Visio Diagram: Hey Blue! Context.vsdx

## Overall Context Diagram

**Components:**

- [Actor] Charity / [Person] /  / Organizational member represents social impact charity
- [Actor] Business / [Person] /  / Organizational member represents business looking for social impact
- [Actor] Civilian / [Member] /  / A non-police officer community member
- [Actor] Officer / [Member] /  / Police Officer community member
- [Actor] Municipality / [Person] /  / Organizational member represents municipality supporting social rdemption
- [Actor] HeyBlue! Staff / [Person] /  / Sysadmin, cash and points reconciliation
- [Component] HeyBlue! Interface / [Software System]  / Interface into they Hey Blue! Systems
- [Component] Uses / [technology]
- [Component] Uses / [technology]
- [Component] Uses / [technology]
- [Component] Uses / [technology]
- [Component] Uses / [technology]
- [Component] Uses / [technology]
- [Component] Analytics And Reporting  / [Software System]  / Interaction and Operational data management/analytics/reporting
- [Component] Donation and Redemption / [Software System]  / Manages Charity and Business Relations and Donation/Redemption
- [Component] Donate/Redeem / Accounting
- [Component] Generate / Schedule / Publish / Analyse
- [Component] Manage
- [Component] Accrue Points
- [Component] Geographic Information and Maps Provider / [Software System]  / External system providing GIS capabilities
- [Component] Uses
- [Component] SocialMedia / [Software System]  / External Social Media Systems
- [Component] Media Outlets / [Software System]  / Organized Media such as News, Blogs, etc
- [Component] Publishes
- [Component] Integrates
- [Component] Integrates
- [Component] Retail Systems / [Software System]  / External Systems Of Businesses looking to spend on positive social impact
- [Component] Charity Systems / [Software System]  / External Systems of Charities Looking for Engagement
- [Component] Municipality Systems / [Software System]  / External Systems of Municipalities Willing to Reward Positive Interaction
- [Component] Integrates
- [Component] Integrates
- [Component] Integrates
- [Component] Engage/Notify
- [Component] Interaction Manager / [Software System]  / System for community members to interact for good
- [Component] Media Manager / [Software System]  / Manages Social and Other Media Interactions
- [Component] #HeyBlue Applciation / Context Diagram

**Connections:**

- Municipality --(Uses / [technology])--> HeyBlue! Interface
- Business --(Uses / [technology])--> HeyBlue! Interface
- HeyBlue! Staff --(Uses / [technology])--> HeyBlue! Interface
- Civilian --(Uses / [technology])--> HeyBlue! Interface
- Officer --(Uses / [technology])--> HeyBlue! Interface
- Charity --(Uses / [technology])--> HeyBlue! Interface
- HeyBlue! Interface --(Engage/Notify)--> Interaction Manager
- Municipality Systems --(Integrates)--> Donation and Redemption
- Charity Systems --(Integrates)--> Donation and Redemption
- Retail Systems --(Integrates)--> Donation and Redemption
- Media Manager --(Integrates)--> Media Outlets
- Media Manager --(Integrates)--> SocialMedia
- Analytics And Reporting  --(Publishes)--> Media Manager
- Interaction Manager --(Uses)--> Geographic Information and Maps Provider
- Interaction Manager --(Accrue Points)--> Donation and Redemption
- HeyBlue! Interface --(Manage)--> Media Manager
- HeyBlue! Interface --(Generate / Schedule / Publish / Analyse)--> Analytics And Reporting 
- HeyBlue! Interface --(Donate/Redeem / Accounting)--> Donation and Redemption

---
*Converted from Visio VSDX (shape text and connections extracted)*
