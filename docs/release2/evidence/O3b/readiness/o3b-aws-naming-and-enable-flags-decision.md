# O3b AWS Naming and Enable Flags Decision

## Decision

O3b AWS Branch will use canonical AWS resource names and explicit enable flags before Terraform implementation.

## Terraform Root

- Root: terraform/aws-branch/dev
- State key: aws-branch-dev.tfstate
- Reusable module: terraform/modules/aws-branch

## Enable Flags

Defaults:

```hcl
enable_o3b_aws_branch   = false
enable_o3b_aws_test_vms = false
enable_o3b_aws_cisco    = false
```

Cheaper AWS preparation mode:

```hcl
enable_o3b_aws_branch   = true
enable_o3b_aws_test_vms = true
enable_o3b_aws_cisco    = false
```

Full O3b validation mode:

```hcl
enable_o3b_aws_branch   = true
enable_o3b_aws_test_vms = true
enable_o3b_aws_cisco    = true
```

## Naming

The canonical AWS branch names are recorded in naming-conventions.md under "O3b AWS Branch Resource Naming".

## Cost Control

Cisco 8000V is separated behind `enable_o3b_aws_cisco` so AWS VPC and test VM preparation can proceed without deploying the Cisco NVA.

## Source-of-Truth Alignment

This decision aligns with the O3b requirement for AWS Cisco Branch with segmented BGP while preserving enterprise state separation through a dedicated AWS branch Terraform root.
