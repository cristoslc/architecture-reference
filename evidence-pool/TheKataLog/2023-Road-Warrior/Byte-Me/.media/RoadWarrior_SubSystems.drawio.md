# RoadWarrior_SubSystems

*Extracted text labels from `RoadWarrior_SubSystems.drawio`*

## Subsystems and Interactions

- API Getway
- Travel Service Provider
- UI
- Notification Manager
- User Management
- Identity management
- DashboardCoordinator
- Trip Organizer
- Authenticate/Authorize
- Broadcast /Trip updates
- add/delete/update trip
- Customer Service Helpdesk Management
- Helpdesk query
- Trip Sync Manager
- live trip data
- Vendor Management
- Add/Remove vendor
- User Configuration Management
- Trip Summary Provider
- Email Service
- Social Media Service
- Share trip details
- Scrape
- Whitelisting mails
- Generate reports
- Login/Register
- Data Management
- Subsystems and Interactions
- Text
- Data Analystics Provider
- Legend
- Internal components
- Components interfacing with external entities

## Page-1

- 000 All @ 50% opacity
- Authentcate/Authorize
- API Gateway
- live triip data
- Trip Sync Mgr
- Notification Mgr
- add/remove/updatetrip
- Broadcast/Trip updates
- share trip details
- scrape
- generate reports
- Dashboard Mgr
- Hepdesk Mgmt
- Vendor Mgmt
- helpdesk query
- Add/Remove vendors
- Travel Service Provider
- Trip Organizer
- Social Media Service
- Email Service
- get whitelistedemails/filters
- User Config Mgmt
- Trip Summary Provider
- Register
- Get User
- Identity Mgmt
- Add/UpdateUser Profile
- User Mgmt
- Data Mgmt
- UI
- 000 All
- Authentcate/Authorize
- API Gateway
- live triip data
- Trip Sync Mgr
- Notification Mgr
- add/remove/updatetrip
- Broadcast/Trip updates
- share trip details
- scrape
- generate reports
- Dashboard Mgr
- Hepdesk Mgmt
- Vendor Mgmt
- helpdesk query
- Add/Remove vendors
- Travel Service Provider
- Trip Organizer
- Social Media Service
- Email Service
- get whitelistedemails/filters
- User Config Mgmt
- Trip Summary Provider
- Register
- Get User
- Identity Mgmt
- Add/UpdateUser Profile
- User Mgmt
- Data Mgmt
- UI
- 001 Register new user
- API Gateway
- Register
- Add/UpdateUser Profile
- User Mgmt
- Data Mgmt
- UI
- Register New User
- 002 Login
- Authentcate/Authorize
- API Gateway
- Dashboard Mgr
- Get User
- return bearer token
- informs of active user login
- Identity Mgmt
- Add/UpdateUser Profile
- User Mgmt
- Data Mgmt
- UI
- Login/Authenticate1. Authenticate2. Check user against UserMgmt3. Inform Dashboard Mgr of active user [will be useful for further use cases...]4. return valid bearer token5. Valid bearer token is must for all further usecase calls5.1. NOTE: ApiGateway will reject all calls with invalid bearer tokens
- 004 Add Email Whitelist/filters
- API Gateway
- Dashboard Mgr
- Updates
- User Config Mgmt
- Data Mgmt
- UI
- Add E-mail whitelist/ filtersPrecondition: Authenticated and with valid token
- 005 User Ad/Re/Up Trips
- API Gateway
- add/remove/updatetrip
- Dashboard Mgr
- all bookingdetails
- Travel Service Provider
- Updatestrip/booking
- get by PNR
- Trip Organizer
- Data Mgmt
- UI
- User manually adds/updates/deletes bookingPrecondition: Authenticated and with valid token1. Calls Trip Organizer with PNR2. Trip Organizer calls Travel Service Provider for all other details like Start/Emnd dates, Departure Arrival times, gate details, etc3. Commits details by informing Data Management
- 006 Auto update via E-mail polling
- API Gateway
- scrape
- Dashboard Mgr
- Trip Organizer
- Email Service
- get whitelistedemails/filters
- User Config Mgmt
- Data Mgmt
- UI
- Auto update via E-mail pollingPrecondition: Authenticated and with valid token1. Activate E-mail scaping for user2. Get users ehitelist/filters3. Start polling3.1 Inform Trip Organizer of data from E-mail3.2 Trip Organizer will check if data is newer and commit

## Email polling and whitelisting

- Email Polling and whitelisting
- From Dashboard
- white listing emails
- Gmail
- Outlook
- Hotmail
- filtered trip details
- User setting
- trip details
- scrape
- Email Service
- Trip Organizer
- User configuration management
- Legends
- Service Container
- Service
- External components
- Database

## Share Trip details

- From Dashboard
- Instagram
- Facebook
- share trip details
- Social service provider
- Chat service provider
- Whatsapp
- Telegram
- %3CmxGraphModel%3E%3Croot%3E%3CmxCell%20id%3D%220%22%2F%3E%3CmxCell%20id%3D%221%22%20parent%3D%220%22%2F%3E%3CmxCell%20id%3D%222%22%20value%3D%22Trip%20Organizer%22%20style%3D%22rounded%3D1%3BwhiteSpace%3Dwrap%3Bhtml%3D1%3Bshadow%3D0%3Bsketch%3D1%3BfontFamily%3DComic%20Sans%20MS%3BfontSize%3D12%3BfillColor%3D%23dae8fc%3BstrokeColor%3D%236c8ebf%3BfontColor%3D%230000CC%3B%22%20vertex%3D%221%22%20parent%3D%221%22%3E%3CmxGeometry%20x%3D%22222%22%20y%3D%2267%22%20width%3D%22101%22%20height%3D%2246%22%20as%3D%22geometry%22%2F%3E%3C%2FmxCell%3E%3C%2Froot%3E%3C%2FmxGraphModel%3E%3CmxGraphModel%3E%3Croot%3E%3CmxCell%20id%3D%220%22%2F%3E%3CmxCell%20id%3D%221%22%20parent%3D%220%22%2F%3E%3CmxCell%20id%3D%222%22%20value%3D%22Trip%20Organizer%22%20style%3D%22rounded%3D1%3BwhiteSpace%3Dwrap%3Bhtml%3D1%3Bshadow%3D0%3Bsketch%3D1%3BfontFamily%3DComic%20Sans%20MS%3BfontSize%3D12%3BfillColor%3D%23dae8fc%3BstrokeColor%3D%236c8ebf%3BfontColor%3D%230000CC%3B%22%20vertex%3D%221%22%20parent%3D%221%22%3E%3CmxGeometry%20x%3D%22222%22%20y%3D%2267%22%20width%3D%22101%22%20height%3D%2246%22%20as%3D%22geometry%22%2F%3E%3C%2FmxCell%3E%3C%2Froot%3E%3C%2FmxGraphModel%3E
- Social Media
- Trip Organizer
- Social Media Service
- Legends
- Service Container
- Service
- External components
- Database

## User Login/Registration

- API Getway
- bearer token
- Fetch User
- Add/Update user profile
- Authenticate/Authorize
- Web App
- Mobile App
- UI
- Registers
- %3CmxGraphModel%3E%3Croot%3E%3CmxCell%20id%3D%220%22%2F%3E%3CmxCell%20id%3D%221%22%20parent%3D%220%22%2F%3E%3CmxCell%20id%3D%222%22%20value%3D%22Trip%20Organizer%22%20style%3D%22rounded%3D1%3BwhiteSpace%3Dwrap%3Bhtml%3D1%3Bshadow%3D0%3Bsketch%3D1%3BfontFamily%3DComic%20Sans%20MS%3BfontSize%3D12%3BfillColor%3D%23dae8fc%3BstrokeColor%3D%236c8ebf%3BfontColor%3D%230000CC%3B%22%20vertex%3D%221%22%20parent%3D%221%22%3E%3CmxGeometry%20x%3D%22219.5%22%20y%3D%2257%22%20width%3D%22101%22%20height%3D%2246%22%20as%3D%22geometry%22%2F%3E%3C%2FmxCell%3E%3C%2Froot%3E%3C%2FmxGraphModel%3E
- Identity Server
- Identity Management
- Identity Management
- User Management
- Legends
- Service Container
- Service
- Database

## Helpdesk Management

- From Dashboard
- %3CmxGraphModel%3E%3Croot%3E%3CmxCell%20id%3D%220%22%2F%3E%3CmxCell%20id%3D%221%22%20parent%3D%220%22%2F%3E%3CmxCell%20id%3D%222%22%20value%3D%22Identity%20Management%22%20style%3D%22rounded%3D1%3BwhiteSpace%3Dwrap%3Bhtml%3D1%3Bshadow%3D0%3Bsketch%3D1%3BfontFamily%3DComic%20Sans%20MS%3BfontSize%3D12%3BfillColor%3D%23dae8fc%3BstrokeColor%3D%236c8ebf%3BfontColor%3D%230000CC%3B%22%20vertex%3D%221%22%20parent%3D%221%22%3E%3CmxGeometry%20x%3D%22439.5%22%20y%3D%22207.03%22%20width%3D%22101%22%20height%3D%2246%22%20as%3D%22geometry%22%2F%3E%3C%2FmxCell%3E%3C%2Froot%3E%3C%2FmxGraphModel%3E
- Airlines Helpdesk
- Car Helpdesk
- Hotel Helpdesk
- ask help regarding trip
- Indigo
- Delta Airlines
- United Airlines
- Uber
- Ola
- Hertz
- Airbnb
- Beverly Hills
- Uber
- Helpdesk Management
- Travel service provider
- Helpdesk Management
- Legends
- Service Container
- Service
- External components

## Add/update/delete trip

- From Dashboard
- Add/Update/Delete trip
- query trip
- Fetch trip details
- Add/Update/Delete trip details
- Airlines service provider
- Car service provider
- Hotel service provider
- Indigo
- Delta Airlines
- United Airlines
- Uber
- Ola
- Hertz
- Airbnb
- Beverly Hills
- Uber
- Trip Organizer
- Trip Organizer
- Travel Service Provider
- Legends
- Service Container
- Service
- External components
- Database

## Trip Summary Provider

- From Dashboard
- Trip search criteria
- Fetch trip details
- report summary
- Trip Summary
- Travel Summary Provider
- Legends
- Service Container
- Service
- Database
- Data Analytics Service

## Trip Nofiication 

- Airlines service provider
- Car service provider
- Hotel service provider
- Indigo
- Delta Airlines
- United Airlines
- Uber
- Ola
- Hertz
- Airbnb
- Beverly Hills
- Uber
- Fetch live data
- trip updates
- Notification Management
- Notification Manager
- Trip Sync Manager
- Travel Service Provider
- Legends
- Service Container
- Service
- External components
- To Apps
- To Dashboard

## Vendor Management

- D
- Airlines service provider
- Car service provider
- Hotel service provider
- Indigo
- Delta Airlines
- United Airlines
- Uber
- Ola
- Hertz
- Airbnb
- Beverly Hills
- Uber
- Add/Remove vendor
- Admin
- Vendor Management
- DashboardCoordinator
- Travel Service Provider
- Vendor Manager
- Legends
- Service Container
- Service
- External components
- Database

## Travel Service Provider

- Get Details
- Airlines service provider
- Car service provider
- Hotel service provider
- Indigo
- Delta Airlines
- United Airlines
- Uber
- Ola
- Hertz
- Airbnb
- Beverly Hills
- Uber
- Trip Organizer
- Travel Service Provider
- Legends
- Service Container
- Service
- External components
- Database
- Trip Organizer
- from Dashboard

## Page-12

- Deployment View
- Client
- API Getway
- Routing
- Orchestration
- API performance and capacity management
- Security, Identity and Access management
- Analytics
- App Layer
- Data Layer
- App Micro services

## Interaction by Use case

- Register
- API Gateway
- Register
- UI
- Add/UpdateUser Profile
- User Management
- Data Management
- 1. Authenticate
- API Gateway
- Login
- UI
- User Management
- 2. Get User
- 3. returns bearer token
- 4. inform of active user login
- IdentityManagement
- Dashboard Manager
- Add/UpdateEmailFilters
- UI
- Informs
- User Config Management
- Informs
- Dashboard Manager
- Data Management
- Add/UpdateEmailFilters
- UI
- 4. Informs
- Trip Organizer
- 1. activates
- Dashboard Manager
- Data Management
- 2. Get whitelist/Filters
- 3. trip infofound during scraping
- Email Service
- User Config Management
- 3. add/updates
- 1. Request all details for PNR
- Trip Organizer
- Data Management
- 2. returns found updates
- Trip Service Provider
- Manual add/update/deletebookings
- UI
- 4. Informs
- Trip Organizer
- Add/update/delete
- Dashboard Manager
- Data Management

## Data Queue Processing

- Trip Sync manager will aggregate all trip info and commonly polls for update. All the trips subscribe to change notification event through dashboard coordinator to push for notifications.
- Gets detaiils
- Updates
- Travel Service Provider
- DashboardCoordinator
- Aggregates
- Informs  in case of updates from External Services
- Trip Organizer
- Notifications queued
- Read Replicas
- External Travel SitesServices
- Notification Manger
- Legends
- Service Container
- Service
- External components
- Database
- Message Queue
