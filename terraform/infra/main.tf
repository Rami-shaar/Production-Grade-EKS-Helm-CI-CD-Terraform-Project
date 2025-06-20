provider "aws" {
  region = "eu-west-2"
}

module "vpc" {
  source = "../modules/vpc"
}

module "iam" {
  source = "../modules/iam"
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
}


module "eks" {
  source = "../modules/eks"

  cluster_role_arn   = module.iam.eks_cluster_role_arn
  node_role_arn      = module.iam.eks_node_role_arn
  private_subnet_ids = module.vpc.private_subnet_ids
}