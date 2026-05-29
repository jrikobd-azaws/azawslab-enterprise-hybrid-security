# O3b AWS Branch State Boundary Decision

## Decision

O3b AWS Branch will use a dedicated Terraform root and state file:

terraform/aws-branch/dev
  -> aws-branch-dev.tfstate

This root will own AWS branch/customer resources for the optional O3b phase.

## Rationale

The AWS branch represents a customer/branch cloud environment managed by the enterprise platform team. It is not part of the Azure landing zone state boundary.

Separating AWS branch state provides:

- cloud/account boundary separation
- clearer customer/branch lifecycle ownership
- reduced blast radius between Azure transit and AWS branch teardown
- separate AWS provider and authentication model
- cleaner cost control for ephemeral AWS resources
- clearer GitHub Actions plan/apply ownership

## Terraform Boundary

Azure transit resources remain in:

terraform/platform-networking/dev
  -> platform-networking-dev.tfstate

AWS branch resources move to the future root:

terraform/aws-branch/dev
  -> aws-branch-dev.tfstate

Reusable AWS code may live under:

terraform/modules/aws-branch/

The module will not run by itself. It must be called from the aws-branch/dev root.

## Source-of-Truth Alignment

Current Release 2 docs already define O3b as:

- AWS Branch with Cisco Catalyst 8000V
- AWS VPC: 172.16.0.0/16
- Trusted segment: 172.16.1.0/24
- DMZ segment: 172.16.2.0/24
- Cisco ASN: 65002
- Azure FortiGate ASN: 65515
- validation of segmented route propagation
- teardown of AWS NVA after validation

This decision formalizes the Terraform state boundary for that design.

## Cost Control

No AWS resources are deployed by this decision.

Future AWS resources must be disabled by default and only enabled during active O3b validation.

## Enterprise vs Lab

Enterprise target:
- separate state per cloud/account/customer boundary
- AWS OIDC role for GitHub Actions
- least-privilege AWS IAM
- budget alarms and teardown controls
- dedicated deployment workflow/matrix entry

Lab implementation:
- same repo
- same existing Azure Storage backend account for Terraform state storage
- new backend key: aws-branch-dev.tfstate
- no AWS resources until O3b is active
