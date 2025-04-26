variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
}

variable "cognito_user_pool_arn" {
  description = "ARN of the Cognito User Pool for JWT authorizer."
  type        = string
  default     = null
}
