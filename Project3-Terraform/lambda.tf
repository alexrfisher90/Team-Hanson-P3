#lambda function creation snake-get
resource "aws_lambda_function" "snakeGet" {
  function_name = "snakeGet"
  filename      = "snakeGet.zip"
  role          = aws_iam_role.snakeGetRole.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
}

##Lambda IAM policy snake-get
resource "aws_iam_role" "snakeGetRole" {
  name = "snakeGetRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dbReadAttach" {
  role       = aws_iam_role.snakeGetRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "snakeGetBasicExecutionRole" {
  role       = aws_iam_role.snakeGetRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#lambda function creation snake push
resource "aws_lambda_function" "snakePut" {
  function_name = "snakePut"
  filename      = "snakePut.zip"
  role          = aws_iam_role.snakePutRole.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
}

##Lambda IAM policy snake-push
resource "aws_iam_role" "snakePutRole" {
  name = "snakePutRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "snakePutDBExec" {
  role       = aws_iam_role.snakePutRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
}

resource "aws_iam_role_policy_attachment" "snakePutBasicExecutionRole" {
  role       = aws_iam_role.snakePutRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}
