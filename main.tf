locals {
  enabled = module.this.enabled

  aws_partition = join("", data.aws_partition.current.*.partition)
}

data "aws_iam_policy_document" "assume_role" {
  count = local.enabled ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals = {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_partition" "current" {
  count = local.enabled ? 1 : 0
}
