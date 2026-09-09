# ──────────────────────────────────────────────────────────────
# Open Policy Agent (OPA) / Conftest Cost Guardrails Policy
# Enforces instance size limits and mandatory cost-allocation tags
# ──────────────────────────────────────────────────────────────

package terraform.cost

default allow = true

# Rule 1: Mandatory cost-allocation tags
mandatory_tags := ["Project", "Environment", "ManagedBy"]

deny[msg] {
  resource := input.resource_changes[_]
  tags := resource.change.after.tags
  missing_tags := [tag | tag := mandatory_tags[_]; not tags[tag]]
  count(missing_tags) > 0
  msg := sprintf("Resource '%v' is missing mandatory tags: %v", [resource.address, missing_tags])
}

# Rule 2: Restrict expensive RDS instance types in non-prod environments
deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_db_instance"
  instance_class := resource.change.after.instance_class
  env := resource.change.after.tags.Environment
  env != "prod"
  re_match("^db\\.(m5|r5|m6g|r6g)\\.(4x|8x|16x|24x)large$", instance_class)
  msg := sprintf("RDS instance class '%v' is oversized for non-prod environment '%v'.", [instance_class, env])
}
