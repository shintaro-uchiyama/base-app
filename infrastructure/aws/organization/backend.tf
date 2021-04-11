terraform {
  backend "s3" {
    bucket  = "ucwork-root-admin-tfstate"
    key     = "organization.tfstate"
    region  = "ap-northeast-1"
    profile = "root-admin"
  }
}