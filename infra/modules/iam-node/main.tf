resource "aws_iam_role" "node" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}
resource "aws_iam_role_policy_attachment" "node" {
  for_each = toset(var.policy_arns)
  role = aws_iam_role.node.name
  policy_arn = each.value
}
