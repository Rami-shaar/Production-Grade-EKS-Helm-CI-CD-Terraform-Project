output "eks_cluster_role_arn" {
  description = "IAM Role ARN for EKS control plane"
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_node_role_arn" {
  description = "IAM Role ARN for EKS worker nodes"
  value       = aws_iam_role.eks_nodes.arn
}

