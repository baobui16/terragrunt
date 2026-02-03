variable "cluster_name" {
  description = "EKS Cluster Name"
  type = string
}

variable "node_group_name" {
  description = "Node Group Name"
  type = string
}

variable "node_role_arn" {
  description = "Node Role ARN"
  type = string
}

variable "subnet_ids" {
  description = "Subnet IDs for node group"
  type = list(string)
}

variable "instance_types" {
  description = "EC2 instance types"
  type        = list(string)
}

variable "desired" {
  description = "Desired node count"
  type        = number
}

variable "min" {
  description = "Min node count"
  type        = number
}

variable "max" {
  description = "Max node count"
  type        = number
}

variable "disk_size" {
  description = "Disk size (GiB)"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}