locals {
  enabled = module.this.enabled

  aws_partition = join("", data.aws_partition.current.*.partition)
}

data "aws_partition" "current" {
  count = local.enabled ? 1 : 0
}

# From https://github.com/gravitational/teleport/blob/b9813e3/examples/aws/terraform/dynamo.tf#L1-L36
module "dynamodb_state_table" {
  source            = "cloudposse/dynamodb/aws"
  version           = "0.29.5"
  attributes        = ["cluster_state"]
  enable_encryption = "true"
  enable_streams    = "true"
  stream_view_type  = "NEW_IMAGE"
  hash_key          = "HashKey"
  hash_key_type     = "S"
  range_key         = "FullPath"
  range_key_type    = "S"
  ttl_attribute     = "Expires"

  regex_replace_chars = "/[^a-zA-Z0-9-_]/"

  # min_read and min_write set the provisioned capacity even if the autoscaler is not enabled
  autoscale_min_read_capacity  = var.autoscale_min_read_capacity
  autoscale_min_write_capacity = var.autoscale_min_write_capacity

  enable_autoscaler            = true
  autoscale_read_target        = var.autoscale_read_target
  autoscale_write_target       = var.autoscale_write_target
  autoscale_max_read_capacity  = var.autoscale_max_read_capacity
  autoscale_max_write_capacity = var.autoscale_max_write_capacity

  context = module.this.context
}

# From https://github.com/gravitational/teleport/blob/b9813e3/examples/aws/terraform/dynamo.tf#L38-L91
module "dynamodb_audit_table" {
  source            = "cloudposse/dynamodb/aws"
  version           = "0.29.5"
  attributes        = ["events"]
  enable_encryption = "true"
  hash_key          = "SessionID"
  hash_key_type     = "S"
  range_key         = "EventIndex"
  range_key_type    = "N"
  ttl_attribute     = "Expires"

  regex_replace_chars = "/[^a-zA-Z0-9-_]/"

  dynamodb_attributes = [
    {
      name = "SessionID"
      type = "S"
    },
    {
      name = "EventIndex"
      type = "N"
    },
    {
      name = "CreatedAtDate"
      type = "S"
    },
    {
      name = "CreatedAt"
      type = "N"
    },
  ]

  global_secondary_index_map = [
    {
      name            = "timesearchV2"
      hash_key        = "CreatedAtDate"
      range_key       = "CreatedAt"
      read_capacity   = var.autoscale_min_read_capacity
      write_capacity  = var.autoscale_min_write_capacity
      projection_type = "ALL"

      non_key_attributes = []
    }
  ]

  # min_read and min_write set the provisioned capacity even if the autoscaler is not enabled
  autoscale_min_read_capacity  = var.autoscale_min_read_capacity
  autoscale_min_write_capacity = var.autoscale_min_write_capacity

  enable_autoscaler            = true
  autoscale_read_target        = var.autoscale_read_target
  autoscale_write_target       = var.autoscale_write_target
  autoscale_max_read_capacity  = var.autoscale_max_read_capacity
  autoscale_max_write_capacity = var.autoscale_max_write_capacity

  context = module.this.context
}
# Source:
# * https://github.com/gravitational/teleport/blob/7d93a421069e75e9b9cbafe9e89690c8d914d3b1/docs/pages/kubernetes-access/helm/guides/aws.mdx
# * https://github.com/gravitational/teleport/blob/9282fbd6130251275901572e3de63df67e855748/examples/aws/cloudformation/ent.yaml#L627

# Allow Read and Write access to the bucket
# https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_s3_rw-bucket.html
data "aws_iam_policy_document" "default" {
  count = local.enabled ? 1 : 0

  statement {
    sid    = "ClusterSessionsStorage"
    effect = "Allow"
    actions = [
      # "s3:CreateBucket",
      # "s3:Get*",
      "s3:GetBucketVersioning",
      "s3:GetEncryptionConfiguration",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetObjectRetention",
      # "s3:List*",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
      # "s3:Put*"
      "s3:PutObject",
      "s3:PutEncryptionConfiguration",
      "s3:PutBucketVersioning",
    ]

    resources = [
      "arn:${local.aws_partition}:s3:::${module.s3_bucket.bucket_id}",
      "arn:${local.aws_partition}:s3:::${module.s3_bucket.bucket_id}/*",
    ]
  }

  statement {
    sid    = "ClusterStateStorage"
    effect = "Allow"
    actions = [
      "dynamodb:*"
      # "dynamodb:CreateTable",
      # "dynamodb:BatchWriteItem",
      # "dynamodb:UpdateTimeToLive",
      # "dynamodb:PutItem",
      # "dynamodb:DescribeTable",
      # "dynamodb:DeleteItem",
      # "dynamodb:GetItem",
      # "dynamodb:Scan",
      # "dynamodb:Query",
      # "dynamodb:UpdateItem",
      # "dynamodb:DescribeTimeToLive",
      # "dynamodb:UpdateTable",
    ]

    resources = [
      module.dynamodb_state_table.table_arn,
      "${module.dynamodb_state_table.table_arn}/stream/*",
    ]
  }

  statement {
    sid    = "ClusterEventsStorage"
    effect = "Allow"
    actions = [
      "dynamodb:*"
      # "dynamodb:CreateTable",
      # "dynamodb:BatchWriteItem",
      # "dynamodb:UpdateTimeToLive",
      # "dynamodb:PutItem",
      # "dynamodb:DescribeTable",
      # "dynamodb:DeleteItem",
      # "dynamodb:GetItem",
      # "dynamodb:Scan",
      # "dynamodb:Query",
      # "dynamodb:UpdateItem",
      # "dynamodb:DescribeTimeToLive",
      # "dynamodb:UpdateTable",
    ]

    resources = [
      module.dynamodb_audit_table.table_arn,
      "${module.dynamodb_audit_table.table_arn}/index/*"
    ]
  }
}
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
