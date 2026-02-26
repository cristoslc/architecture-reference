## The Sysops Squad Migration {#slide-1}

![](ppt/media/image8.png "Google Shape;54;p13")

## Agenda {#slide-2}

- Background & The Journey

<!-- -->

- Motivation
- The Problems & Our Guiding Principles
- Artifacts for initial analysis

<!-- -->

- Our Approach

<!-- -->

- Narrowing Architectural Characteristics
- Picking an Architectural Style
- Two ways to do it
- Trade-offs,  Decisions & Consequences

<!-- -->

- The Migration

<!-- -->

- Architectural Components
- Phase 1
- Phase 2
- Phase 3

<!-- -->

- Looking Ahead
- Conclusion

## Background &  The Journey {#slide-3}

![](ppt/media/image6.png "Google Shape;67;p15")

The measure of intelligence is the ability to change

\~ Albert Einstein

## Motivation {#slide-4}

How to  accommodate  growth with adaptive cost model?

![](ppt/media/image2.png "Google Shape;76;p16")

Steady growth

Under provision

Over provision

Growth with fluctuations

## Slide 5

C4 System Context Diagram

![](ppt/media/image17.jpg "Google Shape;88;p17")

## Slide 6

![](ppt/media/image11.jpg "Google Shape;93;p18")

Use Case  Diagram

## Slide 7

![](ppt/media/image3.png "Google Shape;99;p19")

Sequence Diagram: Ticketing Workflow

## Slide 8

![](ppt/media/image5.png "Google Shape;105;p20")

Sequence Diagram: Non-Ticketing Workflow

## The Problems & Our Guiding Principles {#slide-9}

![](ppt/media/image12.png "Google Shape;112;p21")

- We NEVER ever want to be in this situation again

- Excellent customer experience should be a driver for future business growth 

## Our Approach {#slide-10}

![](ppt/media/image7.png "Google Shape;118;p22")

All great changes are preceded by chaos.

\~ Deepak Chopra

## Our Approach {#slide-11}

- Identify gaps in architectural  characteristics

Fault Tolerance

Elasticity

Maintainability

Security

Feasibility

Agility

Evolvability

Recoverability

Workflow

Testability

Deployability

Data Integrity

Availability

Overwhelming

## Our Approach {#slide-12}

- Determine existing architectural patterns that will help address these gaps

## Our Approach {#slide-13}

- Determine existing architectural patterns that will help address these gaps

![](ppt/media/image1.png "Google Shape;156;p25")

## Our Approach {#slide-14}

- Define a path from existing system to the utopian world

A BIG BANG Approach

A Slow, But Steady Approach

Pros :

- Faster results

Cons :

- High Risk
- Steep Learning Curve
- High Complexity

P ros :

- Low Risk
- Ability to include micro-tweaks & adjustments along the way
- Team gets more room for adapting to the new architecture

Cons :

- Slower results
- Additional work in determining and picking the right fitness functions

## Trade  Offs, Decisions and Consequences {#slide-15}

Better control

Brittle Architecture Coupling

Fitness functions

Loose Coupling

Centralized Workflow

Better control of sagas and error handling

Distributed Workflow

Complex saga and error handling

![](ppt/media/image15.png "Google Shape;193;p27")

![](ppt/media/image15.png "Google Shape;194;p27")

## The  Migration {#slide-16}

![](ppt/media/image14.png "Google Shape;199;p28")

To improve is to change; to be perfect is to change often.

\~ Winston Churchill

## Slide 17

![](ppt/media/image10.png "Google Shape;206;p29")

![](ppt/media/image9.png "Google Shape;207;p29")

## Slide 18

![](ppt/media/image20.png "Google Shape;212;p30")

## Slide 19

![](ppt/media/image19.png "Google Shape;217;p31")

## Slide 20

![](ppt/media/image18.png "Google Shape;222;p32")

## Looking Ahead: System Architecture {#slide-21}

Based on data obtained from fitness functions, other services can be converted to microservices as well and moved to the cloud.

Potential candidates for a first draft pick are -

- Login Service

- Billing Service

## Looking Ahead: Suggestions To Business {#slide-22}

Leverage data collected in the KB to create a data lake that can be used to drive business growth

- Provide self service options to customers for simple tickets

<!-- -->

- Bots
- Online Help

- Train & Empower CSRs to address common issues over the phone (to free up time for Experts to address only critical/complicated issues)

- Assign Experts only for issues not addressed by the previous two (eliminates backlog of tickets)

## Conclusion {#slide-23}

T ransition (over time) to\...

- Fully  Data Driven approach to changes
- Hybrid, Evolutionary architecture
- Use Fitness Functions to drive changes
- Agile processes
- AI, BI & Data Analytics

## Slide 24

It is not the strongest of the species that survive, nor the most intelligent, but the one most responsive to change.

Charles Darwin

## Q & A {#slide-25}

Ask   and   Ye  Shall   Receive...\*

\*  For premium members only whose Sysops Squad subscription is currently active and bills paid in full 

![](ppt/media/image13.png "Google Shape;254;p37")

## System Context Diagram / C4-Container Diagram {#slide-26}

## Slide 27

## Slide 28

## Slide 29

Phase1: (Application Decomposition) 

                                                                                                                               

                                                                                         Architecture  Choice and Guidelines :  

                                                                         Application Decomposition -  coarse grained services.

Database  D ecomposition -  Single Monolithic database. 

                                                                         Message Broker - Better centralized workflow 

                                                                         API  Layer- Hiding Database structures from Users.

          User Interface- A single user Interface for different system users

![](ppt/media/image24.png "Google Shape;275;p41")

## Slide 30

![](ppt/media/image22.png "Google Shape;280;p42")

Phase2: (Database Decomposi tion) 

                            Architecture  Choice and Guidelines :  

Database Decomposition - Bounded Context of services with own DBs.

         User Interface:  Two different micro front ends for customer and internal user

                                                    

## Slide 31

![](ppt/media/image23.png "Google Shape;286;p43")

Phase 3: Microservice Deployment 

                                                                                                                               

                                                      Architecture  Choice and Guidelines 

                                           Ticketing Service- Break Down to Microservice.

                                              

                                                                         
