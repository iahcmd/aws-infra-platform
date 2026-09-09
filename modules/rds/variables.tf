variable "project_name"                { type = string }
variable "environment"                  { type = string }
variable "vpc_id"                       { type = string }
variable "isolated_subnet_ids"          { type = list(string) }
variable "allowed_security_group_ids"   { type = list(string) }
variable "instance_class"               { type = string; default = "db.t3.micro" }
variable "engine_version"               { type = string; default = "16.1" }
variable "allocated_storage"            { type = number; default = 20 }
variable "max_allocated_storage"        { type = number; default = 100 }
variable "database_name"                { type = string; default = "appdb" }
variable "master_username"              { type = string; default = "dbadmin" }
variable "master_password"              { type = string; sensitive = true }
variable "multi_az"                     { type = bool; default = false }
variable "backup_retention_period"      { type = number; default = 7 }
variable "deletion_protection"          { type = bool; default = false }
variable "enable_performance_insights"  { type = bool; default = false }
variable "kms_key_arn"                  { type = string; default = null }
variable "tags"                         { type = map(string); default = {} }
