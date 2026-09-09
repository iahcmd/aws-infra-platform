variable "project_name"              { type = string }
variable "environment"                { type = string }
variable "vpc_id"                     { type = string }
variable "private_subnet_ids"         { type = list(string) }
variable "allowed_security_group_ids" { type = list(string) }
variable "node_type"                  { type = string; default = "cache.t3.micro" }
variable "num_cache_clusters"         { type = number; default = 1 }
variable "snapshot_retention_limit"   { type = number; default = 3 }
variable "tags"                       { type = map(string); default = {} }
