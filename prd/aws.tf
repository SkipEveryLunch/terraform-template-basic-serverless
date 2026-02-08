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
