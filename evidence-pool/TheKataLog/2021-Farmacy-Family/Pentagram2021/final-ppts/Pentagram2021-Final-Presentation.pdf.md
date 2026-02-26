O’Rielly Architecture Katas Autumn 2021
                                                             Buland Malik


                                     Haidar Hadi




Farmacy Family System Architecture & Design                                 Ajay Sreehari




                                     Munir Mastalic


                                                      Somenath Mukherjee

                                                      Pentagram2021
Problem Statement
Wow, Food as medicine. Bob has been using awesome &
delicious food to overcome his health issues with obesity and
high blood pressure. He feels lucky that he found this great
platform known as Farmacy Food whose slogan is Food As
Medicine. He has been sharing this idea widely within his
circles and looking more better ways and means to become
an engaged customer where he can be the voice of the the
great initiative, connect with other similar minded people as
well as areas where he can improve to address his struggles
with his medical conditions.
Solution
We have been thinking about the extension of Farmacy Food as
well as heard our customers and we are happy to share that we
have started our efforts towards that. The overall idea is to make
sure we provide a platform to our huge customer base where
they can better engage themselves, be the voice of the program,
educate themselves via different wellness programs offered
through this new platform, easily able to engage with medical
providers to get better insights about how their overall health is
doing and rely on the platform for better suggestions to improve
their health using food as medicine and platform making sure
that right food is available in right areas considering all the
analytics results which is all based on difference set of customer
data.


                    Farmacy Family
Architecture Characteristics & Style
Quality Attributes/ Architecture Ilities / Characteristics
Architecture Styles




                             Service-based Architecture Style
        Decision is to use
                                    Event-Driven
System Design
Step 1: Component Identification
Using Workflow Approach (Event Storming DDD Concept) - Actor/Action Approach
Customer
           Signup to become Engage Customers (Provide Profile Info)
           Configure Preferences
                        Customer Info Community can see
                        Can be shared with medical service providers
           Create Forums
           Engage in Social events (classes, forums, wellness education programs)
           Engage with doctors & Dieticians
Dieticians
           Access Customer Profile
           Update Customer Profile
           Engage with Customers
System
           Integrate with Clinics
           Integrate with eDieticians
           Integrate with Farmacy Food
           Integrate with Generic Components (Notifications, Reports etc.)
           Gather Customer results and store it in Data Lake via Ingestion process
           Payments/Procurements???
Analytics
           Gather results from data lake and run ML Models
           Store Customer/Geographical suggestions/trends suggested by ML
Step 2 & 3: Assign Requirements to Components
Customer
           Customer Profile Capture                                         R1
           Preferences Capture
           Wellness Engagement Models                                       R2
           Medical Engagement models
Medical Providers
                                                                            R3
           Gather Results
           Analyze Results
           Give Suggestions/Advise                                          R4
Dieticians
           Access Customer Profile                                          R5
           Update Customer Profile
           Engage with Customers
System                                                                      R6
           Advertisement (Generating Leads for Email Notification)
           Integration with Clinics                                         R7
           Integration with eDieticians
           Integration with Farmacy Food
                                                                            R8
           Integration with Generic Components (Notifications etc.)
           Payments/Procurements???
           Store customer data in the Data Lake via Ingestion process       R9
           Payments/Procurements???
Analytics                                                                   R10
           Gather results from data lake and run run ML Models
           Store Customer/Geographical suggestions/trends suggested by ML
                                                                            R11
Strategic Design

       Uniqueness
                                    Supportive
                                                                     Core
                    Email/Text Messaging
                                      Scheduling          Customer          Analytics

                    Advertisement                         Customer Engagement
                                                 CMS
                     Notification                         System Engagement
                                         Medical System


                             Generic

                          AuthN & AuthZ


                                                                            Complexity
  User
Journey
System
Landscape
Diagram
Context
Diagram
Farmacy Family
Container
Diagram
Farmacy Family
Component
Diagram
Analytics
Container
Diagram
Farmacy Family
Deployment
Diagram
Key Links
• Farmacy Family artefacts root folder

• What went into consideration?
   • Requirements
   • Quality Attributes Identification
   • ADRs
   • Overall Solution
Thank You!
