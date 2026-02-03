include "env" {
  path   = find_in_parent_folders("dev.hcl")
  expose = true
}

terraform {
  source = "../../../modules/iam-eks"
}

inputs = {
  role_name = "eks-cluster-dev"

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]

  tags = merge(
    include.env.locals.common_tags,
    { Environment = include.env.locals.environment }
  )
}
