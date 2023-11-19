terraform {
  backend "s3" {
    bucket         = "jenkins-tff-eks"
    key            = "eks/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "eks-terraform-lock"
  }
}
