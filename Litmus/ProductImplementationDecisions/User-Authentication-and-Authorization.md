## User Authentication and Authorization

### Status
- ACCEPTED

### Context

Certifiable, Inc. requires a secure and reliable user authentication and authorization mechanism for its SoftArchCert system. As the system will handle sensitive information related to certification candidates and expert software architects, it is essential to ensure that only authorized individuals can access specific functionalities and data within the application.

The system needs to accommodate different user roles, including:

Candidates: Individuals seeking certification.
Expert Software Architects: Employees responsible for grading exams and providing feedback.
Administrators: Personnel who maintain user accounts and manage system settings.

### Decision
Implement a Multi-Factor Authentication (MFA) solution combined with Role-Based Access Control (RBAC) to ensure secure user authentication and granular authorization.

Multi-Factor Authentication (MFA):
Require all users to complete an additional verification step beyond the username and password. This could include options such as SMS-based one-time passwords (OTPs), email confirmations, or authenticator apps (e.g., Google Authenticator, Authy).

Role-Based Access Control (RBAC):
Define user roles within the system with specific permissions associated with each role. Users will be assigned to roles based on their responsibilities:
Candidate: Can access their certification status, take exams, and submit architecture solutions.
Expert Software Architect: Can access grading dashboards, review submissions, and modify certification tests.
Administrator: Ability to edit the Expert Software Architect list.

### Alternatives Considered
Single-Factor Authentication:

Considered but rejected due to insufficient security against credential theft and unauthorized access. This approach does not provide adequate protection for sensitive information.
Attribute-Based Access Control (ABAC):

While ABAC offers flexibility, the complexity of managing policies based on multiple attributes was deemed too high for the current system requirements. The simpler RBAC model aligns better with the organization’s needs and current resource capabilities.

### References
- NIST Special Publication 800-63: Digital Identity Guidelines NIST
- OWASP Authentication Cheat Sheet: OWASP
- Role-Based Access Control (RBAC) Explained: NIST RBAC
- Multi-Factor Authentication: Federal Trade Commission - Safeguarding Personal Information

### Date
02/18/2025
