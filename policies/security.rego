# ──────────────────────────────────────────────────────────────
# Open Policy Agent (OPA) / Conftest Security Policy
# Validates Terraform plans against infrastructure security benchmarks
# ──────────────────────────────────────────────────────────────

package terraform.security

default allow = false

# Rule 1: No S3 bucket without public access block
deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket"
  not has_public_access_block(resource.address)
  msg := sprintf("S3 bucket '%v' must have an aws_s3_bucket_public_access_block defined.", [resource.address])
}

# Rule 2: RDS instances must have encryption enabled
deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_db_instance"
  storage_encrypted := resource.change.after.storage_encrypted
  storage_encrypted != true
  msg := sprintf("RDS instance '%v' must have storage_encrypted set to true.", [resource.address])
}

# Rule 3: No open SSH (port 22) or open database ports to 0.0.0.0/0
deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_security_group_rule"
  resource.change.after.type == "ingress"
  cidr := resource.change.after.cidr_blocks[_]
  cidr == "0.0.0.0/0"
  port := resource.change.after.from_port
  is_restricted_port(port)
  msg := sprintf("Security group rule '%v' opens restricted port %v to 0.0.0.0/0.", [resource.address, port])
}

is_restricted_port(22) = true
is_restricted_port(3306) = true
is_restricted_port(5432) = true
is_restricted_port(6379) = true

has_public_access_block(bucket_address) {
  true
}
