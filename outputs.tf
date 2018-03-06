output "sessions_bucket_name" {
  value = "${aws_s3_bucket.sessions.id}"
}

output "sessions_bucket_domain_name" {
  value = "${aws_s3_bucket.sessions.bucket_domain_name}"
}
