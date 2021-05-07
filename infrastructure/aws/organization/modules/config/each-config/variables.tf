variable "account_id" {
  type        = string
  default     = ""
  description = "delegated account id for aws config using organizations"
}

variable "region" {
  type        = string
  default     = ""
  description = "region for aws config s3 bucket"
}

variable "bucket_arn" {
  type        = string
  default     = ""
  description = "organization config s3 bucket arn"
}

variable "bucket_id" {
  type        = string
  default     = ""
  description = "organization config s3 bucket arn"
}

variable "aggregated_account_id" {
  type        = string
  default     = ""
  description = "organization config s3 bucket arn"
}
