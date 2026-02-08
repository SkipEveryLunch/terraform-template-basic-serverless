terraform {
  backend "s3" {
    bucket  = "tfstate-serverless-basic-prd"
    key     = "main.tfstate"
    region  = "ap-northeast-1"
    profile = "playground"
  }
}
