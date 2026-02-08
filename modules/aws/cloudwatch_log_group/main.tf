resource "aws_cloudwatch_log_group" "lambda_api" {
  name              = "/aws/lambda/${var.project_name}-api-${var.env}"
  log_group_class   = "STANDARD"
  retention_in_days = 0
  skip_destroy      = false
}
