# #lambda function creation snake-get
resource "aws_lambda_function" "lambda" {
    function_name           = "snake-get"
    filename                = data.archive_file.zip.output_path
    role                    = "${aws_iam_role.lambda-exec.arn}"
    handler                 = "index.handler"
    runtime                 = "nodejs18.x"

    vpc_config {
      subnet_ids         = [aws_subnet.public[0].id]
      security_group_ids = [aws_vpc.main.default_security_group_id]
    }
}

##Lambda IAM policy snake-get
resource "aws_iam_role" "lambda-exec" {
    name = "get_lambda_role"
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

#lambda function creation snake push
resource "aws_lambda_function" "lambda2" {
    function_name           = "snake-push"
    filename                = data.archive_file.zip.output_path
    role                    = "${aws_iam_role.lambda-exec.arn}"
    handler                 = "index.handler"
    runtime                 = "nodejs18.x"

    vpc_config {
      subnet_ids         = [aws_subnet.public[0].id]
      security_group_ids = [aws_vpc.main.default_security_group_id]
    }
}


##Lambda IAM policy snake-push
resource "aws_iam_role" "get_lambda2_role-exec" {
    name = "get_lambda2_role"
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

resource "aws_iam_role_policy_attachment" "additional" {
    
 policy_arn  = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
 role        = aws_iam_role.lambda-exec.id
}


resource "aws_iam_role_policy_attachment" "additonal2" {

 policy_arn  = "aws_iam_policy.snake-push-role-puqck0az.arn"
 role        = aws_iam_role.lambda-exec.id
}


resource "aws_api_gateway_rest_api" "SnakeAPI" {
  name        = "SnakeAPI"
  description = "This is my API for demonstration purposes"
}

resource "aws_api_gateway_resource" "SnakeAPIResource" {
  rest_api_id = aws_api_gateway_rest_api.SnakeAPI.id
  parent_id   = aws_api_gateway_rest_api.SnakeAPI.root_resource_id
  path_part   = "SnakeAPIResource"
}

resource "aws_api_gateway_method" "SnakeMethod" {
  rest_api_id   = aws_api_gateway_rest_api.SnakeAPI.id
  resource_id   = aws_api_gateway_resource.SnakeAPIResource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.SnakeAPI.id
  resource_id = aws_api_gateway_resource.SnakeAPIResource.id
  http_method = aws_api_gateway_method.SnakeMethod.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration" "APIIntegration" {
  rest_api_id          = aws_api_gateway_rest_api.SnakeAPI.id
  resource_id          = aws_api_gateway_resource.SnakeAPIResource.id
  http_method          = aws_api_gateway_method.SnakeMethod.http_method
  type                 = "AWS"
  # cache_key_parameters = ["method.request.path.param"]
  # cache_namespace      = "Hanson"
  # timeout_milliseconds = 29000

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

# resource "aws_api_gateway_integration" "lambda" {
#     rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
#     resource_id = "${aws_api_gateway_resource.test_api.id}"
#     http_method = "${aws_api_gateway_method.get_method.http_method}"

#     integration_http_method = "${aws_api_gateway_method.get_method.http_method}"
#     type                    = "AWS"
#     uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda.arn}/invocations"

# }



resource "aws_lambda_permission" "allow_api_gateway" {
    function_name = "${aws_lambda_function.lambda.id}"
    statement_id = "AllowExecutionFromApiGateway"
    action = "lambda:InvokeFunction"
    principal = "apigateway.amazonaws.com"
    source_arn =  "${aws_api_gateway_rest_api.SnakeAPI.execution_arn}/*"
}

resource "aws_lambda_permission" "allow_api_gateway2" {
    function_name = "${aws_lambda_function.lambda2.id}"
    statement_id = "AllowExecutionFromApiGateway"
    action = "lambda:InvokeFunction"
    principal = "apigateway.amazonaws.com"
    source_arn =  "${aws_api_gateway_rest_api.SnakeAPI.execution_arn}/*"
}