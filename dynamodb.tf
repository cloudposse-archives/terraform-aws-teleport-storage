# From https://github.com/gravitational/teleport/blob/b9813e3/examples/aws/terraform/dynamo.tf#L1-L36
module "dynamodb_state_table" {
  # source            = "git::https://github.com/cloudposse/terraform-aws-dynamodb.git?ref=tags/0.7.0"

  source  = "cloudposse/dynamodb/aws"
  version = "0.29.4"

  attributes        = [compact(concat(var.attributes, list("cluster_state")))]

  enable_encryption = true
  enable_streams    = true
  stream_view_type  = "NEW_IMAGE"
  hash_key          = "HashKey"
  hash_key_type     = "S"
  range_key         = "FullPath"
  range_key_type    = "S"
  ttl_attribute     = "Expires"

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
  # source            = "git::https://github.com/cloudposse/terraform-aws-dynamodb.git?ref=tags/0.7.0"

  source  = "cloudposse/dynamodb/aws"
  version = "0.29.4"

  attributes        = [compact(concat(var.attributes, list("events")))]

  enable_encryption = true
  hash_key          = "SessionID"
  hash_key_type     = "S"
  range_key         = "EventIndex"
  range_key_type    = "N"
  ttl_attribute     = "Expires"

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
      name = "EventNamespace"
      type = "S"
    },
    {
      name = "CreatedAt"
      type = "N"
    },
  ]

  global_secondary_index_map = [{
    name            = "timesearch"
    hash_key        = "EventNamespace"
    range_key       = "CreatedAt"
    read_capacity   = var.autoscale_min_read_capacity
    write_capacity  = var.autoscale_min_write_capacity
    projection_type = "ALL"
  }]

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

module "label_dynamodb" {
  # source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"

  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = [compact(concat(var.attributes, list("dynamodb")))]

  context = module.this.context
}

data "aws_iam_policy_document" "dynamodb" {
  count = local.enabled ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["dynamodb:*"]

    resources = [
      module.dynamodb_audit_table.table_arn,
      module.dynamodb_state_table.table_arn,
    ]
  }
}

resource "aws_iam_role" "dynamodb" {
  count = local.enabled ? 1 : 0

  name               = module.label_dynamodb.id
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)

  max_session_duration = var.iam_role_max_session_duration

  tags = module.label_dynamodb.tags
}

resource "aws_iam_policy" "dynamodb" {
  count = local.enabled ? 1 : 0

  name        = module.label_dynamodb.id
  description = "Allow Teleport Auth service full access to DynamoDB table"
  policy      = join("", data.aws_iam_policy_document.dynamodb.*.json)

  tags = module.label_dynamodb.tags
}

resource "aws_iam_role_policy_attachment" "dynamodb" {
  role       = join("", aws_iam_role.dynamodb.*.name)
  policy_arn = join("", aws_iam_policy.dynamodb.*.arn)
}

resource "aws_iam_instance_profile" "dynamodb" {
  name = module.label_dynamodb.id
  role = join("", aws_iam_role.dynamodb.*.name)
}
