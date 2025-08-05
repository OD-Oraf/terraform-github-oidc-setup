# Create a secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "example_secret" {
  name                    = var.secret_name
  description             = "Example secret created by Terraform"
  recovery_window_in_days = var.secret_recovery_window
}

# Create a version of the secret with the actual value
resource "aws_secretsmanager_secret_version" "example_secret_version" {
  secret_id = aws_secretsmanager_secret.example_secret.id
  secret_string = jsonencode({
    username = "example-secret"
    password = "123456789"
  })
}

# MuleSoft Anypoint CLI Parameters for Governance Rulesets
resource "aws_ssm_parameter" "anypoint_cli_mule_rulesets" {
  name  = "/mulesoft/anypoint-cli/api-governence-rulesets/pearson-rulesets"
  type  = "StringList"
  value = "anypoint-cli-v4 api-mgr ruleset validate --remote-rulesets 68ef9520-24e9-4cf2-b2f5-620025690913/api-governance-ruleset/1.0.1 68ef9520-24e9-4cf2-b2f5-620025690913/best-practices-ruleset/1.0.1 68ef9520-24e9-4cf2-b2f5-620025690913/security-ruleset/1.0.1"
  tags = {
    Service = "MuleSoft"
    Tool    = "Anypoint-CLI"
  }
}

resource "aws_ssm_parameter" "anypoint_ruleset_validation" {
  name        = "/mulesoft/anypoint-cli/api-governance-rulesets/mule-rulesets"
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
