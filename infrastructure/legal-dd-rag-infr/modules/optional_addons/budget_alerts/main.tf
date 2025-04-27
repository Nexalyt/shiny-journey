# Placeholder for AWS Budgets and alerting resources
# Example: resource "aws_budgets_budget" "main" { ... }

variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
}

variable "budget_limit" {
  description = "Monthly budget limit in USD."
  type        = number
  default     = 100
}

variable "notification_email" {
  description = "Email address for budget alerts."
  type        = string
  default     = "owner@example.com"
}

resource "aws_budgets_budget" "monthly" {
  name              = "legal-dd-budget-${var.environment}"
  budget_type       = "COST"
  limit_amount      = var.budget_limit
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  cost_types {
    include_tax = true
    include_subscription = true
    use_blended = false
    include_refund = false
    include_credit = false
    include_upfront = true
    include_recurring = true
    include_other_subscription = true
    include_support = true
    include_discount = true
    use_amortized = false
  }
  notification {
    comparison_operator = "GREATER_THAN"
    notification_type   = "ACTUAL"
    threshold           = 80
    threshold_type      = "PERCENTAGE"
    subscriber_email_addresses = [var.notification_email]
  }
  notification {
    comparison_operator = "GREATER_THAN"
    notification_type   = "ACTUAL"
    threshold           = 100
    threshold_type      = "PERCENTAGE"
    subscriber_email_addresses = [var.notification_email]
  }
}

output "budget_name" {
  value = aws_budgets_budget.monthly.name
}
