resource "aws_lambda_function" "api" {
  function_name = "${var.project_name}-api-${var.env}"
  role          = var.lambda_api.role_arn
  runtime       = "python3.12"
  handler       = "main.lambda_handler"
  description   = "機械学習推論API"
  memory_size   = 512
  timeout       = 60

  // MEMO: 初期ダミーコード、CI/CDでコード更新
  s3_bucket = var.lambda_api.s3_bucket_name
  s3_key    = var.lambda_api.s3_key

  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [var.lambda_api.security_group_id]
    subnet_ids                  = [var.lambda_api.subnet_id]
  }

  // MEMO: コード更新はTerraform管理外
  lifecycle {
    ignore_changes = [
      s3_key,
      s3_object_version,
      source_code_hash
    ]
  }
}
