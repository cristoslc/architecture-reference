## Arch Katas {#slide-1}

Buland  Malik

## Slide 2

Security

Availability

Elasticity

Performability

Extensibility

Scalability

Configurability

Reliability

R1:  Add a new system to manage customer profiles, allowing community engagement, personalization around preferences and dietary needs 

R2:  Support geographical trend analysis to hone Farmacy Family's ability to optimize the foods delivered to fridges  ( an additional integration point TO Farmacy Foods ) 

R3:  Support both push and pull models for community engagement. In other words, Farmacy Family will manage forums, emails, and create connections between similar demographics. Farmacy Family needs transactional member information for outreach purposes. The engagement model includes subscriptions, forums, reference material, class information, and other media that supports Food-as-medicine

  R4:  eDietian  has access customer profile to improve advice and monitoring of customers. Additionally, the customer and dietitian can interact via messages. 

R5:  Farmacy Family wants to improve the distribution and potential food waste from having the wrong mix of foods in a particular fridge. 

R6:  Farmacy Family will include medical profile information and the ability to share information with medical service providers. 

R7:  Farmacy Family customers can customize how much profile information they want to allow the community to see, at a fine- grained level. 

R8:  Farmacy Family has relationships with third party providers(clinics, doctors,  etc ) that have access to more analytical data to improve engagement (for example, regional dietary observations). 

R9:  Add Farmacy Family user interface to existing Foods interface, which is currently a Reactive monolith. Create a holistic UX for both food and Farmacy Family to support engagement model.

R10:  The new system must seamlessly incorporate into Farmacy Foods. 

 R11:  Improved use of analytics driven through the new integration of Farmacy Family will help gather new investors and prove better dietary outcomes in member communities. 

## Component Decomposition {#slide-3}

![](ppt/media/image1.png "Picture 4")

## Step 1: Component Identification {#slide-4}

Avoid "Entity Trap"

Too many entities like Manager X, Manager B

No need to define 1:1 relationship

Use Workflow Approach (Event Storming DDD Concept)

Crate Order -\> Add Items -\> Place Order -\> Fulfill Order -\> Ship Order

\*\*\*\*\* Actor/Action Approach

Customer

	Signup to become Engage Customers (Provide Profile Info)

	Configure Preferences

		Customer Info Community can see	

		Can be shared with medical service providers

	Create Forums

	Engage in Social events (classes, forums, wellness education programs)

	Engage with doctors & Dieticians

Dieticians

	Access Customer Profile

	Update Customer Profile

	Engage with Customers

System

	Integrate with Clinics

	Integrate with  eDieticians

	Integrate with Farmacy Food

	Integrate with Generic Components (Notifications, Reports etc.)

	Gather Customer results and store it in Data Lake via Ingestion process

	Payments/Procurements???

Analytics

	Gather results from data lake and run ML Models

	Store Customer/Geographical suggestions/trends suggested by ML 

## Step 2 & 3: Assign Requirements to Components {#slide-5}

Customer

	Customer Profile Capture

	Preferences Capture

	Wellness Engagement Models

	Medical Engagement models

Medical Providers

	Gather Results

	Analyze Results

	Give Suggestions/Advise

Dieticians

	Access Customer Profile

	Update Customer Profile

	Engage with Customers

System

	Advertisement (Generating Leads for Email Notification)

	Integration with Clinics

	Integration with  eDieticians

	Integration with Farmacy Food

	Integration with Generic Components (Notifications etc.)

	Payments/Procurements???

	Store customer data in the Data Lake via Ingestion process

	Payments/Procurements???

Analytics

	Gather results from data lake and run run ML Models

	Store Customer/Geographical suggestions/trends suggested by ML

R1

R2

R3

R4

R5

R6

R7

R8

R9

R10

R11

## Step 4: Assign  Illities  to Components {#slide-6}

## Strategic Design {#slide-7}

Customer

Customer Engagement

Analytics

Distillation is the process of identifying the domain, decoupling, isolating, clarifying and making it explicit.

As Eric Evans wrote "Distillation is the process of separating the components of a mixture to extract the essence in a form that makes it more valuable and useful."

Distilling a domain is extremely important to a good strategical design, when doing that, we start to distinguish what is a  Core Domain  from what is just a  Generic Domain   for example and, reducing them to manageable sizes.

https:// thedomaindrivendesign.io /distilling-domain/

System Engagement

eDietician

Clinics

Auth A/Z

Farmacy Food

Advertisement

Notification

via events

conformist

D

U

Via REST API

Via REST API

Via Event

Via Event

## Strategic Design {#slide-8}

Uniqueness

Complexity

Core

Customer

Analytics

Customer Engagement

System Engagement

Generic

Notification

Payments??

Supportive

Email/Text Messaging

Advertisement

Scheduling

AuthN  &  AuthZ

## Choose Architecture Style(s) {#slide-9}

## Architecture Decision Records (ADRs) {#slide-10}

## Analytics {#slide-11}

Domain Events

Stream Ingestion

Farmacy Data Lake

Analytics Processor

Raw data

ML Training

ML Model

Analytics Processor

ML Store

## Appendix {#slide-12}

## Domain-Driven Design Learning Map {#slide-13}

![DDD - Domain Driven Design - Learning Map](ppt/media/image35.png "Picture 2")
