variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "github_repos" {
  description = "List of GitHub repositories that can assume the IAM role"
  type        = list(string)
  default     = ["OD-Oraf/terraform-github-oidc-setup", "OD-Oraf/another-repo"]
}

variable "example_name" {
  description = "Name of the secret in AWS Secrets Manager"
  type        = string
  default     = "example-secret"
}

variable "secret_recovery_window" {
  description = "Number of days to wait before permanent deletion of secret"
  type        = number
  default     = 7
}
