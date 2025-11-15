provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_iam_role" "lb-role" {
  name = "serverless-api-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_lambda_function" "lb-func" {
  function_name    = "ServerlessAPI"
  role             = aws_iam_role.lb-role.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.lambda-zip.output_path
  source_code_hash = data.archive_file.lambda-zip.output_base64sha256

  environment {
    variables = {
      GREETING = "Greetings everyone, from Soki!"
    }
  }
}

resource "aws_apigatewayv2_api" "api-gw-v2" {
  name          = "http-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api-gw-v2.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "api-gw-int" {
  api_id           = aws_apigatewayv2_api.api-gw-v2.id
  integration_type = "AWS_PROXY"

  integration_method = "POST"
  integration_uri    = aws_lambda_function.lb-func.invoke_arn
}

resource "aws_apigatewayv2_route" "api-gw-rt" {
  api_id    = aws_apigatewayv2_api.api-gw-v2.id
  route_key = "ANY /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.api-gw-int.id}"
}

resource "aws_lambda_permission" "lb-perm" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lb-func.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api-gw-v2.execution_arn}/*/*"
}

resource "aws_iam_role_policy_attachment" "lb-log" {
  role       = aws_iam_role.lb-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

terraform {
  backend "s3" {

  }
}