# Visio Diagram: Analytics Reporting Context.vsdx

**Components:**

- [Actor] HeyBlue! Staff / [Person] /  / Admins,  Media Relations and Management
- [Actor] HeyBlue! Technical Staff / [Person] /  / Data Staff, SRE
- [Component] Analytics and Reporting / [Software System]  / Interaction and Operational data management/analytics/reporting
- [Component] Interaction Manager / [Software System]  / System for community members to interact for good
- [Component] Media / [Software System]  / Manages Social and Other Media Interactions
- [Component] Donation and Redemption / [Software System]  / Manages Charity and Business Relations and Donation/Redemption
- [Component] Pushes Telemetry / [mTLS]
- [Component] Pushes Telemetry / [mTLS]
- [Component] Generates / [Event]
- [Component] Generates/Reads / [HTTPS]
- [Component] Model/Analyze/Monitor/Investigate / [HTTPS]
- [Component] [Software System] Analytics and Reporting / Context Diagram

**Connections:**

- HeyBlue! Technical Staff --(Model/Analyze/Monitor/Investigate / [HTTPS])--> Analytics and Reporting
- Interaction Manager --(Pushes Telemetry / [mTLS])--> Analytics and Reporting
- Donation and Redemption --(Pushes Telemetry / [mTLS])--> Analytics and Reporting
- Analytics and Reporting --(Generates / [Event])--> Media
- HeyBlue! Staff --(Generates/Reads / [HTTPS])--> Analytics and Reporting

---
*Converted from Visio VSDX (shape text and connections extracted)*
