Architecture Katas On-line
Autumn 2021


       Neal Ford
       ThoughtWorks
       Director / Software Architect / Meme Wrangler
       http://www.nealford.com
       @neal4d
  NFJS Software Symposium Series 2016
      Mark Richards
      Independent Consultant
      Hands-on Software Architect, Published Author
      Founder, DeveloperToArchitect.com
      @markrichardssa
Judges Criteria
• Clarity of narrative
• Organization
• Supporting
  documentation
Narrative and Organization
A narrative tells the story of the architectural solution
Narrative and Organization
  A narrative arc a literary term for the path a story
 follows. It provides a backbone by providing a clear
       beginning, middle, and end of the story
https://github.com/TheJedis2020/arch_katas_2020
https://github.com/miyagis-forests/
         farmacy-food-kata
https://github.com/lookfwd/archkata
Completeness of
Solution
    Completeness of Solution




What’s Missing?
Identification of
Supporting
Architecture
Characteristics
    Architecture Characteristics
Architecture characteristics form the foundational aspects of the
 architecture and are required for proper trade-off analysis and
                        decision making


                                           Scope

                                           Justification
https://www.developertoarchitect.com/downloads/worksheets.html
  https://www.developertoarchitect.com/lessons/lesson112.html
Diagrams:
Types, level of
detail, and
completeness
                        Diagrams
An effective architecture picture is worth more than a 1,000 words.
   Architecture represents topology, which benefits from visual
                          representations.


                         “The goal of a diagram is to
                         convey a clear and shared
                         understanding of the
                         architecture”
                                             - Neal Ford
                            Diagrams
An effective architecture picture is worth more than a 1,000 words.
   Architecture represents topology, which benefits from visual
                          representations.




       component diagrams                context diagrams
                          Diagrams
An effective architecture picture is worth more than a 1,000 words.
   Architecture represents topology, which benefits from visual
                          representations.




       user journey diagrams             sequence diagrams
                             Diagrams
An effective architecture picture is worth more than a 1,000 words.
   Architecture represents topology, which benefits from visual
                          representations.




     system-level diagrams            deployment diagrams
                        Diagrams
An effective architecture picture is worth more than a 1,000 words.
   Architecture represents topology, which benefits from visual
                          representations.




                        user interface mockups
Architecture
Decision Records:
Documentation
and justification
    Second Law of
Software Architecture

    “Why is more
 important then how”
          architecture decision records
                  short text file; 1-2 pages long, one file per decision
                  markdown, textile, asciidoc, plaintext, etc.
# Title
                           short noun phrase
## Status
…                          proposed, accepted, superseded

## Context                 description of the problem and alternative
…
                           solutions available (documentation)
## Decision
…
                           decision and justification (the “why”)
## Consequences
…                          trade-offs and impact of decision
architecture decision records
                  architecture decision records
ADR 001: Use the microservice architecture style with containerization
Farmacy Food is a start up company and does not have a sizeable team of experienced developers
available. The overarching architecture style for the Farmacy Food system should be simple, easy to
create, maintain and evolve. Finding developers that can create and evolve the system, as well as tools
and frameworks that support the system should not require heaps of money. In other words, Farmacy
Food is not in a position to be an early adopter, and should hence adopt an established architecture style
that supports evolution.
                   architecture decision records
ADR_004 Use a centralized notification for external communication

Context
There was some confusion around the purpose of the notification component. Specifically, is this component
an event bus for all communication or is it a shared component for communicating externally.

Decision
We decided to have a dedicated notification system responsible of sending external notification. The reasons
include:
Overall Solution
            Overall Solution
The architecture solution describes the overall structure
     of the system and how it will be constructed

                         Are the architecture characteristics demonstrated
                         in the solution?

                         Is the solution appropriate and feasible given
                         the project constraints?

                         Are the architecture styles selected represented
                         in the solution?
Integration

Feasibility

Agility

Availability

Security

Scalability
Final
Architecture
Presentation
(Semi-Finalists)
The Kata
                   Definitions
• Transactional Customer – Farmacy Foods
• Engaged Customer - in Farmacy Family and Farmacy
  Foods
• Support Community - engaged members within a
  community
• Client - low-income families, elderly, first responders
• Community - small group of engaged customers within
  a neighborhood area
                    Overview
Farmacy Family is an enhancement of the existing
Farmacy Foods system (designed by Arch Colider from
the first Kata exercise) that adds tighter engagement with
their customers.

When a transactional customer purchases a meal,
Farmacy Family will generate an email elucidating
additional benefits available for becoming an engaged
customer.
              Primary Goals
• Develop relationships between engaged customers
  and nurture those relationships.

• Convert transactional customers to engaged
  customers.

• Generate analytical data from medical information
  to demonstrate the benefits of Farmacy Foods.
                        Goal

Thus, the overall goal of Farmacy Family is to connect,
gather, analyze, and communicate.
                  Users
 Hundreds, separated by distinct geographic
   zones. Additionally, different clusters of
  customers frequently consolidate around
similar dietary requirements. Mostly targeting
  low income, elderly, and first responders.
                         Requirements
• Add a new system to manage customer profiles, allowing community
  engagement, personalization around preferences and dietary needs

• Support geographical trend analysis to hone Farmacy Family’s ability to
  optimize the foods delivered to fridges (an additional integration point TO
  Farmacy Foods)

• Support both push and pull models for community engagement. In other
  words, Farmacy Family will manage forums,emails, and create connections
  between similar demographics. Farmacy Family needs transactional member
  information for outreach purposes. The engagement model includes
  subscriptions, forums, reference material, class information, and other media
  that supports Food-as-medicine
                        Technical Details
Domain areas
Onboarding
  • profile for customer
  • analytics
Community
  • forum (localized, temporal)
  • in person / virtual events (localized, temporal)
  • classes (localized, temporal)
  • interactive media library (global, reference)
  • general wellness education (global, reference)
Integration (extranet)
  • dietician
  • clinics
  • Farmacy Foods
                       Engagement Models
Clients
  • Covered above - building a community, education, increased awareness
Clinics - Work with clinics to establish baseline tests for clients
  • Gather results
  • Test every 3 months
  • Analyze results
  • Demonstrate any change in their overall health
  • use this info to gain investors and additional support and help
Dieticians
  • Farmacy Foods supported generic advice from dieticians. Farmacy Family
    will support one-on-one advice for engaged customers
  • Regular contact via messages
  • Selective access to medical information about the customer from a partner
    clinic
Family Foods
  • Farmacy Family needs to know which Transactional Customers (and their
    information) are not part of Farmacy Family (Engaged Customer) to start the
    onboarding process for those customers
  • Farmacy Foods needs to know which transactional customers are Engaged
    Customers
                      Requirements
• eDietian has access customer profile to improve advice and
  monitoring of customers. Additionally, the customer and dietitian can
  interact via messages.

• Farmacy Family wants to improve the distribution and potential food
  waste from having the wrong mix of foods in a particular fridge.

• Farmacy Family will include medical profile information and the
  ability to share information with medical service providers.

• Farmacy Family customers can customize how much profile
  information they want to allow the community to see, at a fine-
  grained level.
                       Requirements

• Farmacy Family has relationships with third party providers (clinics,
  doctors, etc) that have access to more analytical data to improve
  engagement (for example, regional dietary observations).

• Add Farmacy Family user interface to existing Foods interface, which
  is currently a Reactive monolith. Create a holistic UX for both food and
  Farmacy Family to support engagement model.
             Additional Context

• The new system must seamlessly incorporate into Farmacy
  Foods.

• Improved use of analytics driven through the new integration
  of Farmacy Family will help gather new investors and prove
  better dietary outcomes in member communities.
https://github.com/ldynia/archcolide
Event Sourcing
https://github.com/ldynia/archcolide
Meet the SME
Kwaku Osei
Founder, Farmacy Food
                Kwaku Osei is the founder of Farmacy Food, a a tech-enabled
                healthy food startup that to seeks to make health and
                wellness radically affordable and accessible, and Cooperative
                Capital, a community-based private equity fund that enables
                residents to pool their money together to make promising
                investments within their community.

                He was previously an Executive Associate at Rock Ventures,
                served as CEO to Project X LLC, and worked at Deloitte
                Consulting in DC. He currently serves on the boards of The
                Economic Development Corporation of the City of Detroit,
                Community Development Advocates for Detroit (CDAD),
                Detroit Community Wealth Fund, and Bridging Communities,
                Inc.
Meet the Judges
Pramod Sadalage
Director, Thoughtworks
                   Pramod Sadalage is Director at Thoughtworks where he enjoys
                   the rare role of bridging the divide between database
                   professionals and application developers. He is usually sent in to
                   clients with particularly challenging data needs, which require
                   new technologies and techniques. In the early 00’s he
                   developed techniques to allow relational databases to be
                   designed in an evolutionary manner based on version-controlled
                   schema migrations.

                   He is contributing author for Building Evolutionary Architectures
                   - Support Constant Change, co-author of Refactoring Databases,
                   co-author of NoSQL Distilled, author of Recipes for Continuous
                   Database Integration and continues to speak and write about
                   the insights he and his clients learn.
Emily Bache
Technical Agile Coach, ProAgile
                     Emily Bache is a Technical coach at ProAgile and also
                     a well known author and speaker. Emily works with
                     software development teams and organizations who
                     want to get better at the technical practices needed
                     to be agile, including Test-Driven Development,
                     Refactoring, Incremental Design and Architecture.
                     Emily’s most recent book “Technical Agile Coaching
                     with the Samman Method”
                     (https://leanpub.com/techagilecoach) details her
                     coaching methods. Originally from the UK, Emily lives
                     in Gothenburg, Sweden.
David Bock
Vice President of Strategic Development, Core4ce
                   • At Core4ce, Mr. Bock is the Vice President of Strategic
                     Development. Mr. Bock is responsible for turning new
                     ideas at Core4ce into successfully executed business
                     plans.
                   • Prior to joining Core4ce, Mr. Bock was the VP of Tech &
                     Engineering Mission Support at Decisiv, where he was
                     responsible for internal IT operations, Site Reliability
                     Engineering, Quality Assurance, Security, Customer
                     Service, and Release and Triage teams.
                   • David served as the Editor of O'Reilly's OnJava.com
                     website, has been published in several books and
                     magazines, and frequently speaks on technology &
                     team processes at software conferences.
Cassandra (Cassie) Shum
Thoughtworks, Technical Director, Enterprise
Modernization, Platform and Cloud NA
                   • Cassie is the Technical Director, Enterprise
                     Modernization, Platform and Cloud, for North America.
                     As a software engineer and architect, she has spent the
                     last 10+ years at Thoughtworks focusing on building
                     highly scalable and resilient architectures including
                     event-driven systems and microservices on cloud-based
                     technologies.
                   • Cassie has also been involved in growing not only
                     organizations in the delivery practices and technical
                     strategy but also the next generation of technologists.
                     Some of her passions include advocating for women in
                     technology and public speaking.
Contest Details
Important Dates & Reminders
• All teams must submit a google form
  (https://forms.gle/RfGAQS9Bso5CjKfD7) by
  October 22 , 5PM Eastern to participate
              nd



• Solutions are due in your GitHub repo by
  October 31 , midnight Eastern
              st



• Finalists will be announced at the second event
  on November 10     th



• Questions? Email us at katas@oreilly.com
