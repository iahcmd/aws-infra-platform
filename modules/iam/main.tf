# ──────────────────────────────────────────────────────────────
# IAM Module
# Creates least-privilege IAM roles and policies for ECS tasks,
# CI/CD pipelines (OIDC), and service execution.
# ──────────────────────────────────────────────────────────────

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_role" "app_execution" {
  name_prefix        = "${var.project_name}-${var.environment}-exec-"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-execution-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "execution_standard" {
  role       = aws_iam_role.app_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "app_task" {
  name_prefix        = "${var.project_name}-${var.environment}-task-"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-task-role"
    Environment = var.environment
  }
}

resource "aws_iam_policy" "task_s3_access" {
  name_prefix = "${var.project_name}-${var.environment}-s3-access-"
  description = "Allows ECS tasks to interact with application S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task_s3_attach" {
  count      = var.s3_bucket_arn != "" ? 1 : 0
  role       = aws_iam_role.app_task.name
  policy_arn = aws_iam_policy.task_s3_access.arn
}
