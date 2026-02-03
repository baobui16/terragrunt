include "env" {
  path   = find_in_parent_folders("dev.hcl")
  expose = true
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    private_subnet_ids = ["subnet-mock-a", "subnet-mock-b"]
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "iam" {
  config_path = "../iam-eks"

  mock_outputs = {
    eks_cluster_role_arn = "arn:aws:iam::123456789012:role/mock-eks-cluster-role"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

terraform {
  source = "../../../modules/eks"
}

inputs = {
  cluster_name            = "eks-dev"
  cluster_role_arn        = dependency.iam.outputs.eks_cluster_role_arn
  subnet_ids              = dependency.vpc.outputs.private_subnet_ids
  kubernetes_version      = "1.30"
  endpoint_private_access = true
  endpoint_public_access  = true

  tags = merge(
    include.env.locals.common_tags,
    { Environment = include.env.locals.environment }
  )
}
