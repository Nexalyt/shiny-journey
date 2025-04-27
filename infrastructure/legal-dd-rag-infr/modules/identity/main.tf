resource "aws_cognito_user_pool" "this" {
  name = "legal-dd-user-pool${var.environment}"
  tags = var.tags
}

resource "aws_cognito_user_pool_client" "this" {
  name         = "legal-dd-client${var.environment}"
  user_pool_id = aws_cognito_user_pool.this.id
  generate_secret = false
  allowed_oauth_flows = var.allowed_oauth_flows
  allowed_oauth_scopes = var.allowed_oauth_scopes
  callback_urls = var.callback_urls
  supported_identity_providers = ["COGNITO", "Google", "Okta"]
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = "legal-dd-${var.environment}"
  user_pool_id = aws_cognito_user_pool.this.id
}

# Example: Google IdP (Okta similar, not shown for brevity)
# resource "aws_cognito_identity_provider" "google" {
#   user_pool_id  = aws_cognito_user_pool.this.id
#   provider_name = "Google"
#   provider_type = "Google"
#   provider_details = {
#     client_id     = var.google_client_id
#     client_secret = var.google_client_secret
#     authorize_scopes = "openid email profile"
#   }
#   attribute_mapping = {
#     email = "email"
#   }
# }
