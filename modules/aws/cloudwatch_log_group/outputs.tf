output "name_lambda_api" {
  value = aws_cloudwatch_log_group.lambda_api.name
}

output "arn_lambda_api" {
  value = aws_cloudwatch_log_group.lambda_api.arn
}
