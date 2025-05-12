# Terraform Multi-Cloud Demo with HCP Vault

This project demonstrates a multi-cloud infrastructure setup using Terraform, with AWS and GCP resources, and secure secret management using HashiCorp Cloud Platform (HCP) Vault.

## Architecture

- **Infrastructure**: AWS EC2 and GCP Compute Engine instances
- **Secret Management**: HCP Vault for secure credential storage
- **State Management**: Terraform Cloud for remote state and execution
- **Policy Enforcement**: Sentinel policies for cost control
- **Cost Management**: HCP Terraform cost estimation and tracking

## HCP Terraform Integration

HCP Terraform (formerly Terraform Cloud) provides a robust platform for managing infrastructure as code. This project leverages HCP Terraform for:

1. **Remote State Management**
   - Secure storage of Terraform state
   - State locking to prevent concurrent modifications
   - Version history of infrastructure changes

2. **Remote Execution**
   - Consistent execution environment
   - No need for local credentials
   - Automated runs on code changes

3. **Collaboration Features**
   - Team-based access control
   - Run history and audit logs
   - Integration with version control systems

![HCP Terraform Runs](assets/hcp_terraform_runs.png)

The image above shows the HCP Terraform interface displaying run history, plan outputs, and cost estimates for our infrastructure changes.

## Prerequisites

1. **HCP Vault Cluster**
   - A running HCP Vault cluster
   - Vault address and token with appropriate permissions
   - KV secrets engine enabled (version 2)

2. **Terraform Cloud**
   - Organization: `alexcho-demo`
   - Workspace: `terraform_demo_2`
   - Required variables configured
   - Cost estimation enabled

3. **Cloud Provider Access**
   - AWS credentials stored in HCP Vault
   - GCP service account credentials stored in HCP Vault

## Secret Management

### HCP Vault Setup

1. **Enable KV Secrets Engine**
   ```bash
   # In HCP Vault UI:
   # 1. Go to Secrets
   # 2. Enable new engine
   # 3. Select KV
   # 4. Version: 2
   # 5. Path: secret
   ```

2. **Store AWS Credentials**
   ```bash
   # Path: secret/aws
   {
     "access_key": "your-aws-access-key",
     "secret_key": "your-aws-secret-key"
   }
   ```

3. **Store GCP Credentials**
   ```bash
   # Path: secret/gcp
   {
     "credentials": "your-gcp-service-account-json"
   }
   ```

### Required Terraform Cloud Variables

- `vault_addr`: HCP Vault cluster address
- `vault_token`: HCP Vault token (sensitive)
- `gcp_project_id`: GCP project ID
- `aws_instance_type`: AWS instance type (default: t2.micro)
- `gcp_machine_type`: GCP machine type (default: e2-micro)

## Cost Management

HCP Terraform provides built-in cost estimation capabilities that help you understand and manage your infrastructure costs:

### Cost Estimation Features

1. **Pre-apply Cost Estimates**
   - Automatically calculates estimated monthly costs for planned changes
   - Breaks down costs by resource and provider
   - Shows cost impact of infrastructure changes before they're applied

2. **Cost Tracking**
   - Tracks actual costs of deployed resources
   - Compares estimated vs. actual costs
   - Provides cost history and trends

3. **Cost Optimization**
   - Identifies potential cost savings
   - Suggests alternative resource configurations
   - Helps maintain budget compliance

### Example Cost Estimate Output
```
Cost Estimation:

Resources: 2 of 2 estimated
           $80.81/mo +$80.81

AWS:
  aws_instance.demo: $30.40/mo
GCP:
  google_compute_instance.demo: $50.41/mo
```

![Cost Estimation Example](assets/cost_estimation.png)

## Policy Enforcement

The project includes Sentinel policies to enforce:
- Cost control by restricting high-cost instance types
- Security best practices
- Resource naming conventions

## Usage

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Plan Changes**
   ```bash
   terraform plan
   ```

3. **Apply Changes**
   ```bash
   terraform apply
   ```

## Security Notes

- All sensitive credentials are stored in HCP Vault
- Terraform Cloud variables are marked as sensitive where appropriate
- Access to HCP Vault is controlled via tokens and policies
- Regular rotation of credentials is recommended

## Cost Control

The project includes Sentinel policies that prevent the use of high-cost instance types:
- AWS: Blocks instance types like m5.24xlarge, c5.24xlarge, etc.
- GCP: Blocks machine types like n1-ultramem-160, n2-ultramem-160, etc.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.