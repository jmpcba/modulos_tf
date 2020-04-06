output "api_id" {
  value = "${aws_api_gateway_rest_api.apigateway_api.id}"
}

output "dev_url" {
  value = "${aws_api_gateway_stage.dev_stage.invoke_url}"
}

output "prod_url" {
  value = "${aws_api_gateway_stage.prod_stage.invoke_url}"
}

output "execution_arn"{
  value = "${aws_api_gateway_rest_api.execution_ar}"
}