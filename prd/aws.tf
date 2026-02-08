/******************************************************************************
 * VPC
 ******************************************************************************/
module "vpc" {
  source = "../modules/aws/vpc"

  project_name = local.project_name
  env          = local.env
}

/******************************************************************************
 * Subnet
 ******************************************************************************/
module "subnet" {
  source = "../modules/aws/subnet"

  project_name = local.project_name
  env          = local.env
  vpc_id       = module.vpc.id
}

/******************************************************************************
 * Route Table
 ******************************************************************************/
module "route_table" {
  source = "../modules/aws/route_table"

  project_name = local.project_name
  env          = local.env
  vpc_id       = module.vpc.id
  subnet_id    = module.subnet.id_private_1a
}

/******************************************************************************
 * Security Group
 ******************************************************************************/
module "security_group" {
  source = "../modules/aws/security_group"

  project_name = local.project_name
  env          = local.env
  vpc_id       = module.vpc.id
}

/******************************************************************************
 * IAM Role
 ******************************************************************************/
module "iam_role" {
  source = "../modules/aws/iam_role"

  project_name = local.project_name
  env          = local.env
}

/******************************************************************************
 * S3
 ******************************************************************************/
module "s3" {
  source = "../modules/aws/s3"

  project_name = local.project_name
  env          = local.env
}

/******************************************************************************
 * CloudWatch Log Group
 ******************************************************************************/
module "cloudwatch_log_group" {
  source = "../modules/aws/cloudwatch_log_group"

  project_name = local.project_name
  env          = local.env
}

/******************************************************************************
 * Lambda
 ******************************************************************************/
module "lambda" {
  source = "../modules/aws/lambda"

  project_name              = local.project_name
  env                       = local.env
  role_arn                  = module.iam_role.arn_lambda
  s3_bucket_name            = module.s3.bucket_name_lambda_deploy
  s3_key                    = "lambda-initial.zip"
  security_group_id         = module.security_group.id_lambda
  subnet_id                 = module.subnet.id_private_1a
  cloudwatch_log_group_name = module.cloudwatch_log_group.name_lambda_api
}

/******************************************************************************
 * API Gateway
 ******************************************************************************/
module "api_gateway" {
  source = "../modules/aws/api_gateway"

  project_name         = local.project_name
  env                  = local.env
  lambda_invoke_arn    = module.lambda.invoke_arn
  lambda_function_name = module.lambda.function_name
}
