module "s3_bucket" {
  source                   = "cloudposse/s3-log-storage/aws"
  version                  = "0.28.0"
  attributes               = ["sessions"]
  lifecycle_tags           = module.label_s3.tags
  standard_transition_days = var.standard_transition_days
  glacier_transition_days  = var.glacier_transition_days
  expiration_days          = var.expiration_days

  #  name        = "teleport"
  #  environment = ""

  abort_incomplete_multipart_upload_days = null

  versioning_enabled = false

  context = module.this.context
}

module "label_s3" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  #  name        = "teleport"
  #  environment = ""
  attributes = ["sessions"]

  context = module.this.context
}
