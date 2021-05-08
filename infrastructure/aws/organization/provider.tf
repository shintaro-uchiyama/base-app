provider "aws" {
  region  = "ap-northeast-1"
}

provider "aws" {
  alias = "log-archive-production"

  region  = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.log_archive_production_account.id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias = "ucwork-production-account"

  region  = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.ucwork_production_account.id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias = "shared-services-production"

  region  = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.shared_services_production_account.id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias = "ucwork-sdlc"

  region  = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.ucwork_sdlc_account.id}:role/OrganizationAccountAccessRole"
  }
}
