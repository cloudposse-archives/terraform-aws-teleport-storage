module "s3_sessions_logs" {
  source                   = "git::https://github.com/cloudposse/terraform-aws-s3-log-storage.git?ref=tags/0.1.3"
  namespace                = "${var.namespace}"
  stage                    = "${var.stage}"
  name                     = "${var.name}"
  delimiter                = "${var.delimiter}"
  attributes               = ["${compact(concat(var.attributes, list("sessions-logs")))}"]
  prefix                   = "${var.logs_prefix}"
  standard_transition_days = "${var.logs_standard_transition_days}"
  glacier_transition_days  = "${var.logs_glacier_transition_days}"
  expiration_days          = "${var.logs_expiration_days}"
  tags                     = "${var.tags}"
}

module "s3_sessions_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = ["${compact(concat(var.attributes, list("sessions")))}"]
  tags       = "${var.tags}"
}

resource "aws_s3_bucket" "sessions" {
  bucket        = "${module.s3_sessions_label.id}"
  acl           = "private"
  tags          = "${module.s3_sessions_label.tags}"
  region        = "${var.region}"
  force_destroy = false

  logging {
    target_bucket = "${module.s3_sessions_logs.bucket_id}"
    target_prefix = "${module.s3_sessions_logs.prefix}"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "${module.s3_sessions_label.id}"
    enabled = true
    prefix  = "${var.sessions_prefix}"
    tags    = "${module.s3_sessions_label.tags}"

    noncurrent_version_transition {
      days          = "${var.noncurrent_version_transition_days}"
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = "${var.noncurrent_version_expiration_days}"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
