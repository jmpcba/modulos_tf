resource "aws_api_gateway_rest_api" "api" {
  name = var.api_name
  description = var.api_description
}

# DEPLOYMENTS
resource "aws_api_gateway_deployment" "prod_deployment" {
  depends_on  = [aws_api_gateway_integration.get_integration, aws_api_gateway_integration.post_integration, aws_api_gateway_integration.put_integration]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name    = "prod"
}

resource "aws_api_gateway_deployment" "dev_deployment" {
  depends_on  = [aws_api_gateway_integration.get_integration, aws_api_gateway_integration.post_integration, aws_api_gateway_integration.put_integration]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name    = "dev"
}

# RESOURCES
resource "aws_api_gateway_resource" "api_version_1" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id   = aws_api_gateway_rest_api.api.root_resource_id
    path_part   = "v1"
}

resource "aws_api_gateway_resource" "resource" {
    count       = length(var.resource_list)
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id   = aws_api_gateway_resource.api_version_1.id
    path_part   = element(var.resource_list, count.index)
}

#HTTP METHODS
resource "aws_api_gateway_method" "put_method" {
    count                = length(var.resource_list)
    rest_api_id          = aws_api_gateway_rest_api.api.id
    resource_id          = element(aws_api_gateway_resource.resource.*.id, count.index)
    http_method          = "PUT"
    authorization        = "COGNITO_USER_POOLS"
    authorizer_id        = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_method" "get_method" {
    count                = length(var.resource_list)
    rest_api_id          = aws_api_gateway_rest_api.api.id
    resource_id          = element(aws_api_gateway_resource.resource.*.id, count.index)
    http_method          = "GET"
    authorization        = "COGNITO_USER_POOLS"
    authorizer_id        = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_method" "post_method" {
    count                = length(var.resource_list)
    rest_api_id          = aws_api_gateway_rest_api.api.id
    resource_id          = element(aws_api_gateway_resource.resource.*.id, count.index)
    http_method          = "POST"
    authorization        = "COGNITO_USER_POOLS"
    authorizer_id        = aws_api_gateway_authorizer.cognito_authorizer.id
}

# INTEGRATIONS
resource "aws_api_gateway_integration" "get_integration" {
    count                   = length(var.resource_list)
    rest_api_id             = aws_api_gateway_rest_api.api.id
    resource_id             = element(aws_api_gateway_resource.resource.*.id, count.index)
    http_method             = element(aws_api_gateway_method.get_method.*.http_method, count.index)
    content_handling        = "CONVERT_TO_TEXT" 
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = var.lambda_uri
}

resource "aws_api_gateway_integration" "post_integration" {
    count                   = length(var.resource_list)
    rest_api_id             = aws_api_gateway_rest_api.api.id
    resource_id             = element(aws_api_gateway_resource.resource.*.id, count.index)
    http_method             = element(aws_api_gateway_method.post_method.*.http_method, count.index)
    content_handling        = "CONVERT_TO_TEXT" 
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = var.lambda_uri
}

resource "aws_api_gateway_integration" "put_integration" {
    count                   = length(var.resource_list)
    rest_api_id             = aws_api_gateway_rest_api.api.id
    resource_id             = element(aws_api_gateway_resource.resource.*.id, count.index)
    http_method             = element(aws_api_gateway_method.put_method.*.http_method, count.index)
    content_handling        = "CONVERT_TO_TEXT" 
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = var.lambda_uri
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name          = "cognito_authorizer"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.user_pool.arn]
  identity_source = "method.request.header.X-COG-ID"
}

resource "aws_cognito_user_pool" "user_pool" {
  name = "HC_USER_POOL"
}
