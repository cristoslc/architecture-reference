## Strategic Review {#slide-1}

The Mad Katas

May 2021

![](ppt/media/image3.png "Audio 9")

## A solution is needed, and needs to be enacted quickly to save this arm of the Penultimate Electronics business. {#slide-2}

![](ppt/media/image3.png "Audio 7")

## Problems {#slide-3}

With the current Sysops Squad system

![](ppt/media/image3.png "Audio 10")

## Slide 4

![Woman on a call shocked](ppt/media/image4.png "Picture 7")

![Male student raised hands](ppt/media/image5.png "Picture 9")

![Old woman thumbs down](ppt/media/image6.png "Picture 11")

![Businessman hand on face](ppt/media/image7.png "Picture 13")

My laptop won't turn on, and when I called your operator said the ticket system was down!

I needed help with my electric hob but the website wouldn't load!

The person who showed up couldn't fix my printer!

I stayed in all day and no one showed up!

![](ppt/media/image3.png "Audio 5")

## Slide 5

![Businessman confused](ppt/media/image8.png "Picture 9")

![Casual woman writing on notepad](ppt/media/image9.png "Picture 5")

I knew I had a job to go to, but the ticket information wouldn't load!

It was so embarrassing having to say the system had sent the wrong person!

![Woman in wheelchair](ppt/media/image10.png "Picture 2")

The system keeps freezing up and when we make changes something else breaks!

![](ppt/media/image3.png "Audio 8")

## Slide 6

![People sitting on blue chairs](ppt/media/image11.jpeg "Picture 2")

Customers will be cancelling their contracts and going elsewhere.

The brand image is being tarnished.

We are throwing money down the drain!

![](ppt/media/image3.png "Audio 8")

## Tickets are a problem. {#slide-7}

Availability and Scalability are secondary

![](ppt/media/image3.png "Audio 5")

## Updated Ticket Workflows {#slide-8}

The workflows for tickets in the new Sysops system.

## Customer creates a Ticket {#slide-9}

![Diagram

Description automatically generated](ppt/media/image12.png "Picture 5")

## Customer creates a Ticket {#slide-10}

![Diagram

Description automatically generated](ppt/media/image12.png "Picture 5")

## Customer creates a Ticket {#slide-11}

![Diagram

Description automatically generated](ppt/media/image12.png "Picture 5")

## Customer creates a Ticket {#slide-12}

![Diagram

Description automatically generated](ppt/media/image12.png "Picture 5")

## Customer creates a Ticket {#slide-13}

![Diagram

Description automatically generated](ppt/media/image12.png "Picture 5")

## Ticket created for Expert {#slide-14}

![Diagram, schematic

Description automatically generated](ppt/media/image13.png "Picture 4")

## Ticket created for Expert {#slide-15}

![Diagram, schematic

Description automatically generated](ppt/media/image13.png "Picture 4")

## Ticket created for Expert {#slide-16}

![Diagram, schematic

Description automatically generated](ppt/media/image13.png "Picture 4")

## Ticket created for Expert {#slide-17}

![Diagram, schematic

Description automatically generated](ppt/media/image13.png "Picture 4")

## Ticket created for Expert {#slide-18}

![Diagram, schematic

Description automatically generated](ppt/media/image13.png "Picture 4")

## Ticket created for Expert {#slide-19}

![Diagram, schematic

Description automatically generated](ppt/media/image13.png "Picture 4")

## Expert acts on Ticket {#slide-20}

![Diagram

Description automatically generated](ppt/media/image14.png "Picture 2")

## Expert acts on Ticket {#slide-21}

![Diagram

Description automatically generated](ppt/media/image14.png "Picture 2")

## Expert acts on Ticket {#slide-22}

![Diagram

Description automatically generated](ppt/media/image14.png "Picture 2")

## Expert acts on Ticket {#slide-23}

![Diagram

Description automatically generated](ppt/media/image14.png "Picture 2")

## Expert acts on Ticket {#slide-24}

![Diagram

Description automatically generated](ppt/media/image14.png "Picture 2")

## Tickets {#slide-25}

Updating the workflows.

![](ppt/media/image3.png "Audio 5")

## Customer creates a Ticket {#slide-26}

![Diagram

Description automatically generated](ppt/media/image12.png "Picture 5")

![](ppt/media/image3.png "Audio 2")

## Ticket created for Expert {#slide-27}

![Diagram, schematic

Description automatically generated](ppt/media/image13.png "Picture 4")

![](ppt/media/image3.png "Audio 2")

## Ticket created for Expert {#slide-28}

![Diagram, schematic

Description automatically generated](ppt/media/image13.png "Picture 4")

![](ppt/media/image3.png "Audio 5")

## Availability & Scalability {#slide-29}

And other characteristics.

![](ppt/media/image3.png "Audio 4")

## Key Architecture Characteristics {#slide-30}

  Characteristic           Source
  ------------------------ -----------------------------------------------------------------------------------------
  Reliability              lost tickets ticket assigned to wrong expert (incorrect skills)
  Data Integrity           lost tickets ticket assigned to wrong expert (incorrect skills)
  Workflow                 lost tickets ticket assigned to wrong expert (incorrect skills)
  Scalability/Elasticity   system frequently freezes up / crashes thought to be because of a spike in usage
  Availability             the system is not always available for web-based and call-based ticket management
  Maintainability          change is difficult and risky change take a long time and usually breaks something else
  Testability              change is difficult and risky change take a long time and usually breaks something else

## Key  Architecture  Characteristics {#slide-31}

![Graphical user interface, application

Description automatically generated](ppt/media/image15.png "Content Placeholder 4")

## Key  Architecture  Characteristics {#slide-32}

![Graphical user interface, application

Description automatically generated](ppt/media/image15.png "Content Placeholder 4")

## Key  Architecture  Characteristics {#slide-33}

![Graphical user interface, application

Description automatically generated](ppt/media/image15.png "Content Placeholder 4")

## Key  Architecture  Characteristics {#slide-34}

![Graphical user interface, application

Description automatically generated](ppt/media/image15.png "Content Placeholder 4")

## Key  Architecture  Characteristics {#slide-35}

![Graphical user interface, application

Description automatically generated](ppt/media/image15.png "Content Placeholder 4")

## Our current architecture is not distributed {#slide-36}

![Diagram, table

Description automatically generated](ppt/media/image16.png "Content Placeholder 4")

![](ppt/media/image3.png "Audio 5")

## Overall Architecture Style {#slide-37}

![A picture containing table

Description automatically generated](ppt/media/image17.png "Picture 3")

\[original comparison matrix from Understand Architecture Styles (and when to use them) presentation, by Mark Richards\]

![Close with solid fill](ppt/media/image18.png "Graphic 12")

![Close with solid fill](ppt/media/image18.png "Graphic 13")

![Close with solid fill](ppt/media/image18.png "Graphic 14")

## Overall Architecture Style {#slide-38}

![A picture containing table

Description automatically generated](ppt/media/image17.png "Picture 3")

## Overall Architecture Style {#slide-39}

![A picture containing table

Description automatically generated](ppt/media/image17.png "Picture 3")

## Overall Architecture Style {#slide-40}

![A picture containing table

Description automatically generated](ppt/media/image17.png "Picture 3")

## Overall Architecture Style {#slide-41}

![A picture containing table

Description automatically generated](ppt/media/image17.png "Picture 3")

## Overall Architecture Style {#slide-42}

![A picture containing table

Description automatically generated](ppt/media/image17.png "Picture 3")

## Decision: We will use a service-based back-end architecture {#slide-43}

The trade-offs can all be mitigated

![](ppt/media/image3.png "Audio 2")

## Availability & Scalability {#slide-44}

And other characteristics.

![](ppt/media/image3.png "Audio 4")

## Key  Architecture  Characteristics {#slide-45}

![Graphical user interface, application

Description automatically generated](ppt/media/image15.png "Content Placeholder 4")

![](ppt/media/image3.png "Audio 3")

## Our current architecture is not distributed {#slide-46}

![Diagram, table

Description automatically generated](ppt/media/image16.png "Content Placeholder 4")

![](ppt/media/image3.png "Audio 5")

## Overall Architecture Style {#slide-47}

![A picture containing table

Description automatically generated](ppt/media/image17.png "Picture 3")

![](ppt/media/image3.png "Audio 31")

## Overall Architecture Style {#slide-48}

![A picture containing table

Description automatically generated](ppt/media/image17.png "Picture 3")

![](ppt/media/image3.png "Audio 26")

## Overall Architecture Style {#slide-49}

![A picture containing table

Description automatically generated](ppt/media/image17.png "Picture 3")

![](ppt/media/image3.png "Audio 27")

## Overall Architecture Style {#slide-50}

![A picture containing table

Description automatically generated](ppt/media/image17.png "Picture 3")

![](ppt/media/image3.png "Audio 27")

## Decision: We will use a service-based back-end architecture {#slide-51}

The trade-offs can all be mitigated

![](ppt/media/image3.png "Audio 2")

## Data Store {#slide-52}

How we store data affects the system

## Data Store Options {#slide-53}

  Requirement                                        Relational   Document   Graph
  -------------------------------------------------- ------------ ---------- -------
  Data must be accurate when reading and writing                             
  Data should be fast to retrieve                                            
  Allow data migration from the current data store                           
  Have high availability                                                     
  Easy to update the schema                                                  
  Easily maintainable querying                                               
  Manage relationships between all the entities                              

![Help outline](ppt/media/image20.png "Graphic 10")

![Badge Cross with solid fill](ppt/media/image22.png "Graphic 12")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 14")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 19")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 22")

![Badge Cross with solid fill](ppt/media/image22.png "Graphic 27")

![Help outline](ppt/media/image20.png "Graphic 30")

## Data Store Options {#slide-54}

  Requirement                                        Relational   Document   Graph
  -------------------------------------------------- ------------ ---------- -------
  Data must be accurate when reading and writing                             
  Data should be fast to retrieve                                            
  Allow data migration from the current data store                           
  Have high availability                                                     
  Easy to update the schema                                                  
  Easily maintainable querying                                               
  Manage relationships between all the entities                              

![Help outline](ppt/media/image20.png "Graphic 10")

![Badge Cross with solid fill](ppt/media/image22.png "Graphic 12")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 14")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 15")

![Help outline](ppt/media/image20.png "Graphic 17")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 19")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 20")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 22")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 23")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 25")

![Badge Cross with solid fill](ppt/media/image22.png "Graphic 27")

![Help outline](ppt/media/image20.png "Graphic 28")

![Help outline](ppt/media/image20.png "Graphic 30")

![Help outline](ppt/media/image20.png "Graphic 31")

## Data Store Options {#slide-55}

  Requirement                                        Relational   Document   Graph
  -------------------------------------------------- ------------ ---------- -------
  Data must be accurate when reading and writing                             
  Data should be fast to retrieve                                            
  Allow data migration from the current data store                           
  Have high availability                                                     
  Easy to update the schema                                                  
  Easily maintainable querying                                               
  Manage relationships between all the entities                              

![Help outline](ppt/media/image20.png "Graphic 10")

![Badge Cross with solid fill](ppt/media/image22.png "Graphic 12")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 14")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 15")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 16")

![Help outline](ppt/media/image20.png "Graphic 17")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 18")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 19")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 20")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 21")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 22")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 23")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 24")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 25")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 26")

![Badge Cross with solid fill](ppt/media/image22.png "Graphic 27")

![Help outline](ppt/media/image20.png "Graphic 28")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 29")

![Help outline](ppt/media/image20.png "Graphic 30")

![Help outline](ppt/media/image20.png "Graphic 31")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 32")

## ADR: We will use a Graph Database {#slide-56}

Meeting all requirements and enabling fast querying as a bonus

## Slide 57

![A picture containing text, watch

Description automatically generated](ppt/media/image26.png "Picture 4")

Schema

## Data Store {#slide-58}

How we store data affects the system

![](ppt/media/image3.png "Audio 2")

## Data Store Options {#slide-59}

  Requirement                                        Relational   Document   Graph
  -------------------------------------------------- ------------ ---------- -------
  Data must be accurate when reading and writing                             
  Data should be fast to retrieve                                            
  Allow data migration from the current data store                           
  Have high availability                                                     
  Easy to update the schema                                                  
  Easily maintainable querying                                               
  Manage relationships between all the entities                              

![Help outline](ppt/media/image20.png "Graphic 10")

![Badge Cross with solid fill](ppt/media/image22.png "Graphic 12")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 14")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 19")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 22")

![Badge Cross with solid fill](ppt/media/image22.png "Graphic 27")

![Help outline](ppt/media/image20.png "Graphic 30")

![](ppt/media/image3.png "Audio 1")

## Data Store Options {#slide-60}

  Requirement                                        Relational   Document   Graph
  -------------------------------------------------- ------------ ---------- -------
  Data must be accurate when reading and writing                             
  Data should be fast to retrieve                                            
  Allow data migration from the current data store                           
  Have high availability                                                     
  Easy to update the schema                                                  
  Easily maintainable querying                                               
  Manage relationships between all the entities                              

![Help outline](ppt/media/image20.png "Graphic 10")

![Badge Cross with solid fill](ppt/media/image22.png "Graphic 12")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 14")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 15")

![Help outline](ppt/media/image20.png "Graphic 17")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 19")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 20")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 22")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 23")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 25")

![Badge Cross with solid fill](ppt/media/image22.png "Graphic 27")

![Help outline](ppt/media/image20.png "Graphic 28")

![Help outline](ppt/media/image20.png "Graphic 30")

![Help outline](ppt/media/image20.png "Graphic 31")

![](ppt/media/image3.png "Audio 1")

## Data Store Options {#slide-61}

  Requirement                                        Relational   Document   Graph
  -------------------------------------------------- ------------ ---------- -------
  Data must be accurate when reading and writing                             
  Data should be fast to retrieve                                            
  Allow data migration from the current data store                           
  Have high availability                                                     
  Easy to update the schema                                                  
  Easily maintainable querying                                               
  Manage relationships between all the entities                              

![Help outline](ppt/media/image20.png "Graphic 10")

![Badge Cross with solid fill](ppt/media/image22.png "Graphic 12")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 14")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 15")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 16")

![Help outline](ppt/media/image20.png "Graphic 17")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 18")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 19")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 20")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 21")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 22")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 23")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 24")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 25")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 26")

![Badge Cross with solid fill](ppt/media/image22.png "Graphic 27")

![Help outline](ppt/media/image20.png "Graphic 28")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 29")

![Help outline](ppt/media/image20.png "Graphic 30")

![Help outline](ppt/media/image20.png "Graphic 31")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 32")

![](ppt/media/image3.png "Audio 1")

## Decision: We will use a Graph Database {#slide-62}

Meeting all requirements and enabling fast complex querying as a bonus

![](ppt/media/image3.png "Audio 1")

## Tickets are a problem. {#slide-63}

Our biggest problem.

## Slide 64

![Diagram

Description automatically generated](ppt/media/image27.png "Picture 4")

Overview

## Ticket Domain {#slide-65}

![Diagram

Description automatically generated](ppt/media/image28.png "Content Placeholder 4")

ADR: 006 We will separate Ticket-Management

## Ticket Domain {#slide-66}

![Diagram

Description automatically generated](ppt/media/image28.png "Content Placeholder 4")

ADR: 006 We will separate Ticket-Management

## Ticket Domain {#slide-67}

![Diagram

Description automatically generated](ppt/media/image28.png "Content Placeholder 4")

ADR: 006 We will separate Ticket-Management

## Ticket Domain {#slide-68}

![Diagram

Description automatically generated](ppt/media/image28.png "Content Placeholder 4")

ADR: 006 We will separate Ticket-Management

## Ticket Domain {#slide-69}

![Diagram

Description automatically generated](ppt/media/image28.png "Content Placeholder 4")

ADR: 006 We will separate Ticket-Management

## Ticket Domain {#slide-70}

![Diagram

Description automatically generated](ppt/media/image28.png "Content Placeholder 4")

ADR: 006 We will separate Ticket-Management

## Ticket Domain {#slide-71}

![Diagram

Description automatically generated](ppt/media/image28.png "Content Placeholder 4")

ADR: 006 We will separate Ticket-Management

## Ticket Domain {#slide-72}

![Diagram

Description automatically generated](ppt/media/image28.png "Content Placeholder 4")

ADR: 006 We will separate Ticket-Management

## Tickets are a problem. {#slide-73}

Our biggest problem.

![](ppt/media/image3.png "Audio 7")

## Ticket Domain {#slide-74}

![Diagram

Description automatically generated](ppt/media/image28.png "Content Placeholder 4")

ADR: 006 We will separate Ticket-Management

![](ppt/media/image3.png "Audio 10")

## Ticket Domain {#slide-75}

![Diagram

Description automatically generated](ppt/media/image28.png "Content Placeholder 4")

ADR: 006 We will separate Ticket-Management

![](ppt/media/image3.png "Audio 3")

## Roadmap {#slide-76}

Migrating to the new system

## Migration  Iteration 1 {#slide-77}

![Diagram

Description automatically generated](ppt/media/image29.png "Content Placeholder 8")

## Migration  Iteration 1 {#slide-78}

![Diagram

Description automatically generated](ppt/media/image29.png "Content Placeholder 8")

## Migration  Iteration 1 {#slide-79}

![Diagram

Description automatically generated](ppt/media/image29.png "Content Placeholder 8")

## Migration  Iteration 1 {#slide-80}

![Diagram

Description automatically generated](ppt/media/image29.png "Content Placeholder 8")

## Migration  Iteration 1 {#slide-81}

![Diagram

Description automatically generated](ppt/media/image29.png "Content Placeholder 8")

![Close with solid fill](ppt/media/image30.png "Graphic 12")

## Migration Goal {#slide-82}

![Diagram

Description automatically generated](ppt/media/image32.png "Content Placeholder 5")

## Migration Goal {#slide-83}

![Diagram

Description automatically generated](ppt/media/image32.png "Content Placeholder 5")

Website

Phone App

## Roadmap {#slide-84}

Migrating to the new system

![](ppt/media/image3.png "Audio 1")

## Migration  Iteration 1 {#slide-85}

![Diagram

Description automatically generated](ppt/media/image29.png "Content Placeholder 8")

![](ppt/media/image3.png "Audio 7")

## Migration  Iteration 1 {#slide-86}

![Diagram

Description automatically generated](ppt/media/image29.png "Content Placeholder 8")

![](ppt/media/image3.png "Audio 4")

## Migration  Iteration 1 {#slide-87}

![Diagram

Description automatically generated](ppt/media/image29.png "Content Placeholder 8")

![Close with solid fill](ppt/media/image30.png "Graphic 12")

![](ppt/media/image3.png "Audio 4")

## Migration Goal {#slide-88}

![Diagram

Description automatically generated](ppt/media/image32.png "Content Placeholder 5")

![](ppt/media/image3.png "Audio 10")

## Deployment {#slide-89}

Enabling scalability, elasticity and fault-tolerance

![](ppt/media/image3.png "Audio 1")

## Containerisation {#slide-90}

![](ppt/media/image33.png "Content Placeholder 11")

## Fault Tolerance {#slide-91}

Container 

Service A

Container

Service B

Container

Service C

Container 

Service A

![Close with solid fill](ppt/media/image30.png "Graphic 18")

## Fault Tolerance {#slide-92}

Container 

Service A

Container

Service B

Container

Service C

Container 

Service A

![Close with solid fill](ppt/media/image30.png "Graphic 18")

## Fault Tolerance {#slide-93}

Container 

Service A

Container

Service B

Container

Service C

Container 

Service A

![Close with solid fill](ppt/media/image30.png "Graphic 18")

## Deployment {#slide-94}

Enabling scalability, elasticity and fault-tolerance

![](ppt/media/image3.png "Audio 1")

## Containerisation {#slide-95}

![](ppt/media/image33.png "Content Placeholder 11")

![](ppt/media/image3.png "Audio 9")

## Tickets are a problem. {#slide-96}

We need to act quickly.

![](ppt/media/image3.png "Audio 3")

## Solution Summary {#slide-97}

Reliability

Data Integrity  

Workflow

Scalability/Elasticity  

Availability

Maintainability  

Testability

Fault-Tolerance

Agility

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 18")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 20")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 21")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 22")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 23")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 24")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 25")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 26")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 27")

![](ppt/media/image3.png "Audio 4")

## Solution Summary {#slide-98}

Reliability

Data Integrity  

Workflow

Scalability/Elasticity  

Availability

Maintainability  

Testability

Fault-Tolerance

Agility

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 18")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 20")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 21")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 22")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 23")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 24")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 25")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 26")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 27")

![](ppt/media/image3.png "Audio 3")

## Slide 99

![Woman on a call shocked](ppt/media/image4.png "Picture 7")

![Male student raised hands](ppt/media/image5.png "Picture 9")

![Old woman thumbs down](ppt/media/image6.png "Picture 11")

![Businessman hand on face](ppt/media/image7.png "Picture 13")

My laptop won't turn on, and when I called your operator said the ticket system was down!

I needed help with my electric hob but the website wouldn't load!

The person who showed up couldn't fix my printer!

I stayed in all day and no one showed up!

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 10")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 12")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 14")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 15")

![](ppt/media/image3.png "Audio 2")

![Old woman hands together](ppt/media/image34.png "Picture 4")

![Male student thumbs up smiling](ppt/media/image35.png "Picture 6")

![Woman hands together](ppt/media/image36.png "Picture 20")

![Businessman cheering one hand](ppt/media/image37.png "Picture 22")

## Slide 100

![Businessman confused](ppt/media/image8.png "Picture 9")

![Casual woman writing on notepad](ppt/media/image9.png "Picture 5")

I knew I had a job to go to, but the ticket information wouldn't load!

It was so embarrassing having to say the system had sent the wrong person!

![Woman in wheelchair](ppt/media/image10.png "Picture 2")

The system keeps freezing up and when we make changes something else breaks!

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 8")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 12")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 13")

![](ppt/media/image3.png "Audio 3")

![Casual woman smiling](ppt/media/image38.png "Picture 15")

![Woman in wheelchair thumbs up](ppt/media/image39.png "Picture 17")

![Businessman hand on hip](ppt/media/image40.png "Picture 6")

## Slide 101

![People sitting on blue chairs](ppt/media/image11.jpeg "Picture 2")

Customers will be cancelling their contracts and going elsewhere.

The brand image is being tarnished.

We are throwing money down the drain!

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 6")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 7")

![Badge Tick with solid fill](ppt/media/image24.png "Graphic 8")

![](ppt/media/image3.png "Audio 1")

## Questions? {#slide-102}

The Mad Katas

https://github.com/tekiegirl/TheMadKatas/

![](ppt/media/image3.png "Audio 1")
