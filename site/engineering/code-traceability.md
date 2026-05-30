# Code Traceability

This page maps the portfolio narrative to the implementation source tree. It is designed for technical reviewers who want to verify that architecture, implementation and evidence align.

## Traceability model

| Portfolio claim | Source implementation | Evidence path |
|---|---|---|
| Hybrid Modern Workplace, Identity, Endpoint Security and Microsoft 365 Operations | `docs/release1/`, `scripts/release1/` | `screenshots/release1/` |
| Secretless IaC delivery | `.github/workflows/`, `terraform/` | `docs/release2/evidence/P0/` |
| Terraform state boundary discipline | `terraform/*/dev/`, `docs/release2/11-terraform-state-and-pipeline-map.md` | `docs/release2/evidence/P2a/` |
| Ansible and AWX automation | `ansible/`, `scripts/`, `terraform/platform-management/dev/` | `docs/release2/evidence/A2-awx-control-plane/` |
| Hybrid BGP and multi-cloud transit | `terraform/platform-networking/dev/`, `terraform/aws-branch/dev/` | `docs/release2/evidence/O3b/`, `docs/release2/evidence/O3c/` |
| Secure transmission and private routing | `terraform/platform-networking/dev/`, `terraform/platform-aks/dev/`, `terraform/platform-avd/dev/` | `docs/release2/evidence/O4/`, `docs/release2/evidence/O5/` |
| Private AKS platform | `terraform/platform-aks/dev/`, `terraform/modules/private-aks-platform/` | `docs/release2/evidence/O4/` |
| AVD secure workspace and FSLogix | `terraform/platform-avd/dev/`, `terraform/modules/avd-secure-workspace/` | `docs/release2/evidence/O5/` |
| Governed AI operations | `kubernetes/o6-ai-enclave/`, `kubernetes/o6-ai-enclave-live/` | `docs/release2/evidence/O6/` |

## Full GitHub audit map

[Open CODE_TRACEABILITY.md](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/CODE_TRACEABILITY.md){ .md-button .md-button--primary }