# Context
In addition to the [previous ADR](./adr003-archiving-data-for-analytics.md) that talks about separating operational data from general purpose gathering of data for analytics, we have some other data related requirements. An annual report must be shown to users to help with engagement. The report will include things like trends and statistics in their trips.

# Decision
Gathering the data for the reports will be done in the [Data Analytics system](../ContainerView/data-analytics.md). A dedicated container will consumer travel events from the event bus and store them its dedicated database where reports can later be generated from.

# Consequences
- This can be the beginning of a Data Mesh where reports before a product of their own and are not directly tied to the booking system.
- Data will be duplicated between operational and analytical systems. This is a hit we are willing to take given the nature of the data is not used for any critical paths and therefor eventual consistency will be sufficient.