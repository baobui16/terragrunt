resource "aws_iam_role" "eks_cluster" {
    name = var.role_name

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect    = "Allow"
            Principal = { Service = "eks.amazonaws.com" }
            Action    = "sts:AssumeRole"
        }]
    })

    tags = var.tags
}
resource "aws_iam_role_policy_attachment" "eks" {
  for_each = toset(var.policy_arns)

  role       = aws_iam_role.eks_cluster.name
  policy_arn = each.value
}
