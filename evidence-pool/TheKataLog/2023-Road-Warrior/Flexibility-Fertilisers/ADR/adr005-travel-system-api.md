# Context
We will need to get information from travel systems and also take in updates when a booking is updated so that we can show that users can see detailed and up-to-date information about their booking within Road Warrior.

While why we interface with different travel systems is the same, there are still multiple different systems out there and we wouldn't know which one to contact until we look a the details of a particular booking.

# Decision
We will introduce a system to act as an abstraction to individual travel system to the rest of Road Warrior.

This new system will include a container for polling travel systems for updates and another for locating the travel system based on booking information provided.

For more details of the implementation see the [Travel System](../ContainerView/travel-system-api.md) API container view.

# Consequences
- As Road Warrior evolves we can add support for new travel systems without changing the behaviour of the rest of the system.
- This plays into architectural characteristic of extensibility, which we identified as a focus for Road Warrior.