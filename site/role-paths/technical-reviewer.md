# Technical Reviewer Path

## What to inspect first

Technical reviewers should start with implementation boundaries and evidence.

| Area | What to inspect |
|---|---|
| Terraform roots | `terraform/` and Release 2 state map |
| GitHub Actions | OIDC and root-specific workflows |
| Networking | Platform networking root and Release 2 evidence |
| AWX | A2 automation/control-plane evidence |
| Private AKS | O4 evidence and Kubernetes manifests |
| AVD | O5 evidence and platform AVD root |
| O6 | AI operations evidence and Kubernetes support manifests |

## Source links

- [Terraform README](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/terraform/README.md)
- [Terraform state and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md)
- [GitHub workflows](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/.github/workflows)
- [Release 2 evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence)