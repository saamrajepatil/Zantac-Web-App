Part 2: Zantac Web App Deployment using Terraform, Ansible & Jenkins on AWS.


 * Tools Used

<img width="488" height="131" alt="image" src="https://github.com/user-attachments/assets/870a316a-0fb7-461d-8c68-ccb0a79656c1" />


This project demonstrates how to deploy a scalable web application on AWS using:
- Terraform for infrastructure provisioning with reusable modules
- Ansible for configuration management
- Jenkins for CI/CD automation
- GitHub Webhook + Auto Scaling Events to auto-trigger deployment pipelines

___________

  1. Infrastructure Provisioning with Terraform

The infrastructure is modularized into:

- `modules/vpc`: VPC, Subnets, Route Tables, IGW, Security Groups
- `modules/ec2`: Launch Template, Auto Scaling Group (ASG)
- `modules/alb`: Application Load Balancer, Target Group, Listener
- `modules/iam`: IAM user and policy for Jenkins/Ansible access

Steps:

cd main/
terraform init
terraform apply -auto-approve


* Once applied:

 A VPC is created with two public subnets
 ALB is created to route external traffic
 ASG launches EC2 instances tagged as Zantac-App-Node
 Security Groups are configured to allow ALB ↔ EC2 communication on port 8080
 Default userdata.sh installs Apache (httpd) and default index page

---

 2. Configuration Management with Ansible

Use Case:
Update application configuration like index.html or Apache settings across all EC2s.

 * Dynamic Inventory

We use `aws_ec2.yaml` plugin to discover EC2 instances dynamically based on tag:

yaml
plugin: amazon.aws.aws_ec2
regions:
  - us-east-1
filters:
  tag:Name: Zantac-App-Node
hostnames:
  - public_ip_address


* Ansible Directory Structure


ansible/
-ansible.cfg
-aws_ec2.yaml
-playbook.yml
________________________

 * Sample Playbook

yaml
- name: Update index.html on all app nodes
  hosts: tag_Zantac-App-Node
  become: true
  tasks:
    - name: Replace index.html
      copy:
        src: files/index.html
        dest: /var/www/html/index.html


____________________________________

 3. CI/CD Automation with Jenkins

Jenkins automates:

1. Terraform execution
2. Ansible playbook run

 * Jenkinsfile


pipeline {
  agent any
  stages {
    stage('Terraform Init & Apply') {
      steps {
        dir('main') {
          sh 'terraform init'
          sh 'terraform apply -auto-approve'
        }
      }
    }
    stage('Run Ansible Playbook') {
      steps {
        dir('ansible') {
          sh 'ansible-playbook -i aws_ec2.yaml playbook.yml'
        }
      }
    }
  }

  post {
    success { echo 'Deployment successful' }
    failure { echo 'Check pipeline logs' }
  }
}

_____________________

 4. Triggering CI/CD

There are two ways the Jenkins pipeline is triggered:

 A. GitHub Webhook Trigger

 Whenever you update userdata.sh, index.html, or any infra/ansible file and push to GitHub → Jenkins runs pipeline automatically.

 B. Auto Scaling Event Trigger

 When ASG launches a new EC2 instance → An SNS topic triggers a Jenkins pipeline via webhook to apply updated config using Ansible.

_____________

 Flow Summary

User pushes changes to GitHub ─▶ Jenkins builds triggered via webhook
                               └─▶ Runs Terraform → Provisions/updates infra
                               └─▶ Runs Ansible → Configures EC2s

Auto Scaling Event ─▶ SNS Topic ─▶ Jenkins Job → Runs Ansible for new instance

______________

  Architecture Diagram
zentac-cloud-migration/
├── ansible/
│   ├── aws_ec2.yaml             # Dynamic inventory config
│   ├── ansible.cfg              # Ansible config
│   ├── playbook.yml             # Main playbook
│   └── roles/
│       └── web/
│           ├── tasks/
│           │   └── main.yml     # Tasks like updating index.html
│           └── files/
│               └── index.html   # The updated HTML file
├── inventory/
│   └── ec2.py                   # (Optional) script for dynamic inventory (if used)
├── main/
│   ├── main.tf                  # Terraform root file
│   ├── variables.tf
│   └── output.tf
├── modules/
│   ├── alb/
│   ├── ec2/
│   ├── iam/
│   └── vpc/
├── userdata.sh                  # Used in Launch Template
├── Jenkinsfile                  # CI/CD pipeline definition
└── README.md



___________

 Security Notes

 SSH Key is stored securely and passed via Terraform
 Security Groups allow only required ports and source SGs
 No hardcoded credentials (use Jenkins credentials store)

_________

Final Result

 You access the web app using the ALB DNS
 Auto-scaling launches new EC2s → Jenkins auto-configures via Ansible
 Updates to code/config are pushed → Jenkins keeps everything updated

______

Solution implemenmnted iamges:

<img width="1598" height="900" alt="image" src="https://github.com/user-attachments/assets/8e09710f-1171-4cd5-8a82-d928985f9cbb" />

<img width="1595" height="863" alt="image" src="https://github.com/user-attachments/assets/46b7ef8d-c54b-4950-be11-a3522619eb5e" />


