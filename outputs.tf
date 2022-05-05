output "s3_bucket_id" {
  value       = module.s3_bucket.bucket_id
  description = "S3 bucket ID"
}

output "s3_bucket_domain_name" {
  value       = module.s3_bucket.bucket_domain_name
  description = "S3 bucket domain name"
}

output "s3_bucket_arn" {
  value       = module.s3_bucket.bucket_arn
  description = "S3 bucket ARN"
}

output "dynamodb_audit_table_id" {
  value       = module.dynamodb_audit_table.table_id
  description = "DynamoDB audit table ID"
}

output "dynamodb_audit_table_arn" {
  value       = module.dynamodb_audit_table.table_arn
  description = "DynamoDB audit table ARN"
}

output "dynamodb_state_table_id" {
  value       = module.dynamodb_state_table.table_id
  description = "DynamoDB state table ID"
}

output "dynamodb_state_table_arn" {
  value       = module.dynamodb_state_table.table_arn
  description = "DynamoDB state table ARN"
}

output "iam_access_policy" {
  value       = join("", data.aws_iam_policy_document.default.*.json)
  description = "IAM access policy"
}
