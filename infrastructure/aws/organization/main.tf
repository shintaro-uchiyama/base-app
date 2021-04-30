# set default organization id
resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "sso.amazonaws.com",
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
  sso
*/
# read sso instance
data "aws_ssoadmin_instances" "main" {}

# create sso permission set
locals {
  administrator_access = "AdministratorAccess"
  read_only_access = "ReadOnlyAccess"
}
resource "aws_ssoadmin_permission_set" "main" {
  for_each = toset([
    local.administrator_access,
    local.read_only_access
  ])
  name         = each.value
  instance_arn = tolist(data.aws_ssoadmin_instances.main.arns)[0]
}

# set policy to sso permission set
resource "aws_ssoadmin_managed_policy_attachment" "main" {
  for_each = aws_ssoadmin_permission_set.main
  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/${each.key}"
  permission_set_arn = each.value.arn
}

// landing zone admin group
# find sso landing zone admin group
data "aws_identitystore_group" "admin" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
  filter {
    attribute_path  = "DisplayName"
    attribute_value = "landing-zone-admin"
  }
}

# set admin permission to admin group and link to all aws account
resource "aws_ssoadmin_account_assignment" "admin" {
  for_each = toset(aws_organizations_organization.org.accounts[*].id)

  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.main[local.administrator_access].arn

  principal_id   = data.aws_identitystore_group.admin.group_id
  principal_type = "GROUP"

  target_id   = each.value
  target_type = "AWS_ACCOUNT"
}

// application developer group
# find application developer group
data "aws_identitystore_group" "application_developer" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
  filter {
    attribute_path  = "DisplayName"
    attribute_value = "application-developer"
  }
}

# set admin permission to admin group and link to all aws account
resource "aws_ssoadmin_account_assignment" "application_developer" {
  for_each = { for ap in [
    {
      account_id = aws_organizations_account.ucwork_production_account.id,
      permission_set = local.administrator_access
    },
    {
      account_id = aws_organizations_account.log_archive_production_account.id,
      permission_set = local.read_only_access
    }
  ] : ap.account_id => ap }

  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.main[each.value.permission_set].arn

  principal_id   = data.aws_identitystore_group.application_developer.group_id
  principal_type = "GROUP"

  target_id   = each.value.account_id
  target_type = "AWS_ACCOUNT"
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