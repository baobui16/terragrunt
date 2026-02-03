locals {
  project_name = "my-eks-project"
  secret_config = read_terragrunt_config("secrets.hcl")

  aws_region     = secret_config.locals.aws_region
  aws_access_key = secret_config.locals.aws_access_key
  aws_secret_key = secret_config.locals.aws_secret_key

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
  region     = "${local.aws_region}"
  access_key = "${local.aws_access_key}"
  secret_key = "${local.aws_secret_key}"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}
EOF
}
