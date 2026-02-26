## Email System
The Email System parses a users emails for a booking and sends it to the booking system to be stored. It supports adding bookings only, update and deletions come from user input or updates from the travel system API.

An email is ingested by the system in the following ways:

1. The user forwards an email to the email server. The email is then parsed and the booking stored in the booking system.
2. The email is scraped from the user's specified email provider. All emails will be streamed into RoadWarrior and anything non-pertinent will be discarded.

The EmailProviderKey store holds authentication credentials to access the user's email provider.

![](email-system.png)

### Sequence diagrams
#### Email retrieved from EmailProvider
```mermaid
sequenceDiagram
    EmailProvider-)EmailRetriever: Email received
    EmailRetriever-)EmailFilter: email
    break email not relevant
        EmailFilter->>EmailFilter: discard email
    end
    EmailFilter-)EmailParser: email
    EmailParser->>EmailParser: Get booking ID from email
    break can't parse email
        EmailParser->>EmailParser: end
    end
    EmailParser->>BookingSystem: Booking ID
```
\* if a booking confirmation email is detected but can't be parsed, do nothing

#### Email forwarded to RoadWarrior by user
```mermaid
sequenceDiagram
    actor user as User
    user-)EmailServer: Forwards email
    EmailServer-)EmailParser: email
    EmailParser-)BookingSystem: Booking ID
```