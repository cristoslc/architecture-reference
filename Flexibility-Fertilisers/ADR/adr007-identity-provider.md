# Context
Users within the Road Warrior system will need to have their own profile that ensures nobody else can see or amend their bookings & trips.

There are no particular requirements when it comes to managing authorization or interaction between users.

# Decision
We will use an external Identity Provider like Azure AD B2C, Auth0 etc. to do the heavy lifting of securely managing user credentials & personal information as well as login flow.

# Consequences
- This can be easily extended to include things like multi-factor authentication.
- We can easily add other identity providers like logging in with Google, Facebook etc.
- Given the simplistic nature of the requirements we don't need to put much functionality other than keeping track of users and basic information like email, name etc.