## Architectural   Katas  2024 {#slide-1}

Team Low-Code

![](ppt/media/image7.png "Afbeelding 3")

## Slide 2

![Afbeelding met overdekt, tekst, muur, meubels

Automatisch gegenereerde beschrijving](ppt/media/image8.png "Afbeelding 5")

## CONTENT {#slide-3}

MonitorMe  Business Case 		 				

Constraints & Driving Characteristics 					

Architectural Design Decisions

MonitorMe  Solution

## MonitorMe  Business Case  {#slide-4}

Joachim 

## The Business Problem of  StayHealty  Inc. {#slide-5}

MonitorThem data analytics platform

MyMedicalData patient medical record system

## Requirements of  MonitorMe {#slide-6}

VITAL SIGN INPUT SOURCES

HEART RATE

BLOOD PRESSURE

OXYGEN LEVEL

BLOOD SUGAR

RESPIRATION

ECG

BODY TEMPERATURE

SLEEP STATUS

READ DATA VITAL SIGN  INPUT SOURCES

RECORD & STORE DATA  24 HOURS

CONTINUITY IF AN INPUT SOURCE FAILS

DIFFERENT RATE  VITAL SIGNS READINGS 

MORE VITAL SIGN DEVICES

ACCURATE MEASUREMENTS

## Requirements of  MonitorMe {#slide-7}

ANALYZE VITAL SIGNS & ALERT MEDICAL PROFESSIONAL

AWAKE OR ASLEEP  TREND AND TRHESHOLDS

PUSH NOTIFICATION

TO MOBILE APP

GENERATE HOLISTIC SNAPSHOTS 

ON-PREMISES ARCHITECTURE 

MAX 500 PATIENTS  PER INSTANCE

BUILD-FOR-CHANGE

SECURE PATIENT DATA

COMPLETE OWN  INSTALLATION

## Constraints & Driving Characteristics  {#slide-8}

Job

## Driving Characteristics {#slide-9}

Availability

Concurrency

Data integrity

Performance

Responsiveness

Fault tolerance

Security

##    24/7 correct simultaneous analysis of patient vital signs {#slide-10}

Availability

Concurrency

Data integrity

100% uptime

Data loss = missing potential alerts

Correct data must be analyzed

Time from data to alert

No waiting queue

Simultaneous analysis

## (Justification  tekst   gebruiken  om top-3 toe  te   lichten ) {#slide-11}

![](ppt/media/image9.png "Afbeelding 3")

DEZE SLIDE NIET TONEN

## Software C omplexity {#slide-12}

Concurrency

Availability

Data integrity

Evolvability

Fault-tolerance

Performance

Software  architecture

style?

## Hardware  Complexity {#slide-13}

24/7 availability

On-Premise

Futureproof

No single point of  faillure

Easy to install

Rolling upgrades

Hardware  architecture

style?

## Architectural Design Decisions {#slide-14}

Jeroen

## Software C omplexity {#slide-15}

Concurrency

Availability

Data integrity

Evolvability

Fault-tolerance

Performance

Software  architecture

style?

## ADR-0000 Event-driven software architecture {#slide-16}

![](ppt/media/image10.png "Afbeelding 1")

Evolvability

Fault-tolerance

Performance

## (ADR-0001) Event- driven   architecture   will   not   tick   all   the   boxes {#slide-17}

Non- functional   requirements   for   MonitorMe  are:

- 24/7 availability 
- Means no single point of  failures
- Has  to   be  on- premise ;  Preferably  customer  can   replace   faulty   appliances
- Meaning  easy  to   install , support rolling upgrades
- Futureproof ;  scalable   to  support  additional   vital   signs
- 

Considered  options:

- Centralized  systems
- Microservices
- Distributed systems
- 

## Decision outcome {#slide-18}

Chosen option "Distributed system"

- 

Why? It enables all non-functional requirements

- 
- Centralized system lacks fault-tolerance
- Microservices requires a more complex architecture to support. Which would be preferable in a cloud environment, but not on-premise

![](ppt/media/image11.png "Afbeelding 1")

## MonitorMe  Solution {#slide-19}

Shahin

## MonitorMe  Solution  -- Level 1 {#slide-20}

![A diagram of a medical application

Description automatically generated](ppt/media/image12.png "Picture 8")

## MonitorMe  Solution  -- Level 1 {#slide-21}

![A diagram of a company

Description automatically generated](ppt/media/image13.png "Picture 5")

## MonitorMe  Solution  --  Level 2 Analyzer {#slide-22}

![](ppt/media/image14.png "Picture 4")

## 	Wrap-up  MonitorMe {#slide-23}

READ DATA VITAL SIGN  INPUT SOURCES

RECORD & STORE DATA  24 HOURS

CONTINUITY IF AN INPUT SOURCE FAILS

DIFFERENT RATE  VITAL SIGNS READINGS 

MORE VITAL SIGN DEVICES

ACCURATE MEASUREMENTS

ANALYZE VITAL SIGNS & ALERT MEDICAL PROFESSIONAL

AWAKE OR ASLEEP  TREND AND THRESHOLDS

PUSH NOTIFICATION

TO MOBILE APP

GENERATE HOLISTIC SNAPSHOTS 

ON-PREMISES ARCHITECTURE 

MAX 500 PATIENTS  PER INSTANCE

BUILD-FOR-CHANGE

SECURE PATIENT DATA

COMPLETE OWN  INSTALLATION

![Checkmark with solid fill](ppt/media/image15.png "Graphic 20")

![Checkmark with solid fill](ppt/media/image15.png "Graphic 21")

![Checkmark with solid fill](ppt/media/image15.png "Graphic 22")

![Checkmark with solid fill](ppt/media/image15.png "Graphic 23")

![Checkmark with solid fill](ppt/media/image15.png "Graphic 24")

![Checkmark with solid fill](ppt/media/image15.png "Graphic 25")

![Checkmark with solid fill](ppt/media/image15.png "Graphic 26")

![Checkmark with solid fill](ppt/media/image15.png "Graphic 27")

![Checkmark with solid fill](ppt/media/image15.png "Graphic 28")

![Checkmark with solid fill](ppt/media/image15.png "Graphic 29")

![Checkmark with solid fill](ppt/media/image15.png "Graphic 30")

![Checkmark with solid fill](ppt/media/image15.png "Graphic 31")

![Checkmark with solid fill](ppt/media/image15.png "Graphic 32")

![Checkmark with solid fill](ppt/media/image15.png "Graphic 33")

![Checkmark with solid fill](ppt/media/image15.png "Graphic 34")

![](ppt/media/image17.png "Afbeelding 16")

## Happy End {#slide-24}

Team Low-Code

## Slide 25

![A group of men sitting at a table with pizzas and drinks

Description automatically generated](ppt/media/image18.jpeg "Picture 5")

## Slide 26
