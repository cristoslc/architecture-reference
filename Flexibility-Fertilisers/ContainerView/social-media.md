## Social Media
The PostCreator receives a request by the application to create a post. This is handled in RoadWarrior, instead of on the user's device so more booking and trip information than may be available on the device can be used to write the post.

![](social-media.png)

As described in this [ADR](../ADR/adr008-social-media.md), we only support sharing via the Road Warrior Mobile app.

### Sequence diagram
#### User shares booking or trip
```mermaid
sequenceDiagram
    Application->>PostCreator: Create post 
    PostCreator->>BookingSystem: Get trip
    BookingSystem-->>PostCreator: [trip]
    PostCreator->>BookingSystem: Get booking
    BookingSystem-->>PostCreator: [booking]
    PostCreator->>PostCreator: Create post
    PostCreator-->>Application: [post]
```