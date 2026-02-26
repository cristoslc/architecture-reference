# Wired direct communication from Device Gateway to Consolidated Monitoring Screen

## Context
The Nurse Station's Consolidated Monitoring Screen should promptly exhibit essential patient vital sign information, updating every second. This includes data sourced from eight distinct patient-monitoring devices connected to the Device Gateway: heart rate, blood pressure, oxygen level, blood sugar, respiration rate, electrocardiogram (ECG), body temperature, and sleep status.

## Status
Proposed

## Decision
To ensure swift data presentation, the choice was made to establish direct wired communication from the Device Gateway. The Device Gateway will transmit data as fire-and-forget messages, which the application on the Consolidated Monitoring Screen will then receive and display.

## Consequences
This form of communication is designed to guarantee immediate reception of input data, enabling medical professionals to promptly respond if necessary.

## Options
Wireless Communication:
Instead of relying on wired communication, we have considered leveraging wireless communication protocols such as Wi-Fi or Bluetooth to transmit data from the Device Gateway to the Consolidated Monitoring Screen. This approach offers several advantages:
  * Flexibility: Wireless communication eliminates the need for physical cables, providing greater flexibility in the placement of devices. This flexibility can be particularly beneficial in healthcare environments where mobility and accessibility are crucial.
  * Ease of Installation: Setting up wireless communication infrastructure is often simpler and quicker than installing wired connections. This can lead to reduced installation costs and downtime, as well as easier scalability if additional devices need to be added or relocated.
  * Mobility: Wireless communication allows for greater mobility of devices, enabling medical professionals to access patient data from various locations within the healthcare facility without being tethered to a specific workstation.
  * Potential for Redundancy: By utilizing multiple wireless access points or redundant communication channels, it's possible to enhance reliability and resilience against network failures. This redundancy can ensure continuous data transmission even in the event of signal interference or hardware malfunctions.

  However, it's essential to consider limitations associated with wireless communication, such as security concerns, signal interference, and potential latency issues. Proper planning, implementation of security measures, and performance testing are crucial steps in ensuring the effectiveness and reliability of wireless communication in transmitting sensitive medical data.
  
## Usefull links 
- [Infrastructure page](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/2.ArchitectureVisualization/Infrastructure.md)
