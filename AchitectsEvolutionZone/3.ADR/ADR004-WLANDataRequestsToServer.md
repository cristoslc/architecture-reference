# Web App Data Requests to On-Premise Server "MonitorMe" via WLAN

## Context
The Web App serves as the primary interface for healthcare professionals to access patient data from the on-premise server "MonitorMe." 
The decision to use WLAN (Wireless Local Area Network) for data requests to "MonitorMe" is driven by several factors, 
including the need for flexibility, mobility, and real-time data access.

## Status
Proposed

## Decision
The decision to use WLAN for Web App data requests to the on-premise server "MonitorMe" is made to achieve the following benefits:
   * Flexibility and Mobility: WLAN allows healthcare professionals to access patient data from anywhere within the hospital premises, facilitating mobility and flexibility in patient care.
   * Real-Time Data Access: Wireless access enables real-time data retrieval, enabling healthcare professionals to make timely and informed decisions.
   * Scalability: WLAN can easily accommodate a growing number of devices and users, supporting the hospital's evolving needs.
   * Cost-Efficiency: WLAN infrastructure can be more cost-effective than wired alternatives, particularly in large hospital environments.

## Consequences

Pros:
   * Improved Efficiency: WLAN enables healthcare professionals to access patient data quickly and conveniently, improving overall workflow efficiency.
   * Enhanced Patient Care: Real-time data access allows for more timely interventions and adjustments to treatment plans, leading to better patient outcomes.
   * Reduced Infrastructure Complexity: WLAN eliminates the need for complex cabling and reduces installation and maintenance costs.
   * Increased Flexibility: WLAN allows for more flexible device placement and usage within the hospital, supporting various care scenarios.
  
Cons:
   * Security Considerations: WLAN networks require robust security measures to protect patient data from unauthorized access or interception.
   * Network Reliability: WLAN networks can be susceptible to interference and signal degradation, impacting data transmission reliability.
   * Infrastructure Investment: Setting up and maintaining a WLAN infrastructure requires initial investment in access points, switches, and security measures.

## Options
  * Dual-Band WLAN: In order to mitigate interference and improve network reliability, we have considered deploying dual-band WLAN infrastructure (2.4 GHz and 5 GHz) , as this allows devices to connect to less congested frequencies, enhancing performance for critical data requests.
  * Quality of Service Configuration (QoS): Ensuring that critical patient data transmissions receive higher network priority, we could implement QoS configuration on WLAN access points to prioritize Web App data requests, leading to more reliable and consistent performance.
  * Guest Network Segmentation: Segment the WLAN network into separate virtual networks, with one dedicated for healthcare professionals' use and another for guest access. This helps maintain network security and performance by isolating patient data traffic from non-essential traffic.
  * Redundant WLAN Infrastructure: Implement redundant WLAN infrastructure, including backup access points and controllers, to minimize downtime and ensure continuous availability of patient data access even in the event of hardware failures or network disruptions.
    
## Usefull links 
- [Infrastructure page](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/2.ArchitectureVisualization/Infrastructure.md)
