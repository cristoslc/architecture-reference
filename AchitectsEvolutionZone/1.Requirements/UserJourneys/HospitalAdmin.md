# System and Hospital Administrator Role 

The need of the administrators role was identified based on the [provided requirements](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/1.Requirements/ClientInitialRequirements.md).

__System Administrator__ 

A user with this role will be setup with a clean install of the MonitorMe software. We will then use this role to provide access for the Hospital Administrator and configure system operations (maybe limiting supported devices). 

__Hospital Administrator__

This role will help setup the system so the medical professionals can use it with ease and have support in caring for their patients. The person with this role is familiar with the hospital staff, room layouts and infrastructure capabilities.

# Administrator's Journey 
The configuration and setup process of the MonitorMe System are communicated through the perspectives of the Hospital Administrator role and the dedicated support team for the MonitorMe System.

![Admin journey](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/resources/UserJourneys/adminJourney.png)

# Use cases 
- The system administrator sets up an account for the hospital administrator. Here we're interested in the user name, name as data for the hospital administrator
- The hospital administrator registers the hospital rooms. Relevant information to collect here is the room's location (floor, room number) and patient capacity.
- The hospital administrator registers the Consolidated Monitoring Screens that were installed by the support team. Relevant information here is CMS location (floor, nurse station location, identifier) 
- The hospital administrator associates rooms to Consolidated Monitoring Systems, such as there are max 20 patients associated to one CMS.
- The hospital administrator registers the vital sign devices in the MonitorMe System. Relevant information to collect is: device identifier, device type
- The hospital administrator creates accounts for the medical professionals. Relevant information here: name, identifier, medical role

# Proposed infrastructure 
For an overview of the  proposed infrastructure for the MonitorMe System and a visual on how the system will look like after setup, see [Infrastructure Page](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/2.ArchitectureVisualization/Infrastructure.md) 

# Identified components 
This user journey highlights the need of a configuration module in the MonitorMe system.
