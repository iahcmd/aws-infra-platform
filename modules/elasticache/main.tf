# ──────────────────────────────────────────────────────────────
# ElastiCache Redis Module
# ──────────────────────────────────────────────────────────────

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}"
  subnet_ids = var.private_subnet_ids
  tags       = var.tags
}

resource "aws_elasticache_parameter_group" "this" {
  name   = "${var.project_name}-${var.environment}-redis7"
  family = "redis7"

  parameter { name = "maxmemory-policy"; value = "allkeys-lru" }
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id = "${var.project_name}-${var.environment}"
  description          = "Redis cluster for ${var.project_name} ${var.environment}"
  node_type            = var.node_type
  num_cache_clusters   = var.num_cache_clusters
  port                 = 6379

  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = [aws_security_group.redis.id]
  parameter_group_name = aws_elasticache_parameter_group.this.name

  engine_version       = "7.0"
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auto_minor_version_upgrade = true

  snapshot_retention_limit = var.snapshot_retention_limit
  snapshot_window          = "03:00-05:00"
  maintenance_window       = "mon:05:00-mon:07:00"

  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-redis" })
}

resource "aws_security_group" "redis" {
  name_prefix = "${var.project_name}-${var.environment}-redis-"
  vpc_id      = var.vpc_id
  description = "Security group for ElastiCache Redis"

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
    description     = "Allow Redis from app"
  }

  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-redis-sg" })
  lifecycle { create_before_destroy = true }
}
