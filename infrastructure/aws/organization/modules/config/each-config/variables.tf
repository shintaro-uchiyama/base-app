variable "bucket_arn" {
  type        = string
  default     = ""
  description = "organization config s3 bucket arn"
}

variable "bucket_id" {
  type        = string
  default     = ""
  description = "organization config s3 bucket name(id)"
}

variable "aggregator_account_id" {
  type        = string
  default     = ""
  description = "config aggregator account id"
}

variable "config_aggregate_region" {
  type        = string
  default     = ""
  description = "config aggregate region"
}
