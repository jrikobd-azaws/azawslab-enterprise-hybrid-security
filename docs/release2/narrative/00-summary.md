# 00-summary

## 1. Release Overview

Release 2 is the Azure platform engineering and security layer of the Azawslab Enterprise Hybrid Security portfolio.

It demonstrates:
- secretless automation with GitHub Actions and OIDC
- governance-first Azure landing zone design
- reusable Terraform and Ansible automation
- private-only workload architecture
- monitoring, security, and recovery validation
- advanced hybrid, multi-cloud, Zero Trust, and desktop delivery extension patterns

## 2. Narrative-to-Phase Mapping

| Narrative File | Related Phase(s) | Evidence Folder |
|---|---|---|
| 01-foundation-and-landing-zone.md | P0, P1 | docs/release2/evidence/P0/ ; docs/release2/evidence/P1/ |
| 02-terraform-and-automation.md | P2a, P2b, P2c | docs/release2/evidence/P2a/ ; docs/release2/evidence/P2b/ ; docs/release2/evidence/P2c/ |
| 03-governance-rbac-keyvault.md | P3 | docs/release2/evidence/P3/ |
| 04-lighthouse.md | P4 | docs/release2/evidence/P4/ |
| 05-hub-spoke-networking.md | P5 | docs/release2/evidence/P5/ |
| 06-azure-firewall.md | P6 | docs/release2/evidence/P6/ |
| 07-defender-for-cloud.md | P7 | docs/release2/evidence/P7/ |
| 08-sentinel.md | P8 | docs/release2/evidence/P8/ |
| 09-monitoring-backup-and-validation.md | P9a, P9b, P9c | docs/release2/evidence/P9a/ ; docs/release2/evidence/P9b/ ; docs/release2/evidence/P9c/ |
| 10-advanced-traffic-inspection-architecture.md | O1 | docs/release2/evidence/O1/ |
| 11-hybrid-management-extension.md | O2 | docs/release2/evidence/O2/ |
| 12-hybrid-and-multi-cloud-routing.md | O3a, O3b, O3c | docs/release2/evidence/O3a/ ; docs/release2/evidence/O3b/ ; docs/release2/evidence/O3c/ |
| 13-zero-trust-access-modernization.md | O4 | docs/release2/evidence/O4/ |
| 14-enterprise-desktop-and-application-delivery.md | O5 | docs/release2/evidence/O5/ |

## 3. Core Design Themes

- Secretless automation
- Governance first
- Private-only workloads
- CLI-first validation
- Hybrid and multi-cloud depth
- Zero Trust access modernization
- Enterprise-ready operational patterns

## 4. Current Build Status

Current validated implementation status:

| Phase | Status | Notes |
|---|---|---|
| P0 | Complete | OIDC/bootstrap foundation and current Norway East Terraform backend validated |
| P1 | Complete | Management group structure and baseline governance assignments validated |
| P2a | Complete | Reusable Terraform modules, Key Vault secret flow, private-only workload VM, and split-state model validated |
| P2b | Complete for current scope | Azure-connected management host path, private WinRM path, common role execution, and idempotent rerun validated; AD join deferred until HQ AD and hybrid connectivity are ready |
| P2c | Complete | GitHub Actions Terraform CI and controlled Terraform Apply validated with OIDC and split-state roots |
| P3 | Complete | Governance/RBAC review completed; region, mandatory tag, and VM SKU deny behavior validated; resource group tag policy gap diagnosed and corrected |
| P4 | Complete | Azure Lighthouse Reader delegation deployed and validated between `AZAWSLAB / br.azawslab.co.uk` and `entra.azawslab.co.uk` |
| P5+ | Not started | Later phases remain planned or optional depending on Release 2 scope and cost controls |


## 5. Reader Guide

Use the narrative files for the portfolio story.

Use the control docs at docs/release2/ root for:
- source of truth
- execution steps
- implementation tracking
- naming standards
- build discipline

Use docs/release2/evidence/ for CLI-first proof and validation output.


