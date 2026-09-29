# Multi-Provider DevSecOps Infrastructure & CI/CD Pipeline

A production-grade infrastructure project built across multiple milestones, combining AWS cloud provisioning, dynamic networking, automated security linting, local Kubernetes integration, and Terragrunt state management.

---

## 🏗️ Project Architecture & Milestones

### 01. Foundation & Backend
* **S3 Remote State:** Provisioned an S3 bucket with versioning enabled to securely store Terraform state.
* **State Locking:** Utilized native S3 state locking, removing the requirement for a DynamoDB table.
* **Code Quality & Validation:** Integrated `pre-commit-terraform` hooks along with `tfsec` to block overly permissive security groups and `terraform-docs` for auto-documentation[cite: 4].
* **Workspaces:** Initialized isolated `dev` and `prod` Terraform workspaces[cite: 4].

### 02. Dynamic Networking
* **Dynamic IP Detection:** Used the `http` provider to fetch the workstation's public IP dynamically from `icanhazip.com`[cite: 4].
* **Secure Ingress:** Injected the fetched IP into Security Group rules to restrict SSH access (port 22) exclusively to the administrative location[cite: 4].
* **VPC & Subnets:** Built a modular network architecture using `aws_availability_zones` and `cidrsubnets()` to calculate public and private subnets[cite: 4].
* **Environment Sizing:** Implemented `terraform.workspace` conditional logic to deploy a single NAT Gateway for `dev` and one per AZ for `prod`[cite: 4].

### 03. Compute & Provisioning
* **Dynamic SSH Keys:** Generated a fresh RSA private key via the `tls` provider and stored it securely using `local_sensitive_file` with `0400` permissions[cite: 4].
* **Bastion Deployment:** Deployed a RHEL 9 Bastion host into the public subnet via an `aws_key_pair`[cite: 4].
* **Provisioning & Automation:** Configured a `time_sleep` resource for the SSH daemon to initialize, followed by `remote-exec` (installing tools like `jq`) and `local-exec` provisioners to export the Bastion IP[cite: 4].

### 04. Kubernetes Multi-Provider
* **Local Cluster:** Started a local Minikube cluster as the target for containerized workloads[cite: 4].
* **Multi-Provider Setup:** Configured Terraform's `kubernetes` and `helm` providers to interact with the local Minikube context[cite: 4].
* **Deployments:** Deployed an NGINX pod injecting the AWS Bastion IP via a ConfigMap, and installed the Traefik Ingress Controller using Helm[cite: 4].

### 05. CI/CD & Terragrunt Handover
* **GitHub Integration:** Configured the `github` provider with a Personal Access Token (PAT) to provision repositories and GitHub Actions Secrets securely[cite: 4].
* **Terragrunt Refactoring:** Migrated from hardcoded backend blocks to a modular `terragrunt.hcl` root configuration using `remote_state` to bypass Terraform backend limitations[cite: 4].
* **Environment Separation:** Refactored the project into isolated `dev/` and `prod/` directories sourcing shared underlying modules[cite: 4].

---

## 🚀 Getting Started

1. **Initialize Terraform / Terragrunt:**
   ```bash
   terragrunt init
