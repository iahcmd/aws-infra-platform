# Security Policy

## Supported Versions

| Version | Supported          |
|---------|--------------------|
| 1.x     | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

1. **Do NOT** open a public issue for security vulnerabilities.
2. Email findings to **security@iahcmd.dev** with subject: `[SECURITY] aws-infra-platform - <description>`.
3. Include: description, steps to reproduce, potential impact, and suggested fix.

### Response Timeline

| Action | Timeframe |
|--------|-----------|
| Acknowledgment | Within 48 hours |
| Initial assessment | Within 5 business days |
| Fix (critical) | Within 30 days |
| Fix (non-critical) | Within 90 days |

## Security Practices

### Infrastructure Security
- **Encryption at rest**: KMS encryption for RDS, S3, EBS, ElastiCache, CloudWatch Logs
- **Encryption in transit**: TLS 1.2+ enforced, HTTPS-only endpoints
- **Network isolation**: Private subnets for workloads, NACLs, security groups
- **VPC Flow Logs**: Network traffic auditing enabled
- **GuardDuty**: Automated threat detection
- **CloudTrail**: API activity logging for all regions

### Access Control
- **IAM least privilege**: Scoped roles and policies for every service
- **No long-lived credentials**: OIDC federation for CI/CD
- **MFA enforcement**: Required for console access
- **SCPs**: Service Control Policies for organizational guardrails

### CI/CD Security
- **tfsec**: Static analysis on all Terraform changes
- **checkov**: Compliance framework scanning
- **OPA policies**: Custom cost and security policies
- **Drift detection**: Automated infrastructure drift alerts
- **Plan review**: Manual approval required for production

## Compliance Alignment

- CIS AWS Foundations Benchmark v1.5
- AWS Well-Architected Framework (Security Pillar)
- SOC 2 Type II controls (infrastructure layer)
