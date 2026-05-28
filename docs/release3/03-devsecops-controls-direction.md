# 03. DevSecOps Controls Direction

> **Part of** [Release 3 - Multi-Cloud Kubernetes, GitOps & DevSecOps](./README.md)
>
> **Status:** Roadmap / platform evolution

## Purpose

Define the DevSecOps quality gates and policy enforcement that will sit between code commit and production deployment for all Release 3 workloads.

## Direction Overview

- **CI/CD quality gates:** Unit testing, Static Application Security Testing (SAST), and Dynamic Application Security Testing (DAST) will be integrated into the GitHub Actions pipeline before any container image is built or promoted.
- **Image scanning:** Trivy (or equivalent) will scan all container images for vulnerabilities. Critical findings will block promotion.
- **Image signing and promotion gates:** Images passing scans will be signed (Cosign/Notation). Only signed images will be admitted to production clusters via OPA/Gatekeeper policies.
- **Policy-as-code:** OPA/Gatekeeper will enforce cluster-level policies: allowed registries, required labels, resource limits, and disallowed privileged containers. Policies will be version-controlled in Git alongside application code.
- **Admission control:** Mutating and validating webhooks will enforce security context constraints and inject required sidecars (e.g., Istio proxy) at admission time.
- **SBOM and vulnerability tracking:** Software Bill of Materials generation and continuous vulnerability tracking will be planned for the production promotion path.

## Relationship to Release 2

- The policy-as-code pattern (Azure Policy deny rules) is already proven.
- The controlled-apply model in CI/CD will be extended with new quality gates.
- The Defender for Cloud / Sentinel baseline provides CSPM and SIEM context for workload security.

![Release 3 multi-cloud Kubernetes GitOps and DevSecOps roadmap](../../diagrams/release3/release3-target-roadmap.png)