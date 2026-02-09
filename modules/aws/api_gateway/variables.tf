variable "project_name" {}

variable "env" {}

variable "api" {
  type = object({
    lambda_invoke_arn    = string
    lambda_function_name = string
  })
}

variable "custom_domain" {
  type = object({
    domain_name     = string
    certificate_arn = string
  })
  default = null
}
