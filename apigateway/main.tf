resource "aws_api_gateway_rest_api" "api" {
  name = var.api_name
  description = var.api_description
}

# STAGES
resource "aws_api_gateway_stage" "prod_stage" {
  stage_name    = "${var.client_name}_PROD"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.prod_deployment.id
}

resource "aws_api_gateway_stage" "dev_stage" {
  stage_name    = "${var.client_name}_DEV"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.dev_deployment.id
}

resource "aws_api_gateway_deployment" "prod_deployment" {
  depends_on  = [aws_api_gateway_integration.dummy_get_integration]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.prod_stage.stage_name
}

resource "aws_api_gateway_deployment" "dev_deployment" {
  depends_on  = [aws_api_gateway_integration.dummy_get_integration]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.dev_stage.stage_name
}

## dummy integration
resource "aws_api_gateway_method" "dummy_get_method" {
    rest_api_id          = aws_api_gateway_rest_api.api.id
    resource_id          = aws_api_gateway_rest_api.root_resource_id
    http_method          = "GET"
    authorization        = "NONE"
}

resource "aws_api_gateway_integration" "dummy_get_integration" {
    rest_api_id             = aws_api_gateway_rest_api.api.id
    resource_id             = aws_api_gateway_rest_api.root_resource_id
    http_method             = aws_api_gateway_method.dummy_get_method.http_method
    content_handling        = "CONVERT_TO_TEXT" 
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
}