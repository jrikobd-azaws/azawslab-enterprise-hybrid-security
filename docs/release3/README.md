# Release 3 — Multi-Cloud Kubernetes, GitOps & DevSecOps

> **Part of the [Azawslab Enterprise Hybrid Security Platform](../../README.md)**
>
> **Status:** Roadmap / platform evolution

## Overview

Release 3 extends the platform into workload delivery governance. Building directly on the governance, networking, automation, and private platform patterns proven in Release 2, it targets a multi-cloud Kubernetes fleet (AKS, EKS) managed through GitOps, with integrated DevSecOps controls, image assurance, policy-as-code admission, protected ingress, service-mesh encryption, deep observability, and resilience validation.

This release is a defined evolution path, not an active implementation. The architecture and toolchain choices are described with the same rigour as the implemented releases, but all capability descriptions are forward-looking.

## Release 3 Roadmap Documents

| Document | Focus |
|---|---|
| [00. Roadmap](./00-roadmap.md) | Release 3 scope, sequencing, and evidence strategy |
| [01. AKS & EKS Platform Direction](./01-aks-eks-platform-direction.md) | Multi-cloud Kubernetes fleet design |
| [02. Argo CD & GitOps Direction](./02-argocd-gitops-direction.md) | GitOps delivery model and reconciliation |
| [03. DevSecOps Controls Direction](./03-devsecops-controls-direction.md) | CI/CD quality gates, image scanning, policy enforcement |
| [04. Observability & Resilience Direction](./04-observability-resilience-direction.md) | Metrics, logging, tracing, chaos testing, and DR alignment |

## Principles

- **Roadmap, not implementation** - nothing in Release 3 is presented as built unless explicitly migrated from Release 2 evidence.
- **Architectural continuity** - every component extends a pattern already validated in Release 2.
- **Evidence placeholder discipline** - diagrams and proof links use the standard placeholder convention until real artifacts exist.