resource "aws_api_gateway_rest_api" "apigateway_api" {
  name = var.api_name
  description = var.api_description
}

# STAGES
resource "aws_api_gateway_stage" "prod_stage" {
  stage_name    = "${var.client_name}_PROD"
  rest_api_id   = aws_api_gateway_rest_api.apigateway_api.id
  deployment_id = aws_api_gateway_deployment.prod_deployment.id
}

resource "aws_api_gateway_stage" "dev_stage" {
  stage_name    = "${var.client_name}_DEV"
  rest_api_id   = aws_api_gateway_rest_api.apigateway_api.id
  deployment_id = aws_api_gateway_deployment.dev_deployment.id
}

resource "aws_api_gateway_deployment" "prod_deployment" {
  depends_on  = [aws_api_gateway_stage.prod_stage]
  rest_api_id = aws_api_gateway_rest_api.apigateway_api.id
  stage_name  = aws_api_gateway_stage.prod_stage.stage_name
}

resource "aws_api_gateway_deployment" "dev_deployment" {
  depends_on  = [aws_api_gateway_stage.dev_stage]
  rest_api_id = aws_api_gateway_rest_api.apigateway_api.id
  stage_name  = aws_api_gateway_stage.dev_stage.stage_name
 }