output "api_endpoint" {
  description = "URL of the deployed HTTP API"
  value       = aws_apigatewayv2_stage.default.invoke_url
}