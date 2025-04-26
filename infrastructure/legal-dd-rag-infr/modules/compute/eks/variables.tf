variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC ID for EKS cluster."
  type        = string
  default     = null
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS nodes."
  type        = list(string)
  default     = []
}
