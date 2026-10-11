variable "aws_region" {
  description = "AWS region for provisioning resources"
  type        = string
  default     = "ap-south-1" # Change to us-east-1 if preferred
}

variable "app_name" {
  description = "Application name prefix for AWS resources"
  type        = string
  default     = "wanderlust"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}