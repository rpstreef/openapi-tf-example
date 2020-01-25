# -----------------------------------------------------------------------------
# Outputs: Cognito
# -----------------------------------------------------------------------------

output "cognito_user_pool_id" {
  value = "${aws_cognito_user_pool._.id}"
}

output "cognito_user_pool_arn" {
  value = "${aws_cognito_user_pool._.arn}"
}

output "cognito_user_pool_client_id" {
  value = "${aws_cognito_user_pool_client._.id}"
}

output "cognito_identity_pool_id" {
  value = "${aws_cognito_identity_pool._.id}"
}
