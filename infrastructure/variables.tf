variable "aws_profile" {
  type        = string
  description = "AWS Profile to use to deploy resources"
  default     = "default"
}

variable "region" {
  type        = string
  description = "AWS Region to deploy the all the resources."
  default     = "eu-west-1"
}

variable "environment" {
  type        = string
  description = "Deployment Environment"
  default     = "test"
}

locals {
  common_tags = {
    Environment = var.environment
    Owner       = "Deloitte Assignment"
    Application = "String Replacer"
  }

  api = {
    name = "replace-string"
  }

  iam = {
    policy_name = "iam-policy-${var.environment}"
    role_name   = "iam-role-${var.environment}"
  }

  lambda = {
    name = "replace-string"
  }

  s3 = {
    infra_bucket_name = "infra-bucket-${var.environment}"
  }
}
