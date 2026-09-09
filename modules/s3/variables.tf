variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "bucket_purpose" {
  description = "Purpose of the bucket (e.g. assets, logs, backups)"
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = true
}

variable "enable_lifecycle" {
  description = "Enable lifecycle policy"
  type        = bool
  default     = true
}

variable "expiration_days" {
  description = "Days after which objects expire"
  type        = number
  default     = 365
}
