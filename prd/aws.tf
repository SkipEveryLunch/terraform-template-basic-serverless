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
