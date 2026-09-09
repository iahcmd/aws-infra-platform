variable "project_name" {
  description = "Project name prefix for state bucket and lock table"
  type        = string
  default     = "iahcmd"
}

variable "region" {
  description = "AWS region for backend storage"
  type        = string
  default     = "us-east-1"
}
