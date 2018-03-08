module "dynamodb_table" {
  source                       = "git::https://github.com/cloudposse/terraform-aws-dynamodb.git?ref=tags/0.1.0"
  namespace                    = "${var.namespace}"
  stage                        = "${var.stage}"
  name                         = "${var.name}"
  delimiter                    = "${var.delimiter}"
  attributes                   = ["${compact(concat(var.attributes, list("dynamodb")))}"]
  tags                         = "${var.tags}"
  region                       = "${var.region}"
  hash_key                     = "${var.hash_key}"
  range_key                    = "${var.range_key}"
  ttl_attribute                = "${var.ttl_attribute}"
  autoscale_read_target        = "${var.autoscale_read_target}"
  autoscale_write_target       = "${var.autoscale_write_target}"
  autoscale_min_read_capacity  = "${var.autoscale_min_read_capacity}"
  autoscale_max_read_capacity  = "${var.autoscale_max_read_capacity}"
  autoscale_min_write_capacity = "${var.autoscale_min_write_capacity}"
  autoscale_max_write_capacity = "${var.autoscale_max_write_capacity}"
}

module "label_dynamodb" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = ["${compact(concat(var.attributes, list("dynamodb")))}"]
  tags       = "${var.tags}"
}

data "aws_iam_policy_document" "dynamodb" {
  statement {
    effect  = "Allow"
    actions = ["dynamodb:*"]

    resources = ["${module.dynamodb_table.table_arn}"]
  }
}

resource "aws_iam_role" "dynamodb" {
  name               = "${module.label_dynamodb.id}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

resource "aws_iam_policy" "dynamodb" {
  name        = "${module.label_dynamodb.id}"
  description = "Allow Teleport Auth service full access to DynamoDB table"
  policy      = "${data.aws_iam_policy_document.dynamodb.json}"
}

resource "aws_iam_role_policy_attachment" "dynamodb" {
  role       = "${aws_iam_role.dynamodb.name}"
  policy_arn = "${aws_iam_policy.dynamodb.arn}"
}

resource "aws_iam_instance_profile" "dynamodb" {
  name = "${module.label_dynamodb.id}"
  role = "${aws_iam_role.dynamodb.name}"
}
