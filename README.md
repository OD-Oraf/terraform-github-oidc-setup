# AWS Secrets Manager and GitHub Actions OIDC Integration

This Terraform configuration sets up infrastructure for securely accessing AWS Secrets Manager and Parameter Store from GitHub Actions workflows using OpenID Connect (OIDC) authentication.

## Project Structure

The project follows Terraform best practices with a modular file organization:

- `main.tf` - Main entry point and configuration overview
- `providers.tf` - AWS provider configuration
- `variables.tf` - Input variable declarations
- `outputs.tf` - Output value declarations
- `iam.tf` - IAM roles and policies for GitHub OIDC
- `secrets.tf` - AWS Secrets Manager and Parameter Store resources
- `data.tf` - Data sources for AWS region and account ID

## Infrastructure Components

This configuration creates the following AWS resources:

### AWS Secrets Manager
- Creates a secret named `example-secret`
- Stores a JSON object with username and password fields
- Configures a 7-day recovery window

### AWS Systems Manager Parameter Store
- Creates two SSM parameters for MuleSoft Anypoint CLI API-Governance rulesets:
  - `/mulesoft/anypoint-cli/api-governance-rulesets/pearson-rulesets` (StringList)
  - `/mulesoft/anypoint-cli/api-governance-rulesets/mule-rulesets` (StringList)
- All parameters include appropriate tags

### GitHub OIDC Integration
- Sets up an AWS IAM OIDC provider for GitHub Actions
- Creates an IAM role that can be assumed by GitHub Actions workflows
- Configures trust policy limiting access to specific repositories (`repo:OD-Oraf/*`)

### IAM Policies
1. **Secret Access Policy**: Allows the GitHub Actions role to access the example secret
2. **Parameter Store Policy**: Allows the GitHub Actions role to access parameters under:
   - `/example/*` path
   - `/mulesoft/*` path

## Prerequisites

To use this configuration, you'll need:

- AWS CLI configured with appropriate credentials
- Terraform v0.14.9 or newer
- A GitHub repository where you'll run workflows that need access to these secrets

## Usage

### Deployment

1. Clone this repository
2. Initialize Terraform:
   ```
   terraform init
   ```
3. Review the changes that will be made:
   ```
   terraform plan
   ```
4. Apply the configuration:
   ```
   terraform validate
   terraform apply
   ```

### Using with GitHub Actions

To use these resources in a GitHub Actions workflow:

1. Store the IAM role ARN as a GitHub secret named `AWS_ROLE_ARN`
2. Configure your workflow with permissions and AWS credential setup:
   ```yaml
   permissions:
     id-token: write
     contents: read
   
   steps:
     - name: Configure AWS credentials
       uses: aws-actions/configure-aws-credentials@v4
       with:
         role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
         aws-region: us-east-1
   ```
3. Access secrets and parameters using the AWS CLI:
   ```yaml
   - name: Get secret
     run: aws secretsmanager get-secret-value --secret-id example-secret
   
   - name: Get parameter
     run: aws ssm get-parameter --name "/mulesoft/anypoint-cli/api-governance-rulesets/mule-rulesets"
   ```

## Security Considerations

- The OIDC integration provides secure, short-lived credentials without storing AWS access keys
- The IAM role has least-privilege permissions (only accessing specific secrets/parameters)
- Repository constraints in the trust policy limit which repositories can assume the role
- Consider customizing the repository pattern to further restrict access

## Customization

- Change the AWS region in the `variables.tf` file
- Update the secret values in the `secrets.tf` file
- Modify the repository pattern in the `variables.tf` and `iam.tf` files to match your organization
- Add or remove parameters as needed for your specific use case

## Cleanup

To remove all resources created by this configuration:

```
terraform destroy
```

**Note:** This will permanently delete all created resources including secrets and parameters.
