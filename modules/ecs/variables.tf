variable "project_name"              { type = string }
variable "environment"                { type = string }
variable "region"                     { type = string }
variable "vpc_id"                     { type = string }
variable "private_subnet_ids"         { type = list(string) }
variable "target_group_arn"           { type = string }
variable "execution_role_arn"         { type = string }
variable "task_role_arn"              { type = string }
variable "alb_security_group_ids"     { type = list(string) }
variable "container_image"            { type = string }
variable "container_port"             { type = number; default = 8080 }
variable "task_cpu"                   { type = number; default = 256 }
variable "task_memory"                { type = number; default = 512 }
variable "desired_count"              { type = number; default = 1 }
variable "enable_autoscaling"         { type = bool; default = false }
variable "min_capacity"               { type = number; default = 1 }
variable "max_capacity"               { type = number; default = 10 }
variable "cpu_scaling_target"         { type = number; default = 70 }
variable "memory_scaling_target"      { type = number; default = 80 }
variable "enable_fargate_spot"        { type = bool; default = false }
variable "enable_container_insights"  { type = bool; default = true }
variable "log_retention_days"         { type = number; default = 30 }
variable "environment_variables"      { type = list(map(string)); default = [] }
variable "secrets"                    { type = list(map(string)); default = [] }
variable "tags"                       { type = map(string); default = {} }
