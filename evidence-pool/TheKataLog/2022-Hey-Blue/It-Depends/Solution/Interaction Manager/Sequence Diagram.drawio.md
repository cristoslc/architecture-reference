# Sequence Diagram

*Extracted text labels from `Sequence Diagram.drawio`*

## Register

- Member
- return
- MemberController
- Check email & devicenot already registered
- ProfileManager
- Software System: Interaction ManagerUser Story: Register
- HeyBlue UI
- Register
- Register
- Store profile data:Name, EmailDeviceOpt in to notificationLocation trackingPointsFavourite community hubs
- Persist
- return
- return

## Interact

- HeyBlue UI
- HeyBlue UI
- Officer
- Member
- if proximity < 50ft & interactionCount<1
- NoftifyOpportunity
- Notify Opportunity
- Notify(location)
- MemberController
- LocationManager
- HubServer
- OfficerController
- Software System: Interaction ManagerUser Story: Notify Proximity
- Scan hub
- Scan hubQR Code
- Check in
- Get check-ins
- available officers
- get citizens
- nearby citizens
- Define community hubs.  These can be parks, shopping centres or even train stations.The hub will have a QR code displayed and the officer will check in if she or he is in the area.The system will notify registered citizens as they approach a staffed hub

## Share

- Member
- MemberController
- Donation & Redemption
- HeyBlue UI
- MediaManager
- Analytics &Reporting
- share
- share interaction
- share interaction
- return
- ProfileManager
- calculate points
- return
- add points
- return
- send metrics
- return
- notify points
- notify points
- Software System: Interaction ManagerUser Story: Share, Earn Points

## ADR-IM-002 MVVM pattern

- member
- view
- view model
- press button
- model interface
- send UI action
- send data write
- notify change
- update UI
- Synchronous
- Asynchronous
- ADR-IM-002: ADR-IM-002 Adopt UI design pattern MVVM

## ADR Initiate Option 1

- Member
- Officer
- Location Manager
- ADR-IM-003: Sequence for Member Controlled Interaction
- broadcast location
- notify of proximity
- Interaction Manager
- extend invitationto connect
- nofiy of offer
- accept invitation
- invitation accepted
- Connect?RQ
- AvailabilityCitizen AvailableCitizen Available
- Member sees officers,extends invitation to connect

## ADR Initiate Option 2

- Officer
- Member
- Location Manager
- ADR-IM-003: Sequence for Officer Controlled Interaction
- broadcast location
- notify of proximity
- Interaction Manager
- extend invitationto connect
- nofiy of offer
- accept invitation
- invitation accepted
- Connect?RQ
- AvailabilityOfficer AvailableOfficer Available
- Officer sees member locations, extends invitation to connect
