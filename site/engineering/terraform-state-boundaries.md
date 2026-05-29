# Terraform State Boundaries

Terraform state is treated as a platform engineering control.

## Why it matters

State separation reduces blast radius, clarifies ownership, and prevents unrelated changes from mutating critical platform components.

## Key boundaries

| Root | Ownership |
|---|---|
| `platform-networking` | Hub/spoke, firewall, FortiGate, VPN, BGP, shared route control |
| `platform-management` | Management VM and AWX/control-plane resources |
| `platform-aks` | Private AKS, ACR integration, workload identity, monitoring, AKS-specific egress |
| `platform-avd` | AVD session hosts, FSLogix, secure workspace resources |
| `aws-branch` | AWS branch and Cisco/AWS-side resources |
| `governance` and `platform-shared` | Policy, monitoring, backup, and shared platform services |

## Source links

- [Terraform state and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md)
- [Terraform roots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform)