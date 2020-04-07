resource "aws_api_gateway_rest_api" "api" {
  name = var.api_name
  description = var.api_description
}

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


resource "aws_api_gateway_method" "put_method" {
    count                = length(var.resource_list)
    rest_api_id          = aws_api_gateway_rest_api.api.id
    resource_id          = element(aws_api_gateway_resource.resource.*.id, count.index)
    http_method          = "PUT"
    authorization        = "NONE"
}

resource "aws_api_gateway_integration" "put_integration" {
    count                   = length(var.resource_list)
    rest_api_id             = aws_api_gateway_rest_api.api.id
    resource_id             = element(aws_api_gateway_resource.resource.*.id, count.index)
    http_method             = aws_api_gateway_method.put_method.http_method
    content_handling        = "CONVERT_TO_TEXT" 
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = var.lambda_uri
}

resource "aws_api_gateway_method" "get_method" {
    count                = length(var.resource_list)
    rest_api_id          = aws_api_gateway_rest_api.api.id
    resource_id          = element(aws_api_gateway_resource.resource.*.id, count.index)
    http_method          = "GET"
    authorization        = "NONE"
}

resource "aws_api_gateway_integration" "prestadores_get_integration" {
    count                   = length(var.resource_list)
    rest_api_id             = aws_api_gateway_rest_api.api.id
    resource_id             = element(aws_api_gateway_resource.resource.*.id, count.index)
    http_method             = aws_api_gateway_method.get_method.http_method
    content_handling        = "CONVERT_TO_TEXT" 
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = var.lambda_uri
}

resource "aws_api_gateway_method" "post_method" {
    count                = length(var.resource_list)
    rest_api_id          = aws_api_gateway_rest_api.api.id
    resource_id          = element(aws_api_gateway_resource.resource.*.id, count.index)
    http_method          = "POST"
    authorization        = "NONE"
}

resource "aws_api_gateway_integration" "post_integration" {
    count                   = length(var.resource_list)
    rest_api_id             = aws_api_gateway_rest_api.api.id
    resource_id             = element(aws_api_gateway_resource.resource.*.id, count.index)
    http_method             = aws_api_gateway_method.post_method.http_method
    content_handling        = "CONVERT_TO_TEXT" 
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = var.lambda_uri
}
