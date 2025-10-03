# Create a secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "example_secret" {
  name                    = var.example_name
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

# Create another secret for credentials
resource "aws_secretsmanager_secret" "example_credential" {
  name                    = "${var.example_name}-credential"
  description             = "Example credential secret created by Terraform"
  recovery_window_in_days = var.secret_recovery_window
}

# MuleSoft GIP Secrets - Secret 1
resource "aws_secretsmanager_secret" "mule_gip_secret_1" {
  name                    = "mule/gip/secret-1"
  description             = "MuleSoft GIP Secret 1"
  recovery_window_in_days = var.secret_recovery_window
}

resource "aws_secretsmanager_secret_version" "mule_gip_secret_1_version" {
  secret_id = aws_secretsmanager_secret.mule_gip_secret_1.id
  secret_string = jsonencode({
    user = "mule-gip-user-1"
    pass = "mule-gip-pass-1"
  })
}

# MuleSoft GIP Secrets - Secret 2
resource "aws_secretsmanager_secret" "mule_gip_secret_2" {
  name                    = "mule/gip/secret-2"
  description             = "MuleSoft GIP Secret 2"
  recovery_window_in_days = var.secret_recovery_window
}

resource "aws_secretsmanager_secret_version" "mule_gip_secret_2_version" {
  secret_id = aws_secretsmanager_secret.mule_gip_secret_2.id
  secret_string = jsonencode({
    user = "mule-gip-user-2"
    pass = "mule-gip-pass-2"
  })
}

# MuleSoft GIP Secrets - Secret 3
resource "aws_secretsmanager_secret" "mule_gip_secret_3" {
  name                    = "mule/gip/secret-3"
  description             = "MuleSoft GIP Secret 3"
  recovery_window_in_days = var.secret_recovery_window
}

resource "aws_secretsmanager_secret_version" "mule_gip_secret_3_version" {
  secret_id = aws_secretsmanager_secret.mule_gip_secret_3.id
  secret_string = jsonencode({
    user = "mule-gip-user-3"
    pass = "mule-gip-pass-3"
  })
}

# MuleSoft GIP Secrets - Secret 4
resource "aws_secretsmanager_secret" "mule_gip_secret_4" {
  name                    = "mule/gip/secret-4"
  description             = "MuleSoft GIP Secret 4"
  recovery_window_in_days = var.secret_recovery_window
}

resource "aws_secretsmanager_secret_version" "mule_gip_secret_4_version" {
  secret_id = aws_secretsmanager_secret.mule_gip_secret_4.id
  secret_string = jsonencode({
    user = "mule-gip-user-4"
    pass = "mule-gip-pass-4"
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
