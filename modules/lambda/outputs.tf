output "arn" {
  value = aws_lambda_function._.arn
}

output "name" {
  value = local.function_name
}