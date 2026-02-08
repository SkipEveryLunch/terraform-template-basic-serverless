output "id" {
  value = aws_api_gateway_rest_api.api.id
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.api.execution_arn
}

output "invoke_url" {
  value = aws_api_gateway_stage.default.invoke_url
}
