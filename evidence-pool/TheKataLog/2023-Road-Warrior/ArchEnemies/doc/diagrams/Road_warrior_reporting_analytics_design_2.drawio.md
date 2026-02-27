# Road_warrior_reporting_analytics_design_2

*Extracted text labels from `Road_warrior_reporting_analytics_design_2.drawio`*

- Requirements:Analytical exports is the main revenue generation.Scalability -> user growth -> more processing, more metricsElasticity -> vary processing based on active bookings todayData integrity -> data is delivered to the destination (user/3rd party)Extensibility -> easily add a new metric for exporting.Performance (? depending on exporter type?) -> metrics are exported sufficiently fast
- Booking storage
- Analytics storage
- User
- Data exporter
- Data extraction: Abstraction on the rest of the system
- Supporting flows:Yearly reports to individual usersAnalytical exports to 3rd parties
- Analytics exporter
- 3rd party
- Data Analytics Generator
- Front-end
