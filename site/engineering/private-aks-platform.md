# Private AKS Platform

## What this proves

This page isolates the private AKS platform story from the AVD workspace story. It focuses on private Kubernetes delivery, ACR integration, identity, monitoring and private access patterns.

## Why it matters

Private AKS is a strong platform engineering signal. It shows that Kubernetes was treated as an enterprise platform component, not a public demo cluster.

## Source implementation

| Area | Source |
|---|---|
| AKS Terraform root | [terraform/platform-aks/dev](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/platform-aks/dev) |
| Private AKS module | [terraform/modules/private-aks-platform](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform/modules/private-aks-platform) |
| Private platform narrative | [docs/release2/04-private-platform-secure-workspace.md](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/04-private-platform-secure-workspace.md) |

## Evidence and validation

| Evidence | Purpose |
|---|---|
| [O4 evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4) | Private AKS and private platform validation |
| [Release 2 evidence index](../evidence/release2-evidence-index.md) | Capability-mapped evidence entry point |

## Reviewer signal

This page should be used by reviewers looking for private Kubernetes, ACR, Workload Identity, private networking, policy-aware platform delivery and controlled access.