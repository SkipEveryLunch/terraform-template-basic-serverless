/************************************************************
Lambda 実行ロール
************************************************************/
resource "aws_iam_role" "lambda" {
  name = "${var.project_name}-lambda-${var.env}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda" {
  for_each = {
    cloudwatch = aws_iam_policy.cloudwatch_logs_write.arn
    eni        = "arn:aws:iam::aws:policy/service-role/AWSLambdaENIManagementAccess"
  }
  role       = aws_iam_role.lambda.name
  policy_arn = each.value
}

/************************************************************
CloudWatch Logs 書き込みポリシー
************************************************************/
resource "aws_iam_policy" "cloudwatch_logs_write" {
  name = "${var.project_name}-cloudwatch-logs-write-${var.env}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}
