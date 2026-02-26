## O'Rielly  Architecture Katas Autumn 2021 {#slide-1}

Somenath Mukherjee 

Pentagram2021

Farmacy Family System Architecture & Design

## Problem Statement {#slide-2}

Wow, Food as medicine. Bob has been using awesome & delicious food to overcome his health issues with obesity and high blood pressure. He feels lucky that he found this great platform known as Farmacy Food whose slogan is Food As Medicine. He has been sharing this idea widely within his circles and looking more  better ways and means to become an engaged customer  where he can be the  voice of the the great initiative ,  connect with other similar minded people  as well as areas where he can improve to  address his struggles with his medical conditions . 

![SleuthSayers: What&#39;s the Objective?](ppt/media/image2.gif "Picture 4")

## Solution {#slide-3}

We have been thinking about the extension of Farmacy Food as well as heard our customers and we are happy to share that we have started our efforts towards that. The overall idea is to make sure we provide a platform to our huge customer base where they can better  engage themselves , be the voice of the program,  educate themselves via different wellness programs  offered through this new platform, easily able to  engage with medical providers  to get better insights about how their overall health is doing and rely on the platform for better suggestions to improve their health using food as medicine and platform making sure that right food is available in right areas considering all the analytics results which is all based on difference set of customer data.

Farmacy Family

![314,903 Problem Solution Stock Photos and Images - 123RF](ppt/media/image3.jpeg "Picture 2")

## Architecture Characteristics & Style {#slide-4}

## Quality Attributes/ Architecture  Ilities  / Characteristics {#slide-5}

![Farmacy Family Archutecture Illities](ppt/media/image4.png "Picture 2")

## Slide 6

![Calendar

Description automatically generated](ppt/media/image5.png "Picture 3")

Decision is to use

Service-based Architecture Style

Event-Driven

Architecture Styles

## System Design {#slide-7}

## Step 1: Component Identification {#slide-8}

Using Workflow Approach (Event Storming DDD Concept) -  Actor/Action Approach

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

## Step 2 & 3: Assign Requirements to Components {#slide-9}

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

## Strategic Design {#slide-10}

Uniqueness

Complexity

Core

Customer

Analytics

Customer Engagement

System Engagement

Generic

Supportive

Email/Text Messaging

Advertisement

Scheduling

AuthN  &  AuthZ

CMS

Notification

Medical System

## Slide 11

User Journey

![page1image32442672](ppt/media/image6.png "Picture 1")

## Slide 12

![Diagram

Description automatically generated](ppt/media/image7.png "Picture 2")

System Landscape Diagram

## Slide 13

![Diagram

Description automatically generated](ppt/media/image8.png "Picture 2")

Context Diagram

## Slide 14

Farmacy Family  Container Diagram

![Diagram

Description automatically generated](ppt/media/image9.png "Picture 4")

## Slide 15

Farmacy Family Component Diagram

![Diagram

Description automatically generated](ppt/media/image10.png "Picture 2")

## Slide 16

Analytics Container  Diagram

![Graphical user interface, diagram, text

Description automatically generated](ppt/media/image11.png "Picture 2")

## Slide 17

Farmacy Family Deployment Diagram

![Graphical user interface, diagram, application

Description automatically generated](ppt/media/image12.png "Picture 4")

## Key Links {#slide-18}

- Farmacy Family artefacts  root folder
- 
- What went into consideration?

<!-- -->

- Requirements
- Quality Attributes Identification
- ADRs
- Overall Solution

<!-- -->

- 

## Slide 19

![Church Preaching Slide: Shout It Out - SermonCentral.com](ppt/media/image13.jpeg "Picture 4")

Thank You!
