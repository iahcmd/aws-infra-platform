variable "project_name"          { type = string }
variable "environment"            { type = string }
variable "vpc_cidr"               { type = string }
variable "availability_zones"     { type = list(string) }
variable "public_subnet_cidrs"    { type = list(string) }
variable "private_subnet_cidrs"   { type = list(string) }
variable "isolated_subnet_cidrs"  { type = list(string) }
variable "nat_gateway_count"      { type = number; default = 1 }
variable "enable_flow_logs"       { type = bool; default = true }
variable "flow_log_retention_days" { type = number; default = 90 }
variable "tags"                   { type = map(string); default = {} }
