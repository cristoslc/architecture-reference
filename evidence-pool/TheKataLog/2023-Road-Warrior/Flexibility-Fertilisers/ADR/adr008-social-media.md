# Context
When designing the social media system we realized that this means authenticating the user with the various social media services they may want to share with. We were faced with the decisions of either handling users social media login details ourselves and accessing the services via their respective APIs or outsourcing sharing and authentication by relying on the functionality in place for mobile apps.

# Decision
We have decided to use the sharing abilities mobile phones offer. This will offload authentication and authorization concerns to the social media apps on the user's phone. Doing this means we can avoid building out the social media systems for now and allows us to get to market quickly with sharing capabilities, albeit limited. 

# Consequences
- Architectural and implementation effort is reduced
- Sharing is limited to mobile phones
- Sharing options are limited to other apps the user has installed on their phone 