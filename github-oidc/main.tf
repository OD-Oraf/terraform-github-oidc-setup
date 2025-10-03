# Terraform GitHub OIDC Setup
# Main entry point for the Terraform configuration

# This file serves as the entry point for the Terraform configuration.
# Resources are organized in separate files by their logical function:
# - providers.tf: AWS provider configuration
# - variables.tf: Input variables
# - outputs.tf: Output values
# - iam.tf: IAM roles and policies for GitHub OIDC
# - secrets.tf: AWS Secrets Manager resources
# - data.tf: Data sources

# Uncomment this block to configure S3 backend for remote state
# terraform {
#   backend "s3" {
#     bucket = "od-orafgithub-actions-terraform-state-bucket"
#     key    = "github-oidc/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

# Uncomment this block to specify required Terraform and provider versions
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
