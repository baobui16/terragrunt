output "node_group_name" {
  value = aws_eks_node_group.this.node_group_name
}

output "node_group_arn" {
  value = aws_eks_node_group.this.arn
}

output "node_group_status" {
  value = aws_eks_node_group.this.status
}

output "node_role_arn" {
  value = aws_eks_node_group.this.node_role_arn
}

output "scaling_config" {
  value = {
    desired = aws_eks_node_group.this.scaling_config[0].desired_size
    min     = aws_eks_node_group.this.scaling_config[0].min_size
    max     = aws_eks_node_group.this.scaling_config[0].max_size
  }
}
