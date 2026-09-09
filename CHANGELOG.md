# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-01

### Added
- VPC module with 3-AZ public/private/isolated subnets, NAT gateways, flow logs
- ECS Fargate module with service auto-scaling, capacity providers, task definitions
- RDS PostgreSQL module with multi-AZ, encryption, automated backups, parameter groups
- ElastiCache Redis module with cluster mode, encryption at rest and in transit
- ALB module with HTTPS listeners, target groups, health checks, access logging
- CloudFront CDN module with WAF integration, custom cache policies
- S3 module with versioning, encryption, lifecycle rules, access logging
- IAM module with least-privilege roles, OIDC federation for CI/CD
- Monitoring module with CloudWatch dashboards, alarms, SNS notifications
- Dev, staging, and production environment configurations
- S3 + DynamoDB remote state backend bootstrap
- OPA policies for cost controls and security baseline
- GitHub Actions CI/CD with tfsec, checkov, and environment gates
- Comprehensive documentation and security policies

## [0.1.0] - 2024-11-01

### Added
- Initial project structure with VPC and ECS modules
- Basic CI pipeline with Terraform validation
