# System Architecture

While identifying suitable architecture style for [the system](/doc/adr/0002-architecture-style.md), 
we identify microservices and event driven as prominant arch styles.

Furthermore, we identified

- The key feature of the system is to act upon the **event** when an update in booking has taken place in original system and reflect in the system in real time. This event should trigger workflow to update the booking details in our system and notify the user.

- Another flow of receiving booking details from email is similar in nature. In particular, an **event** of receiving an email with booking details, triggers the flow to add/update the booking into system. 

- System has strong analytics scope and aspiration for which data will be moved from booking storage to analytics storage ([ADR-00003](/doc/adr/0003-dedicated-db-for-analytics-usage.md)). Along with benefits of event driven architecture style, with growing industry demand of near real time data for analytics, it makes strong case to consider update in booking system as **event** which triggers copy of the this update to analytics db. 

Among our most suitable architecture styles, Microservices is a revolutionary arch style and offers great value in many characteristics including scalability and elasticity but lacks severely in performance and cost. Along with this, since we do not have many services, it will add additional complexity to have microservices architecture implemented in this case. 

On the other hand, The system requirements are around event based activities and Event driven arch style scores astonishingly well in performance and fault-tolerance. It is not the costliest and does quite well in elasticity. 
