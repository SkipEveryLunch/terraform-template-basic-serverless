output "bucket_name_lambda_deploy" {
  value = module.lambda_deploy.s3_bucket_id
}

output "arn_lambda_deploy" {
  value = module.lambda_deploy.s3_bucket_arn
}
