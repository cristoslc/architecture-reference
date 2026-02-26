# Context
The business wants to minimize the steps a user needs to take before a booking they have created with an external system is present in Road Warrior and our app is useful to them.

# Decision
We will develop 2 ways of directly picking up information from booking confirmation emails so that users don't need to input this automatically:

1. Users can provide access to all their emails in which case we will automatically scan them and filter out anything that is not a booking.
1. Users can set up a forwarding rule themselves so we only get access to relevant emails.

# Consequences
- The upside of this approach is that it significantly reduces the number of steps before a user can start using Road Warrior.
- There is quite a lot of complexity with this. Parsing emails is a task in and of itself. We are complicating it with filtering out emails 