output "api_id" {
  value = aws_api_gateway_rest_api.api.id
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.api.execution_arn
}

output "root_resource_id" {
  value = aws_api_gateway_rest_api.api.root_resource_id
}

output "dev_url" {
  value = aws_api_gateway_deployment.dev_deployment.invoke_url
}

output "prod_url" {
  value = aws_api_gateway_deployment.prod_deployment.invoke_url
}