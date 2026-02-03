variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_role_arn" {
  description = "IAM role ARN for EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for EKS control plane"
  type        = list(string)
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "endpoint_private_access" {
  description = "Enable private endpoint"
  type        = bool
}

variable "endpoint_public_access" {
  description = "Enable public endpoint"
  type        = bool
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
