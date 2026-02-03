variable "role_name" {
  type = string
}

variable "policy_arns" {
  type = list(string)
}

variable "tags" {
  type = map(string)
  default = {}
}
