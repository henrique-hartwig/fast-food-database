variable "aws_region" {
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambientes (dev, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Fast Food"
  type        = string
  default     = "fast-food"
}
