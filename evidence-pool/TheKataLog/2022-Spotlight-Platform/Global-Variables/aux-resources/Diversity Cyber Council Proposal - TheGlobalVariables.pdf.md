Diversity Cyber Council
          Illuminating Possibilities

Spotlight App Platform - Proposed Architecture
                June 23, 2022
      Scott Lew
      Cloud Architect



                        Donald Donovan
                        Consultant
                                                                Samira Barouti
                                                                Principal Software Engineer




                                         Presented by:

                                         TheGlobalVariables
                                         https://github.com/IlluminatePossibilities/TheGlobalVariables

Marc Boudreau
Principal Engineer
Proposed Solution
Convenient, Accessible, Usable
SSO Login

Rich-text editor

Search services

Map
Smarter Recommendations, Effective Collaboration
Cost-Effective,
Serverless
Faster Deployment
Reporting
TODO: D3, generic examples
Prioritized Architectural Characteristics
●   Usability
●   Responsiveness
●   Feasibility
●   Elasticity
●   Security
●   Privacy
●   Interoperability
●   Data Integrity
Context
Diagram
Container
Diagram
Architecture Decision Records
●   ADR 0001 - Choice of Serverless
●   ADR 0002 - Choice of Cloud Provider
●   ADR 0003 - Process Modeling
●   ADR 0004 - Observability
●   ADR 0005 - Amplify
●   ADR 0006 - Markdown
Major Risks
●   Vendor Lock-in
     ○   AWS Amplify and Serverless: Signiﬁcant eﬀort to move pipelines, deployment, dependent libraries
     ○   AWS Cognito: Signiﬁcant eﬀort and risks in moving local users
●   Third-Party Library Updates
     ○   Amplify and frontend libraries require frequent security updates to mitigate the exploitation of
         security vulnerabilities.
●   Staﬀ Training and Industry Knowledge
                 Thank you!



https://github.com/IlluminatePossibilities/TheGlobalVariables
