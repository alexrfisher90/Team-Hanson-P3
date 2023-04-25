resource "aws_api_gateway_rest_api" "snakeAPI" {
  name        = "snakeAPI"
  description = "This is the Snake API"
}

resource "aws_api_gateway_integration_response" "snakeGetIntR" {
  rest_api_id = aws_api_gateway_rest_api.snakeAPI.id
  resource_id = aws_api_gateway_rest_api.snakeAPI.root_resource_id
  http_method = aws_api_gateway_method.snakeGet.http_method
  status_code = aws_api_gateway_method_response.snakeGet200.status_code

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_integration_response" "snakePutIntR" {
  rest_api_id = aws_api_gateway_rest_api.snakeAPI.id
  resource_id = aws_api_gateway_rest_api.snakeAPI.root_resource_id
  http_method = aws_api_gateway_method.snakePut.http_method
  status_code = aws_api_gateway_method_response.snakePut200.status_code

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_method" "snakeGet" {
  rest_api_id   = aws_api_gateway_rest_api.snakeAPI.id
  resource_id   = aws_api_gateway_rest_api.snakeAPI.root_resource_id
  http_method   = "POST"
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
}

resource "aws_api_gateway_method_response" "snakeGet200" {
  rest_api_id = aws_api_gateway_rest_api.snakeAPI.id
  resource_id = aws_api_gateway_rest_api.snakeAPI.root_resource_id
  http_method = aws_api_gateway_method.snakeGet.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration" "snakePutInt" {
  rest_api_id             = aws_api_gateway_rest_api.snakeAPI.id
  resource_id             = aws_api_gateway_rest_api.snakeAPI.root_resource_id
  http_method             = aws_api_gateway_method.snakePut.http_method
  integration_http_method = aws_api_gateway_method.snakePut.http_method
  type                    = "AWS"
  uri                     = aws_lambda_function.snakePut.invoke_arn

  request_parameters = {
    "integration.request.header.X-Authorization" = "'static'"
  }

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
  integration_http_method = aws_api_gateway_method.snakeGet.http_method
  type                    = "AWS"
  uri                     = aws_lambda_function.snakeGet.invoke_arn

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
