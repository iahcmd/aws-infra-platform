output "state_bucket_id" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for Terraform state locks"
  value       = aws_dynamodb_table.terraform_locks.name
}
