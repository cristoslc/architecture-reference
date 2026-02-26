# Visio Diagram: Media Containers.vsdx

**Components:**

- [Actor] Civilian / [Member] /  / A non-police officer community member
- [Actor] Officer / [Member] /  / Police Officer community member
- [Component] Media / [Software System] / Manages Social and Other Media Interactions
- [Component] #HeyBlue! UI / [Container: Mobile/ Web] /  / User interface, enables interaction and redemption
- [Component] Posts storage / [Container: technology] / Stores the Posts data
- [Component] Confirm Add/View/Update
- [Component] SocialMedia / [Software System] / External Social Media Systems
- [Component] Views/Likes
- [Component] Notifications / Handles Notifications to  HeyBlue Members
- [Component] Donation and Redemption / [Software System]  / Manages Charity and Business Relations and Donation/Redemption
- [Component] Media Outlets / [Software System]  / Organized Media such as News, Blogs, etc
- [Component] Social Media Gateway / [Container: technology] / Event and Request Routing
- [Component] Posts / Enables Posting service to HeyBlue Memebrs
- [Component] Analytics And Reporting  / [Software System]  / Interaction and Operational data management/analytics/reporting
- [Component] Interaction Manager / [Software System]  / System for community members to interact for good
- [Component] HeyBlue Feeds / Handles Feeds of HeyBlue system
- [Component] Home Timeline storage / [Container: technology] / Stores the streams of data

**Connections:**

- Officer --(Views/Likes)--> SocialMedia
- Civilian --(Confirm Add/View/Update)--> SocialMedia
- Analytics And Reporting  --(Generates / [Event])--> HeyBlue Feeds
- Officer --(Interactions Workflow / [HTTPS])--> #HeyBlue! UI
- Civilian --(Interactions Workflow / [HTTPS])--> #HeyBlue! UI
- Social Media Gateway --(Uses / [technology])--> Posts
- Social Media Gateway --(Uses / [technology])--> HeyBlue Feeds
- HeyBlue Feeds --(Triggers / [Event])--> Notifications
- Notifications --(Sends / [technology])--> #HeyBlue! UI
- #HeyBlue! UI --(Uses / [technology])--> Social Media Gateway
- HeyBlue Feeds --(CRUD)--> Home Timeline storage
- Posts --(CRUD)--> Posts storage
- Civilian --(Interactions Workflow / [HTTPS])--> Interaction Manager
- Interaction Manager --(Initiates / [Event])--> HeyBlue Feeds
- HeyBlue Feeds --(Publishes / [HTTPS])--> Media Outlets
- Donation and Redemption --(Generates / [Event])--> HeyBlue Feeds

---
*Converted from Visio VSDX (shape text and connections extracted)*
