output "arn_lambda" {
  value = aws_iam_role.lambda.arn
}

output "name_lambda" {
  value = aws_iam_role.lambda.name
}

output "arn_github_actions" {
  value = aws_iam_role.github_actions.arn
}
