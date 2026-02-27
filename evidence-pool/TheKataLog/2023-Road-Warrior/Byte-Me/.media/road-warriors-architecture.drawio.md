# road-warriors-architecture

*Extracted text labels from `road-warriors-architecture.drawio`*

## rw-highlevel-architecture

- Namespace
- Namespace
- Namespace
- Front end
- Microservices
- Utility services
- Managed Kubernetes cluster
- Pod autoscaling
- Client apps
- Virtual network
- Ingress
- External data stores
- Elasticsearch
- Prometheus
- Role-based access control
- AD Integration
- Monitoring services
- Azure Container Registry
- Docker push
- Docker pull
- API Gateway with WAF
- Cloud Kubernetes services
- Dashboard Coordinator
- AWS Aurora Writes
- Road Warriors High level architecture
- Read Replicas
- ElastiCache - Redis
- Cloud Front
- Pipelines
- CI/CD
- EMail
- Trip Service Provider
- Data Analytics

## final-rw-highlevel-architecture

- Cloud Front
- Client apps
- API Gateway
- Front end
- Microservices
- Utility services
- Managed Kubernetes cluster
- Pod autoscaling
- Virtual network
- Ingress
- Elasticsearch
- Prometheus
- Amazon Kubernetes services
- EMail Service
- Trip Service Provider
- Data Analytics
- Dashboard Coordinator
- Docker pull
- Web access firewall
- Centralized Logging & Auditing
- Centralized Monitoring
- Encryption
- Istio Service mesh
- Legend
- Rabbit MQ
- Cloud Geo instances
- AWS Aurora Writes
- Read Replicas
- ElastiCache - Redis
- External data stores
- Role-based access control
- AD Integration
- Cloud Monitoring  services
- Road Warriors High level architecture
- Amazon Container Registry
- Pipelines
- CI/CD

## ReferenceArchitecture

- Namespace
- Namespace
- Namespace
- Front end
- Back-end services
- Utility services
- Managed Kubernetes cluster
- Pod autoscaling
- Client apps
- Virtual network
- Ingress
- External data stores
- Elasticsearch
- Prometheus
- Role-based access control
- AD Integration
- Monitoring services
- Azure Container Registry
- Docker push
- Docker pull
- API Gateway with WAF
- Cloud Kubernetes services
- AWS Aurora Writes
- Road Warriors High level architecture
- Read Replicas
- ElastiCache - Redis
- Cloud Front
- Pipelines
- CI/CD

## build-pipeline

- Build pipeline
- Compile/Build
- Test
- Packaging
- Validation Test
- Full WindowsDebug
- Full WindowsRelease
- Docker
- Unit Test
- Integration Test
- Component Test
- Test Coverage
- Static Code Analysis
- 3rd Party Component Usage Tests
- Docker containers
- 3rd Party SW
- System
- Stability
- Performance
- Building Blocks
- Solutions realizing the building blocks
- Localization
- Goal of the build pipelineTo produce a quality artifact
- Documentation
- Build Monitoring
- Logging
- Monitoring
- Full web build
- Scalaility

## security-build-pipeline

- Build pipeline
- PR gate build
- Packaging
- Validation Test
- Docker container vulnerability scanning using JFrog
- Static code analysis checks using Sonarqube/CodeQL
- Building Blocks
- Security as part of the build process
- Goal of the secure build pipelineTo ensure security compliance of the infrastructure and product
- Build Monitoring
- 3rd party SW scanning using Mend (Whitesource)
- Secret scanning
- Full package signing
- Update package signing
- Docker container signing
- Nessus scans
- Penetration tests
- Automatic password renewal
- Referenceshttps://docs.github.com/en/enterprise-server@3.3/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/about-code-scanning-with-codeqlGitHub Advanced Security for Azure DevOps: https://devblogs.microsoft.com/devops/integrate-security-into-your-developer-workflow-with-github-advanced-security-for-azure-devops/
- Dependency Scanning
- 1
- 2
- 3
- 4
- 5
- 5
- 7
- Developer
- GitHub Advanced Security
- ADO/Amazon native tasks
- GitHub
- Pull requests
- Approval gates for deployments
- Azure Active Directory
- VS Code
- Visual Studio
- Nessus, STIG checks, Penetration tests
- 8
- Shift-left securityADO Multi factor authenticationSonar Lint/Additional security tooling in VS Code/Visual studioPush changes to remote serverPR Gate build GitHub Advanced security solutions: Secrets, CodeQL, dependency analysisPackage signing, Access checks to drop$Deployment Nessus scans, STIG checks, Penetration tests

## Page-6

- API Gateway
- Cloud Front
- Client apps
- Amazon Elasticsearch Service
