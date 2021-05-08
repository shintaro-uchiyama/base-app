# AWS Config Rule that manages IAM Password Policy
resource "aws_config_organization_managed_rule" "iam_policy_organization_config_rule" {
  input_parameters  = <<EOF
    {
      "RequireUppercaseCharacters": "true",
      "RequireLowercaseCharacters": "true",
      "RequireSymbols": "true",
      "RequireNumbers": "true",
      "MinimumPasswordLength": "9",
      "PasswordReusePrevention": "5",
      "MaxPasswordAge": "90"
    }
  EOF

  name              = "iam-password-policy"
  rule_identifier   = "IAM_PASSWORD_POLICY"
}

# AWS Config Rule that manages IAM Root Access Keys to see if they exist
resource "aws_config_organization_managed_rule" "iam_root_access_key_organization_config_rule" {
  name              = "iam-root-access-key-check"
  rule_identifier   = "IAM_ROOT_ACCESS_KEY_CHECK"
}

# AWS Config Rule that checks whether your AWS account is enabled to use multi-factor authentication (MFA)
# hardware device to sign in with root credentials.
resource "aws_config_organization_managed_rule" "root_hardware_mfa_organization_config_rule" {
  name              = "root-hardware-mfa"
  rule_identifier   = "ROOT_ACCOUNT_HARDWARE_MFA_ENABLED"
}

# AWS Config Rule that checks whether users of your AWS account require a multi-factor authentication (MFA)
# device to sign in with root credentials.
resource "aws_config_organization_managed_rule" "root_account_mfa_organization_config_rules" {
  name              = "root-account-mfa-enabled"
  rule_identifier   = "ROOT_ACCOUNT_MFA_ENABLED"
}


# AWS Config Rule that checks whether the required public access block settings are configured from account level.
# The rule is only NON_COMPLIANT when the fields set below do not match the corresponding fields in the configuration
# item.
resource "aws_config_organization_managed_rule" "s3_public_access_organization_config_rules" {
  name              = "s3-account-level-public-access-blocks"
  rule_identifier   = "S3_ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS"
}

# AWS Config Rule that checks whether logging is enabled for your S3 buckets.
resource "aws_config_organization_managed_rule" "s3_bucket_logging_organization_config_rules" {
  name              = "s3-bucket-logging-enabled"
  rule_identifier   = "S3_BUCKET_LOGGING_ENABLED"
}

# AWS Config Rule that checks whether logging is enabled for your S3 buckets.
resource "aws_config_organization_managed_rule" "s3_bucket_encryption_organization_config_rules" {
  name              = "s3-bucket-server-side-encryption-enabled"
  rule_identifier   = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
}
