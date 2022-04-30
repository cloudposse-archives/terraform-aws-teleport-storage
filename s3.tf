locals {
  enabled = module.this.enabled

  s3_attributes = [compact(concat(var.attributes, list("sessions")))]
}

module "s3_bucket" {
  source = "cloudposse/s3-log-storage/aws"
  version = "0.28.0"

  attributes               = local.s3_attributes
  prefix                   = var.prefix
  standard_transition_days = var.standard_transition_days
  glacier_transition_days  = var.glacier_transition_days
  expiration_days          = var.expiration_days

  context = module.this.context
}

module "label_s3" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = local.s3_attributes

  context = module.this.context
}

# Allow Read and Write access to the bucket
# https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_s3_rw-bucket.html
data "aws_iam_policy_document" "s3" {
  count = local.enabled ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:${local.aws_partition}:s3:::${module.s3_bucket.bucket_id}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]

    resources = [
      "arn:${local.aws_partition}:s3:::${module.s3_bucket.bucket_id}/*",
    ]
  }
}

resource "aws_iam_role" "s3" {
  count = local.enabled ? 1 : 0

  name               = module.label_s3.id
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)

  max_session_duration = var.iam_role_max_session_duration

  tags = module.label_s3.tags
}

resource "aws_iam_policy" "s3" {
  count = local.enabled ? 1 : 0

  name        = module.label_s3.id
  description = "Allow Teleport Auth service read/write access to S3 bucket"
  policy      = join("", data.aws_iam_policy_document.s3.*.json)

  tags = module.label_s3.tags
}

resource "aws_iam_role_policy_attachment" "s3" {
  count = local.enabled ? 1 : 0

  role       = join("", aws_iam_role.s3.*.name)
  policy_arn = join("", aws_iam_policy.s3.*.arn)
}

resource "aws_iam_instance_profile" "s3" {
  count = local.enabled ? 1 : 0

  name = module.label_s3.id
  role = join("", aws_iam_role.s3.*.name)
}
