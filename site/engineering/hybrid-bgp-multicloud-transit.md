# Hybrid BGP and Multi-Cloud Transit

## What this proves

This page demonstrates hybrid and multi-cloud connectivity patterns using Azure, AWS branch integration, FortiGate, VyOS/Cisco routing components and BGP-based transit validation.

## Why it matters

BGP, VPN, transit routing and multi-cloud connectivity are common senior cloud, network and platform engineering requirements. This capability shows routing depth beyond basic VNet deployment.

## Source implementation

| Area | Source |
|---|---|
| Azure platform networking root | [terraform/platform-networking/dev](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-networking/dev) |
| AWS branch root | [terraform/aws-branch/dev](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/aws-branch/dev) |
| Networking release narrative | [docs/release2/02-hybrid-multicloud-network-security.md](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/02-hybrid-multicloud-network-security.md) |
| Terraform modules | [terraform/modules](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/modules) |

## Evidence and validation

| Evidence | Purpose |
|---|---|
| [O3b evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O3b) | AWS branch and multi-cloud validation |
| [O3c evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O3c) | Hybrid routing and branch integration validation |
| [Release 2 evidence index](../evidence/release2-evidence-index.md) | Capability-mapped evidence entry point |

## Reviewer signal

This capability is a high-value differentiator for roles requiring hybrid connectivity, branch routing, BGP, VPN, firewall/NVA integration and multi-cloud architecture.