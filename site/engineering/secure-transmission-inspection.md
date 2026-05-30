# Secure Transmission, Inspection and Private Routing

## What this proves

This page maps secure traffic paths across the platform: private routing, firewall inspection, egress control, transit design and separation of durable architecture from validation resources.

## Why it matters

Enterprise platforms must prove not only that workloads run, but that traffic paths are controlled, inspected and aligned with zero-trust operating principles.

## Source implementation

| Area | Source |
|---|---|
| Platform networking root | [terraform/platform-networking/dev](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-networking/dev) |
| Private AKS root | [terraform/platform-aks/dev](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-aks/dev) |
| AVD root | [terraform/platform-avd/dev](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-avd/dev) |
| Networking narrative | [docs/release2/02-hybrid-multicloud-network-security.md](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/02-hybrid-multicloud-network-security.md) |
| Private platform narrative | [docs/release2/04-private-platform-secure-workspace.md](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/04-private-platform-secure-workspace.md) |

## Evidence and validation

| Evidence | Purpose |
|---|---|
| [Release 2 evidence index](../evidence/release2-evidence-index.md) | Capability-mapped evidence |
| [O4 evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4) | Private platform validation |
| [O5 evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O5) | Secure workspace validation |

## Reviewer signal

This page is for reviewers focused on secure transmission, private access, inspected paths, egress control, firewalls, UDRs, private DNS and zero-trust platform traffic design.