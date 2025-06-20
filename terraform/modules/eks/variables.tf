variable "cluster_role_arn" {
  description = "IAM role ARN for EKS control plane"
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN for EKS worker nodes"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS control plane and nodes"
  type        = list(string)
}
