# AWS Branch Terraform Root

This root owns the O3b AWS branch/customer environment.

State:
- aws-branch-dev.tfstate

Backend:
- resource group: rg-dev-terraformstate-norwayeast
- storage account: stdevtfstatene01
- container: tfstate
- key: aws-branch-dev.tfstate

Current scaffold:
- validates AWS provider and backend wiring
- creates no AWS resources while all enable flags are false

Future prep mode:
enable_o3b_aws_branch   = true
enable_o3b_aws_test_vms = true
enable_o3b_aws_cisco    = false

Future full O3b validation mode:
enable_o3b_aws_branch   = true
enable_o3b_aws_test_vms = true
enable_o3b_aws_cisco    = true
