output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "oidc_provider_arn" {
  description = "IAM OIDC provider ARN"
  value       = aws_iam_openid_connect_provider.oidc.arn
}


output "oidc_provider_url" {
   description = "IAM OIDC provider URL"
  value = aws_iam_openid_connect_provider.oidc.url
}
