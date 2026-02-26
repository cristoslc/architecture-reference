<img src="https://theme.zdassets.com/theme_assets/9716892/9d4dbeff76ce4633b7f7bb6ad23087af7d0e40b9.png" align="right" height="64px" />

# Core requirements
Our analysis on the client's requirements concludes that these are the essential features of the system
- MonitorMe system receives data from medical devices and does not fail when one of the medical devices is down 
- The Consolidated Monitoring Screen is updated with patient's vital signs in under 1 second 
- Medical professional receives alerts when patient's vital signs are out of norm 

# Project Constraints 
- OnPremise infrastructure that will allow high control over the data, enable limited access to public networks.
- Fast data transfer:  1s data delay between communication points is acceptable.
- Integration with MyMedicalData - upload snapshot functionality.
- Changing requirements due to a continuously developing environment. 
- Expectation is that the MonitorMe system can support data storage and analysis for 500 patients. 

# Architecture characteristics
Based on the core requirements, the following architecture characteristics were identified 
- __Responsivness__. Health data should reach the Consolidated Monitoring Screen in less than 1 second. 
- __Fault tolerance__. The system is required to work even when some of it's devices are down, continuing to process information and deliver data for medical professionals. As further development, we propose to alert the hospital administrator when a device is detected as being faulty (the system didn't receive data from it as expected).
- __Performance__. The component of the system responsible for analyzing vital sign data plays a pivotal role in responding promptly. It is critical for swift and timely action, facilitating instant alerts to medical professionals.
- __Accuracy__. Vital sign data that is analyzed and recorded must be as accurate as possible since human lives are at stake. The monitoring device types and supported protocols need to be analyzed and established, so we can attest to the quality of the data that is sent into the system. 
- __Agility__. In order to support the need of the client for changing requirements, we plan to adopt an agile methodology for developing the MonitorMe system. 
- __Extensibility__. The system should be able to support the addition of new medical devices. This can be achieved by supporting several standardized device communication protocols, creating abstraction layer between the device and the MonitorMe system and preparing new plugins for handling the received data. 
- __Security__. MonitorMe needs to be a high performing system enabling Medical Professionals to react faster to patient's degrading health. With that purpose in mind, it's important for the system to be secure, the data collected needs to be reliable and accurate. The system needs to be protected from malicious intent like fake data or hacking, DDOS attack. Patient data is confidential.

Having these characteristics identified, we have further analysed and detailed them in the [Cross-Functional requirements section](https://github.com/ArchitectsEvolutionZone/MonitorMe/blob/main/1.Requirements/CrossFunctionalRequirements.md) and [Architecture Decision Records](https://github.com/ArchitectsEvolutionZone/MonitorMe/tree/main/3.ADR)
