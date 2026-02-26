# Visio Diagram: Interaction Manager Containers.vsdx

## Containers - Community Connect Change System

**Components:**

- [Actor] Civilian / [Member] /  / A non-police officer community member
- [Actor] Officer / [Member] /  / Police Officer community member
- [Database] Geo Information and Maps Provider / [Software System]  / External system providing GIS capabilities
- [Component] Interactions Workflow / [HTTPS]
- [Component] Publish metrics
- [Component] [Software System] Interaction Manager  / Container Diagram
- [Component] Uses / [technology]
- [Component] Calculate Points / [Event]
- [Component] Interaction Manager  / [Software System]
- [Component] Interactions Workflow / [HTTPS]
- [Component] Publish post
- [Component] Auth  / [HTTPS]
- [Component] Identity Provider / [Software System]  / External System for Auth
- [Component] Auth / [HTTPS]
- [Component] #HeyBlue! UI / [Container: Mobile/ Web] /  / User interface, enables interaction and redemption
- [Component] Analytics and Reporting / [Software System]  / Data management, analytics & reporting
- [Component] Donation And / Redemption  / [Software System]  / Manages Organization Relations, Donation, Redemption, Accounting
- [Component] Connection Manager /  / Manages the connection, authenticates both parties
- [Component] Location Manager /  / Maps Interop, Proximity Detection, Interaction Workflow
- [Component] Media Management / [Software System]  / Manages Social and Other Media Interactions
- [Component] Profile Manager /  / Registration, Profile, Settings (e.g. location services)
- [Component] Officer  / Controller / [Component] /  / Event and Request Routing
- [Component] Member Controller / [Component] /  / Event and Request Routing
- [Component] Interact with
- [Component] Controller /  / Event and Request Routing
- [Component] Accept / Reject / [interaction]
- [Component] Register Location
- [Component] Controller  / [Container]
- [Component] Add points to

**Connections:**

- Civilian --(Interactions Workflow / [HTTPS])--> #HeyBlue! UI
- Connection Manager --(Publish metrics)--> Analytics and Reporting
- Location Manager --(Uses / [technology])--> Geo Information and Maps Provider
- Connection Manager --(Calculate Points / [Event])--> Donation And
- Controller --(Add points to)--> Profile Manager
- Controller --(Register Location)--> Location Manager
- Controller --(Accept / Reject / [interaction])--> Connection Manager
- #HeyBlue! UI --(Interact with)--> Controller
- Officer --(Auth / [HTTPS])--> Identity Provider
- Civilian --(Auth  / [HTTPS])--> Identity Provider
- Connection Manager --(Publish post)--> Media Management
- Officer --(Interactions Workflow / [HTTPS])--> #HeyBlue! UI

---
*Converted from Visio VSDX (shape text and connections extracted)*
