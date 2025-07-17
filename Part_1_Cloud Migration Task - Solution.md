Problem Statement:

Migrate an on-premise legacy Java application to the cloud, modernize the application, ensure availability, scalability using DevOps and SRE principles.

Approach and Solution:

1. Cloud Provider Selection:

   * Chossing AWS for its wide service offerings, global infrastructure, and managed services support.

2. Existing Architecture Analysis:

   * The legacy application is a monolithic Java-based application with a MySQL database hosted on physical servers.
   * Applications are built and deployed manually.

3. Migration Strategy (6R Analysis):

   * Rehost the monolith app as a Lift-and-Shift on EC2 temporarily.
   * Replatform the database from on-premise MySQL to Amazon RDS (MySQL engine).
   * Refactor the monolithic Java application into microservices for better scalability and modularity.

4. Cloud Architecture Design:

   * Frontend: React app hosted in S3 with CloudFront CDN for global low-latency delivery.
   * Backend: Java microservices containerized using Docker.
   * Orchestration: Amazon EKS (Elastic Kubernetes Service) to deploy and scale containers.
   * Database: Amazon RDS for MySQL.
   * Object Storage: Amazon S3 for file storage.
   * Networking: VPC with public and private subnets.
   * Security: IAM roles, Security Groups, and Secret Manager for credentials.
   * CI/CD: GitHub Actions integrated with AWS EKS via kubectl and Helm.

5. DevOps Implementation:

   * Version control using Git.
   * Dockerized microservices with Dockerfiles.
   * CI pipeline: On every code commit, build Docker image and push to Amazon ECR.
   * CD pipeline: Deploy the latest image to EKS using Helm charts.

6. Infrastructure as Code:

   * Used Terraform to provision:

     * VPC, Subnets, Internet Gateway, NAT Gateway
     * EKS cluster with node groups
     * RDS MySQL instance
     * S3 buckets
     * IAM roles and policies
   * Code stored in a Git repo and provisioned via GitHub Actions.

7. Monitoring and Logging:

   * Implemented using AWS CloudWatch and Prometheus with Grafana for application and infrastructure monitoring.
   * Fluent Bit for log aggregation and forwarding to CloudWatch Logs.

8. SRE Principles Applied:

   * Defined SLOs and SLIs for each microservice.
   * Implemented alerting using CloudWatch Alarms and Prometheus Alertmanager.
   * Applied Error Budget policies.
   * Conducted Chaos Engineering with tools like LitmusChaos on EKS.

9. Scalability and High Availability:

   * EKS nodes are auto-scaled using Cluster Autoscaler and HPA (Horizontal Pod Autoscaler).
   * Application replicas deployed across multiple Availability Zones.
   * RDS Multi-AZ enabled.

10. Security:

    * IAM roles for service accounts (IRSA) used in EKS for fine-grained access control.
    * Secrets stored in AWS Secrets Manager and fetched at runtime.
    * Ingress controller with TLS termination using ACM.
    * WAF and Shield enabled on CloudFront and ALB.

11. Testing and Deployment Strategy:

    * Unit and Integration tests in CI pipeline.
    * Canary deployments using Argo Rollouts on EKS.
    * Manual approval steps for production releases.

12. Backup and Disaster Recovery:

    * RDS automated backups and snapshots.
    * S3 versioning and lifecycle policies.
    * Application state stored in RDS and S3 for easy restoration.

13. Cost Optimization:

    * Right-sizing EC2 instances using AWS Cost Explorer recommendations.
    * Enabled EC2 Spot instances for non-prod workloads.
    * Storage tiering and lifecycle policies on S3.

14. Documentation and Handover:

    * All architecture, deployment, and troubleshooting docs maintained in Confluence and GitHub Wiki.
    * Knowledge transfer sessions conducted with development and operations teams.

15. Results:

    * Application modernized and successfully deployed on AWS.
    * Reduced deployment time from hours to minutes.
    * Enabled auto-scaling, self-healing, and observability for production workloads.
    * Improved system uptime and developer productivity.


