# O3b AWS Branch Foundation Narrative

## Objective

O3b prepares an AWS branch/customer environment for later Cisco Catalyst 8000V and segmented BGP validation.

This foundation step deploys the AWS network and test VM baseline only. Cisco remains disabled.

## Terraform Ownership

```text
terraform/aws-branch/dev
  -> AWS branch/customer deployment root
  -> backend: AWS S3
  -> state key: aws-branch/dev/terraform.tfstate

terraform/modules/aws-branch
  -> reusable AWS branch module
```

This keeps the customer/branch AWS environment separate from the Azure platform state boundaries.

## Current Lab Deployment

```text
Current lab mode

Admin laptop
  |
  | temporary SSH from approved source CIDR only
  v
AWS Branch VPC: 172.16.0.0/16
  |
  +-- Mgmt subnet:       172.16.0.0/24
  |
  +-- Trusted subnet:    172.16.1.0/24
  |     +-- ec2-dev-aws-trusted-01
  |
  +-- DMZ subnet:        172.16.2.0/24
  |     +-- ec2-dev-aws-dmz-01
  |
  +-- Untrusted subnet:  172.16.254.0/24
  |
  +-- Cisco 8000V: disabled
```

## GitHub Actions Execution Model

```text
GitHub Environment: release-2
  |
  +-- AWS_ROLE_ARN
  +-- AWS_REGION
  |
  v
GitHub Actions OIDC
  |
  v
AWS IAM Role:
role-github-oidc-azawslab-o3b-terraform
  |
  v
terraform/aws-branch/dev
  |
  +-- backend: S3 bucket s3-dev-azawslab-tfstate-euwest1
  +-- state key: aws-branch/dev/terraform.tfstate
  +-- var file: o3b-dev.tfvars
  |
  v
AWS Branch Foundation
```

## Enterprise Target Access Model

```text
Enterprise target mode

Admin / Operations
  |
  +-- VPN / ZTNA / Bastion / SSM Session Manager
  |
  v
AWS Branch VPC
  |
  +-- Cisco 8000V branch edge
  |     |
  |     +-- Trusted subnet: private instances
  |     +-- DMZ subnet: controlled exposure only
  |
  +-- NAT Gateway or firewall path for outbound updates
```

## Enterprise vs Lab

Enterprise target:

- No direct public SSH to trusted or DMZ workloads.
- Admin access should use VPN, ZTNA, Bastion, or SSM Session Manager.
- Private instances should use NAT Gateway, firewall, or controlled egress path for updates.
- Cisco 8000V will become the branch edge during later O3b/Cisco validation.

Lab implementation:

- Temporary public IPv4 SSH was used only for rapid validation.
- SSH source CIDR is not committed to the repository.
- Cisco 8000V remains disabled.
- The two small AWS test VMs remain running to support the next phase.

## Validation Summary

Validated:

- GitHub Actions AWS OIDC role assumption.
- S3 backend for AWS branch Terraform state.
- AWS VPC and subnet deployment.
- Route table and internet gateway deployment.
- Trusted and DMZ EC2 test VM deployment.
- SSH access to both VMs.
- Amazon Linux 2023 OS confirmation.
- Internet egress from both VMs.
- Cisco-disabled Terraform state.
