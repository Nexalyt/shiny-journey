resource "aws_apigatewayv2_api" "http" {
  name          = "legal-dd-api${var.environment}"
  protocol_type = "HTTP"
  tags          = var.tags
}

resource "aws_apigatewayv2_authorizer" "jwt" {
  api_id           = aws_apigatewayv2_api.http.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "legal-dd-jwt-authorizer${var.environment}"
  jwt_configuration {
    audience = [] # Fill with Cognito app client IDs as needed
    issuer   = var.cognito_user_pool_arn
  }
}

resource "aws_apigatewayv2_route" "upload" {
  api_id    = aws_apigatewayv2_api.http.id
  route_key = "POST /upload"
  authorizer_id = aws_apigatewayv2_authorizer.jwt.id
}

resource "aws_apigatewayv2_route" "status" {
  api_id    = aws_apigatewayv2_api.http.id
  route_key = "GET /status/{jobId}"
  authorizer_id = aws_apigatewayv2_authorizer.jwt.id
}

resource "aws_apigatewayv2_route" "search" {
  api_id    = aws_apigatewayv2_api.http.id
  route_key = "GET /search"
  authorizer_id = aws_apigatewayv2_authorizer.jwt.id
}

resource "aws_apigatewayv2_route" "docs" {
  api_id    = aws_apigatewayv2_api.http.id
  route_key = "GET /docs/{proxy+}"
  authorizer_id = aws_apigatewayv2_authorizer.jwt.id
}
