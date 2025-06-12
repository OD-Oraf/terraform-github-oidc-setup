# Configure AWS Provider
provider "aws" {
  region = "us-east-1" # Change this to your desired region
}

# Create a secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "example_secret" {
  name                    = "example-secret"
  description             = "Example secret created by Terraform"
  recovery_window_in_days = 7 # Optional: Number of days to wait before permanent deletion
}

# Create a version of the secret with the actual value
resource "aws_secretsmanager_secret_version" "example_secret_version" {
  secret_id = aws_secretsmanager_secret.example_secret.id
  secret_string = jsonencode({
    username = "example-secret"
    password = "123456789"
  })
}

# Create the OIDC Provider for GitHub
resource "aws_iam_openid_connect_provider" "github_oidc" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com", "sigstore"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# Create IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions" {
  name = "github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_oidc.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" : "repo:OD-Oraf/*"
          }
        }
      }
    ]
  })
}

# Attach policy to the role (example with SecretsManager access)
resource "aws_iam_role_policy" "github_actions_policy" {
  name = "github-actions-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.example_secret.arn
      }
    ]
  })
}

# MuleSoft Anypoint CLI Parameters
resource "aws_ssm_parameter" "anypoint_cli_ruleset_validation" {
  name  = "/mulesoft/anypoint-cli/ruleset-validation"
  type  = "StringList"
  value = "ruleset,validate,--format json"
  tags = {
    Service = "MuleSoft"
    Tool    = "Anypoint-CLI"
  }
}

resource "aws_ssm_parameter" "anypoint_cli_mule_rulesets" {
  name  = "/mulesoft/anypoint-cli/mule-rulesets"
  type  = "StringList"
  value = "anypoint-cli-v4 api-mgr ruleset validate --remote-rulesets 68ef9520-24e9-4cf2-b2f5-620025690913/api-governance-ruleset/1.0.1 68ef9520-24e9-4cf2-b2f5-620025690913/best-practices-ruleset/1.0.1 68ef9520-24e9-4cf2-b2f5-620025690913/security-ruleset/1.0.1"
  tags = {
    Service = "MuleSoft"
    Tool    = "Anypoint-CLI"
  }
}

# Parameter Store - Anypoint CLI Ruleset Validation Command
resource "aws_ssm_parameter" "anypoint_ruleset_validation" {
  name        = "/mulesoft/anypoint-cli/ruleset-validation-command"
  description = "Anypoint CLI command for ruleset validation"
  type        = "StringList"
  value       = "anypoint-cli-v4 api-mgr ruleset validate --remote-rulesets 68ef9520-24e9-4cf2-b2f5-620025690913/api-governance-ruleset/1.0.1 68ef9520-24e9-4cf2-b2f5-620025690913/best-practices-ruleset/1.0.1 68ef9520-24e9-4cf2-b2f5-620025690913/security-ruleset/1.0.1"
  tier        = "Standard"

  tags = {
    Environment = "development"
    Service     = "MuleSoft"
    Tool        = "Anypoint-CLI"
  }
}

# Get current AWS region and account details
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Update IAM policy to include access to MuleSoft parameters
resource "aws_iam_role_policy" "parameter_store_policy" {
  name = "parameter-store-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = [
          "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/example/*",
          "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/mulesoft/*"
        ]
      }
    ]
  })
}