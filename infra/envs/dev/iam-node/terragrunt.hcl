include "env" {
  path   = find_in_parent_folders("dev.hcl")
  expose = true
}

terraform {
  source = "../../../modules/iam-node"
}

inputs = {
  role_name = "eks-node-dev"

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]

  tags = merge(
    include.env.locals.common_tags,
    { Environment = include.env.locals.environment }
  )
}
