module "lambda_deploy" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.7.0"
  bucket  = "${var.project_name}-lambda-deploy-${var.env}"
  versioning = {
    enabled = true
  }
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled = true
    }
  }
  lifecycle_rule = [
    {
      id      = "noncurrent-version-expiration"
      enabled = true
      noncurrent_version_expiration = {
        days = 30
      }
      filter = {
        prefix = ""
      }
    }
  ]
}
