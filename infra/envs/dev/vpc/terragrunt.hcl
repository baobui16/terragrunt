include "env" {
  path   = find_in_parent_folders("dev.hcl")
  expose = true
}

terraform {
  source = "../../../modules/vpc"
}

inputs = {
  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

  azs = ["ap-southeast-1a", "ap-southeast-1b"]

  tags = merge(
    include.env.locals.common_tags,
    { Environment = include.env.locals.environment }
  )
}
