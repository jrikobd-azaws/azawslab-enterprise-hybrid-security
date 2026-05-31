# Platform Journey and Architecture

This architecture is designed as a staged enterprise journey rather than a single isolated lab.

## Architecture principles

- Identity-first access control.
- Infrastructure as Code with separated root ownership.
- Controlled delivery through GitHub Actions and OIDC.
- Hybrid and multi-cloud connectivity with explicit routing and inspection.
- Private platform delivery for AKS and AVD.
- Evidence-backed documentation instead of unsupported claims.
- Governed AI operations with policy and human approval.

## Journey model

| Release | Architecture role | Status |
|---|---|---|
| Release 1 | Local and Microsoft 365 hybrid foundation | Complete and evidenced |
| Release 2 | Azure platform engineering and secure operations | Implemented and evidenced |
| Release 3 | Kubernetes, GitOps, and DevSecOps evolution | Roadmap |

!!! tip "How to review"
    Hiring managers should read this page with the portfolio case study. Technical reviewers should pair it with the Terraform state map and proof gallery.

## Main architecture references

- [Repository README](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/README.md)
- [Architecture document](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/ARCHITECTURE.md)
- [Portfolio case study](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/PORTFOLIO.md)
- [Design decisions](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/DESIGN_DECISIONS.md)

## Key diagrams

- [Platform hero diagram](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/diagrams/platform/hero-diagram.png)
- [Release 2 AI operations enclave](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/diagrams/release2/ai-operations-enclave.png)
- [Release 3 roadmap target state](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/diagrams/release3/release3-target-roadmap.png)