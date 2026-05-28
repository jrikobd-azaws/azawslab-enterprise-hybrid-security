# Terraform

This folder contains the Terraform roots and reusable modules for the Azawslab Enterprise Hybrid Security Platform.

Terraform is used primarily for Release 2 platform engineering: landing zone governance, shared services, networking, private AKS, AVD, platform management, workload resources, and AWS branch integration.

## Terraform Roots

| Path | Purpose |
|---|---|
| `governance/` | Management groups, Azure Policy assignments, and RBAC foundations |
| `platform-shared/dev/` | Shared platform services such as Key Vault, shared identities, and common platform outputs |
| `platform-networking/dev/` | Hub-spoke networking, Azure Firewall, VPN Gateway, FortiGate integration, routing, and hybrid connectivity |
| `platform-aks/dev/` | Private AKS platform, ACR integration, managed monitoring, and workload identity foundations |
| `platform-avd/dev/` | Azure Virtual Desktop secure workspace, FSLogix storage, private endpoints, and session-host configuration |
| `platform-management/dev/` | Platform management tooling, management VM/Bastion patterns, and AWX-related infrastructure dependencies |
| `workloads/dev/` | Workload-level resources and application-layer infrastructure |
| `aws-branch/dev/` | AWS branch foundation, Transit Gateway, Cisco CSR, BGP, and route-map integration |
| `modules/` | Reusable Terraform modules shared across roots |
| `environments/dev-retired-after-state-split/` | Retired state-split reference material retained for traceability |

## Delivery Model

GitHub Actions controlled apply is the default execution model. Local `terraform apply` is exceptional and must be documented when used.

State files are never committed to this repository. Remote state is stored in Azure Storage and protected through state locking.

## Active Profile Guardrails

Some roots include optional or cost-sensitive resources. Use the profile-aware wrapper scripts documented in the Release 2 phase reference before planning active hybrid roots.

- State and pipeline map: [`docs/release2/11-terraform-state-and-pipeline-map.md`](../docs/release2/11-terraform-state-and-pipeline-map.md)
- Active-profile rules: [`docs/release2/10-phase-reference/terraform-active-profile-guardrails.md`](../docs/release2/10-phase-reference/terraform-active-profile-guardrails.md)

## Safety Notes

- Do not commit `.tfstate`, `.tfplan`, private keys, kubeconfigs, or generated credentials.
- Do not run local apply against active platform roots unless explicitly approved.
- Review plan output for destroy/replacement operations before any apply.
- Use branch review and GitHub Actions for normal infrastructure changes.
