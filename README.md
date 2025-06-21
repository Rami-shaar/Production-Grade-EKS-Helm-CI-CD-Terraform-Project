# 🌐 Production-Ready EKS + Helm + Microservices WebApp Infrastructure (Terraform)

This project provisions a complete, production-grade EKS infrastructure on AWS using **Terraform** and **Helm**. It includes modular infrastructure stacks for VPC, IAM, and EKS, and deploys Kubernetes microservices using `kubectl` — designed for real-world scalability, modularity, and GitOps-style automation.



![mermaid-diagram-2025-06-21-020747ww](https://github.com/user-attachments/assets/9e48d4e2-5157-4a55-a7c0-c2bdbe6b16b6)





---

## 🔧 Modules

### ☁️ Networking
- **VPC**: Custom VPC with CIDR block
- **Subnets**: 2 Public + 2 Private Subnets across multiple AZs
- **Internet Gateway**: Enables public subnet access
- **NAT Gateway**: Allows private subnets to reach the internet securely
- **Route Tables**: Public + private routing

### 🛡️ IAM & Security
- **OIDC Provider**: Created in `eks/main.tf`, enables IAM roles for Kubernetes service accounts
- **ALB Ingress Role**: IAM role and inline policy for ALB Ingress Controller defined in `iam/main.tf` and linked via OIDC
- **Node Group Role**: Grants EC2 nodes permission to interact with EKS and other AWS resources

### 🖥️ Compute (EKS)
- **EKS Cluster**: Managed control plane provisioned in private subnets
- **Managed Node Group**: Auto-scaling EC2 worker nodes in private subnets
- **Add-ons Ready**: Compatible with Ingress, DNS, TLS, autoscaling tools, etc.

---

## ✅ Features
- Modular Terraform setup with separate `vpc`, `iam`, and `eks` modules
- Remote backend support using S3 + DynamoDB
- OIDC integration with IAM roles for service accounts
- GitHub Actions workflow for automated app deployment
- Clean `.gitignore` excluding `.terraform/`, `.tfstate`, and sensitive files

---

## 🚀 Kubernetes Deployment Approach

Kubernetes resources in this project are deployed using two approaches:

- ✅ `helm` was used to install the **NGINX Ingress Controller** onto the EKS cluster  
- 🛠️ Helm can also be used to install tools like **cert-manager**, **external-dns**, or **metrics-server** for TLS, DNS automation, and enhanced scalability
- ✅ `kubectl apply -f` is used to deploy our own microservice (`service-a`)

### App manifests:
```
k8s-apps/
└── service-a/
    ├── deployment.yaml
    ├── service.yaml
    └── ingress.yaml
```

### Deploy with:
```bash
kubectl apply -f k8s-apps/service-a/
```

---

## ⚙️ CI/CD Pipeline (via GitHub Actions)

This project includes a GitHub Actions workflow located at:

```
.github/workflows/deploy.yaml
```

### What it does:
- Triggered when changes are pushed to `main` in the `k8s-apps/**` directory
- Uses AWS credentials stored in GitHub Secrets (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)
- Updates kubeconfig to connect to the EKS cluster
- Applies Kubernetes manifests using `kubectl`

### Workflow Summary:
```yaml
on:
  push:
    branches:
      - main
    paths:
      - 'k8s-apps/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - Checkout code
      - Configure AWS credentials
      - Update kubeconfig
      - Apply Kubernetes manifests using kubectl
```

---

## 📁 Directory Structure

```
terraform-eks-microservices-webapp/
├── terraform/
│   ├── infra/
│   │   ├── main.tf
│   │   ├── backend.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── .terraform.lock.hcl
│   ├── modules/
│   │   ├── vpc/
│   │   ├── iam/
│   │   └── eks/
├── k8s-apps/
│   └── service-a/
│       ├── deployment.yaml
│       ├── service.yaml
│       └── ingress.yaml
├── .github/
│   └── workflows/
│       └── deploy.yaml
├── .gitignore
├── README.md
```

---

## 🧪 Deployment Guide

### 1️⃣ Provision EKS Cluster

```bash
cd terraform/infra
terraform init
terraform plan
terraform apply
```

### 2️⃣ Configure Kubeconfig

```bash
aws eks --region eu-west-2 update-kubeconfig --name eks-cluster
```

### 3️⃣ Deploy Microservice

```bash
kubectl apply -f k8s-apps/service-a/
```

---

## 🔒 Security Notes

- `.tfstate`, `.tfvars`, and `.terraform/` are excluded via `.gitignore`
- IAM roles follow least-privilege design
- Nodes and workloads are deployed to **private subnets**
- AWS credentials are stored securely as GitHub Actions secrets

---

## 👤 Author

**Rami Alshaar**  
[GitHub Profile](https://github.com/Rami-shaar)
