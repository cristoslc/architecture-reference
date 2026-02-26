# Visio Diagram: Media Context.vsdx

**Components:**

- [Actor] Community Member / [Person] /  / Civilian or Officer
- [Actor] Civilian / [Member] /  / A non-police officer community member
- [Actor] Officer / [Member] /  / Police Officer community member
- [Component] Interaction Manager / [Software System]  / System for community members to interact for good
- [Component] Interactions Workflow / [HTTPS]
- [Component] Media Management / [Software System]  / Manages Social and Other Media Interactions
- [Component] Initiates / [Event]
- [Component] SocialMedia / [Software System]  / External Social Media Systems
- [Component] Confirm Post/View/Update
- [Component] Views/Likes
- [Component] Publish Workflow / [Https]
- [Component] Analytics and Reporting / [Software System]  / Interaction and Operational data management/analytics/reporting
- [Component] Generates / [Event]
- [Component] Donation Redemption / And Accounting / [Software System]  / Manages Organization Relations, Donation/Redemption and Accounting
- [Component] Generates / [Event]
- [Component] Media Outlets / [Software System]  / Organized Media such as News, Blogs, etc
- [Component] Publishes / [HTTPS]
- [Component] General Public / [Person] /  / Person to convert to community Member
- [Component] Reads
- [Component] Reads
- [Component] Post to HeyBlue! / Social Media / [Https]
- [Component] [Software System] Media Manager  / Context Diagram

**Connections:**

- Analytics and Reporting --(Generates / [Event])--> Media Management
- Media Management --(Publish Workflow / [Https])--> Civilian
- Civilian --(Interactions Workflow / [HTTPS])--> Interaction Manager
- Interaction Manager --(Initiates / [Event])--> Media Management
- Civilian --(Confirm Post/View/Update)--> SocialMedia
- Officer --(Views/Likes)--> SocialMedia
- Media Management --(Post to HeyBlue! / Social Media / [Https])--> SocialMedia
- Community Member --(Reads)--> Media Outlets
- General Public --(Reads)--> Media Outlets
- Media Management --(Publishes / [HTTPS])--> Media Outlets
- Donation Redemption --(Generates / [Event])--> Media Management

---
*Converted from Visio VSDX (shape text and connections extracted)*
