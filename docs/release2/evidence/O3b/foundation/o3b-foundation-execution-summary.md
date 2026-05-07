# O3b AWS Branch Foundation - Execution Summary

## Scope

This evidence records the successful O3b AWS branch foundation deployment.

This is not the full Cisco/BGP phase. Cisco Catalyst 8000V remains disabled.

## Deployment Result

Terraform apply completed successfully through GitHub Actions.

Result:

```text
Resources: 17 added, 0 changed, 0 destroyed
aws_branch_enabled   = true
aws_test_vms_enabled = true
aws_cisco_enabled    = false
```

Deployed foundation:

```text
AWS Branch VPC: 172.16.0.0/16
  |
  +-- Mgmt subnet:       172.16.0.0/24
  +-- Trusted subnet:    172.16.1.0/24
  +-- DMZ subnet:        172.16.2.0/24
  +-- Untrusted subnet:  172.16.254.0/24
  |
  +-- Trusted test VM: ec2-dev-aws-trusted-01
  +-- DMZ test VM:     ec2-dev-aws-dmz-01
  +-- Cisco 8000V:     disabled
```

## GitHub and AWS Execution Model

```text
GitHub Actions
  |
  +-- Environment: release-2
  |     +-- AWS_ROLE_ARN
  |     +-- AWS_REGION
  |
  +-- OIDC to AWS IAM role
  |
  v
terraform/aws-branch/dev
  |
  +-- backend: AWS S3
  |     bucket: s3-dev-azawslab-tfstate-euwest1
  |     key: aws-branch/dev/terraform.tfstate
  |
  +-- var file:
        o3b-dev.tfvars
```

## Validation Captured

Evidence files in this folder capture:

- Terraform outputs
- Terraform state list
- AWS caller identity
- VPC status
- subnet status
- route table status
- EC2 instance status
- security group status
- Cisco-disabled validation
- SSH, OS, route, DNS, HTTPS egress, and DNF repository reachability from both test VMs

## SSH Source Redaction

The temporary home public IP used for validation has been redacted from committed evidence.

The committed `o3b-dev.tfvars` file uses a documentation-safe placeholder CIDR. Runtime SSH source CIDR is supplied manually when the GitHub apply workflow is run.

## Current Lab Position

The AWS test VMs are intentionally kept running for the next implementation phase.

## Enterprise Delta

The current lab uses temporary direct SSH to public IPv4 addresses for short validation.

The enterprise target design removes direct public SSH and uses approved access paths such as VPN, ZTNA, Bastion, or SSM Session Manager.
