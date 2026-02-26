  Architecture Characteristics Worksheet

    System/Project:                                                                                                                    Domain:
     Architect/Team:                                                                                                                   Date:


                  Candidate Architecture Characteristics                                 Top 3         Driving Characteristics                      Implicit Characteristics

        performance                       data integrity             deployability                                                                  feasibility (cost/time)

        responsiveness                    data consistency           testability                                                                    security

        availability                      adaptability               abstraction                                                                    maintainability

        fault tolerance                   extensibility              workflow                                                                       observability

        scalability                       interoperability           configurability
        elasticity                        concurrency                recoverability                                                                 Others Considered

        others:
                                                                                        Instructions
                                                                                         • Identify no more than 7 driving characteristics.
                                                                                         • Pick the top 3 characteristics (in any order).
                                                                                         • Implicit characteristics can become driving
                                                                                           characteristics if they are critical concerns.
                          a                                                              • Add additional characteristics identified that weren’t
                               denotes characteristics that are related; some systems
                               only need one of these, other systems may need both         deemed as important as the list of 7 to the Others
                          b                                                                Considered list.

Last updated August 30, 2023                                                                                                                           Created by Mark Richards, DeveloperToArchitect.com
  Architecture Characteristics Worksheet

  performance                                                                  adaptability
  The amount of time it takes for the system to process a business request     The ease in which a system can adapt to changes in environment and functionality

  responsiveness                                                               concurrency
  The amount of time it takes to get a response to the user                    The ability of the system to process simultaneous requests, in most cases in the same
                                                                               order in which they were received; implied when scalability and elasticity are supported
  availability
  The amount of uptime of a system; usually measured in 9's (e.g., 99.9%)      interoperability
                                                                               The ability of the system to interface and interact with other systems to complete a
  fault tolerance                                                              business request
  When fatal errors occur, other parts of the system continue to function
                                                                               extensibility
  scalability                                                                  The ease in which a system can be extended with additional features and functionality
  A function of system capacity and growth over time; as the number of users
  or requests increase in the system, responsiveness, performance, and error   deployability
  rates remain constant                                                        The amount of ceremony involved with releasing the software, the frequency in which
                                                                               releases occur, and the overall risk of deployment
  elasticity
  The system is able to expend and respond quickly to unexpected or            testability
  anticipated extreme loads (e.g., going from 20 to 250,000 users instantly)   The ease of and completeness of testing

  data integrity                                                               abstraction
  The data across the system is correct and there is no data loss in the       The level at which parts of the system are isolated from other parts of the system (both
  system                                                                       internal and external system interactions)

  data consistency                                                             workflow
  The data across the system is in sync and consistent across databases and    The ability of the system to manage complex workflows that require multiple parts
  tables                                                                       (services) of the system to complete a business request



Last updated August 30, 2023                                                                                                           Created by Mark Richards, DeveloperToArchitect.com
  Architecture Characteristics Worksheet

  configurability
  The ability of the system to support multiple configurations, as well as
  support custom on-demand configurations and configuration updates

  recoverability
  The ability of the system to start where it left oﬀ in the event of a system
  crash

  feasibility (implicit)
  Taking into account timeframes, budgets, and developer skills when making
  architectural choices; tight timeframes and budgets make this a driving
  architectural characteristic

  security (implicit)
  The ability of the system to restrict access to sensitive information or
  functionality

  maintainability (implicit)
  The level of eﬀort required to locate and apply changes to the system

  observability (implicit)
  The ability of a system or a service to make available and stream metrics
  such as overall health, uptime, response times, performance, etc.




Last updated August 30, 2023                                                     Created by Mark Richards, DeveloperToArchitect.com
