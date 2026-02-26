## #HeyBlue! {#slide-1}

project Overview

![](ppt/media/image1.png "Picture 4")

## Where we started {#slide-2}

Establish

- Skills, specialties
- Working patterns
- Commitment
- Time zones

Brainstorm

## Connecting  the dots with O-Reilly {#slide-3}

Our Approach:

Straight Through Architecture

![](ppt/media/image11.png "Graphic 26")

![](ppt/media/image9.png "Graphic 30")

![](ppt/media/image9.png "Graphic 19")

Use cases, Process Flows (UC) 

eg  citizens and officers can interact

System requirements (SR) 

eg  the system shall notify of officer proximity

Architecture Characteristics (ADR)  eg  security, zero trust, officer safety

Software System (SS)

eg  entity relationship, data flows

Engineering Diagrams (ED)

eg  data models, sequence flows

Functional Decisions (ADR)

eg  Adopt MVVM, protect location

SHARI

## Slide 4

Our Approach:

Straight Through Architecture

UC-001  Creating an interaction

SR-009   Officers and Citizens must have the ability to connect with each other

US-001  As a user I need to be notified that an officer is available so that I can forge a community connection 

ADR-009  Officer safety

SS-001  Interaction Manager

ED-002  Interaction Manager Engineering Diagrams

ADR-012  Adopt MVVM

ADR-013  Protect officer location

![](ppt/media/image22.emf "Picture 6")

US-002

Notify

Proximity

ADR-003 Architecture Characteristic Security

o fficer safety

zero trust

![](ppt/media/image23.png "Picture 2")

SR-009

Officers and Citizens must have the ability to connect with each other

ADR-013 Design to protect officer location

ADR-016 Data Protection, delete functionality

Interaction Manager

![](ppt/media/image24.png "Picture 2")

#HeyBlue! UI

Location Manager

Profile Manager

User

Controller

Connection Manager

![](ppt/media/image25.png "Picture 2")

![](ppt/media/image26.jpg "Picture 41")

US-001

Register

User

![](ppt/media/image27.png "Picture 4")

![](ppt/media/image28.png "Picture 6")

non functional

functional

## Deviants {#slide-5}

![](ppt/media/image26.jpg "Picture 3")

We decided to significantly deviate from the face-value requirements.

We believe an architect has the responsibility to present alternatives.

Instead of a system which tracks officer location (clear security risk!) we have introduced the concept of community hubs with QR Codes representing the location.  When a meet and greet opportunity arises, nearby citizens will be notified.

If the clients vehemently object, the straight through architecture approach makes it easy to change tack.

![](ppt/media/image11.png "Graphic 5")

![](ppt/media/image9.png "Graphic 6")

![](ppt/media/image9.png "Graphic 7")

## #HeyBlue {#slide-6}

How to read

![](ppt/media/image29.png "Picture 4")

![](ppt/media/image30.png "Picture 6")

## Slide 7

![](ppt/media/image31.jpg "Picture 3")

## Domain map {#slide-8}

MIGUEL

## Slide 9

![](ppt/media/image32.jpg "Picture 3")

![](ppt/media/image6.jpg "Picture 5")

#HeyBlue! Requirements  Use cases, system requirements 

& process flow

![](ppt/media/image33.emf "Picture 7")

![](ppt/media/image30.png "Picture 8")

![](ppt/media/image34.png "Picture 6")

KAVYA

## #HeyBlue! Requirements  User Story Map {#slide-10}

Activity Group

Must have

User Stories

Task

Legend

US-001

Register

User

US-002

Notify

Proximity

US-003

Interact

US-005

Share

Create profile for Citizen

US-004 Earn Points

Create profile for Officer

Update profile

Calculate Rewards

Add rewards to profile

Share to #HeyBlue feed

Share to Social Media

Option to connect

Location Tracking

Proximity Alert

Get Map

US-008

Redeem Points

US-007

Browse store

US-010

Donate

Points

Charity Registers

Send to charity

US-009

Browse Charities

Retailer creates storefront

Spend Manager

Update points

Purchase Items

Delete profile

Store metrics

Present metrics

US-011

Send to analytics

Interaction

Donate & Redeem

Media

Analytics & Reporting

Business storefront

Charity front page

US-006

Register

3 rd  Party

Manage  catalog

Officer location shutoff

Store location alerts

![](ppt/media/image30.png "Picture 26")

![](ppt/media/image35.png "Picture 2")

KAVYA

## #HeyBlue! Requirements  User Story Map {#slide-11}

![](ppt/media/image36.png "Picture 4")

![](ppt/media/image37.png "Picture 6")

![](ppt/media/image38.png "Picture 8")

![](ppt/media/image39.png "Picture 10")

Software System

Donation & Redemption

Software System

Media Manager

Software System

Analytics & Reporting

Software System

Interaction Manager

![](ppt/media/image8.png "Picture 4")

KAVYA

## Slide 12

![](ppt/media/image40.jpg "Content Placeholder 11")

#HeyBlue! Solution

Context Diagram

![](ppt/media/image41.png "Picture 2")

![](ppt/media/image8.png "Picture 4")

![](ppt/media/image42.png "Picture 2")

![](ppt/media/image30.png "Picture 3")

![](ppt/media/image34.png "Picture 6")

MIGUEL

## Analytics & Reporting {#slide-13}

## Slide 14

![](ppt/media/image16.jpg "Content Placeholder 4")

#HeyBlue! Solution 

-   Interaction Manager Software System Container Diagram

Interaction Manager

![](ppt/media/image30.png "Picture 2")

![](ppt/media/image34.png "Picture 6")

## Slide 15

![](ppt/media/image43.jpg "Picture 4")

#HeyBlue! Solution 

-   Interaction Manager   Detailed Design

![](ppt/media/image44.jpg "Picture 2")

![](ppt/media/image30.png "Picture 8")

![](ppt/media/image34.png "Picture 6")

## Social Media Manager {#slide-16}

## Donation & Redemption {#slide-17}

UMA

PRASHANT

## Lessons learned {#slide-18}

![Over/Perfect Communication -- No such thing! \| The Armchair HR Manager -  Advice from an \"HR Fan\"](ppt/media/image45.jpeg "Picture 4")

- Start with a  structured  brainstorm with the full team, starting with a use cases analysis, architecture characteristics and domain model
- Jumping straight to the solution is a natural software engineering trait, do this, but  iterate continuously  over the requirements looking for gaps and rabbit holes ( eg  1 connection/24hrs, 1 device)
- Tell a story, how did you get to the solution?  Look for accidental and  implicitly made decisions  with unintended consequences, identify and explicitly capture decisions, review and communicate with the team ( eg  data)
- Due diligence as you go along, document, readme, diagram titles, purpose and legends.
- Diagram language must be fit for purpose, for example, don't cram every system requirement into a story and don't model every aspect in C4
- Communicate always and all the time, from commit messages to daily catchups to random 2am thoughts and ideas
- 
- 

![Planet Autism: square pegs don\'t fit into round holes \| The Art of Autism](ppt/media/image46.jpeg "Picture 2")

![Group Leader \| Great PowerPoint ClipArt for Presentations -  PresenterMedia.com](ppt/media/image47.jpeg "Picture 6")

![Conference Brainstorming \| Great PowerPoint ClipArt for Presentations -  PresenterMedia.com](ppt/media/image48.jpeg "Picture 8")

![Conference Brainstorming \| Great PowerPoint ClipArt for Presentations -  PresenterMedia.com](ppt/media/image48.jpeg "Picture 8")

SHARI

## If we were to do this internally {#slide-19}

Set expectations around

Detail, container level?  Code level?

Technology, agnostic/ azure?

Real use case

KAVYA
