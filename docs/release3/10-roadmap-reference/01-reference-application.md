# 01. AKS & EKS Platform Direction

> **Part of** [Release 3 â€” Multi-Cloud Kubernetes, GitOps & DevSecOps](./README.md)
>
> **Status:** Roadmap / platform evolution

## Purpose

Define the target design for a multi-cloud Kubernetes fleet (AKS on Azure, EKS on AWS) that extends the private networking and governance patterns from Release 2.

## Direction Overview

- **Private cluster posture:** Both AKS and EKS clusters will follow the Release 2 private API model - no public endpoints, all control plane access through private networking.
- **Networking integration:** AKS clusters will be deployed into the existing hub-spoke VNet, with pod egress through Azure Firewall. EKS clusters will connect via the existing AWS Transit Gateway and BGP-routed paths validated in O3b/O3c.
- **Node identity and RBAC:** Workload identity will be handled through Azure AD Workload Identity (AKS) and IAM Roles for Service Accounts (EKS), integrated with the existing Entra ID tenant.
- **Baseline add-ons:** Managed Prometheus/Grafana (AKS), Cluster Autoscaler, and Azure Policy for AKS / AWS Config for EKS.
- **Consistency across clouds:** Cluster configurations will be defined in Git and applied through a common toolchain, minimising provider-specific drift.

## Relationship to Release 2

- The hub-spoke network, Azure Firewall, and AWS Transit Gateway are already in place.
- The private endpoint model for container registries (ACR, ECR) is already validated.
- The AWX control plane and Ansible automation can be extended to manage Kubernetes operational tasks.

*Diagram placeholder â€” AKS and EKS clusters, networking integration, and identity flow.*