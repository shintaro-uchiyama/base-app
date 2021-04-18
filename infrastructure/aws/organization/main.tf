# set default organization id
data "aws_organizations_organization" "root" {}
locals {
  root_id = data.aws_organizations_organization.root.roots[0].id
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

resource aws_organizations_account security_production_account {
  name = "shintaro.a.uchiyama+security-production@gmail.com"
  email = "shintaro.a.uchiyama+security-production@gmail.com"
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

# workload sdlc
resource aws_organizations_organizational_unit workload_sdlc_organization_unit {
  name = "workload sdlc"
  parent_id = aws_organizations_organizational_unit.workload_organization_unit.id
}

# sandbox
resource aws_organizations_organizational_unit sandbox_organization_unit {
  name = "sandbox"
  parent_id = aws_organizations_organizational_unit.custom-ou.id
}