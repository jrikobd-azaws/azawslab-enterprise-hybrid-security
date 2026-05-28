# 00. Release 3 Roadmap

> **Part of** [Release 3 Ã¢â‚¬â€ Multi-Cloud Kubernetes, GitOps & DevSecOps](./README.md)
>
> **Status:** Roadmap / platform evolution

## Scope

Release 3 takes the governed, private, automated platform from Release 2 and adds:

- A multi-cloud Kubernetes control plane (AKS and EKS)
- GitOps delivery via Argo CD
- DevSecOps quality gates in CI/CD
- Image scanning, signing, and admission control
- Policy-as-code at the workload and cluster level
- Protected ingress with WAF and mTLS
- Service-mesh encryption (Istio)
- Deep observability (Prometheus, Grafana, Loki, OpenTelemetry)
- Resilience validation (chaos engineering, multi-zone, PDBs)

## Sequencing

Release 3 is designed to be built on top of the Release 2 platform without disrupting existing evidence. The planned rough order:

1. Establish AKS and EKS baseline clusters, integrated with the existing hub-spoke network and Azure Firewall.
2. Deploy Argo CD and connect it to the platform's Git repositories.
3. Implement CI/CD quality gates (unit, SAST, DAST) and image scanning (Trivy).
4. Enforce admission control with OPA/Gatekeeper and signed image promotion.
5. Deploy Istio for mTLS and ingress protection.
6. Build the observability stack and validate resilience scenarios.

## Evidence Strategy

All Release 3 evidence will use the same CLI-first, redacted, phase-folder model as Release 2. Placeholder paths are marked `proof link to be inserted` until implementation begins.

- `docs/release3/evidence/` will mirror the Release 2 evidence structure.
- Diagram placeholders follow the standard portfolio convention.

> Current visual reference: [Release 3 roadmap target state](../../../diagrams/release3/release3-target-roadmap.png).