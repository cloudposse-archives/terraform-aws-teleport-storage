output "s3_bucket_id" {
  value = "${module.s3_bucket.bucket_id}"
}

output "s3_bucket_domain_name" {
  value = "${module.s3_bucket.bucket_domain_name}"
}

output "s3_bucket_arn" {
  value = "${module.s3_bucket.bucket_arn}"
}

output "dynamodb_audit_table_id" {
  value = "${module.dynamodb_audit_table.table_id}"
}

output "dynamodb_audit_table_arn" {
  value = "${module.dynamodb_audit_table.table_arn}"
}

output "dynamodb_state_table_id" {
  value = "${module.dynamodb_state_table.table_id}"
}

output "dynamodb_state_table_arn" {
  value = "${module.dynamodb_state_table.table_arn}"
}
