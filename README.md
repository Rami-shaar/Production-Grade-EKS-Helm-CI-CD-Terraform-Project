# 🌐 Production-Ready EKS + Microservices WebApp Infrastructure (Terraform)

This project provisions a complete, production-grade EKS infrastructure on AWS using Terraform. It includes modular infrastructure stacks for VPC, IAM, and EKS, and deploys Kubernetes microservices using `kubectl` — designed for real-world scalability, modularity, and GitOps-style automation.

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
- **Add-ons Ready**: Compatible with ALB Ingress Controller, cert-manager, external-dns, etc.

---

## ✅ Features
- Modular Terraform setup with separate `vpc`, `iam`, and `eks` modules
- Remote backend support using S3 + DynamoDB
- OIDC integration with IAM roles for service accounts
- CI/CD pipeline for Kubernetes app deployment via GitHub Actions
- Clean `.gitignore` excluding `.terraform/`, `.tfstate`, and sensitive files

---

## 🚀 Kubernetes Deployment Approach

Kubernetes resources in this project are deployed using two approaches:

- ✅ `helm` was used to install core infrastructure components like the **NGINX Ingress Controller**
- ✅ `kubectl apply -f` is used to deploy our own app (`service-a`)

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

## ⚙️ CI/CD with GitHub Actions

This project uses GitHub Actions for automatic app deployment to EKS whenever files in `k8s-apps/` are modified.

### Workflow file:
```
.github/workflows/deploy.yaml
```

### What it does:
- Triggered on `push` to `main` branch when any file in `k8s-apps/**` changes
- Uses AWS credentials stored in GitHub Secrets (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)
- Updates kubeconfig and applies manifests to EKS using `kubectl`

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

This keeps your application deployments automated, consistent, and Git-tracked.

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
- AWS credentials are stored securely as GitHub Actions secrets
- IAM roles follow least-privilege design
- Nodes and services are isolated in private subnets

---

## 👤 Author

**Rami Alshaar**  
[GitHub Profile](https://github.com/Rami-shaar)
