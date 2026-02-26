# Context
After an analysis of the [architecture characteristics](../README.md#architectural-characteristics) of Road Warrior, Availability, Reliability, Elasticity and Extensibility have been selected as the most important for the success of the system.

We now need to select an architecture style that is best caters for these characteristics.

We have identified a modular monolith, microservices and an event-driven system as best fitting to achieve what we aim for.

# Decision
A Microservices architecture style has been chosen. We felt the ability to manage the required architectural characteristics on a per-service basis means lowering the complexity of meeting targets such as uptime, fault-tolerance etc.

# Consequences
### Pros
- Microservices by design lend themselves to easily achieving elasticity and extensibility.
- There are several different parts of the bookings and trips workflows so being able to break down that complexity will help us with managing it long-term.
- The development team is already familiar with the architecture style so minimal coaching will be required

### Cons
- An eco-system of microservice comes with its own overhead. We will need to make tactical and strategic decisions for how much effort it is worth investing in having a robust eco-system at the different stages of lifetime of Road Warrior.
- Getting the boundaries between microservices is inherently difficult at the start as you can't know where the boundaries are before you discover more about your domain. We can consider doing some prototyping to answer questions and high probability ahead of time.