resource "aws_iam_role" "config_role" {
  name = "ConfigRecorderRole"

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
resource "aws_iam_service_linked_role" "config_role" {
  aws_service_name = "config.amazonaws.com"
}

resource "aws_iam_policy" "s3_config_org_policy" {
  path        = "/"
  description = "S3ConfigOrganizationPolicy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:PutObject"],
      "Resource": ["${var.bucket_arn}/AWSLogs/*"],
      "Condition": {
        "StringLike": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetBucketAcl"],
      "Resource": "${var.bucket_arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "config_s3_policy_attach" {
  role       = aws_iam_role.config_role.name
  policy_arn = aws_iam_policy.s3_config_org_policy.arn
}

resource "aws_iam_role_policy_attachment" "read_only_attachment" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "config_attachment" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

# auth
resource "aws_config_aggregate_authorization" "config_aggregation" {
  account_id = var.aggregated_account_id
  region = data.aws_region.current.name
}

# -----------------------------------------------------------
# set up the  Config Recorder
# -----------------------------------------------------------
resource "aws_config_configuration_recorder" "config_recorder" {
  role_arn = aws_iam_role.config_role.arn
}

# Delivery channel resource and bucket location to specify configuration history location.
resource "aws_config_delivery_channel" "config_channel" {
  s3_bucket_name = var.bucket_id
  depends_on = [aws_config_configuration_recorder.config_recorder]
}

# config
resource "aws_config_configuration_recorder_status" "config_recorder_status" {
  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.config_channel]
}


