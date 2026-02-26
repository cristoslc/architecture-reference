# Context
Part of Road Warrior's business model is to gather a rich set of analytical data about users and their trips. 

We considered a regular (e.g. nightly) copy of the data available in persistent storage to an archive, polling of the operational systems or have it raise events to communicated changes to the system.

# Decision
We haven chosen to use asynchronous communication. 

In a Mircoservice architecture ownership of the data should lie with one service. Copying the database seems an infringement on that ownership, as well as tying the type and schema of analytical storage to the operational storage without further processing of the data.

Instead, using events, these can be selectively subscribed to by the data analytics system and stored in whatever way is suitable. Additionally, using an asynchronous method of communication, data analytics is decoupled from the other systems.

# Consequences
### Pros
- Data is available more timely than, e.g hourly polling, which could be useful during times of travel disruptions.
- Avoids calling the relevant operational services and increasing their load
- Data analytics can scale independently from other systems

### Cons
- Events can be dropped or not delivered - given the events are not relevant for operations, missing the occasional event may be acceptable. Mitigations like dead-lettering can be put in place.