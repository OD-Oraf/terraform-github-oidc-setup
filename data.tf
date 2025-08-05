# Get current AWS region and account details
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
