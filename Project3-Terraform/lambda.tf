# #lambda function creation snake-get
resource "aws_lambda_function" "snakeGet" {
  function_name = "snake-get"
  filename      = "SnakeGET.zip"
  role          = aws_iam_role.snakeGetRole.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  vpc_config {
    subnet_ids         = [aws_subnet.public[0].id]
    security_group_ids = [aws_vpc.main.default_security_group_id]
  }
}

##Lambda IAM policy snake-get
resource "aws_iam_role" "snakeGetRole" {
  name               = "snakeGetRole"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

data "aws_iam_policy" "dbRead" {
  arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  role       = aws_iam_role.snakeGetRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "dbReadAttach" {
  role       = aws_iam_role.snakeGetRole.name
  policy_arn = data.aws_iam_policy.dbRead.arn
}

#lambda function creation snake push
resource "aws_lambda_function" "snakePut" {
  function_name = "snake-push"
  filename      = "SnakePUSH.zip"
  role          = aws_iam_role.snakePutRole.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  vpc_config {
    subnet_ids         = [aws_subnet.public[0].id]
    security_group_ids = [aws_vpc.main.default_security_group_id]
  }
}

##Lambda IAM policy snake-push
resource "aws_iam_role" "snakePutRole" {
  name               = "snakePutRole"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

data "aws_iam_policy" "dbExec" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole2" {
  role       = aws_iam_role.snakePutRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "dbExecAttach" {
  role       = aws_iam_role.snakePutRole.name
  policy_arn = data.aws_iam_policy.dbExec.arn
}

resource "aws_api_gateway_rest_api" "snakeAPI" {
  name        = "snakeAPI"
  description = "This is the Snake API"
}

# resource "aws_api_gateway_resource" "snakeAPIResource" {
#   rest_api_id = aws_api_gateway_rest_api.snakeAPI.id
#   parent_id   = aws_api_gateway_rest_api.snakeAPI.root_resource_id
#   path_part   = "snakeAPIResource"
# }

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

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.snakeAPI.id
  resource_id = aws_api_gateway_rest_api.snakeAPI.root_resource_id
  http_method = aws_api_gateway_method.snakePut.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration" "snakePutInt" {
  rest_api_id             = aws_api_gateway_rest_api.snakeAPI.id
  resource_id             = aws_api_gateway_rest_api.snakeAPI.root_resource_id
  http_method             = aws_api_gateway_method.snakePut.http_method
  integration_http_method = aws_api_gateway_method.snakePut.http_method
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${aws_lambda_function.snakePut.arn}/invocations"

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
  rest_api_id = aws_api_gateway_rest_api.snakeAPI.id
  resource_id = aws_api_gateway_rest_api.snakeAPI.root_resource_id
  http_method = aws_api_gateway_method.snakeGet.http_method

  integration_http_method = aws_api_gateway_method.snakeGet.http_method
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${aws_lambda_function.snakeGet.arn}/invocations"

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
