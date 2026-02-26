# Infrastructure 

![infrastructure](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/Infrastructure.png)

As a hospital that starts using the MonitorMe system, StayHealthy, Inc will provide support for setting up the infrastructure required for a smooth user experience both for patients and medical professionals as well. 

The recommendation is to have the vital sign monitoring devices ready in each hospital room, so each time a new patient is registered, devices are at hand and can be connected on the patient. This will help get the patient's vital signs on the Consolidate Monitoring Screen as soon as possible. 

The MonitorMe support team will install Device Gateways in each room, which will pick-up data transmitted for the vital sign monitoring devices and forward (over wire) to the Consolidated Monitoring Screen (CMS) and the On-Premise Monitor Me server. 

The On-Premise server will then store and analyze the information, it will communicate with the Web and Mobile apps by Wireless Local Area Network (WLAN) 

The On-Premise MonitorMe server, will host 
* the data storage
* the services required to deliver alerts on the (CMS) and Mobile App
* web server for the Website and Mobile App (backend for the Mobile App)

## MonitorMe infrastructure part delivered by StayHealthy,Inc 
- The vital sign devices can be provided by StayHealthy, Inc or a set of specifications or vendors can be provided
- Device Gateway
- Consolidated Monitoring Screens
- Server hardware

## Constraints on the hospital 
The hospital's administrative team will need to provide 
- possibility to setup a Wireless Local Area Network
- wire infrastructure across the hospital's premise

## Cross-functional requirements 
- Extensibility. The MonitorMe system is capable of integrating with vital sign monitoring devices that communicate over Bluetooth LE. The Device Gateway enables easy integration of other type of protocols, being able to transform the information to the format used by MonitorMe system.
- Security. By using strict communication channels, as well as wired communication and secured Wireless Networks, we can limit the interaction that MonitorMe has with other apps.
- Fast data transfer. By having wired communication to the CMS and On-Premise Server, data is transferred fast and reliably. 

## Relevant Architecture Decision Records 
- [Multiple medical devices in communication with the Device Gateway](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR002-HL7TransmissionToDeviceGateway.md)
- [Device Gateway for data collection and transmission](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR006-DeviceGateway.md) 
- [Wired communication from Device Gateway to CMS](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR001-WiredCommunicationGatewayToCMS.md) 
- [Wired communication from Device Gateway to On-Premise Server](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR003-WiredCommunicationGatewayToServer.md)
- [WLAN communication with Mobile App](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR005-WLANReceiveAlertsFromServer.md)
- [WLAN communication with Web App](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR004-WLANDataRequestsToServer.md)
- [Using On-Premise server cluster for redundancy](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/3.ADR/ADR011-OnPremServerCluster.md)

## Deployment considerations 
Check the [Deployment page](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/2.ArchitectureVisualization/Deployment.md) for details on how we think of delivering updates at this stage.
