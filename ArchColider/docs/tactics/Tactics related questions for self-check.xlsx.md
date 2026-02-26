## Intro

| | These questionnaires could be used by an analyst, who poses each question, in turn, to the architect and records the responses, as a means of conducting a lightweight architecture review. Alternatively, the questionnaires could be employed as a set of reflective questions, that you could, on your own, use to examine your architecture.

In either case, to use these questionnaires, simply follow these four steps: | 
| | --- | 
| | 1. For each tactics question, fill the “Supported” column with Y if the tactic is supported in the architecture and with N otherwise. The tactic name in the “Tactics Question” column appears in bold. | 
| | 2. If the answer in the “Supported” column is Y, then in the “Design Decisions and Location” column describe the specific design decisions made to support the tactic and enumerate where these decisions are manifested (located) in the architecture. For example, indicate which code modules, frameworks, or packages implement this tactic. | 
| | 3. In the “Risk” column, indicate the anticipated/experienced difficulty or risk of implementing the tactic using a (H = high, M = medium, L = low) scale. For example, a tactic that was of medium difficulty or risk to implement (or which is anticipated to be of medium difficulty, if it has not yet been implemented) would be labeled M. | 
| | 4. In the “Rationale” column, describe the rationale for the design decisions made (including a decision to not use this tactic). Briefly explain the implications of this decision. For example, you might explain the rationale and implications of the decision in terms of the effort on cost, schedule, evolution, and so forth. | 

## Availability

| | # | Tactics Group | Tactics Question | Supported? (Y/N) | Risk | Design Decisions and Location | Rationale and Assumptions | 
| | --- | --- | --- | --- | --- | --- | --- | 
| | 1 | Detect faults | Does the system use ping/echo to detect a failure of a component or connection, or network congestion?  |  |  |  |  | 
| | 2 |  | Does the system use a component to monitor the state of health of other parts of the system? A system monitor can detect failure or congestion in the network or other shared resources, such as from a denial-of-service attack.  |  |  |  |  | 
| | 3 |  | Does the system use a heartbeat — a periodic message exchange between a system monitor and a process—to detect a failure of a component or connection, or network congestion?  |  |  |  |  | 
| | 4 |  | Does the system use a time stamp (as in section A.4.1) to detect incorrect sequences of events in distributed systems?  |  |  |  |  | 
| | 5 |  | Does the system do any sanity checking: checking the validity or reasonableness of a component’s operations or outputs?  |  |  |  |  | 
| | 6 |  | Does the system do condition monitoring, checking conditions in a process or device, or validating assumptions made during the design?  |  |  |  |  | 
| | 7 |  | Does the system use voting to check that replicated components are producing the same results? The replicated components may be identical replicas, functionally redundant, or analytically redundant.  |  |  |  |  | 
| | 8 |  | Do you use exception detection to detect a system condition that alters the normal flow of execution (e.g., system exception, parameter fence, parameter typing, timeout)?  |  |  |  |  | 
| | 9 |  | Can the system do a self-test to test itself for correct operation?  |  |  |  |  | 
| | 10 | Recover from faults (preparation and repair) | Does the system employ active redundancy (hot spare)? In active redundancy, all nodes in a protection group (a group of nodes where one or more nodes are “active”, with the remainder serving as redundant spares) receive and process identical inputs in parallel. allowing redundant spares to maintain synchronous state with the active node(s).  |  |  |  |  | 
| | 11 |  | Does the system employ passive redundancy (warm spare)? In passive redundancy, only the active members of the protection group process input traffic; one of their duties is to provide the redundant spare(s) with periodic state updates.  |  |  |  |  | 
| | 12 |  | Does the system employ spares (cold spares)? Here redundant spares of a protection group remain out of service until a tailover occurs, at which point a power-on-reset procedure is initiated on the redundant spare prior to its being placed in service.  |  |  |  |  | 
| | 13 |  | Does the system employ exception handling to deal with faults? Typically the handling involves either reporting the fault or handling it. potentially masking the fault by correcting the cause of the exception and retrying.  |  |  |  |  | 
| | 14 |  | Does the system employ rollback, so that it can revert to a previously saved good state (the ‘rollback line”) in the event of a fault?  |  |  |  |  | 
| | 15 |  | Can the system perform in-service software upgrades to executable code images in a non-service-affecting manner?  |  |  |  |  | 
| | 16 |  | Does the system systematically retry in cases where the component or connection failure may be transient?  |  |  |  |  | 
| | 17 |  | Can the system simply ignore faulty behavior (e.g., ignore messages sent from a source when it is determined that those messages are spurious)?  |  |  |  |  | 
| | 18 |  | Does the system have a policy of degradation when resources are compromised, maintaining the most critical system functions in the presence of component failures, and dropping less critical functions?  |  |  |  |  | 
| | 19 |  | Does the system have consistent policies and mechanisms for reconﬁguration after failures, reassigning responsibilities to the resources left functioning, while maintaining as much functionality as possible?  |  |  |  |  | 
| | 20 | Recover from faults (reintroduction)  | Can the system operate a previously failed or in-service upgraded component in a “shadow mode” for a predeﬁned time prior to reverting the component back to an active role?  |  |  |  |  | 
| | 21 |  | If the system uses active or passive redundancy, does it also employ state resynchronization, to send state information from active to standby components?  |  |  |  |  | 
| | 22 |  | Does the system employ escalating restart — that is, does it recover from faults by varying the granularity of the component(s) restarted and minimizing the level of service affected?  |  |  |  |  | 
| | 23 |  | Can message processing and routing portions of the system employ nonstop (as in section A.4.1) forwarding, where functionality is split into supervisory and data planes? In this case, if a supervisor fails, a router continues forwarding packets along known routes while protocol information is recovered and validated.  |  |  |  |  | 
| | 24 | Prevent faults  | Can the system remove components from service, temporarily placing a system component in an out-of-service state, for the purpose of mitigating potential system failures?  |  |  |  |  | 
| | 25 |  | Does the system employ transactions — bundling state updates so that asynchronous messages exchanged between distributed components are atomic, consistent, isolated, and durable?  |  |  |  |  | 
| | 26 |  | Does the system use a predictive model to monitor the state of health of a component to ensure that the system is operating within nominal parameters? When conditions are detected that are predictive of likely future faults, the model initiates corrective action.  |  |  |  |  | 
| | 27 |  | Does the system prevent exceptions from occurring by, for example, masking a fault, using smart pointers, abstract data types, or wrappers?  |  |  |  |  | 
| | 28 |  | Has the system been designed to increase its competence set, for aample by designing a component to handle more cases—iaults—as part of its normal operation?  |  |  |  |  | 
| | 29 |  |  |  |  |  |  | 
| | 30 |  |  |  |  |  |  | 
| | 31 |  |  |  |  |  |  | 
| | 32 |  |  |  |  |  |  | 
| | 33 |  |  |  |  |  |  | 
| | 34 |  |  |  |  |  |  | 
| | 35 |  |  |  |  |  |  | 
| | 36 |  |  |  |  |  |  | 
| | 37 |  |  |  |  |  |  | 
| | 38 |  |  |  |  |  |  | 
| | 39 |  |  |  |  |  |  | 
| | 40 |  |  |  |  |  |  | 
| | 41 |  |  |  |  |  |  | 

## Interoperability

| | # | Tactics Group | Tactics Question | Supported? (Y/N) | Risk | Design Decisions and Location | Rationale and Assumptions | 
| | --- | --- | --- | --- | --- | --- | --- | 
| | 1 | Locate | Does the system have a way to discover services (typically through a directory service)?   |  |  |  |  | 
| | 2 | Manage interfaces | Does the system have a way to orchestrate the activities of services? That is, does it have a control mechanism to coordinate, manage, and sequence the invocation of services?   |  |  |  |  | 
| | 3 |  | Does the system have a way to tailor interfaces? For example. can it add or remove  capabilities to an inter face such as translation, buffering, or data  smoothing?  |  |  |  |  | 

## Modifability

| | # | Tactics Group | Tactics Question | Supported? (Y/N) | Risk | Design Decisions and Location | Rationale and Assumptions | 
| | --- | --- | --- | --- | --- | --- | --- | 
| | 1 | Reduce size of a module   | Do you make modules simpler by splitting the module? For example,  if you have a large, complex module, can  you split it into two (or more) smaller, simpler modules?   |  |  |  |  | 
| | 2 | Increase cohesion   | Does the system consistently support increasing semantic coherence? For example, if responsibilities in a module do not serve the same purpose, they should be placed in different modules. This may involve creating a new module or moving  a responsibility to an existing module.   |  |  |  |  | 
| | 3 | Reduce coupling   | Does the system consistently encapsulate functionality? This typically involves isolating the functionality under scrutiny and introducing  an explicit interface to it. |  |  |  |  | 
| | 4 |  | Does the system consistently use an intermediary to keep modules from being too tightly coupled? For example, if A calls concrete functionality C, you might introduce an abstraction B that mediates between A and C.   |  |  |  |  | 
| | 5 |  | Do you restrict dependencies between modules in a systematic way? Or is any system module free to interact  with any other module?   |  |  |  |  | 
| | 6 |  | When two or more unrelated modules change together—that is. when they are regularly affected by the  same changes—do you regularly refactor the  functionality to isolate the shared functionality  as common code in a distinct module?   |  |  |  |  | 
| | 7 |  | Does the system abstract common services, in cases where you are providing several similar services? For example, this technique is often used when you want your  system to be portable across operating sys tems, hardware. or other environment variations. |  |  |  |  | 
| | 8 | Deter binding | Does the system regularly defer binding of important functionality so that it can be replaced later in the life cycle, perhaps even  by end users? For example, do you use plug-ins, add-ons, or user scripting to extend the functionality of the  system? |  |  |  |  | 
| | 9 |  |  |  |  |  |  | 
| | 10 |  |  |  |  |  |  | 
| | 11 |  |  |  |  |  |  | 
| | 12 |  |  |  |  |  |  | 
| | 13 |  |  |  |  |  |  | 
| | 14 |  |  |  |  |  |  | 
| | 15 |  |  |  |  |  |  | 
| | 16 |  |  |  |  |  |  | 
| | 17 |  |  |  |  |  |  | 
| | 18 |  |  |  |  |  |  | 
| | 19 |  |  |  |  |  |  | 
| | 20 |  |  |  |  |  |  | 
| | 21 |  |  |  |  |  |  | 

## Performance

| | # | Tactics Group | Tactics Question | Supported? (Y/N) | Risk | Design Decisions and Location | Rationale and Assumptions | 
| | --- | --- | --- | --- | --- | --- | --- | 
| | 1 | Control resource demand | If your inputs are a continuous stream of data, does the system manage the sampling rate? That is, is it possible to sample the data at varying rates (with concomitant changes in accuracy/fidelity)?  |  |  |  |  | 
| | 2 |  | Does the system monitor and limit its event response? Does the system limit the number of events it responds to in a time period, to ensure predictable responses for the events that are actually serviced?  |  |  |  |  | 
| | 3 |  | Given that you may have more requests for service than available resources, does the system prioritize events?  |  |  |  |  | 
| | 4 |  | Does the system reduce the overhead of responding to service requests by, for example, removing intermediaries or co-locating resources?  |  |  |  |  | 
| | 5 |  | Does the system monitor and bound execution time? More generally, do you bound the amount of any resource (e.g., memory, CPU, storage, bandwidth, connections, locks) expended in response to requests for services?  |  |  |  |  | 
| | 6 |  | Do you increase resource efﬁciency? For example, do you regularly improve the efficiency of algorithms in critical areas, to decrease latency and improve throughput?  |  |  |  |  | 
| | 7 | Manage resources | Can the system seamlessly increase resources (e.g., CPU, memory, network bandwidth)?  |  |  |  |  | 
| | 8 |  | Can the system introduce concurrency? For example, does it support the seamless addition of parallel processing streams so that more requests for services can be processed concurrently?  |  |  |  |  | 
| | 9 |  | Does the system maintain multiple copies of data (e.g., by replicating databases or using caches) to decrease contention for frequeme accessed data?  |  |  |  |  | 
| | 10 |  | Does the system maintain multiple copies of computations (e.g., by keeping a pool of servers in a server farm) to decrease contention for frequently accessed computational resources?  |  |  |  |  | 
| | 11 |  | Does the system bound queue sizes? That is, do you limit the number of events placed in a queue, waiting for services?  |  |  |  |  | 
| | 12 |  | Does the system schedule resources, particularly scarce resources, so that they may be allocated according to an explicit scheduling POliCV’?  |  |  |  |  | 
| | 13 |  |  |  |  |  |  | 
| | 14 |  |  |  |  |  |  | 
| | 15 |  |  |  |  |  |  | 
| | 16 |  |  |  |  |  |  | 
| | 17 |  |  |  |  |  |  | 
| | 18 |  |  |  |  |  |  | 
| | 19 |  |  |  |  |  |  | 
| | 20 |  |  |  |  |  |  | 
| | 21 |  |  |  |  |  |  | 
| | 22 |  |  |  |  |  |  | 

## Security

| | # | Tactics Group | Tactics Question | Supported? (Y/N) | Risk | Design Decisions and Location | Rationale and Assumptions | 
| | --- | --- | --- | --- | --- | --- | --- | 
| | 1 | Detecting attacks | Does the system support the detection of intrusions? An example is comparing network trafﬁc or service request patterns within a system to a set of signatures or known patterns of mali- cious behavior stored in a database.  |  |  |  |  | 
| | 2 |  | Does the system support the detection of denial-of-service attacks? An example is the comparison of the pattern or signature of network traffic coming into a system to historic profiles of known deni- al-of-service attacks.  |  |  |  |  | 
| | 3 |  | Does the system support the verification of message integrity? An example is the use of techniques such as checksums or hash val- ues to verify the integrity of messages, resource ﬁles, deployment ﬁles, and configuration files. |  |  |  |  | 
| | 4 |  | Does the system support the detection of message delays? An example is checking the time that it takes to deliver a message.  |  |  |  |  | 
| | 5 | Resisting attacks | Does the system support the identiﬁcation of actors? An example is identifying the source of any external input to the system.  |  |  |  |  | 
| | 6 |  | Does the system support the authentication of actors? An example is ensuring that an actor (a user or a remote computer) is actually who or what it purports to be.  |  |  |  |  | 
| | 7 |  | Does the system support the authorization of actors? An example is ensuring that an authenticated actor has the rights to access and modify either data or services.  |  |  |  |  | 
| | 8 |  | Does the system support limiting access? An example is controlling what and who may access which parts of a system, such as processors, memory, and network connections.  |  |  |  |  | 
| | 9 |  | Does the system support limiting exposure? An atample is reducing the probability of a successful attack, or restricting the amount of potential damage, by concealing facts about a system (“security by obscurity") or dividing and distributing critical resources (“don’t put all your eggs in one basket').  |  |  |  |  | 
| | 10 |  | Does the system support data encryption? An example is to apply some term of encryption to data and to communication.  |  |  |  |  | 
| | 11 |  | Does the system validate input in a consistent, system-wide way? An example is the use of a security framework or validation class to perform actions such as filtering, canonicalization, and escaping of external input.  |  |  |  |  | 
| | 12 |  | Does the system design consider the separation of entities? An example is the physical separation of different servers attached to different networks, the use of virtual machines, or an ‘air gap”.  |  |  |  |  | 
| | 13 |  | Does the system support changes in the default settings? An example is forcing the user to change settings assigned by default.  |  |  |  |  | 
| | 14 | Reacting to attacks  | Does the system support revoking access? An example is limiting access to sensitive resources, even for normally legitimate users and uses, if an attack is suspected.  |  |  |  |  | 
| | 15 |  | Does the system support Iocking access? An example is limiting access to a resource if there are repeated failed attempts to access it.  |  |  |  |  | 
| | 16 |  | Does the system support informing actors? An example is notifying operators. other personnel, or cooperating systems when an attack is suspected or detected.  |  |  |  |  | 
| | 17 | Recovering from attacks | Does the system support maintaining an audit trail? An example is keeping a record of user and system actions and their ettects, to help trace the actions of, and to identify, an attacker  |  |  |  |  | 
| | 18 |  |  |  |  |  |  | 
| | 19 |  |  |  |  |  |  | 
| | 20 |  |  |  |  |  |  | 
| | 21 |  |  |  |  |  |  | 

## Testability

| | # | Tactics Group | Tactics Question | Supported? (Y/N) | Risk | Design Decisions and Location | Rationale and Assumptions | 
| | --- | --- | --- | --- | --- | --- | --- | 
| | 1 | Control and observe system state | Does the system or the system components provide specialized interfaces to facilitate testing and monitoring?  |  |  |  |  | 
| | 2 |  | Does the system provide mechanisms that allow information that crosses an interface to be recorded so that it can be used later for testing purposes (record/playback)?  |  |  |  |  | 
| | 3 |  | Is the state of the system, subsystem, or modules stored in a single place to facilitate testing (localized state storage)?  |  |  |  |  | 
| | 4 |  | Can you abstract data sources—for example. by abstracting interfaces? Abstracting the interfaces lets you substitute test data more easily. |  |  |  |  | 
| | 5 |  | Can the system be executed in isolation (a sandbox) to experiment or test it without worrying about having to undo the consequences of the experiment?  |  |  |  |  | 
| | 6 |  | Are executable assertions used in the system code to indicate when and where a program is in a faulty state?  |  |  |  |  | 
| | 7 | Limit complexity  | Is the system designed in such a way that structural complexity is limited? Examples include avoiding cyclic dependencies, reducing dependencies, and using techniques such as dependency injection.  |  |  |  |  | 
| | 8 |  | Does the system include few or no (i.e., limited) sources of nondeterminism? This helps to limit the behavioral complexity that comes with unconstrained parallelism, which in turn simplifies testing.  |  |  |  |  | 
| | 9 |  |  |  |  |  |  | 
| | 10 |  |  |  |  |  |  | 
| | 11 |  |  |  |  |  |  | 
| | 12 |  |  |  |  |  |  | 
| | 13 |  |  |  |  |  |  | 
| | 14 |  |  |  |  |  |  | 
| | 15 |  |  |  |  |  |  | 
| | 16 |  |  |  |  |  |  | 
| | 17 |  |  |  |  |  |  | 
| | 18 |  |  |  |  |  |  | 
| | 19 |  |  |  |  |  |  | 

## Usability

| | # | Tactics Group | Tactics Question | Supported? (Y/N) | Risk | Design Decisions and Location | Rationale and Assumptions | 
| | --- | --- | --- | --- | --- | --- | --- | 
| | 1 | Supporting user initiative | Does the system support operation canceling?  |  |  |  |  | 
| | 2 |  | Does the system support operation undoing?  |  |  |  |  | 
| | 3 |  | Does the system support operations to be paused and later resumed? Examples are pausing the download of a file in a web browser and allowing the user to retry an incomplete (and failed) download.  |  |  |  |  | 
| | 4 |  | Does the system support operations to be applied to groups of objects (aggregation)? For example, does it allow you to see the cumulative size of a number of tiles that are selected in a file browser window?  |  |  |  |  | 
| | 5 | Support system initiative | Does the system provide assistance to the user based on the tasks that he or she is performing (by maintaining a task model)? Examples include:  - Validation of input data  - Drawing user attention to changes in the UI  - Maintaining UI consistency  - Adding toolbars and menus to help users find functionality provided by the UI  - Using wizards or other techniques to guide users in performing key user scenarios  |  |  |  |  | 
| | 6 |  | Does the system support adjustments to the UI with respect to the class of users (by maintaining a user model)? Examples include supporting Ul customization (including localization) and supporting accessibility.  |  |  |  |  | 
| | 7 |  | Does the system provide appropriate feedback to the user based on the system characteristics (by maintaining a system model)? Examples include:  - Avoiding blocking the user while handling long-running requests  - Providing feedback on action progress (i.e., progress bars)  - Displaying userfriendly errors without exposing sensitive data by managing exceptions  - Adjusting the UI with respect to screen size and resolution  |  |  |  |  | 
| | 8 |  |  |  |  |  |  | 
| | 9 |  |  |  |  |  |  | 
| | 10 |  |  |  |  |  |  | 
| | 11 |  |  |  |  |  |  | 
| | 12 |  |  |  |  |  |  | 
| | 13 |  |  |  |  |  |  | 
| | 14 |  |  |  |  |  |  | 
| | 15 |  |  |  |  |  |  | 
| | 16 |  |  |  |  |  |  | 
| | 17 |  |  |  |  |  |  | 
| | 18 |  |  |  |  |  |  | 
| | 19 |  |  |  |  |  |  | 
| | 20 |  |  |  |  |  |  | 
| | 21 |  |  |  |  |  |  | 
| | 22 |  |  |  |  |  |  | 
| | 23 |  |  |  |  |  |  | 
| | 24 |  |  |  |  |  |  | 
| | 25 |  |  |  |  |  |  | 

## DevOps

| | # | Tactics Group | Tactics Question | Supported? (Y/N) | Risk | Design Decisions and Location | Rationale and Assumptions | 
| | --- | --- | --- | --- | --- | --- | --- | 
| | 1 | Testability: control and observe system state | Does the system or the system components provide specialized interfaces to facilitate testing and monitoring?  |  |  |  |  | 
| | 2 |  | Does the system provide mechanisms that allow information that crosses an interface to be recorded so that it can be used later for testing purposes (record/playback)?  |  |  |  |  | 
| | 3 |  | Can the system be executed in isolation (a sandbox) to experiment or test it without worrying about having to undo the consequences of the experiment?  |  |  |  |  | 
| | 4 | Performance: manage resources | Can the system seamlessly increase resources (e.g., CPU, memory, network bandwidth)? |  |  |  |  | 
| | 5 |  | Can the system introduce concurrency? For example, does it support the seamless addition of parallel processing streams so that more requests for services can be processed concurrently?   |  |  |  |  | 
| | 6 |  | Does the system maintain multiple copies of data (9.9., by replicating databases or using caches) to decrease  contention for frequently accessed data?   |  |  |  |  | 
| | 7 |  | Does the system maintain multiple copies of computations (e.g., by keeping a pool of servers in a server  farm) to decrease contention for frequently  accessed computational resources?   |  |  |  |  | 
| | 8 |  | Does the system schedule resources, particularly scarce resources,  so that they may be allocated according to  an explicit scheduling policy?   |  |  |  |  | 
| | 9 | Performance: control resource  demand | Does the system reduce overhead of responding to service requests by, for example, removing intermediaries or co-locating resources?   |  |  |  |  | 
| | 10 |  | If your inputs are a continuous stream of data, does the system manage the sampling rate?  That is, is it possible tor you to sample the data at varying rates (with concomitant changes in accuracy/fidelity)?   |  |  |  |  | 
| | 11 |  | Does the system monitor and limit its event response? That is, does the system limit the number of events  it responds to in a  time period, to ensure predictable responses for the events that are actually serviced?   |  |  |  |  | 
| | 12 |  | Given that you may have more requests for service than available resources, does the system prioritize events? |  |  |  |  | 
| | 13 | Modifiability: reducecoupling | Does the system consistently encapsulate functionality? This typically involves isolating the functionality under scrutiny and introducing an explicit interface to it. |  |  |  |  | 
| | 14 |  | Does the system abstract common services, in cases where you are providing several similar services? For example, this technique is often used when you want your system to be portable across operating systems, hardware, or other environment variations. |  |  |  |  | 
| | 15 | Modifiability: deferbinding | Does the systemregularly defer binding of important functionality so that it can be replaced later in the lifecycle, perhaps even by end users? For example, do you use plugins, addons, or user scripting to extend the functionality of the system? |  |  |  |  | 
| | 16 | Availability: detectfaults | Does the system use acomponent to monitor the state of health of other parts of the system? A system monitor can detect failure or congestion in the network or other shared resources, such as from a denial of service attack. |  |  |  |  | 
| | 17 |  | Do you use exception detection to detect a system condition that alters the normal flow of execution (e.g., system exception, parameter fence, parameter typing, timeout)?   |  |  |  |  | 
| | 18 |  | Does the system use voting to check that replicated components are producing the same results? The replicated components may be identical replicas, functionally redundant, or analytically redundant.   |  |  |  |  | 
| | 19 | Availability: recover from faults (preparation and  repair) | Does the system employ rollback, so that it can revert to a previously  saved good state (the “rollback line”) in the  event of a fault?   |  |  |  |  | 
| | 20 |  | Does the system employ active redundancy  (hot spare)? In active redundancy, all nodes  in a protection group (a group of nodes where one or more nodes  are ‘active”, with the remainder sewing as redundant spares) receive and process identical inputs in parallel, allowing redundant spares to  maintain synchronous state with the active  node(s).   |  |  |  |  | 
| | 21 |  | Does the system have consistent policies  and mechanisms for reconﬁguration after failures, reassigning responsibilities to the resources left functioning, while maintaining as much functionality as possible?   |  |  |  |  | 
| | 22 |  | Does the system employ exception handling  to deal with faults? Typically, the handling involves either reporting the fault or handling it, potentially masking the  fault by correcting the cause of the exception  and retrying. |  |  |  |  | 
| | 23 |  |  |  |  |  |  | 
| | 24 |  |  |  |  |  |  | 
| | 25 |  |  |  |  |  |  | 
| | 26 |  |  |  |  |  |  | 
| | 27 |  |  |  |  |  |  | 
| | 28 |  |  |  |  |  |  | 
| | 29 |  |  |  |  |  |  | 
| | 30 |  |  |  |  |  |  | 
| | 31 |  |  |  |  |  |  | 
