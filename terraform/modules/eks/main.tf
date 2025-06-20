resource "aws_eks_cluster" "main" {
  name     = "eks-cluster"
  role_arn = var.cluster_role_arn

  version = "1.29"

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
}

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "eks-nodes"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}


resource "aws_iam_openid_connect_provider" "oidc" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd10df6"]
}

