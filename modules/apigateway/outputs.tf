output "deployment_execution_arn" {
  value = aws_api_gateway_deployment._.execution_arn
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api._.id
}

output "api_url" {
  value = local.api_url
}

output "api_name" {
  value = local.api_name
}

output "api_stage" {
  value = aws_api_gateway_stage._.stage_name
}