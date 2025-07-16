resource "aws_iam_user" "admin" {
  name = "web-admin"
}

resource "aws_iam_policy" "restart_policy" {
  name   = "RestartEC2"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "ec2:RebootInstances",
      Resource = "*"
    }]
  })
}

resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.admin.name
  policy_arn = aws_iam_policy.restart_policy.arn
}
