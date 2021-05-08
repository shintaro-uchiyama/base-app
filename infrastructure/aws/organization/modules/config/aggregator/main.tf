# logging s3
resource "aws_s3_bucket" "config_bucket" {
  bucket = "config-bucket-${var.aggregator_account_id}-${var.aggregator_s3_region}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "config_logging_policy" {
  bucket = aws_s3_bucket.config_bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSConfigBucketPermissionsCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": [
         "config.amazonaws.com"
        ]
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "${aws_s3_bucket.config_bucket.arn}"
    },
    {
      "Sid": "AWSConfigBucketExistenceCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "config.amazonaws.com"
        ]
      },
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.config_bucket.arn}"
    },
    {
      "Sid": "AWSConfigBucketDelivery",
      "Effect": "Allow",
      "Principal": {
        "Service": [
         "config.amazonaws.com"
        ]
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.config_bucket.arn}/AWSLogs/*/Config/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}
POLICY
}

# iam role
resource "aws_iam_role" "config_role" {
  name = "config_aggregator_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "config_org_policy" {
  path        = "/"
  description = "IAM Policy for AWS Config"
  name        = "ConfigPolicy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "config:GetOrganizationConfigRuleDetailedStatus",
        "config:Put*",
        "iam:GetPasswordPolicy",
        "organizations:ListAccounts",
        "organizations:DescribeOrganization",
        "organizations:ListAWSServiceAccessForOrganization",
        "organization:EnableAWSServiceAccess"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:PutObject"],
      "Resource": ["${aws_s3_bucket.config_bucket.arn}/AWSLogs/${var.aggregator_account_id}/*"],
      "Condition": {
        "StringLike": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetBucketAcl"],
      "Resource": "${aws_s3_bucket.config_bucket.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "config_org_policy_attach" {
  role       = aws_iam_role.config_role.name
  policy_arn = aws_iam_policy.config_org_policy.arn
}

resource "aws_iam_role_policy_attachment" "config_policy_attach" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_iam_role_policy_attachment" "read_only_policy_attach" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# -----------------------------------------------------------
# set up the aggregator account Config
# -----------------------------------------------------------
resource "null_resource" "config_delegated" {
  provisioner "local-exec" {
    command = "aws organizations register-delegated-administrator --account-id ${var.aggregator_account_id} --service-principal config.amazonaws.com"
    on_failure = continue
  }
}

resource "null_resource" "config_multi_setup_delegated" {
  provisioner "local-exec" {
    command = "aws organizations register-delegated-administrator --account-id ${var.aggregator_account_id} --service-principal config-multiaccountsetup.amazonaws.com"
    on_failure = continue
  }
  depends_on = [ null_resource.config_delegated ]
}

resource "aws_config_configuration_aggregator" "organization" {
  name = "organization-aggregator"

  organization_aggregation_source {
    all_regions = true
    role_arn    = aws_iam_role.config_role.arn
  }
}

resource "aws_config_configuration_recorder" "config_recorder" {
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

# Delivery channel resource and bucket location to specify configuration history location.
resource "aws_config_delivery_channel" "config_channel" {
  s3_bucket_name = aws_s3_bucket.config_bucket.id
  depends_on = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_configuration_recorder_status" "config_recorder_status" {
  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.config_channel]
}
