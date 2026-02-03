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

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    cluster_name = "eks-dev-mock"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

dependency "iam_node" {
  config_path = "../iam-node"

  mock_outputs = {
    node_role_arn = "arn:aws:iam::123456789012:role/mock-eks-node-role"
  }
  mock_outputs_allowed_terraform_commands = ["plan"]
}

terraform {
  source = "../../../modules/nodegroup"
}

inputs = {
  cluster_name    = dependency.eks.outputs.cluster_name
  node_group_name = "eks-nodegroup-dev"
  node_role_arn   = dependency.iam_node.outputs.node_role_arn
  subnet_ids      = dependency.vpc.outputs.private_subnet_ids

  instance_types = ["t3.medium"]
  desired        = 2
  min            = 1
  max            = 3
  disk_size      = 20

  tags = merge(
    include.env.locals.common_tags,
    { Environment = include.env.locals.environment }
  )
}
