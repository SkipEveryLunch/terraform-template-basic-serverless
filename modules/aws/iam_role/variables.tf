variable "project_name" {}

variable "env" {}

variable "github_actions" {
  type = object({
    oidc_provider_arn = string
    account_id        = string
    github_repo       = string
    s3_bucket_arn     = string
  })
}

locals {
  // MEMO: Lambda関数名は project_name-api-env の命名規則
  lambda_function_arn = "arn:aws:lambda:*:${var.github_actions.account_id}:function:${var.project_name}-api-${var.env}"
}
