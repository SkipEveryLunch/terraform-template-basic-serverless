variable "project_name" {}

variable "env" {}

variable "lambda_api" {
  type = object({
    role_arn                  = string
    s3_bucket_name            = string
    s3_key                    = string
    security_group_id         = string
    subnet_id                 = string
    cloudwatch_log_group_name = string
  })
}
