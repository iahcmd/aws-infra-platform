output "cluster_id"           { value = aws_ecs_cluster.this.id }
output "cluster_name"         { value = aws_ecs_cluster.this.name }
output "service_name"         { value = aws_ecs_service.app.name }
output "task_definition_arn"  { value = aws_ecs_task_definition.app.arn }
output "security_group_id"   { value = aws_security_group.ecs_tasks.id }
