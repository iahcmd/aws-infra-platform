variable "project_name" {
  type    = string
  default = "aws-platform"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "app_port" {
  type    = number
  default = 8080
}

variable "container_image" {
  type    = string
  default = "ghcr.io/iahcmd/sample-api:v1.0.0"
}

variable "database_password" {
  type      = string
  sensitive = true
}
