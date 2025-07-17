 Zantac Inc. | AWS Cloud Migration Strategy

This document outlines a comprehensive cloud migration strategy including current-state assessment, AWS target architecture, app-by-app migration approach, and phased rollout.
_____

# Current Infra

Zantac's infrastructure supports 8 major applications built using multiple technologies:

| Application                  | Technology Stack                         |
| ---------------------------- | ---------------------------------------- |
| E-commerce application       | Java J2EE                                |
| Retail Storefront (FE App)   | .NET Web App                             |
| Backend Systems              | Linux, WebLogic, Oracle                  |
| Middleware                   | MuleSoft ESB                             |
| Mobile Backend (Android/iOS) | B2B & B2C APIs                           |
| Big Data / Analytics         | Azure-based Analytics                    |
| CRM                          | Salesforce (SaaS)                        |
| Campaign Management          | Web tool integrated with CRM and backend |

___________

# Target AWS Architecture 

The AWS design is built around modularity, scalability, and high availability.

# Core Components used:

* VPC per environment:  (dev, test, prod) with isolated subnets
* Public Subnets: for Load Balancers, Bastion
* Private Subnets: for app/backend tiers
* NAT Gateways for secure internet access from private subnets
* Auto Scaling Groups (ASG) for EC2 workload elasticity
* Amazon RDS (Oracle or Aurora) for managed relational DBs
* ECS Fargate or EKS for containerized middleware
* S3 + Glue + Athena for analytics workloads
* API Gateway + Lambda for lightweight, scalable mobile APIs
* IAM, KMS, Secrets Manager for security
* CloudWatch + X-Ray + OpenSearch for logging/monitoring
* Route 53 + ACM for DNS and SSL cert management

 
______

# Migration Strategy: 

 1. Executive Summary

* Adopt AWS to increase scalability, agility, and reduce TCO.
* Managed services reduce ops burden.
* Risks: Migration downtime, data integrity, retraining.

 2. Current apps status

* Mix of Java, .NET, Oracle, Mule, Azure, Mobile, Salesforce.
* Data centers maintained in-house, high infra cost.

 3. AWS Target Architecture

* Modular VPC per environment.
* Multi-tier isolation (ALB → App → DB).
* Standardized CI/CD with CodePipeline, Terraform, Jenkins.
* Centralized logging & governance via CloudWatch/OpenSearch.

 4. App-by-App Migration Strategy


# Migration Plan (App-by-App)

| App Type                     | Migration Approach      | AWS Services Used                              |
| ---------------------------- | ----------------------- | ---------------------------------------------- |
| Java J2EE e-commerce         | Rehost or Replatform    | EC2 + ASG + ALB + RDS Oracle                   |
| .NET Retail Store App        | Replatform to Win EC2   | EC2 (Windows) + RDS SQL Server                 |
| Backend (Linux + WebLogic)   | Rehost                  | EC2 + RDS Oracle                               |
| Middleware (Mule ESB)        | Replatform (containers) | ECS Fargate + App Mesh                         |
| Mobile API Backend (B2B/B2C) | Rebuild (Serverless)    | API Gateway + Lambda + DynamoDB/S3             |
| Big Data Analytics (Azure)   | Migrate & Rebuild       | S3 + Glue + Athena + EMR                       |
| CRM (Salesforce)             | SaaS Integration        | Step Functions + API Gateway for orchestration |


 5. Security & Compliance

* IAM, SCPs, GuardDuty, AWS Config, CloudTrail enabled.
* Data encrypted at rest (KMS) and in transit (TLS/ACM).

 6. Monitoring & Logging

* Use CloudWatch for metrics and logs.
* OpenSearch for log aggregation and search.
* X-Ray for application tracing.

 7. Cost Considerations

* Leverage AWS Cost Explorer, Budgets, and S3 storage classes.
* Use Auto Scaling, Spot Instances where appropriate.

 8. Timeline & Phases

| Phase | Applications                           | Duration   |
| ----- | -------------------------------------- | ---------- |
| 1     | Mobile Backend, CRM                    | Week 1–2   |
| 2     | Middleware (Mule), Retail (.NET FE)    | Week 3–5   |
| 3     | Core Java + Backend (Oracle, WebLogic) | Week 6–10  |
| 4     | Analytics Migration                    | Week 11–13 |

__________


# Non-Functional and Solution (NFR)

| Category              | Solution/Tooling                             |
| --------------------- | -------------------------------------------- |
| Scalability       | Auto Scaling, ECS, Lambda                    |
| High Availability | Multi-AZ, ALB, RDS Multi-AZ                  |
| Security          | IAM Roles, KMS, Secrets Manager              |
| Monitoring        | CloudWatch, X-Ray, AWS Config                |
| Disaster Recovery | AWS Backup, Cross-region S3 replication      |
| Cost Optimization | Auto Stop, Reserved Instances, Cost Explorer |

____________
# Tools & Technologies

| Area          | Tools Used                           |
| ------------- | ------------------------------------ |
| Infra-as-Code | Terraform, Jenkins,Github            |
| App Hosting   | EC2, ECS, Lambda                     |
| Database      | Amazon RDS (Oracle/Aurora), DynamoDB |
| Monitoring    | CloudWatch, X-Ray                    |
| Security      | IAM, KMS, Secrets Manager            |
| Analytics     | Athena, Glue, S3, EMR                |

________________



