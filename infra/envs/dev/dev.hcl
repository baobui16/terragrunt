locals {
  environment = "dev"

  common_tags = {
    Project   = "EKS"
    ManagedBy = "Terragrunt"
  }
}
