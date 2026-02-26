    Viewpoints and Perspectives                                 Contents
                                                                Overview..................................................................................................................................1
         Reference Card                                         Viewpoint Summaries ..............................................................................................................2
                                                                Quality Properties Addressed by Perspectives ........................................................................2
                                                                Stakeholders ............................................................................................................................3
           Nick Rozanski and Eoin Woods
                                                                Functional Viewpoint ................................................................................................................4
      www.viewpoints-and-perspectives.info                      Information Viewpoint...............................................................................................................5
                                                                Concurrency Viewpoint ............................................................................................................6
                                                                Development Viewpoint ...........................................................................................................7
                                                                Deployment Viewpoint .............................................................................................................8
                                                                Operational Viewpoint ..............................................................................................................9
                                                                Accessibility Perspective........................................................................................................10
                                                                Availability and Resilience Perspective ..................................................................................11
                                                                Development Resource Perspective ......................................................................................12
                                                                Evolution Perspective.............................................................................................................13
                                                                Internationalisation Perspective .............................................................................................14
                                                                Location Perspective..............................................................................................................15
                                                                Performance and Scalability Perspective ...............................................................................16
                                                                Regulation Perspective ..........................................................................................................17
                                                                Security Perspective ..............................................................................................................18
                                                                Usability Perspective..............................................................................................................19




Content excerpted from Software Systems Architecture: Working
 With Stakeholders Using Viewpoints and Perspectives by Nick
       Rozanski and Eoin Woods, Addison Wesley 2005.
The book is available from Amazon.com and Amazon.co.uk and
     other booksellers that carry Addison-Wesley books.
Overview                                                                                     Viewpoint Summaries
Our book is based around four key concepts: stakeholders, views, viewpoints and
perspectives. The definition of each is reproduced below.                                     •   Functional: Describes the system’s functional elements, their responsibilities,
                                                                                                  interfaces, and primary interactions and drives the shape of other system structures
                                                                                                  such as the information structure, concurrency structure, deployment structure, and so
                                                                                                  on.
   Definition: A stakeholder in a software architecture is a person, group, or entity with
                                                                                              •   Information: Describes the way that the architecture stores, manipulates, manages,
   an interest in or concerns about the realization of the architecture.
                                                                                                  and distributes information. This viewpoint develops a complete but high-level view of
                                                                                                  static data structure and information flow to answer the big questions around content,
                                                                                                  structure, ownership, latency, references, and data migration.
   Definition: A view is a representation of one or more structural aspects of an             •   Concurrency: Describes the concurrency structure of the system and maps functional
   architecture that illustrates how the architecture addresses one or more concerns              elements to concurrency units to clearly identify the parts of the system that can
   held by one or more of its stakeholders.                                                       execute concurrently and how this is coordinated and controlled.
                                                                                              •   Development: Describes the architecture that supports the software development
                                                                                                  process. Development views communicate the aspects of the architecture of interest to
                                                                                                  those stakeholders involved in building, testing, maintaining, and enhancing the system.
   Definition: A viewpoint is a collection of patterns, templates, and conventions for
                                                                                              •   Deployment: Describes the environment into which the system will be deployed, and
   constructing one type of view. It defines the stakeholders whose concerns are
                                                                                                  the dependencies the system has on its runtime environment. Deployment views
   reflected in the viewpoint and the guidelines, principles, and template models for
                                                                                                  capture the system’s hardware environment, technical environment requirements, and
   constructing its views.
                                                                                                  the mapping of the software to hardware elements.
                                                                                              •   Operational: Describes how the system will be operated, administered, and supported
                                                                                                  when it is running in its production environment, by identifying system-wide strategies
   Definition: An architectural perspective is a collection of activities, tactics, and           for addressing operational concerns and identifying solutions that address these.
   guidelines that are used to ensure that a system exhibits a particular set of related
   quality properties that require consideration across a number of the system’s             Quality Properties Addressed by Perspectives
   architectural views.
                                                                                              •   Accessibility: The ability of the system to be used by people with disabilities
The sets of viewpoints and perspectives that we have developed for information systems        •   Availability and Resilience: The ability of the system to be fully or partly operational as
architecture are illustrated by the diagram in Figure 1.                                          and when required and to effectively handle failures that could affect system availability
                                                                                              •   Development Resource: The ability of the system to be designed, built, deployed, and
                                                                                                  operated within known constraints of people, budget, time, etc.
                        Security Perspective          Accessibility Perspective               •   Evolution: The ability of the system to be flexible in the face of the inevitable change
                                                                                                  that all systems experience after deployment, balanced against the costs of providing
                      Performance Perspective           Location Perspective                      such flexibility
                                                                                              •   Internationalization: The ability of the system to be independent from any particular
                       Availability Perspective       Regulation Perspective
                                                                                                  language, country, or cultural group
                        Usability Perspective                         etc.                    •   Location: The ability of the system to overcome problems brought about by the
                                                                                                  absolute location of its elements and the distances between them
                                                                                              •   Performance and Scalability: The ability of the system to predictably execute within its
                                                                                                  mandated performance profile and to handle increased processing volumes
                                                                                              •   Regulation: The ability of the system to conform to local and international laws, quasi-
                                                                                                  legal regulations, company policies, and other rules and standards
                                                                                              •   Security: The ability of the system to reliably control, monitor, and audit who can
               Functional Viewpoint                        Development Viewpoint                  perform what actions on what resources and to detect and recover from failures in
                                                                                                  security mechanisms
                                                                                              •   Usability: The ease with which people who interact with the system can work effectively

               Information Viewpoint                       Deployment Viewpoint




               Concurrency Viewpoint                       Operational Viewpoint



                          Figure 1 - Viewpoints and Perspectives

In this document, we provide a summary of each of our viewpoints and perspectives.




                                                  1                                                                                      2
Stakeholders                                                                                 Functional Viewpoint
Stakeholder groups important to the development of most information systems include the      The Functional view of a system defines the architectural elements that deliver the system’s
following.                                                                                   functionality. The view documents the system’s functional structure—including the key
                                                                                             functional elements, their responsibilities, the interfaces they expose, and the interactions
 •   Acquirers: Oversee the procurement of the system or product                             between them. Taken together, this demonstrates how the system will perform the functions
 •   Assessors: Oversee the system’s conformance to standards and legal regulation           required of it.
 •   Communicators: Explain the system to other stakeholders via its documentation and
     training materials                                                                      Definition                  Describes the system’s runtime functional elements and their responsibilities,
 •   Developers: Construct and deploy the system from specifications (or lead the teams                                  interfaces, and primary interactions
     that do this)                                                                           Concerns                    Functional capabilities, external interfaces, internal structure, and design philosophy
 •   Maintainers: Manage the evolution of the system once it is operational                  Models                      Functional structure model
 •   Suppliers: Build and/or supply the hardware, software, or infrastructure on which the
     system will run                                                                         Problems and Pitfalls       Poorly defined interfaces, poorly understood responsibilities, infrastructure modeled
                                                                                                                         as functional elements, overloaded view, diagrams without element definitions,
 •   Support staff: Provide support to users for the product or system when it is running                                difficulty in reconciling the needs of multiple stakeholders, inappropriate level of
 •   System administrators: Run the system once it has been deployed                                                     detail, “God elements,” and too many dependencies
 •   Testers: Test the system to ensure that it is suitable for use                          Applicability               All systems
 •   Users: Define the system’s functionality and ultimately make use of it
                                                                                             Stakeholders and Concerns
The characteristics of a good stakeholder can be summarised as follows.                      Acquirers                   Primarily functional capabilities and external interfaces
 •   Informed: Do your stakeholders have the information, the experience, and the            Assessors                   All concerns
     understanding needed to make the right decisions?                                       Communicators               All concerns, to some extent
 •   Committed: Are your stakeholders willing and able to make themselves available to
     participate in the process, and are they prepared to make some possibly difficult       Developers                  Primarily design philosophy and internal structure, but also functional capabilities
                                                                                                                         and external interfaces
     decisions?
 •   Authorized: Can you be sure that decisions made now by your stakeholders will not be    System administrators       Primarily design philosophy and internal structure
     reversed later (at potentially high cost)?                                              Testers                     Primarily design philosophy and internal structure, but also functional capabilities
 •   Representative: If a stakeholder is a group rather than a person, have suitable                                     and external interfaces
     representatives been selected from the group? Do those representatives meet the         Users                       Primarily functional capabilities and external interfaces
     above criteria for individual stakeholders?
                                                                                             Checklist
                                                                                               •     Do you have fewer than 15–20 top-level elements?
                                                                                               •     Do all elements have a name, clear responsibilities, and clearly defined interfaces?
                                                                                               •     Do all element interactions take place via well-defined interfaces and connectors that
                                                                                                     link the interfaces?
                                                                                               •     Do your elements exhibit an appropriate level of cohesion and coupling?
                                                                                               •     Have you identified the important usage scenarios and used these to validate the
                                                                                                     system’s functional structure?
                                                                                               •     Have you checked the functional coverage of your architecture to ensure it meets its
                                                                                                     functional requirements?
                                                                                               •     Have you considered how the architecture is likely to cope with possible change
                                                                                                     scenarios in the future?
                                                                                               •     Does the presentation of the view take into account the concerns and capabilities of all
                                                                                                     interested stakeholder groups? Will the view act as an effective communication vehicle
                                                                                                     for all of these groups?




                                           3                                                                                                     4
Information Viewpoint                                                                                               Concurrency Viewpoint
The ultimate purpose of any information system is to manipulate data in some form. This data                        The Concurrency view is used to describe the system’s concurrency and state-related
may be stored persistently, as in a database management system, or it may be transiently                            structure and constraints. This involves defining the parts of the system that can run at the
manipulated in memory while a program executes. You use the Information view to answer                              same time and how this is to be controlled, by defining how the system’s functional elements
questions about how your system will store, manipulate, manage, and distribute information                          are packaged into operating system processes and how the processes coordinate their
                                                                                                                    execution.
Definition                 Describes the way that the architecture stores, manipulates, manages, and
                           distributes information                                                                  Definition               Describes the concurrency structure of the system, mapping functional elements to
                                                                                                                                             concurrency units to clearly identify the parts of the system that can execute
Concerns                   Information structure and content; information flow; data ownership; timeliness,
                                                                                                                                             concurrently, and shows how this is coordinated and controlled
                           latency, and age; references and mappings; transaction management and recovery;
                           data quality; data volumes; archives and data retention; and regulation                  Concerns                 Task structure, mapping of functional elements to tasks, interprocess
                                                                                                                                             communication, state management, synchronization and integrity, startup and
Models                     Static data structure models, information flow models, information lifecycle models,
                                                                                                                                             shutdown, task failure, and reentrancy
                           data ownership models, data quality analysis, metadata models, and volumetric
                           models                                                                                   Models                   System-level concurrency models and state models
Problems and Pitfalls      Data incompatibilities, poor data quality, unavoidable multiple updaters, key matching   Problems and Pitfalls    Modeling of the wrong concurrency, excessive complexity, resource contention,
                           deficiencies, poor information latency, interface complexity, and inadequate                                      deadlock, and race conditions
                           volumetrics
                                                                                                                    Applicability            All information systems with a number of concurrent threads of execution
Applicability              Any system that has more than trivial information management needs

                                                                                                                    Stakeholders and Concerns
Stakeholders and Concerns
                                                                                                                    Administrators           Task structure, startup and shutdown, and task failure
Acquirers                  Typically interested in data quality, archiving and data retention
                                                                                                                    Communicators            Task structure, startup and shutdown, and task failure
Assessors                  Typically focus on regulation and data quality
                                                                                                                    Developers               All concerns
Communicators              May find understanding the key principles and strategies helpful
                                                                                                                    Testers                  Task structure, mapping of functional elements to tasks, startup and shutdown,
Developers                 Focus on how the models will map to real databases & interfaces                                                   task failure, and reentrancy
System administrators      Interested in how the databases & interfaces will be managed and supported
Users                      Concerned with information stored and aspects like data ownership and user-              Checklist
                           visible qualities such as timeliness & latency.
                                                                                                                      •   Is there a clear system-level concurrency model?
                                                                                                                      •   Are your models at the right level of abstraction? Have you focused on the
Checklist                                                                                                                 architecturally significant aspects?
  •     Do you have an appropriate level of detail in your models (no more than 20 entities)?                         •   Can you simplify your concurrency design?
  •     Are keys clearly identified for all important entities?                                                       •   Do all interested parties understand the overall concurrency strategy?
  •     Have you defined mappings between keys, where required, and defined processes for                             •   Have you mapped all functional elements to a process (and thread if necessary)?
        maintaining these mappings when data items are created and removed?                                           •   Do you have a state model for at least one functional element in each process and
  •     Have you defined strategies for resolving data ownership conflicts, particularly where                            thread? If not, are you sure the processes and threads will interact safely?
        there are multiple creators or updaters?                                                                      •   Have you defined a suitable set of interprocess communication mechanisms to support
  •     Are latency requirements clearly identified, and are mechanisms in place to ensure                                the interelement interactions defined in the Functional view?
        these are achieved?                                                                                           •   Are all shared resources protected from corruption?
  •     Do you have clear strategies for transactional consistency across distributed data                            •   Have you minimized the intertask communication and synchronization required?
        stores, balanced against their cost in terms of performance and complexity?                                   •   Do you have any resource hot spots in your system? If so, have you estimated the likely
  •     Do you have mechanisms in place for validating migrated data and dealing                                          throughput, and is it high enough? Do you know how you would reduce contention at
        appropriately with errors?                                                                                        these points if forced to later?
  •     Have you defined sufficient storage and processing capacity for archiving and restore?                        •   Can the system possibly deadlock? If so, do you have a strategy for recognizing and
  •     Has a data quality assessment been done? Have you created strategies for dealing with                             dealing with this when it occurs?
        poor-quality data?




                                                   5                                                                                                                6
Development Viewpoint                                                                                         Deployment Viewpoint
A considerable amount of planning and design of the development environment is often                          The Deployment view focuses on aspects of the system that are important after the system
required to support the design and build of software for complex systems. Things to think                     has been tested and is ready to go into live operation. This view defines the physical
about include code structure and dependencies, build and configuration management of                          environment in which the system is intended to run, including the hardware environment your
deliverables, system-wide design constraints, and system-wide standards to ensure technical                   system needs (e.g., processing nodes, network interconnections, and disk storage facilities),
integrity. It is the role of the Development view to address these aspects of the system                      the technical environment requirements for each node (or node type) in the system, and the
development process.                                                                                          mapping of your software elements to the runtime environment that will execute them.
Definition               Describes the architecture that supports the software development process            Definition               Describes the environment into which the system will be deployed, including the
                                                                                                                                       dependencies the system has on its runtime environment
Concerns                 Module organization, common processing, standardization of design, standardization
                         of testing, instrumentation, and codeline organization                               Concerns                 Types of hardware required, specification and quantity of hardware required, third-
                                                                                                                                       party software requirements, technology compatibility, network requirements,
Models                   Module structure models, common design models, and codeline models                                            network capacity required, and physical constraints
Problems and Pitfalls    Too much detail, overburdening the AD, uneven focus, lack of developer focus, lack   Models                   Runtime platform models, network models, and technology dependency models
                         of precision, and problems with the specified environment
                                                                                                              Problems and Pitfalls    Unclear or inaccurate dependencies, unproven technology, lack of specialist
Applicability            All systems with significant software development involved in their creation                                  technical knowledge, and late consideration of the deployment environment
                                                                                                              Applicability            Systems with complex or unfamiliar deployment environments
Stakeholders and Concerns
Developers               All concerns                                                                         Stakeholders and Concerns
Testers                  All concerns                                                                         System administrators    Types, specification, and quantity of hardware required; third-party software
                                                                                                                                       requirements; technology compatibility; network requirements; network capacity
                                                                                                                                       required; and physical constraints
Checklist
                                                                                                              Developers               Types and (general) specification of hardware required, third-party software
  •   Have you defined a clear strategy for organizing the source code modules in your                                                 requirements, technology compatibility, and network requirements (particularly
      system?                                                                                                                          topology)
  •   Have you defined a general set of rules governing the dependencies that can exist                       Communicators            Types and specification of hardware required, third-party software requirements,
      between code modules at different abstraction levels?                                                                            and network requirements (particularly topology)
  •   Have you identified all of the aspects of element implementation that need to be
                                                                                                              Testers                  Types, specification, and quantity of hardware required; third-party software
      standardized across the system?                                                                                                  requirements, and network requirements
  •   Have you clearly defined how any standard processing should be performed?
                                                                                                              Assessors                Types of hardware required, technology compatibility, and network requirements
  •   Have you identified any standard approaches to design that you need all element
      designers and implementers to follow? If so, do your software developers accept and
      understand these approaches?                                                                            Checklist
  •   Will a clear set of standard third-party software elements be used across all element                     •   Have you mapped all of the system’s functional elements to a type of hardware device?
      implementations? Have you defined the way they should be used?                                                Have you mapped them to specific hardware devices if appropriate?
  •   Is this view as minimal as possible?                                                                      •   Is the role of each hardware element in the system fully understood? Is the specified
  •   Is the presentation of this view in the AD appropriate?                                                       hardware suitable for the role?
                                                                                                                •   Have you established detailed specifications for the system’s hardware devices? Do
                                                                                                                    you know exactly how many of each device are required?
                                                                                                                •   Have you identified all required third-party software and documented all the
                                                                                                                    dependencies between system elements and third-party software?
                                                                                                                •   Is the network topology required by the system understood and documented?
                                                                                                                •   Have you estimated and validated the required network capacity? Can the proposed
                                                                                                                    network topology be built to support this capacity?
                                                                                                                •   Have network specialists validated that the required network can be built?
                                                                                                                •   Have you performed compatibility testing when evaluating your architectural options to
                                                                                                                    ensure that the elements of the proposed deployment environment can be combined as
                                                                                                                    desired?
                                                                                                                •   Have you used enough prototypes, benchmarks, and other practical tests when
                                                                                                                    evaluating your architectural options to validate the critical aspects of the proposed
                                                                                                                    deployment environment?
                                                                                                                •   Can you create a realistic test environment that is representative of the proposed
                                                                                                                    deployment environment?
                                                                                                                •   Are you confident that the deployment environment will work as designed? Have you
                                                                                                                    obtained external review to validate this opinion?
                                                                                                                •   Are the assessors satisfied that the deployment environment meets their requirements
                                                                                                                    in terms of standards, risks, and costs?
                                                                                                                •   Have you checked that the physical constraints (such as floor space, power, cooling,
                                                                                                                    and so on) implied by your required deployment environment can be met?

                                                7                                                                                                             8
Operational Viewpoint                                                                                             Accessibility Perspective
The aim of the Operational viewpoint is to identify a system-wide strategy for addressing the                     Accessibility should take into account not only the direct users of the system—i.e., those
operational concerns of the system’s stakeholders and to identify solutions that address                          sitting at terminals—but the indirect users as well. For example, a financial system may need
these. The Operational view focuses on concerns that help ensure that the system is a                             to provide bank statements in Braille for blind customers. Consideration of disability aside,
reliable and effective part of commissioning enterprise’s information technology environment.                     addressing accessibility concerns brings benefits in many cases by making systems more
For a product development project, the Operational view illustrates the types of concerns that                    usable and efficient in their operation.
customers of the product are likely to encounter, rather than the concerns of a specific site.
                                                                                                                  Desired Quality            The ability of the system to be used by people with disabilities
Definition               Describes how the system will be operated, administered, and supported when it is
                         running in its production environment                                                    Applicability              Any system that may be used or operated by people with disabilities or may be
                                                                                                                                             subject to legislation regarding disabilities
Concerns                 Installation and upgrade, functional migration, data migration, operational monitoring
                         and control, configuration management, performance monitoring, support, and              Concerns                   Types of disability, functional availability, and disability regulation
                         backup and restore
                                                                                                                  Activities                 Identification of system touch points, device independence, and content equivalence
Models                   Installation models, migration models, configuration management models,
                         administration models, and support models                                                Tactics                    Assistive technologies, specialist input devices, and voice recognition
Problems and Pitfalls    Lack of engagement with the operational staff, lack of backout planning, lack of
                                                                                                                  Problems & Pitfalls        Ignoring these needs until too late, lack of knowledge about regulation and
                         migration planning, insufficient migration window, missing management tools, lack of
                                                                                                                                             legislation, and lack of knowledge about suitable solutions
                         integration into the production environment, and inadequate backup models
Applicability            Any system being deployed into a complex or critical operational environment
                                                                                                                  Applicability to Views
                                                                                                                  Functional                 In theory, the functional structure should not really be affected by accessibility
Stakeholders and Concerns                                                                                                                    considerations. In practice, functional compromises may need to be made.
Assessors                Functional migration, data migration, and support
                                                                                                                  Information                The information structure is unlikely to be significantly affected.
Communicators            Installation and upgrade, functional migration, and operational monitoring and
                                                                                                                  Concurrency                The impact on this view is minimal.
                         control
                                                                                                                  Development                The Development view needs to raise awareness that accessibility issues are
Developers               Operational monitoring and control and performance monitoring
                                                                                                                                             important. And, of course, you may need to accommodate disabled developers, too.
Support staff            Functional migration, data migration, and support
                                                                                                                  Deployment                 The deployment environment is likely to be the most affected by this perspective.
System administrators    All concerns                                                                                                        Special hardware may be needed to support disabled users.
                                                                                                                  Operational                The Operational view may have to take into account the needs of disabled users
                                                                                                                                             requiring support or the needs of disabled support staff themselves.
Checklist
  •   Do you know what it takes to install your system?
  •   Do you have a plan for backing out a failed installation?
                                                                                                                  Checklist for Requirements Capture
  •   Can you upgrade an existing version of the system (if required)?                                              •    Have you identified and obtained stakeholder approval of the extent to which the system
  •   How will information be moved from the existing environment into the new system?                                   must support the needs of disabled users?
  •   Do you have a clear migration strategy to move workload to the new system? Can you                            •    Have you provided for the needs of indirect disabled users, such as customers who
      reverse the migration if you need to? How will you deal with data synchronization?                                 need paperwork provided in Braille format?
  •   How will the system be backed up? Is restore possible in an acceptable time period?                           •    Have you identified the disability legislation that affects the system and assessed the
  •   Are the administrators confident that they can monitor and control the system and do                               system against it?
      they have a clear understanding of operational procedures?                                                    •    Have you ensured that the system meets any internal accessibility standards?
  •   How will performance metrics be captured for the system’s elements?                                           •    Have you considered all points at which the system has any human interaction? For
  •   Can you manage the configuration of all of the system’s elements?                                                  example, have you considered operational management and monitoring of the system,
  •   Do you know how support will be provided for the system? Is the support provided                                   or printed forms that are sent to customers to be filled in?
      suitable for the stakeholders it is being provided for?
  •   Have you cross-referenced the requirements of the administration model back to the                          Checklist for Architecture Definition
      Development view to ensure that they will be implemented consistently?                                        •    How confident are you that your architectural assumptions are correct? Where you are
                                                                                                                         not, are mitigating activities in place (such as a proof-of-concept)?
                                                                                                                    •    Do the interactive elements of your architecture sufficiently separate presentation and
                                                                                                                         content to meet the system’s accessibility objectives?
                                                                                                                    •    Are the interfaces between components (particularly those leading in and out of
                                                                                                                         presentation devices) sufficiently generic to be able to take on board new devices
                                                                                                                         without (much) rework?
                                                                                                                    •    Does the architecture allow for presentation alternatives to convey meaning (e.g., text,
                                                                                                                         pictures, and/or sound in a user interface)?
                                                                                                                    •    Do standards for user interface design emphasize simplicity, consistency, and clarity in
                                                                                                                         place? Does the architecture adhere to them?




                                                9                                                                                                                    10
Availability and Resilience Perspective
This perspective allows you to identify the availability and resilience needs of your system and
                                                                                                                      Development Resource Perspective
identify solutions that take into account the costs that providing these properties incur.                            All software projects are primarily constrained by time and cost. IT budgets are never
                                                                                                                      unlimited, and although technology capabilities improve from year to year, so do the costs of
Desired Quality           The ability of the system to be fully or partly operational as and when required and to     building, deployment, and support. This perspective allows you to consider whether your
                          effectively handle failures that could affect system availability                           architecture can be created, given development resource constraints.
Applicability             Any system that has complex or extended availability requirements, complex
                          recovery processes, or a high profile (e.g., is visible to the public)                      Desired Quality            The ability of the system to be designed, built, deployed, and operated within known
                                                                                                                                                 constraints related to people, budget, time, and materials
Concerns                  Classes of service, planned downtime, unplanned downtime, time to repair, and
                          disaster recovery                                                                           Applicability              Any system for which development time is limited, technical skills for development or
                                                                                                                                                 operations are hard to find, or unusual or unfamiliar hardware or software is required
Activities                Capture the availability requirements, produce the availability schedule, estimate
                          platform availability, estimate functional availability, assess against the requirements,   Concerns                   Time constraints, cost constraints, required skill sets, available resources, budgets,
                          and rework the architecture                                                                                            and external dependencies

Tactics                   Select fault-tolerant hardware, use hardware clustering and load balancing, log             Activities                 Cost estimation, development time estimation, development planning, dependency
                          transactions, apply software availability solutions, select or create fault-tolerant                                   management, scoping, prototyping, and expectation management
                          software, and identify backup and disaster recovery solutions
                                                                                                                      Tactics                    Incremental and iterative development, expectation management, descoping,
Problems & Pitfalls       Single point of failure, overambitious availability requirements, ineffective error                                    prototyping and piloting, and fitness for purpose
                          detection, overlooked global availability requirements, and incompatible technologies
                                                                                                                      Problems & Pitfalls        Overly ambitious timescales, failure to consider lead times, failure to consider
                                                                                                                                                 physical constraints, underbudgeting, failure to provide staff training and consider
                                                                                                                                                 familiarization needs, insufficient resource allocation for testing and rollout,
Applicability to Views                                                                                                                           insufficient time for likely rework, and overallocation of staff
Functional                Functional changes may sometimes be needed to support availability requirements,
                          such as the ability to operate in an offline mode a network is unavailable.
                                                                                                                      Applicability to Views
Information               A key availability consideration is the set of processes and systems for backup and
                          recovery.                                                                                   Functional                 Resource constraints such as short timescales or limitations on available skills often
                                                                                                                                                 impose restrictions on functionality and on functional qualities such as generality.
Concurrency               Features such as hardware replication and failover in your system may imply
                          changes or enhancements to your concurrency model.                                          Information                Complex or particularly sophisticated information models may require a large staff of
                                                                                                                                                 specialists to implement; and so may impose restrictions on your options.
Development               Your approach to achieving availability may impose design constraints on the
                          software modules that need captured in this view.                                           Concurrency                Concurrent architectures are often complex to implement, so you will need to
                                                                                                                                                 consider the development skills and testing time available to you.
Deployment                Availability and resilience can have a big impact on the deployment environment
                          such as fault-tolerant hardware, disaster recovery sites, redundancy & clustering.          Development                Cost constraints may limit the number of separate development and test
                                                                                                                                                 environments available to you.
Operational               May need to capture processes to allow the identification and recovery of problems
                          in the production environment and handle failure appropriately (e.g. failover & DR).        Deployment                 Again, cost constraints may limit your options for deployment, particularly where
                                                                                                                                                 redundancy and resilience are concerned.
                                                                                                                      Operational                You need to be aware of the cost implications of your proposed operational and
Checklist for Requirements Capture                                                                                                               support architecture.
  •    Are availability requirements defined, documented, and approved?
  •    Are availability requirements driven by business needs?                                                        Checklist for Requirements Capture
  •    Do availability requirements consider different classes of service, if appropriate?
  •    Do availability requirements strike a realistic balance between cost and need?                                   •    Have you understood the project’s key constraints in terms of time and budget, as well
                                                                                                                             as the room for manoeuvring if your architecture mandates extra resources?
  •    Do availability requirements consider online and batch availability?
                                                                                                                        •    Have you considered physical constraints such as existing capacity and office space?
  •    Do availability requirements take into account variations such as period end?
                                                                                                                        •    Have you balanced the benefits of unfamiliar technologies against their costs and risks?
  •    Do availability requirements take into account future changes a longer online day?
                                                                                                                        •    Which compromises are more likely to be accepted where resource constraints
  •    Can availability requirements be met by the chosen hardware and software platform?
                                                                                                                             necessitate this? To what extent could you limit scope, functionality, or even quality?
  •    Have you defined strategies for disaster recovery and business continuity?
                                                                                                                             Are you confident that savings would be realized by making such compromises?
  •    Do stakeholders have realistic expectations around unplanned downtime?
                                                                                                                        •    To what extent is there scope for deferring features until future releases of software?
                                                                                                                        •    Do you understand which functional and operational principles absolutely cannot be
Checklist for Architecture Definition                                                                                        compromised, no matter what the resource impact?
  •    Does the proposed architectural solution meet the availability requirements? Can this be
       demonstrated, either theoretically or based on previous practical experience?                                  Checklist for Architecture Definition
  •    Does the solution consider the time taken to recover from failure?
                                                                                                                        •    Is your architecture based on technologies already familiar to the developer community?
  •    Does the backup solution provide for the transactional integrity of restored data?
                                                                                                                        •    Is your architecture based on proven technologies as opposed to innovative ones?
  •    Can online backup be achieved? If not, it is feasible to shutdown for backups?
                                                                                                                        •    Have you assessed your architecture against existing infrastructure capabilities (e.g.
  •    Has consideration been given to restoring data from corrupt or incomplete backups?                                    desktop platforms) to see whether upgrades are required?
  •    Will the system respond gracefully to software errors, reporting them appropriately?                             •    Have you included in plans the costs of additional infrastructures for disaster recovery,
  •    Have you defined a suitable standby site in the architecture, if appropriate?                                         support, acceptance, and training?
  •    Have you defined and tested mechanisms for switching to standby environments?                                    •    Where new or unfamiliar technologies are used, have you considered the impacts of
  •    Have you assessed the impact of availability on functionality and performance?                                        staff training and support?
  •    Have you assessed the architecture for single points of failure and other weaknesses?                            •    Is your architecture simple enough to be built and supported by development/operations
  •    If you developed a fault-tolerant model, does this extend to all vulnerable components?                               staff who have only recently been trained?

                                                  11                                                                                                                    12
Evolution Perspective                                                                                                      Internationalisation Perspective
The Evolution perspective addresses the concerns related to dealing with evolution during the                              The Internationalization perspective is important for any system that will have users who
lifetime of a system and thus is relevant to most large-scale information systems because of                               speak different languages or come from different countries. If systems are aimed at a specific
the amount of change that most systems need to handle.                                                                     locale with no plans to move it into a wider area, this perspective has limited relevance.
Desired Quality            The ability of the system to be flexible in the face of the inevitable change that all          Desired Quality            The ability of the system to be independent from any particular language, country, or
                           systems experience after deployment, balanced against the costs of providing such                                          cultural group
                           flexibility
                                                                                                                           Applicability              Any system that may need to be accessed by users or operational staff from different
Applicability              Important for all systems to some extent; more important for longer lived and more                                         cultures or parts of the world, or in multiple languages, either now or in the future
                           widely used systems
                                                                                                                           Concerns                   Character sets, text presentation and orientation, specific language needs, cultural
Concerns                   Magnitude of change, dimensions of change, likelihood of change, timescale for                                             norms, automatic translation, and cultural neutrality
                           change, when to pay for change, development complexity, preservation of
                           knowledge, and reliability of change                                                            Activities                 Identification of system touch points, identification of regions of concern,
                                                                                                                                                      internationalization of code, and localization of resources
Activities                 Characterize the evolution needs, assess the current ease of evolution, consider the
                           evolution tradeoffs, and rework the architecture                                                Tactics                    Separation of presentation and content, use of message catalogs, system-wide use
                                                                                                                                                      of suitable character sets (e.g., Unicode), and specialized display and presentation
Tactics                    Contain change, create flexible interfaces, apply change-oriented architectural styles,                                    hardware
                           build variation points into the software, use standard extension points, achieve
                           reliable change, and preserve development environments                                          Problems & Pitfalls        Platforms not available in required locales, initial consideration of similar languages
                                                                                                                                                      only, internationalization performed late in the development process, incompatibilities
Problems & Pitfalls        Prioritization of the wrong dimensions, changes that never happen, impacts of                                              between locales on servers
                           evolution on critical quality properties, lost development environments, and ad hoc
                           release management
                                                                                                                           Applicability to Views
Applicability to Views                                                                                                     Functional                 The functional structure may need to reflect how presentation is separated from
                                                                                                                                                      content. General functionality should be independent of location.
Functional                 If the evolution required is significant, the functional structure will need to reflect this.
                                                                                                                           Information                The Information view defines which stored information needs to be internationalized
Information                If environment or information evolution is needed, a flexible information model will be                                    and how this will be achieved.
                           required.
                                                                                                                           Concurrency                This perspective has minimal impact on the Concurrency view.
Concurrency                Evolutionary needs may dictate particular element packaging or some constraints on
                           the concurrency structure (e.g., that it must be very simple).                                  Development                The Development view will need to reflect the impact of these factors on the
                                                                                                                                                      development environment. (e.g. internationalized test data or user message
Development                Evolution requirements may have a significant impact on the development                                                    catalogues).
                           environment that needs to be defined (e.g., enforcing portability guidelines).
                                                                                                                           Deployment                 The deployment environment may need to take into consideration such items as
Deployment                 This perspective rarely has a significant impact on the Deployment view because                                            internationalized input and presentation devices.
                           system evolution usually affects structures described in other views.
                                                                                                                           Operational                The Operational view may need to consider what functionality is provided to support
Operational                This perspective typically has less impact on the Operational view.                                                        the maintenance and administration of localized information and services, and how
                                                                                                                                                      support will be provided to different locations.

Checklist for Requirements Capture
                                                                                                                           Checklist for Requirements Capture
  •    Have you considered which evolutionary dimensions are most important for your
       system?                                                                                                               •    Have you agreed with stakeholders on the extent to which systems must be operable in
  •    Are you confident that you have done enough analysis to confirm that your prioritization                                   different languages or countries, either now or in the future?
       of evolutionary dimensions is valid?                                                                                  •    Have you considered all points at which the system has any human interaction? For
  •    Have you identified specific changes that will be required and the magnitude of each?                                      example, have you considered operational management and monitoring of the system
  •    Have you assessed the likelihood of each of your changes actually being needed?                                            or printed forms sent to customers to be filled in?
                                                                                                                             •    Have you identified whether there is a requirement for non-Western character sets such
Checklist for Architecture Definition                                                                                             as Kanji, which have special requirements for entry and presentation of data?
                                                                                                                             •    Does your analysis consider all types of interaction—screens, keyboards, printed
  •    Have you performed an architectural assessment to establish whether your architecture                                      reports, and so on?
       is sufficiently flexible to meet the evolutionary needs of your system?                                               •    If the system needs to convert between different units of measurement, have you
  •    Where change is likely, does your architectural design contain the change as far as                                        considered how this will be done while retaining suitable data precision?
       possible?
  •    Have you considered choosing an inherently change-oriented architectural style? If so,                              Checklist for Architecture Definition
       have you assessed the costs of doing so?
  •    Have you traded off the costs of your support for evolution against the needs of the                                  •    How confident are you that the architecture will meet all the requirements? Where you
       system as a whole? Are any critical quality properties negatively impacted by the design                                   are not, are mitigating activities in place (such as a proof-of-concept)?
       you have adopted?                                                                                                     •    Do the interactive elements of your architecture sufficiently separate presentation and
  •    Have you designed the architecture to accommodate only those changes you are                                               content to meet the system’s internationalization objectives?
       confident will be needed?                                                                                             •    If non-Western character sets such as Kanji must be supported, do your input and
  •    Can you recreate your development and test environments reliably?                                                          output devices accommodate these?
  •    Can you reliably and repeatedly build, test, and release your system?                                                 •    If standard text must be presented in multiple languages, have you designed facilities
  •    Is your chosen evolutionary approach the cheapest and least risky option of delivering                                     for maintaining such information?
       the initial system and the future evolution required?                                                                 •    Does your system sizing take into consideration the extra capacity (disk storage,
                                                                                                                                  network bandwidth, and so on) required for multibyte character sets?
                                                   13                                                                                                                        14
Location Perspective                                                                                                   Performance and Scalability Perspective
The Location perspective addresses the problems that arise when systems or system                                      This perspective helps you to address the two related quality properties of performance and
elements are physically distant from one another. If all elements are located in the same                              scalability. These properties are important because, in large systems, they can cause more
place, you can usually disregard this perspective.                                                                     unexpected, complex, and expensive problems late in the system lifecycle than most of the
                                                                                                                       other properties combined.
Desired Quality            The ability of the system to overcome problems brought about by the absolute
                           location of its elements and the distances between them                                     Desired Quality           The ability of the system to predictably execute within its mandated performance
                                                                                                                                                 profile and to handle increased processing volumes
Applicability              Any system whose elements (or other systems with which it interacts) are or may be
                           physically far from one another                                                             Applicability             Any system with complex, unclear, or ambitious performance requirements; systems
                                                                                                                                                 whose architecture includes elements whose performance is unknown; and systems
Concerns                   Time zones of operation, network link characteristics, resiliency to link failures, wide-
                                                                                                                                                 where future expansion is likely to be significant
                           area interoperability, high-volume operations, intercountry concerns (political,
                           commercial, and legal), and physical variations between locations                           Concerns                  Response time, throughput, scalability, predictability, hardware resource
                                                                                                                                                 requirements, and peak load behavior
Activities                 Geographical mapping, estimation of link quality, estimation of latency,
                           benchmarking, and modeling of geographical characteristics                                  Activities                Capture the performance requirements, create the performance models, analyze the
                                                                                                                                                 performance models, conduct practical testing, assess against the requirements, and
Tactics                    Avoidance of widely distributed transactions, architectural plans for wide-area link
                                                                                                                                                 rework the architecture
                           failure, and allowance for offline operation
                                                                                                                       Tactics                   Optimize repeated processing, reduce contention via replication, prioritize
Problems & Pitfalls        Invalid (wide-area) network assumptions; assumption of single point administration;
                                                                                                                                                 processing, consolidate related workloads, distribute processing over time, minimize
                           assumption of one primary time zone; assumption of end-to-end security; assumption
                                                                                                                                                 the use of shared resources, partition and parallelize, use asynchronous processing,
                           of an overnight batch period; failure to consider political, commercial, or legal
                                                                                                                                                 and make design compromises
                           differences; and assumption of a standard physical environment
                                                                                                                       Problems & Pitfalls       Imprecise performance and scalability goals, unrealistic models, use of simple
                                                                                                                                                 measures for complex cases, inappropriate partitioning, invalid environment and
Applicability to Views                                                                                                                           platform assumptions, too much indirection, concurrency-related contention, careless
                                                                                                                                                 allocation of resources, and disregard for network and in-process invocation
Functional                 The Functional view is often presented independently of real-world location
                                                                                                                                                 differences
                           concerns; typically, these are modelled in the Deployment view.
Information                If data is highly distributed, the Information view should describe how information is
                           kept synchronized, what update latencies are expected, how temporary                        Applicability to Views
                           discrepancies are handled, and how information is transformed between locations.
                                                                                                                       Functional                May reveal the need for changes and compromises to your ideal functional structure;
Concurrency                Concurrent processing across highly distributed parts of the system is likely to be                                   functional models also provide input to the creation of performance models.
                           problematic so the Concurrency view will need to reflect this.
                                                                                                                       Information               Allows identification of shared resources and the transactional requirements of each.
Development                If system development is spread over multiple locations, the Development view                                         May suggest possible replication or distribution approaches.
                           needs to explain how software will be managed, integrated, and tested.
                                                                                                                       Concurrency               Problems such as contention may cause concurrency redesign. View content may
Deployment                 The Deployment view must consider significant issues such as latency, lead times,                                     provide elements of performance models and calibration metrics.
                           and costs that are often associated with the rollout of wide-area networks.
                                                                                                                       Development               May need to contain performance and scalability patterns and anti-patterns.
Operational                The Operational view needs to consider how widely distributed systems are
                                                                                                                       Deployment                Performance models and calibration metrics are derived from the Deployment view.
                           monitored, managed, and repaired.
                                                                                                                                                 Applying this perspective will often suggest changes to the deployment environment.
                                                                                                                       Operational               Highlights the need for performance monitoring and management capabilities.
Checklist for Requirements Capture
  •    Have you agreed on the physical location of each component of the architecture?
                                                                                                                       Checklist for Requirements Capture
  •    Do you understand the requirements for throughput, response time, availability, and
       resilience for all connections between geographically distributed components?                                     •    Have you identified approved performance targets, at a high level at least, with key
  •    Are the performance and reliability expectations of the wide-area network realistic and                                stakeholders?
       achievable within the time and budget constraints?                                                                •    Have you considered targets for both response time and throughput?
  •    Have you understood how the system will accommodate multiple time zones? Does                                     •    Do your targets distinguish between observed performance (i.e., synchronous tasks)
       this include consideration of online and batch modes of working?                                                       and actual performance (i.e., taking asynchronous activity into account)?
  •    Have the bandwidth and response time requirements of high-volume operations such as                               •    Have you assessed your performance targets for reasonableness?
       distributed backups or distributed software updates been understood and approved?                                 •    Have you appropriately set expectations among your stakeholders of what is feasible in
  •    If there is a requirement to support offline operation when wide-area connectivity is not                              your architecture?
       available, are the service-level requirements for these clear and achievable?                                     •    Have you defined all performance targets within the context of a particular load on the
  •    Do the requirements account for the legal and political situations in different countries?                             system?
  •    Has the wide-area network infrastructure been factored into disaster recovery plans?
                                                                                                                       Checklist for Architecture Definition
Checklist for Architecture Definition                                                                                    •    Have you identified the major potential performance problems in your architecture?
  •    How confident are you that the architecture will meet all the requirements? Where you                             •    Have you performed enough testing and analysis to understand the likely performance
       are not, are mitigating activities in place (such as a proof-of-concept)?                                              characteristics of your system?
  •    Have you identified all points at which network protocol translations need to take place                          •    Do you know what workload your system can process? Have you prioritized the
       (e.g., TCP/IP to SPX/IPX), and does the architecture allow for this?                                                   different classes of work?
  •    If there is a requirement to support remote offline operation, does the architecture                              •    Do you know how far your proposed architecture can be scaled without major changes?
       incorporate suitable features to later recover and resubmit information?                                          •    Have you identified and validated the performance-related assumptions made?
  •    Do the disaster recovery features of the architecture extend to wide-area connectivity?                           •    Have you reviewed your architecture for common performance pitfalls?
                                                  15                                                                                                                   16
Regulation Perspective                                                                                                 Security Perspective
Unlike other system qualities, compliance with the law is an area where you cannot make                                The security perspective guides you as you consider the set of processes and technologies
compromises. Although you may be able to live with a system that is slow, occasionally                                 that allow the owners of resources in the system to reliably control who can perform what
unreliable, or potentially insecure, a system that does not comply with legal regulations may                          actions on particular resources.
be prevented from going into production or may expose the organization to risk of
prosecution.                                                                                                           Desired Quality            The ability of the system to reliably control, monitor, and audit who can perform what
                                                                                                                                                  actions on these resources and the ability to detect and recover from failures in
                                                                                                                                                  security mechanisms
Desired Quality            The ability of the system to conform to local and international laws, quasi-legal
                           regulations, company policies, and other rules and standards                                Applicability              Any systems with publicly accessible interfaces, with multiple users where the
                                                                                                                                                  identity of the user is significant, or where access to operations or information needs
Applicability              Any system that may be subject to laws or regulations
                                                                                                                                                  to be controlled
Concerns                   Statutory industry regulation, privacy and data protection, cross-border legal              Concerns                   Policies, threats, mechanisms, accountability, availability, and detection and recovery
                           restrictions, data retention and accountability, and organizational policy compliance
                                                                                                                       Activities                 Identify sensitive resources, define the security policy, identify threats to the system,
Activities                 Compliance auditing
                                                                                                                                                  design the security implementation, and assess the security risks
Tactics                    Assessment of architecture against regulatory and legislative requirements                  Tactics                    Apply recognized security principles, authenticate the principals, authorize access,
                                                                                                                                                  ensure information secrecy, ensure information integrity, ensure accountability,
Problems & Pitfalls        Not understanding regulations or resulting obligations, and being unaware of                                           protect availability, integrate security technologies, provide security administration,
                           statutory regulations                                                                                                  and use third-party security infrastructure
                                                                                                                       Problems & Pitfalls        Complex security policies, unproven security technologies, system not designed for
Applicability to Views                                                                                                                            failure, lack of administration facilities, technology-driven approach, failure to
                                                                                                                                                  consider time sources, overreliance on technology, no clear requirements or models,
Functional                 Regulations can have a significant impact on what the system does and how it                                           security as an afterthought, security embedded in the application code, piecemeal
                           works.                                                                                                                 security, and ad hoc security technology
Information                Especially in Europe, there is a great deal of legislation related to the retention, use,
                           and manipulation of personal information. The impact on the Information view may            Applicability to Views
                           include privacy, access control, retention and archive, audit, availability, and
                           distribution.                                                                               Functional                 Reveals which functional elements need to be protected. Functional structure may be
                                                                                                                                                  impacted by the need to implement your security policies.
Concurrency                This perspective has little or no impact on the Concurrency view.
                                                                                                                       Information                Reveals what data needs to be protected. Information models are often modified as a
Development                This perspective has little or no impact on the Development view, although if                                          result of security design (e.g., partitioning information by sensitivity).
                           production (live) test data is to be used, there may be restrictions on this.
                                                                                                                       Concurrency                Security design may indicate the need to isolate different pieces of the system into
Deployment                 This perspective has little or no impact on the Deployment view, although health and                                   different runtime elements, so affecting the system’s concurrency structure.
                           safety legislation could have an impact on the hardware deployed.
                                                                                                                       Development                Captures security related development guidelines and constraints.
Operational                This perspective has little or no impact on the Operational view.
                                                                                                                       Deployment                 May need major changes to accommodate security-oriented hardware or software, or
                                                                                                                                                  to address security risks.
Checklist for Requirements Capture
                                                                                                                       Operational                Needs to make the security assumptions and responsibilities clear, so that these
  •    Have you identified all legislation that applies to the functionality the system supports                                                  aspects of the security implementation can be reflected in operational processes.
       (e.g., employment law for a human resources system, or company law for a financial
       system) and assessed the architecture for compliance with these?
                                                                                                                       Checklist for Requirements Capture
  •    Have you identified the generic legislation that applies to software systems (e.g., health
       and safety, the environment, data protection) and assessed the architecture for                                   •    Have you identified the sensitive resources contained in the system?
       compliance with these?                                                                                            •    Have you identified the sets of principals that need access to the resources?
  •    Have you determined whether the system can be considered as touching on other                                     •    Have you identified the system’s needs for information integrity guarantees?
       countries in any way, and if so, what legislation it may be subject to as a result?                               •    Have you identified the system’s availability needs?
  •    Have you considered international law such as technology export restrictions?                                     •    Is there a security policy, including access control and information integrity needs?
  •    Have you identified the relevant internal business and technology regulations and                                 •    Is the security policy as simple as possible?
       standards? Have you assessed the architecture for compliance with these?                                          •    Have you worked through a formal threat model to identify security risks?
  •    If legislation requires registration with governmental agencies (e.g., the Data Protection                        •    Have you worked through example scenarios with your stakeholders so that they
       Registrar in the United Kingdom), have you applied for this registration, or do you have                               understand the planned security policy and the security risks the system runs?
       plans to make this happen?                                                                                        •    Have you reviewed your security requirements with external experts?
  •    Do your archive and retention plans conform to all applicable legislation?
                                                                                                                       Checklist for Architecture Definition
Checklist for Architecture Definition                                                                                    •    Have you addressed each threat identified in the threat model to the extent required?
  •    Does your architecture accommodate any required automated interfaces to regulatory                                •    Have you used as much third-party security technology as possible?
       bodies (e.g., automatic upload of accounting or taxation information)? Do these                                   •    Have you produced an integrated overall design for the security solution?
       interfaces conform to prescribed business and technical standards?                                                •    Have you considered all standard security principles when designing the infrastructure?
  •    Does the architecture conform to any mandated technical standards?                                                •    Is your security infrastructure as simple as possible?
                                                                                                                         •    Have you defined how to identify and recover from security breaches?
                                                                                                                         •    Have you applied the results of the Security perspective to all of the affected views?
                                                                                                                         •    Have external experts reviewed your security design?

                                                  17                                                                                                                     18
Usability Perspective
Applying the Usability perspective ensures that the system allows those who interact with it to
do so effectively. This perspective tends to focus on the end users of the system but should
also address the concerns of any others who interact with it directly or indirectly, such as
maintainers and support personnel.
Desired Quality            The ease with which people who interact with the system can work effectively

Applicability              Any system that has significant interaction with humans (users, operational staff, and
                           so on) or that is exposed to members of the public
Concerns                   User interface usability, business process flow, information quality, alignment of the
                           human–computer interface (HCI) with working practices, alignment of the HCI with
                           users’ skills, maximization of the perceived usability, and ease of changing user
                           interfaces
Activities                 User interface design, participatory design, interface evaluation, and prototyping

Tactics                    Separation of user interface from functional processing

Problems & Pitfalls        Failure to consider user capabilities, failure to use non-IT communication specialists,
                           failure to consider how concerns from other perspectives affect usability, overly
                           complex interfaces, assumption of a single type of user access, design based on
                           technology rather than needs, inconsistent interfaces, disregard for organizational
                           standards, and failure to separate interface and processing implementations


Applicability to Views
Functional                 The functional structure indicates where the system’s external interfaces are and
                           thus where usability needs to be considered. It may be impacted by usability needs
                           (e.g., the addition of interface services to support certain interaction styles) but is
                           unlikely to be changed significantly.
Information                Information quality (the provision of accurate, relevant, consistent, and timely data)
                           can have a large impact on usability.
Concurrency                This perspective typically has little or no impact on the Concurrency view.
Development                The results of applying the Usability perspective impact the Development view in
                           terms of the guidelines, standards, and patterns that ensure the creation of a
                           consistent and appropriate set of user interfaces for the system.
Deployment                 This perspective has little or no impact on the Deployment view, although usability
                           concerns could require changes to element deployment (e.g., due to response time
                           requirements).
Operational                The Usability perspective should consider the usability needs of the system’s
                           administrators.


Checklist for Requirements Capture
  •    Have you identified all of the system’s key touch points?
  •    Have you identified all of the different types of users who will interact with the system?
  •    Do you understand the type of usage (occasional, regular, transactional, unstructured)
       for each of the touch points?
  •    Have you taken into account the needs of support and maintenance staff and other
       second-line users?
  •    Do you understand the capabilities, experience, and expertise of the system’s users?
       Have you correctly mapped these into requirements for presentation and support?
  •    Have you taken into account any corporate standards for presentation and interaction,
       particularly for systems exposed to the public?

Checklist for Architecture Definition
  •    For Web and mobile platforms, have you considered the variation in bandwidth,
       hardware capabilities (screen resolution), and rendering software?
  •    Do the interface designs align in a sensible way with the business processes they are
       automating?
  •    If your system is exposed to the general public, have you obtained any necessary
       approvals from your marketing department for the use of company logos and so on?


                                                  19
