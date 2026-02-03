include "env" {
  path   = find_in_parent_folders("dev.hcl")
  expose = true
}

terraform {
  source = "../../../modules/backend"
}

inputs = {
  bucket_name         = "my-terraform-states"
  dynamodb_table_name = "terraform-locks"

  tags = merge(
    include.env.locals.common_tags,
    { Environment = include.env.locals.environment }
  )
}
