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

    resources = ["arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${module.label_dynamodb.id}"]
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
