output "id" {
  value = aws_api_gateway_rest_api.api.id
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.api.execution_arn
}

output "invoke_url" {
  value = aws_api_gateway_stage.default.invoke_url
}

output "custom_domain_name" {
  value = try(aws_api_gateway_domain_name.api[0].domain_name, null)
}

output "custom_domain_regional_domain_name" {
  value = try(aws_api_gateway_domain_name.api[0].regional_domain_name, null)
}

output "custom_domain_regional_zone_id" {
  value = try(aws_api_gateway_domain_name.api[0].regional_zone_id, null)
}
