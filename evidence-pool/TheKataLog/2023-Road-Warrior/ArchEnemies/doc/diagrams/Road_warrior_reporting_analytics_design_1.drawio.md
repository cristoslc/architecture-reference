# Road_warrior_reporting_analytics_design_1

*Extracted text labels from `Road_warrior_reporting_analytics_design_1.drawio`*

- Booking storage
- Processed storage
- Reporter:Scheduled runs of extracting reporting metrics
- User
- Data transformer: transform raw data into clean metrics, (handle data quality)
- Data extraction: Abstraction on the rest of the system
- Supporting flows:Yearly reports to individual usersAnalytical exports to 3rd parties
- Exporter:Scheduled runs of extracting analytical metrics
- 3rd party
- Examples of analytics to monetize:Top source/destinations (Where do people fly/hotel/car to the most?)Seasonality (which time of year is the hottest?)Problems (Top canceled destinations/agancies/)Costs (? Avg $$$ spent per trip)...Etc
- Examples of data to report:Number of trips Longest tripShortest tripMost travelled monthCost (?)...etc.
- Requirements:Analytical exports is the main revenue generation.Scalability -> user growth -> more processing, more metricsElasticity -> vary processing based on active bookings todayData integrity -> data is delivered to the destination (user/3rd party)Extensibility -> easily add a new metric for exporting.Performance (? depending on exporter type?) -> metrics are exported sufficiently fast
- Do we need a separate storage? To support some technical requirements? Scalability/performance?Is it only a logical separation and both can reside in the same database, but different tables?
- Reporter and exporter are logically doing the same very similar, but support different business functions, so perhaps can be separated for better adherence to technical requirements?
- The type of exporting can be different. Dashboards, subscription to topics/api. Needs to be extensible, elastic (?)
