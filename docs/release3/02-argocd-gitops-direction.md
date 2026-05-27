# 02. Argo CD & GitOps Direction

> **Part of** [Release 3 — Multi-Cloud Kubernetes, GitOps & DevSecOps](./README.md)
>
> **Status:** Roadmap / platform evolution

## Purpose

Define the GitOps delivery model that will manage cluster configurations, application deployments, and policy objects across the AKS/EKS fleet.

## Direction Overview

- **Central GitOps controller:** Argo CD will be deployed as the single source of truth for desired cluster state. All cluster and application manifests will be stored in Git repositories under the platform's GitHub organisation.
- **Multi-cluster management:** Argo CD will manage multiple clusters (AKS and EKS) from a single control plane, with per-cluster configuration overlays.
- **Automated sync and drift detection:** Argo CD will continuously reconcile desired state with live state, alerting on drift. Auto-sync will be enabled for pre-approved namespaces; manual sync gating for production workloads.
- **Secrets handling:** Secrets will not be stored in plain-text Git. Integration with Azure Key Vault and AWS Secrets Manager (via External Secrets Operator or similar) will be planned.
- **Promotion model:** Changes will flow through a Git branching strategy (feature -> staging -> production), with Argo CD syncing each environment from its respective branch.

## Relationship to Release 2

- The GitHub Actions OIDC pipeline already proves secretless delivery.
- The controlled-apply discipline (plan, review, approve, apply) will be extended to GitOps sync gating.
- The existing branch protection and PR review workflows will be reused.

*Diagram placeholder — Argo CD multi-cluster architecture with Git repos, sync policies, and promotion flow.*