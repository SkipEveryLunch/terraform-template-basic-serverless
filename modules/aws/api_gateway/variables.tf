variable "project_name" {}

variable "env" {}

variable "api" {
  type = object({
    lambda_invoke_arn    = string
    lambda_function_name = string
    custom_domain_name   = string
    certificate_arn      = string
  })
}
