          O’REILLY
ARCHITECTURE KATAS
       WINTER 2024
THE TEAM

           Vishal Gamji   Gibran Castillo   Harshada        Subodh Gupta
                                            Kandalgaonkar
Ch1. Introduction
[Problem Background & Business Goals]

Ch2. Navigating Challenges
[Architecture Analysis]


Ch3. Dueling Architectural & Operational
Obstacles [Architecture Decision Records]   OUR STORY …
Ch4. Eureka!
[The Proposed Solution]

Ch5. Curtains Close
[The End]
                     StayHealthy, Inc.: A leading medical software
                     company in San Francisco with two major products:
                     MonitorThem and MyMedicalData.
       CHAPTER 1:
 INTRODUCTION
                     MonitorMe: StayHealthy, Inc. is exploring growth
                     opportunities with MonitorMe. A real-time patient
                     monitoring solution for hospitals, integrating with
PROBLEM BACKGROUND   existing products for enhanced patient care.
         &
   BUSINESS GOALS

                     The Vision: Disrupt patient monitoring industry
                     with a reliable solution for hospitals that
                     incorporates real-time data analysis, insights, and
                     flexible EHR integration.
Technical Complexity: Developing MonitorMe to
handle data from multiple patient-monitoring devices
with varying transmit rates and data volumes,
ensuring data integrity and low latency.


On-Premises Hosting & Deployment: Packaging and
deploying this solution surfaces operational obstacles
                                                         CHAPTER 2:
and introduces a risk element for StayHealthy Inc. as
they haven’t operated in this business model.            NAVIGATING
                                                         CHALLENGES
Integration Hurdles: Seamlessly integrating
MonitorMe with MyMedicalData for EHR updates,
while ensuring data security and patient                 ARCHITECTURE
confidentiality.                                         ANALYSIS

Scalability and Future Expansion: Building a system
capable of expanding to accommodate more devices
and patients without compromising performance.
         2.1
     ACTORS,
ACTIONS, AND
COMPONENTS
            2.2
  ARCHITECTURE
CHARACTERISTICS
      2.3
 CAPACITY
PLANNING
2.4 ARCHITECTURE STYLE   M I C R O S E RV I C E S
                                   +
            SELECTION     E V E N T- D R I V E N
     Architectural Decisions: Adopting a             Security and Compliance: Implementing layered     Interoperability and Data Integrity: Ensuring the
 microservice and event-driven architecture to       security measures and achieving compliance with      system works flawlessly with existing hospital
ensure scalability, fault tolerance, and real-time     health data regulations without governmental     infrastructure and maintains high data accuracy
                  performance.                                        requirements.                                  for life-critical decisions.




     CHAPTER 3:
     DUELING ARCHITECTURAL
         & OPERATIONAL OBSTACLES
                                                                                                       ARCHITECTURE DECISION RECORDS
          3.1
ARCHITECTURE
    DECISION
      RECORD

 HIGHLIGHT 1
    ADR-001
          3.2
ARCHITECTURE
    DECISION
      RECORD

 HIGHLIGHT 2
    ADR-002
          3.3
ARCHITECTURE
    DECISION
      RECORD

 HIGHLIGHT 3
    ADR-003
 ARCHITECTURE & DEPLOYMENT SHOWCASE: ON-           REAL-TIME MONITORING: WITH AN AVERAGE         FUTURE-PROOF AND SCALABLE: DESIGNED TO
PREMISES IMPLEMENTATION AT HOSPITAL LOCATIONS        RESPONSE TIME OF LESS THAN A SECOND,      ACCOMMODATE ADDITIONAL MONITORING DEVICES
  WITH AWS OUTPOSTS SERVERS, ENSURING DATA         MONITORME REVOLUTIONIZES PATIENT CARE,          AND INTEGRATE WITH EVOLVING MEDICAL
    PRIVACY AND LOCAL PROCESSING NEEDS.         ENABLING HEALTHCARE PROFESSIONALS TO RESPOND    SOFTWARE LANDSCAPES, ENSURING LONG-TERM
                                                           SWIFTLY TO PATIENT NEEDS.                             VIABILITY.




         CHAPTER 4:
         THE EUREKA MOMENT
         [THE PROPOSED SOLUTION]
           4.1
  HIGH LEVEL
ARCHITECTURE
       C4 MODEL
 SYSTEM CONTEXT
    DIAGRAM (C1)
             4.2
   HIGH LEVEL
 ARCHITECTURE
         C4 MODEL
CONTAINER DIAGRAM
              (C2)
4.3
HIGH LEVEL
ARCHITECTURE
C4 MODEL
CONTAINER DIAGRAM (C2)
MICROSERVICES
EXPANDED
4.4
DEPLOYMENT
DIAGRAM
INNOVATIVE SOLUTION: MONITORME REPRESENTS A     IMPACT ON HEALTHCARE: ENHANCING PATIENT    STAYHEALTHY, INC.'S COMMITMENT: CONTINUING
   SIGNIFICANT LEAP FORWARD IN PATIENT CARE,   OUTCOMES, REDUCING HEALTHCARE COSTS, AND       TO INNOVATE AND SUPPORT THE HEALTHCARE
 COMBINING REAL-TIME MONITORING WITH ROBUST    PAVING THE WAY FOR DATA-DRIVEN HEALTHCARE    INDUSTRY WITH SOLUTIONS THAT SAVE LIVES AND
  DATA ANALYSIS AND SECURE EHR INTEGRATION.                   SOLUTIONS.                               IMPROVE PATIENT CARE.




    CHAPTER 5:
    THE END
*Credits: Dall-E generated.




5.1 NURSE STATION DASHBOARD VIEW
*Credits: Dall-E generated.




5.2 MEDICAL PROFESSIONAL MOBILE APP VIEW
