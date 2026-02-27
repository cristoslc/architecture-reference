# Flow Diagram Using System Requ

*Extracted text labels from `Flow Diagram Using System Requ.drawio`*

## Camera API

- User
- Mobile App
- CameraAPI
- DB
- Camera
- critter
- User to interact with camera using the App, on the location, of the camera
- Saving the camera setting to DB, against each camera
- Flow: User interacting with camera, using camera API

## camera alert to notification

- DB
- Camera
- critter
- Flow: Camera sending Alert using Notification API
- User
- Mobile App
- NotificationAPI
- Camera sends an alert using the notification API to Mobile application of the user
- Sends an Alert
- Sends an Alert

## Image/Video Retrival

- User
- Mobile App
- CameraAPI
- Camera
- Saving the images/ raw data to DB
- Flow: Fetching and Storing Images/ Video
- Multimedia Module API
- DB
- Fetching the images from the camera using camera API

## Interaction with 3rd Application

- User
- Mobile App
- Integration Module API
- Retriving the multimedia data from the DB
- Flow: Interaction with 3rd Application
- Multimedia Module API
- DB
- Data Sharing with3rd Party Applications
- Camera Trap
- iNaturalist
- GBIF / Camera Trap
- ML Sites (Roboflow, Tensor Flow)
- 3rd Party Applications
