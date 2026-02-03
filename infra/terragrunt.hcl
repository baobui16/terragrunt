locals {
  project_name = "my-eks-project"

  # Region có thể đặt cố định ở đây; credential lấy từ AWS profile/env/IAM role
  aws_region = "ap-southeast-1"

  common_tags = {
    Project   = "EKS"
    ManagedBy = "Terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
}
EOF
}
