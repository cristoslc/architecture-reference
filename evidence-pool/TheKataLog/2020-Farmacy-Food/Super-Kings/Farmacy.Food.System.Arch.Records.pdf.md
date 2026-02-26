This document contains four sections. The first section describes the requirements. The
second section contains architectural characteristics analysis. The third section presents the
architectural design. The fourth section presents the architectural decision records.
The Problem (Kata)
Farmacy Food
Founder: Kwaku Osei
Farmacy Food is a tech-enabled healthy food startup that takes the “Let food be thy medicine” quote
literally and creates tasty meals around peoples’ dietary needs and active lifestyles to support their
overall well-being. Our mission is to make health and wellness radically affordable and accessible.
Farmacy Food mission: ​https://www.youtube.com/watch?v=9aSLSVAIkoM
Farmacy Food website: ​https://www.farmacyfood.com/


A “ghost kitchen” needs a system to allow users to have visibility of what items are available,
purchase, and pick up items at any one of their points of sale.

Users:​ dozens of automated fridges and representative run kiosks, thousands of customers.

Requirements
   ● Must integrate with 3rd party smart fridges to obtain inventory and purchase activity
   ● Smart Fridges Produce item inventory levels and purchases. The smart fridges have a cloud
      based management system that handles communication with the Smart Fridge so obtaining
      this data would be through an API.
   ● Must integrate with point of sale system at kiosks
   ● The Kiosk is a sublet space inside another business where we will sell our product but have
      an employee handle the transactions through a point of sale. The same data should be
      accessible through the POS systems API’s.
   ● Mobile and Web accessible
   ● Support providing feedback on items of verified purchases and in app surveys
   ● Accept coupons and promotional pricing
   ● Send inventory updates to central kitchen

Long Term Goals
   ● Long term would like to allow multiple vendors to offer items through points of sale
   ● Wants to harvest data to provide personalized recommendations based on users health
      goals, purchase history, and item ratings
Additional Requirements from the interview/research
   ● Support personalized meal choices through profiles (individual-based, family-based, and
       subscription-based)
            ○ Maintain nutrition profiles which include health conditions and dietary restrictions
                (HIPAA regulation)
            ○ Maintain preference profiles which include food preferences
            ○ Maintain location profiles which include pickup location preferences and delivery
                method preferences
            ○ Maintain purchase profiles which include meal selection and frequency in meal
                purchases
   ● Monitor health impact based on meal choices, frequency in meal consumptions, and nutrition
       profile
   ● Browse meal variety and availability of meals (as real time as possible) that meet customers’
       profiles (nutrition, preference, and location). Nutritious information about the meals should
       also be provided.
   ● Purchase meals
            ○ Based on the availability of meals at purchase location
            ○ Based on customers’ profiles
   ● Make real time suggestion for meal choices based on customers’ nutrition profiles (this
       requirement is only applicable to Smart Fridge purchase with a card, and the card is linked to
       a customer’s profile)
   ● Support purchase of meals via
            ○ Mobile app
            ○ Company’s website (email)
            ○ POS
            ○ SMS service
            ○ Smart Fridge
   ● Handle increased number of customer transactions to accommodate the increased number
       of smart fridges and kiosk locations.
   ● Provide visibility of meal availability across the network (network refers to all the smart
       fridges and kiosk locations)
   ● Predict meal stocking needs
            ○ Track purchases at each location
            ○ Track frequency of purchases for each meal
   ● Track meal supplies (inventory)
   ● Support three distribution strategies
            ○ Smart fridges
            ○ Kiosk at coffee shops
            ○ Subscription service where more personalized meals will be provided
   ● Support proxy meal pickup service
   ● Support community funded meal services: Individuals/companies can donate money to
       support specific groups
   ● Support notification service to customers (e.g. promotional offers, health information) via
            ○ Mobile app
            ○ Company’s website
            ○ SMS service
   ●   Support the integration to their backend solutions
           ○ Quickbooks (Accounting)
           ○ Cheftec (Inventory Control, Nutritional Analysis, Purchasing & Ordering)
   ●   Support rating of meal purchases
   ●   Ability to adjust meal prices based on meal expiration dates and on site purchase trends

New Questions
   ● You mentioned that customers can order meals via the mobile app, website, and SMS
      services.
          ○ For mobile purchase, how do customers go about identifying themselves at the smart
              fridges? Will they be scanning their app ID at the smart fridge?
          ○ For website purchase, how do customers go about identifying themselves at the
              smart fridges? Will the smart fridge recognize them by their card on file?
          ○ For SMS purchase, how do customers go about identifying themselves at the smart
              fridges? Will the smart fridge recognize them by a SMS QR code?
   ● Would the ability of adjusting meal prices based on meal expiration dates and on site
      purchase trends be a requirement?

Metrics
   ● No. of customers: 1000 by 2021 (10% of them are projected to be subscription customers
       and will be ordering about 10 meals per week).
   ● No. of meals produced: 400 to 2000 (by Dec 2020)
   ● No. of location: 6 to 8 locations
Architectural Characteristics
Google Sheet link:
https://docs.google.com/spreadsheets/d/1r6S7qjxz4Ch9gOjgk_Tcb6x38g-Rp_oWktzEUxmMIOs
/edit?usp=sharing
Architectural Design (Lucid Chart)
https://lucid.app/invitations/accept/539d7bf4-84ed-4549-b10c-c3ea7ede82a7
Architectural Decision Record
Meal Order Services, Adapter Services, Meal Inventory, Meal
Order History Service, Orchestrator Service, and
Recommendation Service
Status:
Approved

Content:
Customers can order prepared meals through the Farmacy Food system via SMS, website,
mobile application, at POS locations, and at Smart Fridges.

Decision
We created meal order services: SMS/MMS meal order service, POS meal order service, fridge
meal order service, and subscription meal order service. Each service provides nutrition
information of meals, meal availability, and purchase options.

We also created adapter services to handle communications with different types of external
systems (e.g. SMS/MMS software, Toast software, and Smart Fridge software). The meal order
services communicate with the external systems via the adapter services to retrieve meal
availability and place orders.

When customers use the meal order services, they are provided with personalized
recommendation through the recommendation service. Recommendation service uses
information provided by the profile service, satisfaction service, preference service, and health
service.

Orchestrator service is created to handle aggregate requests about an individual customer to
reduce the communications between services. E.g. After the customer logs on via the
authentication and authorization service, the meal order service would make a request to the
orchestrator service to identify the pickup location, payment methods, and other profile related
information. The meal order service can then display the meal availability based on the
preferred pickup location. If the customer proceeds in placing an order, the meal order service
can use the preferred payment method for the meal order.

The adapter services update the meal order history service after an order is placed, paid, and
picked up. They also update the meal inventory aggregator after an order is placed. It provides
visibility of meal availability across all smart fridges and POSs. This design also takes walk-in
purchases into consideration.
Consequences
Having one service per transaction type increases the complexity of the system. However, the
design allows for scalability, elasticity, and extendability.
Notification Service
Status:
Approved

Content:
The Farmacy Food system generates notifications to customers via mobile application, email,
and SMS services. Notifications include promotional offers, health information, and reminders
to pick up orders. This can be done via 3 services (Application notification service, email
notification service, and SMS notification service) or one service (notification service).

Decision
We used one service to handle the responsibility of generating and sending different types of
notifications.

We made an assumption that the throughput for notification service using SMS, email, and via
application notification would be similar. If the performance metrics for the three services would
be significantly different, then we would split the notification service into three services, namely
SMS notification service, email notification service, and application notification service.

Consequences
The service will need to have three protocol adapters, one for each communication protocol.
Health Service
Status:
Approved

Content:
The Farmacy Food system stores health conditions and dietary restrictions. It uses the provided
health information as one of the criteria in making meal recommendations. It also tracks the
health impact based on meal selections, frequency in meal consumptions, and the provided
health information.

Decision
Health service is responsible for storing all health related information and performing health
related analysis. The data at rest are encrypted at the database level. Access is controlled by
the authentication and authorization service. All communications between health service, profile
service, and recommendation service are encrypted. The system uses audit service to log and
audit every transaction involving the health service. Health service should be located in a
private container/virtual machine that has a firewall.

Consequences
There could be a potential performance penalty.
