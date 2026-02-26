## Architecture Proposal {#slide-1}

![](ppt/media/image1.jpeg "Picture 2")

Farmacy Food Case

![](ppt/media/image2.png "Audio 13")

## Business Goals {#slide-2}

A "ghost kitchen" (cooking facility set up for the preparation of delivery-only meals.) needs an  ordering system to allow users to have visibility of what items are available, purchase, and pick-up items at  any one of their  points of sale / smart-fridge .

Business Drivers (BD)

System support and engage occasional users to purchase to increase the user base, converting Occasional users to Known users and Known users to Subscribers.

System provides rich options for engaging known users and subscribers by different kinds of loyalty programs. New options are easily added to increase user satisfaction and a chance of recommendation.

System provides information about consumed meals and on-demand requests to support Ghost Kitchen management.

System should be easy to use for inexperienced users to increase the user base.

Sustainable usage of service.

Involve other specialists in health areas to increase userbase.

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

![](ppt/media/image2.png "Audio 12")

## Assumptions {#slide-3}

Assumptions

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

![](ppt/media/image2.png "Audio 7")

## Slide 4

Dev Team

Time-to-Market

Platform

Budget

Smart Fridges

Ghost Kitchen

PoS  Terminals

User App

Feedback 

![](ppt/media/image12.png "Picture 23")

![](ppt/media/image13.png "Picture 25")

![](ppt/media/image14.png "Picture 27")

![](ppt/media/image15.png "Picture 29")

![](ppt/media/image16.png "Picture 31")

![](ppt/media/image17.png "Picture 33")

![](ppt/media/image18.png "Picture 35")

![](ppt/media/image19.png "Picture 37")

Constraints and Scope

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

![](ppt/media/image20.png "Picture 43")

![](ppt/media/image15.png "Picture 44")

![](ppt/media/image20.png "Picture 45")

![](ppt/media/image2.png "Audio 2")

## Significant Architectural Drivers {#slide-5}

  \#   Significant Architectural Drivers (SAD)                                                             From BD
  ---- --------------------------------------------------------------------------------------------------- ------------
  1    System support cash and electronic payments                                                         1
  2    Pluggable system of feedback, survey, review abilities                                              1, 2
  3    On-time reports about consumed meals from fridges. Breakdown by subscribers and occasional buying   3
  4    Scheduling system for subscribers, to avoid repetitive operations of ordering                       1, 3, 4, 5
  5    Ability to purchase without registering first                                                       1, 4, 5
  6    Notification system to inform the user about their orders                                           1, 4, 5
  7    Notifications about new loyalty programs and coupons                                                2, 5
  8    Detailed break down of a meal by components in catalog                                              1, 5, 6
  9    Secure payments                                                                                     1, 5
  10   Maximizing guarantee of a meal picking up by user                                                   1, 5

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

![](ppt/media/image2.png "Audio 2")

## Slide 6

Stakeholders

Ghost Kitchen

Subscribers

Known users

Occasional users

Owner

Nutritionists

Developers

Admins

Food suppliers

3rd party kitchens

PoS  Admins

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

![](ppt/media/image2.png "Audio 9")

## Slide 7

Stakeholders

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

  Stakeholder          Concerns
  -------------------- -------------------------------------------------------------------------------------------
  Ghost Kitchen        Get information about prepared and delivered meals consuming to predict supply refilment
                       Get information about on-demand orders
  Subscribers          Create a menu and getting meals on time
                       Get notification about arriving or delayed food to save their time
                       Be informed about meal ingredients
  Known users          Browse catalog and buy food with guarantee of getting it when they come to pick it up
                       Ease of buying process
                       Be informed about meal ingredients
  Occasional users     Visually select a meal, get info about it and pay in the most convinient way at same time
  Owner                Attract all type of users
                       Improve quality of provided food and service
                       Information about users preferences
                       Support for accounting system
  Nutritionists        Search in catalog by specific components
                       Calculation % of fats\\carbs\\vitamins\...
  Developers           Ease of maintaining and developing the system
  Admins               Ease of monitoring
                       Ease of configuration and scaling
  Food suppliers       Predicted plan of purchases and delivery
  3rd party kitchens   Same as for Ghost Kitchen
  PoS Admins           Only meals from fridges installed locally should be visible in the App
                       Ease access to a meal ingredients and allergens
                       Ease of registration selling operation
                       Automatic report generation about selling activity

![](ppt/media/image2.png "Audio 9")

## Slide 8

![](ppt/media/image21.png "Picture 6")

STRATEGIC DOMAIN DESIGN

Solution overview

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

Categorization by Core, Generic and Support  helps identify subdomains and prioritize  development efforts.

Core -- custom made software

Support -- buy and customize 

Generic -- buy 

![](ppt/media/image2.png "Audio 2")

## Slide 9

![](ppt/media/image22.png "Picture 3")

Solution overview

CONCEPTUAL DESIGN

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

![](ppt/media/image2.png "Audio 4")

## Slide 10

![](ppt/media/image23.png "Picture 5")

Solution overview

MODULARIZED MONOLITH(S)

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

![](ppt/media/image2.png "Audio 3")

## Slide 11

Simplicity

We\'d like to provide initial simplicity for the overall system but that do not close the window for further extraction of services and independent development and deployment.

Grouping functional areas to benefit from the ease of development and deployment.

Modifiability

The second important part is to provide points of extensions and ease of modifiability for the proposed solution. It means subparts can be extracted and extended without massive refactoring.

Quality Attributes

DOMINATING

![](ppt/media/image24.png "Picture 13")

![](ppt/media/image25.png "Picture 15")

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

![](ppt/media/image2.png "Audio 3")

## Slide 12

![](ppt/media/image26.png "Picture 3")

Quality Attributes

BY SUBSYSTEMS

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

![](ppt/media/image2.png "Audio 10")

## Slide 13

System Design 

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

![](ppt/media/image27.png "Picture 2")

COMMANDS & EVENTS

![](ppt/media/image2.png "Audio 12")

## Slide 14

System Design 

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

EXTRACTION CASE

![](ppt/media/image28.png "Picture 11")

![](ppt/media/image2.png "Audio 14")

## Slide 15

System Design 

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

MONITORING

![](ppt/media/image29.png "Picture 2")

HealthCheck  end points provide information about: 

- Readiness to start business communication 
- Internal metrics of business request processing 
- Technical metrics (requests rate, failure rate)

![](ppt/media/image2.png "Audio 15")

## Slide 16

![](ppt/media/image30.png "Picture 4")

Information View

MEAL PURCHASE SCENARIO

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

![](ppt/media/image31.png "Picture 14")

  Make Order Request   Length   Size (bytes)
  -------------------- -------- --------------
  user_guid            1        16
  meal_guid            1        16
  kitchen_guid         1        16
  pos_guid                      16
  notes                500      2000
  http_header          300      600

  #Requests   Day     Week     Month     
  ----------- ------- -------- -------- -----
  500         1.27    8.89     35.57    MiB
  1000        2.54    17.78    71.14    MiB
  5000        12.70   88.92    355.68   MiB
  10000       25.41   177.84   711.36   MiB

![](ppt/media/image2.png "Audio 6")

## Slide 17

![](ppt/media/image32.png "Picture 3")

Order cancelation

![](ppt/media/image33.png "Picture 7")

Scheduled order cancelation

CANCELATION SCENARIOS

Information View

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

![](ppt/media/image2.png "Audio 17")

## Slide 18

![](ppt/media/image34.png "Picture 3")

Concurrency View

AVAILABLE NUMBER OF MEALS IN CATALOG

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

![](ppt/media/image2.png "Audio 12")

## Slide 19

![](ppt/media/image35.png "Picture 2")

Concurrency View

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

ACTORS

AVAILABLE NUMBER OF MEALS IN CATALOG

![](ppt/media/image2.png "Audio 12")

## Slide 20

![](ppt/media/image36.png "Picture 3")

Concurrency View

INTERCOMPONENT COMMUNICATION SCENARIO

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

![](ppt/media/image2.png "Audio 12")

## Slide 21

Infrastructure View

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

![](ppt/media/image37.png "Picture 11")

![](ppt/media/image38.png "Picture 13")

Scaling

VPC Design

![](ppt/media/image2.png "Audio 23")

## Slide 22

Security View

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

![](ppt/media/image39.png "Picture 2")

![](ppt/media/image2.png "Audio 6")

## Slide 23

Cost Analysis

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

  Service                     1-year TCO at minimum   1-year TCO at projected growth
  --------------------------- ----------------------- --------------------------------
  EC2                         3,114.96 USD            3,114.96 USD
  VPN                         9.13 USD                9.13 USD
  AMAZON MQ                   508.32 USD              546.72 USD
  AMAZON S3 Buckets           262.32 USD              524.52 USD
  AMAZON Dynamo DB            3,072.00 USD            3,072.00 USD
  Application Load Balancer   TBD                     TBD
  Kafka Managed Streams       138.72 USD              138.72 USD
  Tableau                     1,440.00 USD            1,440.00 USD
  DataDog                     3,336.00 USD            3,336.00 USD
  SNS                         366.12 USD              366.12 USD
  Data Transfer out           TBD                     TBD
  TOTAL                       12,247.57 USD           12,548.17 USD

![](ppt/media/image2.png "Audio 7")

## Slide 24

Risks and Sensitive Points

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

Technical Risks

Payment provider\'s service is temporarily down.

Spawning too many service instances lead to money wastes.

Ghost Kitchen is down and does not provide information about meals availability

Not applying security practices.

Risky releases with significant changes.

Breaking changes in message formats for internal or external services.

Mismatch of production and development environment

Business related risks

The catalog is stale, and reserved food can\'t be dispatched from the selected smart-fridge.

Subscriber\'s menu can\'t be prepared.

Notification about delivery or meal can\'t be delivered by preferred channel.

PoS  app disconnected from the network.

Smart fridge disconnected from the network.

User booked a meal but did not pick it up.

Meal is stuck in the fridge.

![](ppt/media/image2.png "Audio 20")

## Slide 25

Risks and Sensitive Points

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

Technical sensitive points 

Modern cloud scaling technologies allows scaling up for a long time that might postpone decisions about scaling out. 

Service overloaded.        Options: 

- Proactive monitoring
- Circuit breaker
- Dog Pile protection

Business related sensitive points

Subscribers and Known users make an over provisioning situation for a fridge. Not all food can be placed in a fridge.

Order was placed during off hours of Ghost Kitchen.

Review bombing for 3rd party kitchens.

![](ppt/media/image2.png "Audio 12")

## Slide 26

![](ppt/media/image40.png "Picture 18")

![Chart, sunburst chart

Description automatically generated](ppt/media/image3.png "Content Placeholder 6")

Andrei,  Han, Hemanth, Lukasz

https://github.com/ldynia/archcolider

![](ppt/media/image2.png "Audio 4")
