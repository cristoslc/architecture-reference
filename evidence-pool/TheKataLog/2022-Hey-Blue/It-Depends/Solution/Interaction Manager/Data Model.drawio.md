# Data Model

*Extracted text labels from `Data Model.drawio`*

## Data Model

- Member
- +MemberId
  +Name
  +Address
  +Points
- Officer
- +OfficerId
  +ZipCode
  +Municipality
  +Points
- Interaction
- +Interaction Type
- Interaction
- +InteractionId 
   +MemberId (FK) 
   +OfficerId (FK)
   +ZipCode
   +Municipal
   +InteractionType
- Interaction TypeVirtualIn Person
- Software System: CommunityConnectorComponent: Interaction ManagerView: Data Model
- Send to Analytics
- Constrain 1 officer connection per 24 hours, unique index on member, officer

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
