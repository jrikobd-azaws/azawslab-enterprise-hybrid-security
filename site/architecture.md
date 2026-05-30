# Architecture Overview

The Azawslab Enterprise Hybrid Security Platform is a staged enterprise platform portfolio. It is designed to show how hybrid identity and workplace operations evolve into governed Azure platform engineering, secure automation, hybrid BGP and multi-cloud transit, private platform delivery and governed AI operations.

## Platform journey

| Stage | Capability |
|---|---|
| Release 1 | Hybrid Modern Workplace, Identity, Endpoint Security and Microsoft 365 Operations |
| Release 2 | Azure Platform Engineering, Security, Automation, Private Platform and AI Operations |
| Release 3 | Multi-Cloud Kubernetes, GitOps and DevSecOps Roadmap |

## Architecture signals

| Signal | Where to review |
|---|---|
| Identity, Conditional Access, Intune, Autopilot, Purview and Microsoft 365 operations | [Release 1](releases/release1.md) |
| Terraform state boundaries and secretless delivery | [Terraform State Boundaries](engineering/terraform-state-boundaries.md), [GitHub Actions OIDC](engineering/github-actions-oidc.md) |
| Ansible and AWX operations | [Automation Control Plane](engineering/automation-control-plane.md) |
| BGP, multi-cloud and hybrid transit | [Hybrid BGP and Multi-Cloud Transit](engineering/hybrid-bgp-multicloud-transit.md) |
| Secure transmission, firewalling, inspection and private routing | [Secure Transmission and Traffic Inspection](engineering/secure-transmission-inspection.md) |
| Private AKS and AVD secure workspace | [Private AKS Platform](engineering/private-aks-platform.md), [AVD Secure Workspace](engineering/avd-secure-workspace.md) |
| Governed AI operations | [Governed AI Operations Enclave](ai-operations/index.md) |
| Claim-to-source verification | [Code Traceability](engineering/code-traceability.md) |

## Reviewer guidance

Use this page to understand the platform story. Use the Engineering Deep Dive section to inspect the major implementation pillars. Use Proof and Evidence to validate claims against public-safe evidence.