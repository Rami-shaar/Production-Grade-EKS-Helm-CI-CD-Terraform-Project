terraform {
  backend "s3" {
    bucket         = "eks-microservices-app-bucket1"
    key            = "eks-microservices/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "eks-microservices-app-table"
  }
}