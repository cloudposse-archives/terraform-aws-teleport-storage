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
