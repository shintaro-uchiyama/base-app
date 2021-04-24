# set default organization id
resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]

  feature_set = "ALL"
}

locals {
  root_id = aws_organizations_organization.org.roots[0].id
}

/*
core organization unit
*/
resource aws_organizations_organizational_unit core-ou {
  name = "core organization unit"
  parent_id = local.root_id
}

# infra
resource aws_organizations_organizational_unit infra_organization_unit {
  name = "infra"
  parent_id = aws_organizations_organizational_unit.core-ou.id
}

# infra production
resource aws_organizations_organizational_unit infra_production_organization_unit {
  name = "infra production"
  parent_id = aws_organizations_organizational_unit.infra_organization_unit.id
}

resource aws_organizations_account shared_services_production_account {
  name = "shared-services-production"
  email = "shintaro.a.uchiyama+shared-services-production@gmail.com"
  parent_id = aws_organizations_organizational_unit.infra_production_organization_unit.id
}

# infra sdlc
resource aws_organizations_organizational_unit infra_sdlc_organization_unit {
  name = "infra sdlc"
  parent_id = aws_organizations_organizational_unit.infra_organization_unit.id
}

# security
resource aws_organizations_organizational_unit security_organization_unit {
  name = "security"
  parent_id = aws_organizations_organizational_unit.core-ou.id
}

# security production
resource aws_organizations_organizational_unit security_production_organization_unit {
  name = "security production"
  parent_id = aws_organizations_organizational_unit.security_organization_unit.id
}

resource aws_organizations_account log_archive_production_account {
  name = "log-archive-production"
  email = "shintaro.a.uchiyama+log-archive-production@gmail.com"
  parent_id = aws_organizations_organizational_unit.security_production_organization_unit.id
}

# security sdlc
resource aws_organizations_organizational_unit security_sdlc_organization_unit {
  name = "security sdlc"
  parent_id = aws_organizations_organizational_unit.security_organization_unit.id
}

/*
custom organization unit
*/
resource aws_organizations_organizational_unit custom-ou {
  name = "custom organization unit"
  parent_id = local.root_id
}

# workload
resource aws_organizations_organizational_unit workload_organization_unit {
  name = "workload"
  parent_id = aws_organizations_organizational_unit.custom-ou.id
}

# workload production
resource aws_organizations_organizational_unit workload_production_organization_unit {
  name = "workload production"
  parent_id = aws_organizations_organizational_unit.workload_organization_unit.id
}

resource aws_organizations_account ucwork_production_account {
  name = "ucwork-production"
  email = "shintaro.a.uchiyama+ucwork-production@gmail.com"
  parent_id = aws_organizations_organizational_unit.workload_production_organization_unit.id
}

# workload sdlc
resource aws_organizations_organizational_unit workload_sdlc_organization_unit {
  name = "workload sdlc"
  parent_id = aws_organizations_organizational_unit.workload_organization_unit.id
}

resource aws_organizations_account ucwork_sdlc_account {
  name = "ucwork-sdlc"
  email = "shintaro.a.uchiyama+ucwork-sdlc@gmail.com"
  parent_id = aws_organizations_organizational_unit.workload_sdlc_organization_unit.id
}

# sandbox
resource aws_organizations_organizational_unit sandbox_organization_unit {
  name = "sandbox"
  parent_id = aws_organizations_organizational_unit.custom-ou.id
}