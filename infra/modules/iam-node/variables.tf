variable "role_name" {
  description = "IAM role name for EKS node group"
  type = string
}

variable "policy_arns" {
  description = "List of managed policy ARNs attached to the node role"
  type = list(string)
}

variable "tags" {
  description = "Tags to apply to IAM resources"
  type        = map(string)
  default     = {}
}