# Table of Contents
1. [Introduction](https://github.com/intelligent-growth-solutions/flexibility-fertilisers/blob/main/Requirements/requirements-user-stories.md#introduction)  
1. [Business Case](https://github.com/intelligent-growth-solutions/flexibility-fertilisers/blob/main/Requirements/requirements-user-stories.md#business-case)
1. [Assumptions](https://github.com/intelligent-growth-solutions/flexibility-fertilisers/blob/main/Requirements/requirements-user-stories.md#assumptions)
1. [User Stories](https://github.com/intelligent-growth-solutions/flexibility-fertilisers/blob/main/Requirements/requirements-user-stories.md#user-stories)
1. [High Level Scenarios](https://github.com/intelligent-growth-solutions/flexibility-fertilisers/blob/main/Requirements/requirements-user-stories.md#straw-man-use-cases)
   
# Introduction
Do you travel frequently? Do you book stays, flights, cars, buses and trains? Are you frustrated by trying to keep track of all of your travel arrangements by sifting through your email and the different travel providers’ apps? 
The Road Warrior offers a single point of truth for all your travel arrangements. Hotels, cars, flights, trains, buses, all arranged into a simple trip-centred interface.
# Business Case
## Mission
To be the platform that frequent travellers and travel marketers rely on for accurate travel information.
## Problem statement
-	I can’t keep track of my travel reservations across emails and provider-specific apps. I worry that I will miss messages about checking in, delays or cancellations.
-	There are few ways to get a consolidated view of traveller information. Providers, marketers and researchers cannot easily piece together trends for end-to-end travel
## Non-Functional Requirements
-	Platform is expected to have 2 million active users / week with a total 15 million user accounts
o	On a weekly basis usage will most likely have peaks between Sunday-Monday and Thursday-Friday, as most of the customer base is expected to be business travel
o	Major travel disruptions such as storms and other large events will cause dramatic peaks in some areas of the software
-	The Road Warrior will monetize its data, which may mean large queries being run against its data.
-	Users must be able to access the system from around the world at all times
-	Updates to travel arrangements must be communicated to The Road Warrior users within 5 minutes after generation from the source
-	Our customers are very demanding for performance. First-contentful paint should occur under 1.4 seconds

# Assumptions
-	Travel bookings are made elsewhere. The app is used for managing/tracking/viewing
-	Road Warrior will not process payments for adjustments to bookings. Those will be handled by the Travel Agencies
-	Travel information will be from APOLLO and SABRE, via the open API provided by those systems, while problem resolution will be done via preferred travel agencies
-	“Preferred travel agency” means agencies that have established a relationship with Road Warrior and that provide an API for customer support
-	Data customers will access the data via API and this data does not need to be real-time
	
# User Stories
## Road Warriors
As a road warrior, I want the app to automatically add travel arrangements to my itinerary from my email

As a road warrior I want to use multiple email accounts so I can track my personal and work travel arrangements in one place.

As a road warrior, I want to add travel arrangements manually if I don’t receive an email or the app misses one

As a road warrior I want my itineraries to be automatically organized into trips so I don’t have to waste time arranging things in the app

As a road warrior I want to view my travel history so I can make sense of the blur of airports and hotels that is my memory

As a road warrior I want to be notified of all changes to my upcoming travel

As a road warrior I want to set my notifications settings so I can decide what I need to be informed of

As a road warrior I want to decide what travel agencies I interact with

As a road warrior I want to chat with the travel agencies so I can easily and comfortably adapt my travel plans as needed

As a road warrior I want to share my itinerary with co-workers and family

## The Agent
As a preferred travel agent, I want to be confident that whom I am talking to is the person who arranged travel

As a preferred travel agent I want to use my own customer support system to respond to requests

As a preferred travel agent, I want all of The Road Warrior’s travel information to be available to me while working with them

## The Data Team
As a data scientist, I want to run queries against The Road Warrior’s data to find travel trends. For example
-	What routes are people traveling for key destinations?

How often are our customers having their travel disrupted? Where are the most common disruptions? What do people do when their travel is disrupted? How can we monetise this?

# Straw Man Use Cases
## Automated Itinerary Discovery
1.	Alfred books a trip using his work travel agency and receives an email in his work inbox
2.	The Road Warrior scans the email for details
3.	The Road Warrior finds the travel details in the relevant travel systems
4.	The Road Warrior uses the details to create a new trip
5.	Alfred adds a car reservation in the same time period and destination and receives an email confirmation
6.	The Road Warrior scans the email and adds that car reservation to the trip
7.	Alfred shares the details on WhatsApp with his family
8.	The airline delays Alfred’s flight. 
9.	The Road Warrior learns of the delay and informs Alfred
10.	Alfred’s plans change and he has to leave a day later
11.	Alfred contacts the travel agent via The Road Warrior and changes his return flight
12.	Alfred’s partner looks at the shared itinerary and sees the most recent version
13.	Alfred completes his trip
14.	The Road Warrior archives his trip details, including any delays or changes

## Manual Itinerary Entry
1.	Alfred enters the confirmation code
2.	The Road Warrior finds the relevant information and asks Alfred to confirm the details
3.	Alfred adds some details not included with the confirmation number (?)
4.	Alfred removes the hotel because he doesn’t want his boss knowing he’s staying at the golf resort
