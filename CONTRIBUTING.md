# Contributing to aws-infra-platform

Thank you for contributing! This guide covers module authoring standards, PR workflow, and testing requirements.

## Code of Conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## Getting Started

1. Fork and clone the repository
2. Create a feature branch: `git checkout -b feat/your-module-change`
3. Make changes following the standards below
4. Test: `make validate ENV=dev`
5. Submit a PR

## Module Authoring Standards

### File Structure

Every module must contain:
```
modules/<name>/
├── main.tf          # Resource definitions
├── variables.tf     # Input variables (all with type + description)
├── outputs.tf       # Output values
└── README.md        # Module documentation (optional but recommended)
```

### Variable Requirements
- All variables must have `description` and `type`
- Sensitive variables must be marked `sensitive = true`
- Use `validation` blocks for input constraints
- Provide sensible defaults where possible

### Naming Conventions
- Resources: `<project>-<environment>-<resource>` (e.g., `platform-prod-rds`)
- Variables: snake_case (e.g., `instance_type`)
- Outputs: snake_case, prefixed by module (e.g., `vpc_id`, `rds_endpoint`)

### Tagging
All resources must include:
```hcl
tags = {
  Project     = var.project_name
  Environment = var.environment
  ManagedBy   = "terraform"
  Module      = "<module-name>"
}
```

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):
```
feat(modules/ecs): add Fargate Spot capacity provider
fix(modules/rds): correct backup retention window
docs(readme): update cost estimates
```

## Pull Request Process

1. Ensure `make validate` passes
2. Include `terraform plan` output for affected environments
3. Fill out the PR template completely
4. Wait for CI checks and review
5. Squash and merge after approval

## Questions?

Open an [issue](https://github.com/iahcmd/aws-infra-platform/issues/new).
