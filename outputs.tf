output "s3_bucket_id" {
  value       = module.s3_bucket.bucket_id
  description = "Session storage S3 bucket id"
}

output "s3_bucket_domain_name" {
  value       = module.s3_bucket.bucket_domain_name
  description = "Session storage S3 bucket domain name"
}

output "s3_bucket_arn" {
  value       = module.s3_bucket.bucket_arn
  description = "Session storage S3 bucket ARN"
}

output "dynamodb_audit_table_id" {
  value       = module.dynamodb_audit_table.table_id
  description = "DynamoDB audit table id"
}

output "dynamodb_audit_table_arn" {
  value       = module.dynamodb_audit_table.table_arn
  description = "DynamoDB audit table ARN"
}

output "dynamodb_state_table_id" {
  value       = module.dynamodb_state_table.table_id
  description = "DynamoDB state table id"
}

output "dynamodb_state_table_arn" {
  value       = module.dynamodb_state_table.table_arn
  description = "DynamoDB state table ARN"
}
