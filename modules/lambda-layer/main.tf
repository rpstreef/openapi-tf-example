locals {
  resource_name_prefix = "${var.namespace}-${var.resource_tag_name}"
}

resource "aws_lambda_layer_version" "_" {
  filename = "${var.dist_file_path}/${var.zip_name}"
  layer_name = "${local.resource_name_prefix}-${var.name}"

  source_code_hash = filebase64sha256("${var.dist_file_path}/${var.zip_name}")

  compatible_runtimes = ["nodejs10.x"]

  description = var.description
}