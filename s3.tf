module "s3_bucket" {
  source                   = "git::https://github.com/cloudposse/terraform-aws-s3-log-storage.git?ref=tags/0.1.3"
  namespace                = "${var.namespace}"
  stage                    = "${var.stage}"
  name                     = "${var.name}"
  delimiter                = "${var.delimiter}"
  attributes               = ["${compact(concat(var.attributes, list("sessions")))}"]
  tags                     = "${var.tags}"
  prefix                   = "${var.prefix}"
  standard_transition_days = "${var.standard_transition_days}"
  glacier_transition_days  = "${var.glacier_transition_days}"
  expiration_days          = "${var.expiration_days}"
}

module "label_s3" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = ["${compact(concat(var.attributes, list("sessions")))}"]
  tags       = "${var.tags}"
}

# Allow Read and Write access to the bucket
# https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_s3_rw-bucket.html
data "aws_iam_policy_document" "s3" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${module.s3_bucket.bucket_id}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${module.s3_bucket.bucket_id}/*",
    ]
  }
}

resource "aws_iam_role" "s3" {
  name               = "${module.label_s3.id}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

resource "aws_iam_policy" "s3" {
  name        = "${module.label_s3.id}"
  description = "Allow Teleport Auth service read/write access to S3 bucket"
  policy      = "${data.aws_iam_policy_document.s3.json}"
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = "${aws_iam_role.s3.name}"
  policy_arn = "${aws_iam_policy.s3.arn}"
}

resource "aws_iam_instance_profile" "s3" {
  name = "${module.label_s3.id}"
  role = "${aws_iam_role.s3.name}"
}
