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
