locals {
  resource_name_prefix = "${var.namespace}-${var.resource_tag_name}"
}

# -----------------------------------------------------------------------------
# Data: IAM
# -----------------------------------------------------------------------------

data "template_file" "_" {
  template = var.template
  vars     = var.role_vars
}

# -----------------------------------------------------------------------------
# Resources: IAM Lambda Roles and Policies
# -----------------------------------------------------------------------------

resource "aws_iam_role" "_" {
  name = "${local.resource_name_prefix}-${var.role_name}"

  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy" "_" {
  name = "${local.resource_name_prefix}-${var.policy_name}"

  policy = data.template_file._.rendered
}

resource "aws_iam_policy_attachment" "_" {
  name = "${local.resource_name_prefix}-${var.policy_attachment_name}"

  policy_arn = aws_iam_policy._.arn
  roles      = ["${aws_iam_role._.name}"]
}
