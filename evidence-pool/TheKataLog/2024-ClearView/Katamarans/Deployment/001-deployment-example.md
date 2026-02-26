# Example deployment using Microsoft Azure

## Introduction
Following document describes an example approach to deploying ClearView system on Microsoft's Azure platform. It groups certain components from [C4 diagram](../C4/C4.md) into deployment units, their logical groupings and visualises external dependencies.

This deployment can easily be converted to use different cloud providers (like AWS or GCP) or to plan on-prem deployment.

## Diagram
<img src="images/clearview_deployment_diagram.drawio.png">

## Deployment units
Most of the deployment units is aligned with components from C4 diagram. However, ClearView frontend and backend units on the diagram above group several C4 components that offer user interactions through some kind of an interface. These components include: 
- Company & job description management,
- Resume & candidate data management,
- Match management,
- and Admin panel.

Because logic in event-driven architecture is mostly triggered by incoming events/messages we decided to use in this example a mix of Azure Functions with Azure Service Bus to handle more complex workloads in a performant and scalable way.