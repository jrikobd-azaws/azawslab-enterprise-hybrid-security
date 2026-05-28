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
- Cisco 8000V will become the branch edge during later O3b/Cisco validation, with selective BGP advertisement used to prove trusted-vs-DMZ route-control behavior.

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

---

## O3b Next Architecture Direction - Cisco to Azure VPN Gateway

The current AWS branch foundation remains valid: AWS VPC, subnets, test instances, GitHub OIDC, and S3-backed Terraform state are already established. Cisco 8000V was intentionally disabled during the foundation step.

The next O3b implementation target is to introduce Cisco Catalyst 8000V as the AWS branch edge router and connect it to Azure VPN Gateway using IPSec/BGP.

```text
[AWS Branch VPC]
  172.16.0.0/16
      |
      v
[Cisco Catalyst 8000V]
  ASN: 65002
      |
      | IPSec/BGP
      v
[Azure VPN Gateway]
  ASN: 65515
      |
      +-- existing IPSec path to VyOS / HQ
      +-- route propagation to Azure hub/spoke paths
```

FortiGate is not the AWS IPSec/BGP peer. FortiGate remains the Azure-side inspection and service-chaining plane. Any AWS-to-Azure or AWS-to-HQ inspection claim must be proven later with FortiGate policy counters or logs.

### Marketplace Readiness

Cisco Catalyst 8000V Marketplace BYOL subscription has been confirmed before Terraform enablement.

Recorded Marketplace details:
- Product: Cisco Catalyst 8000V for SD-WAN & Routing Deployed on AWS
- Product ID: `42cb6e93-8d9d-490b-a73c-e3e56077ffd1`
- Offer ID: `3ycwqehancx46bkpb3xkifiz5`
- Agreement ID: `agmt-19mxi27m9lp1apyzpi0ylhyqq`
- Pricing model: Bring your own license (BYOL)
- Service start: May 10, 2026 22:33 UTC

### O3b Implementation Boundary

O3b should validate:
- Cisco 8000V deployment through Terraform.
- AWS route tables steering selected branch subnet traffic to Cisco ENI.
- Cisco-to-Azure VPN Gateway IPSec tunnel.
- Cisco-to-Azure VPN Gateway BGP session.
- Azure learns AWS branch prefixes.
- Cisco learns intended Azure/HQ prefixes.

O3b should not claim:
- full Azure/HQ/AWS transitive routing before O3c
- FortiGate inspection for AWS flows without FortiGate counters or logs
- Cisco configuration success without management and routing validation


---

## O3b Selective BGP Validation Requirement

O3b must prove segmented BGP behavior, not just basic route propagation.

The AWS branch currently has separate trusted and DMZ subnets:

```text
AWS Branch VPC: 172.16.0.0/16

Trusted subnet:
  172.16.1.0/24
  ec2-dev-aws-trusted-01

DMZ subnet:
  172.16.2.0/24
  ec2-dev-aws-dmz-01
```

The intended O3b validation is selective route propagation:

```text
Advertised over BGP:
  172.16.1.0/24 trusted subnet

Not advertised over BGP:
  172.16.2.0/24 DMZ subnet
```

This proves that the Cisco 8000V branch edge can advertise approved private branch prefixes while withholding less-trusted segments from hybrid private routing.

Validation intent:

```text
Positive validation:
  Azure/HQ learns or can reach the trusted AWS prefix only where expected.

Negative validation:
  Azure/HQ does not learn or reach the DMZ prefix through private BGP propagation.

AWS routing validation:
  Trusted subnet route table steers selected hybrid prefixes to Cisco.
  DMZ subnet route table does not receive the same private hybrid route by default.
```

Do not advertise the full `172.16.0.0/16` summary during the first O3b segmented validation, because that would hide the intended trusted-vs-DMZ route-control proof.


