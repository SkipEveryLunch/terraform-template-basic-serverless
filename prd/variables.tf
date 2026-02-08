locals {
  project_name = "serverless-basic"
  env          = "prd"
  account_id   = "263015886388"
  region       = "ap-northeast-1"
  domain       = "skip-every-lunch-pg.click"
  api_domain   = "api.${local.domain}"
}
