resource "aws_api_gateway_rest_api" "snakeAPI" {
  name = "snakeAPI"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  description = "This is the Snake API"
}

resource "aws_api_gateway_integration_response" "snakeGetIntR" {
  rest_api_id = aws_api_gateway_rest_api.snakeAPI.id
  resource_id = aws_api_gateway_rest_api.snakeAPI.root_resource_id
  http_method = aws_api_gateway_method.snakeGet.http_method
  status_code = aws_api_gateway_method_response.snakeGet200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_integration_response" "snakePutIntR" {
  rest_api_id = aws_api_gateway_rest_api.snakeAPI.id
  resource_id = aws_api_gateway_rest_api.snakeAPI.root_resource_id
  http_method = aws_api_gateway_method.snakePut.http_method
  status_code = aws_api_gateway_method_response.snakePut200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_method" "snakeGet" {
  rest_api_id   = aws_api_gateway_rest_api.snakeAPI.id
  resource_id   = aws_api_gateway_rest_api.snakeAPI.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "snakePut" {
  rest_api_id   = aws_api_gateway_rest_api.snakeAPI.id
  resource_id   = aws_api_gateway_rest_api.snakeAPI.root_resource_id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "snakePut200" {
  rest_api_id = aws_api_gateway_rest_api.snakeAPI.id
  resource_id = aws_api_gateway_rest_api.snakeAPI.root_resource_id
  http_method = aws_api_gateway_method.snakePut.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_method_response" "snakeGet200" {
  rest_api_id = aws_api_gateway_rest_api.snakeAPI.id
  resource_id = aws_api_gateway_rest_api.snakeAPI.root_resource_id
  http_method = aws_api_gateway_method.snakeGet.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "snakePutInt" {
  rest_api_id             = aws_api_gateway_rest_api.snakeAPI.id
  resource_id             = aws_api_gateway_rest_api.snakeAPI.root_resource_id
  http_method             = aws_api_gateway_method.snakePut.http_method
  integration_http_method = "PUT"
  type                    = "AWS"
  uri                     = aws_lambda_function.snakePut.invoke_arn

  request_templates = {
    "application/json" = <<EOF
{
    "TableName": "snakehighscore",
    "Item": {
        "playername": "$input.path('$.playername')",
        "highscore": $input.path('$.highscore')
    }
}
    EOF
  }
}

resource "aws_api_gateway_integration" "snakeGetInt" {
  rest_api_id             = aws_api_gateway_rest_api.snakeAPI.id
  resource_id             = aws_api_gateway_rest_api.snakeAPI.root_resource_id
  http_method             = aws_api_gateway_method.snakeGet.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.snakeGet.invoke_arn
}

resource "aws_api_gateway_deployment" "snakeAPI" {
  rest_api_id = aws_api_gateway_rest_api.snakeAPI.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.snakeAPI.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.snakeAPI.id
  rest_api_id   = aws_api_gateway_rest_api.snakeAPI.id
  stage_name    = "prod"
}

resource "aws_lambda_permission" "snakeGet" {
  function_name = aws_lambda_function.snakeGet.id
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.snakeAPI.execution_arn}/*"
}

resource "aws_lambda_permission" "snakePut" {
  function_name = aws_lambda_function.snakePut.id
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.snakeAPI.execution_arn}/*"
}
