resource "aws_api_gateway_resource" "api_version_1" {
    rest_api_id = var.restapi_id
    parent_id   = var.root_resource_id
    path_part   = "v1"
}

resource "aws_api_gateway_resource" "resource" {
    rest_api_id = var.restapi_id
    parent_id   = aws_api_gateway_resource.api_version_1.id
    path_part   = var.resource_path
}


resource "aws_api_gateway_method" "prestadores_put_method" {
    rest_api_id          = var.restapi_id
    resource_id          = aws_api_gateway_resource.resource.id
    http_method          = "PUT"
    authorization        = "NONE"
}

resource "aws_api_gateway_integration" "prestadores_put_integration" {
    rest_api_id             = var.restapi_id
    resource_id             = aws_api_gateway_resource.resource.id
    http_method             = aws_api_gateway_method.prestadores_put_method.http_method
    content_handling        = "CONVERT_TO_TEXT" 
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = var.lambda_uri
}

resource "aws_api_gateway_method" "prestadores_get_method" {
    rest_api_id          = var.restapi_id
    resource_id          = aws_api_gateway_resource.resource.id
    http_method          = "GET"
    authorization        = "NONE"
}

resource "aws_api_gateway_integration" "prestadores_get_integration" {
    rest_api_id             = var.restapi_id
    resource_id             = aws_api_gateway_resource.resource.id
    http_method             = aws_api_gateway_method.prestadores_get_method.http_method
    content_handling        = "CONVERT_TO_TEXT" 
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = var.lambda_uri
}

resource "aws_api_gateway_method" "prestadores_post_method" {
    rest_api_id          = var.restapi_id
    resource_id          = aws_api_gateway_resource.resource.id
    http_method          = "POST"
    authorization        = "NONE"
}

resource "aws_api_gateway_integration" "prestadores_post_integration" {
    rest_api_id             = var.restapi_id
    resource_id             = aws_api_gateway_resource.resource.id
    http_method             = aws_api_gateway_method.prestadores_post_method.http_method
    content_handling        = "CONVERT_TO_TEXT" 
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = var.lambda_uri
}