variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
}

variable "allowed_oauth_flows" {
  description = "OAuth flows enabled for the user pool client."
  type        = list(string)
  default     = ["code"]
}

variable "allowed_oauth_scopes" {
  description = "OAuth scopes enabled for the user pool client."
  type        = list(string)
  default     = ["openid", "email", "profile"]
}

variable "callback_urls" {
  description = "Callback URLs for the user pool client."
  type        = list(string)
  default     = ["http://localhost:3000/callback"]
}
