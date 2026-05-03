# P2a Terraform State Boundary Refinement

## Purpose
This note records the Terraform state boundary refinement implemented during P2a.

## Outcome
Terraform root/state ownership is now separated across three active roots:

- `terraform/governance`
- `terraform/platform-shared/dev`
- `terraform/workloads/dev`

## Ownership split
- `terraform/governance`
  - management-group policy assignments
- `terraform/platform-shared/dev`
  - shared security resources
  - Key Vault
  - secret flow
- `terraform/workloads/dev`
  - workload networking
  - workload compute

## Validation result
Each active Terraform root:
- initializes successfully
- owns the intended resource slice
- plans cleanly with no unexpected changes

## Operational note
This refinement keeps the reusable module structure unchanged while reducing destroy risk by separating governance, shared security, and workload lifecycles.