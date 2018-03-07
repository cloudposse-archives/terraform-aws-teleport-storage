module "s3_bucket" {
  source                   = "git::https://github.com/cloudposse/terraform-aws-s3-log-storage.git?ref=tags/0.1.3"
  namespace                = "${var.namespace}"
  stage                    = "${var.stage}"
  name                     = "${var.name}"
  delimiter                = "${var.delimiter}"
  attributes               = ["${compact(concat(var.attributes, list("logs")))}"]
  tags                     = "${var.tags}"
  prefix                   = "${var.prefix}"
  standard_transition_days = "${var.standard_transition_days}"
  glacier_transition_days  = "${var.glacier_transition_days}"
  expiration_days          = "${var.expiration_days}"
}
