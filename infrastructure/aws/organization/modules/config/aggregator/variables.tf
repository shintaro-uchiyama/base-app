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
