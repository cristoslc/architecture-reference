Farmacy Food Architecture Proposal




                                     selfdriventeam
Farmacy Food Kata
Farmacy Food is a tech-enabled healthy food startup that creates
tasty meals around people's dietary needs and active lifestyles to
support their overall well-being.

Their mission is to make health and wellness radically affordable and
accessible.




                                                                     selfdriventeam
Problem Statement
A “ghost kitchen” needs a system to allow users to have visibility of
what items are available, purchase, and pick up items at any one of
their points of sale.




                                                                        selfdriventeam
Requirements
Users: Dozens of automated fridges and representative run kiosks, thousands of customers.
 1. Must integrate with 3rd party smart fridges to obtain inventory and purchase activity Smart
     Fridges Produce item inventory levels and purchases.
 2. Must integrate with point of sale system at kiosks
 3. Mobile and Web accessible
 4. Support providing feedback on items of verified purchases and in app surveys Accept
     coupons and promotional pricing
 5. Send inventory updates to central kitchen
 6. Would like to allow multiple vendors to offer items through points of sale
 7. Wants to harvest data to provide personalized recommendations based on users health
     goals, purchase history, and item ratings


                                                                                  selfdriventeam
  User Stories
Alice is a Farmacy Food chef.          Scott is an occasional Farmacy
                                       Food eater, but not a member.

Claire is a Farmacy Food business      Jennifer is a Farmacy Food
analyst.                               subscriber, she likes to eat healthy.

Edward is a Farmacy Food delivery      Barbara works at the corner coffee
person.                                shop.

Mark is a Farmacy Food nutritionist.

                                                                           selfdriventeam
Challenges
●   Time To Market
●   3rd Party Integrations
●   Data Security
●   Future Growth




                             selfdriventeam
Decisions:
 ● Microservice Based
 ● S.O.L.I.D Base
 ● Scalable Domains
 ● Architecture
      Characteristics




                 selfdriventeam
     Customers

Decisions:
 ● PII must be anonymized
 ● REST API between components
 ● 3rd party health hooks into the
      customer info

Characteristics:
 ● Adaptable
 ● Security
 ● Extensible

                                     selfdriventeam
     Orders

Decisions:
 ● No separate delivery component

Characteristics:
 ● Reliable
 ● Durable
 ● Low latency


                                    selfdriventeam
     Billing

Decisions:
 ● Separate payments engine for
      billing

Characteristics:
 ● Durable
 ● Security
 ● Accurate
 ● Customizable (Coupon and
     promotions)

                                  selfdriventeam
     Inventory
Decisions:
 ● Use queue to update the inventory
      and external notification
 ● Stock monitoring and inventory
      update mechanism

Characteristics:
 ● Trackable
 ● Accurate
 ● Consistent
 ● Customizable (3rd party vendor)

                                       selfdriventeam
     Recommendations

Decisions:
 ● Hybrid approach for
      recommendation component
 ● Recommendation engine is a batch
      system

Characteristics:
 ● Security
 ● Customizable

                                      selfdriventeam
     Notifications

Decisions:
 ● Use a centralized notification for
      external communication

Characteristics:
 ● Scalable
 ● Highly Available
 ● Durable
 ● Reliable


                                        selfdriventeam
  Gateway/UI
Decisions:
 ● Using External Identity Provider
 ● Component level authorization
      rules for access control
 ● Use mobile friendly web app

Characteristics:
 ● Gateway:
       ○ Security
       ○ Available
       ○ Reliable
 ● UI
       ○ Responsive and reliable
       ○ Flexible
       ○ Accessibility                selfdriventeam
Ready for Today
Ready for the Future
●   Time To Market           ●   Data Security
     ○ Casual Users               ○ Financials
     ○ Subscription Users         ○ PII
     ○ Employees             ●   Future Growth
●   3rd Party Integrations        ○ New Partners
     ○ POS                        ○ Market Penetration
     ○ Partners                   ○ Geographic Expansion

                                                           selfdriventeam
Thank You
Additional Info                   SelfDrivenTeam:
     O'Reilly Kata Page            ● Alex Torok
     FarmacyFoods                  ● Ankit Aggarwal
     SelfDrivenTeam Github Repo    ● Leon Rosenshein
                                   ● Shaw Xu
                                   ● Z Wang




                                                       selfdriventeam
