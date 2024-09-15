# Infrastructure as Code (IaC) Repository

This repository contains the Infrastructure as Code for my assessment, including Terraform code, Kubernetes resources, Jenkinsfile, Dockerfile, and application source code.

## Architecture Overview

My deployment platform architecture consists of 3 layers:

1. Infrastructure
2. Tools
3. Application

### Infrastructure Layer

- Virtual Network: VPC, Subnet, Security Group, NAT Gateway
- Core: Route53, ALB, ECR
- Main: EKS, EC2

### Tools Layer

- CI/CD Tools: Jenkins
- Observability Tools: Prometheus, Grafana
- TODO: Security Tools: SonarQube, Trivy, OWASP, Snyk 

### Application Layer

- Services: Frontend, Backend

## IaC Structure

I use Terraform for provisioning cloud resources, utilizing the workspace model and variable files (.tfvars) for environment-specific configurations.

## Note:
 Route53, Application Load Balancer, and ECR are currently set up manually.
 TODO: Implement IaC for these resources.

### Deployment Process

To deploy to a specific environment (e.g., "development"):

1. Use Tofu CLI to select the appropriate workspace:
```sh
cd provisions/infrastructure/main/<name>
tofu workspace select development
```
2. Plan and apply using the environment-specific .tfvars file:
```sh
tofu plan -var-file=environments/development/<name>.tfvars 
tofu apply -var-file=environments/development/<name>.tfvars
```

## CI/CD

- CI: Jenkins (Jenkinsfile pipelines stored in `deployments/backend/development` and `deployments/frontend/development`)
- CD: ArgoCD (syncs with Helm charts in `charts/private/backend` and `charts/private/frontend`)

## URL List

- Jenkins: jenkins.demo.kietvo.vn
- ArgoCD: argocd.demo.kietvo.vn
- Vault: vault.demo.kietvo.vn
- TODO: Application: demo.kietvo.vn
- TODO: SonarQube - sonarqube.demo.kietvo.vn
- TODO: Monitoring - grafana.demo.kietvo.vn
- TODO: Logging - kibana.demo.kietvo.vn

## Installation Runbook

1. Initialize Network
```sh
cd provisions/infrastructure/main/network 
tofu init 
tofu workspace select development 
tofu plan -var-file=../../environments/development/network.tfvars 
tofu apply -var-file=../../environments/development/network.tfvars
```

1. Initialize EKS
```sh
cd provisions/infrastructure/main/eks/ 
tofu init 
tofu workspace select development 
tofu plan -var-file=../../environments/development/eks.tfvars 
tofu apply -var-file=../../environments/development/eks.tfvars
```

2. Initialize Kubernetes resources in `charts/public/` and `provisions/`
- Setup Jenkins by running the script in `playbooks/tools/jenkins/install.sh`

3. Create SSH key (RSA) for GitHub "deploy key" to establish connections between GitHub, Jenkins, and ArgoCD

4. For Helm chart installation steps, refer to the README.md in the `charts` folder


