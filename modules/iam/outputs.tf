output "execution_role_arn" {
  description = "ARN of ECS execution role"
  value       = aws_iam_role.app_execution.arn
}

output "task_role_arn" {
  description = "ARN of ECS task role"
  value       = aws_iam_role.app_task.arn
}
