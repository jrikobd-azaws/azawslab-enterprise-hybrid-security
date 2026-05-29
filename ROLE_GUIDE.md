# Role Guide - Reading Paths by Job Role

This guide recommends a reading order tailored to common technical roles. It helps a reviewer quickly find the parts of the portfolio that are most relevant to their evaluation.

## Senior Cloud Platform Engineer

1. `README.md` - platform snapshot
2. `ARCHITECTURE.md` - landing zone, networking, automation, and private platform architecture
3. `docs/release2/01-landing-zone-iac-governance.md` - Terraform, OIDC, Azure Policy, RBAC
4. `docs/release2/04-private-platform-secure-workspace.md` - Private AKS and AVD secure workspace
5. `docs/release2/11-terraform-state-and-pipeline-map.md` - state boundaries and CI/CD delivery model
6. Evidence: `docs/release2/evidence/P0/` through `P4/`, `O4/`, `O5/`

## Hybrid Cloud / Infrastructure Engineer

1. `docs/release2/02-hybrid-multicloud-network-security.md` - FortiGate, VyOS, Cisco, IPSec, BGP, routing
2. `ARCHITECTURE.md` - network, identity, and trust-boundary architecture
3. `docs/release2/03-automation-secops-resilience.md` - Ansible and AWX operational validation
4. Evidence: `docs/release2/evidence/P5/`, `P6/`, `P5-vpn/`, `O1/`, `O3b/`, `O3c/`

## Cloud Security Architect

1. `ARCHITECTURE.md` - trust boundaries, security controls, and platform segmentation
2. `docs/release2/01-landing-zone-iac-governance.md` - policy, RBAC, OIDC, and governance foundation
3. `docs/release2/03-automation-secops-resilience.md` - Defender, Sentinel, Key Vault, AWX, backup controls
4. `docs/release2/05-ai-operations-enclave.md` - AI governance, MCP gateway, deny-by-default tool access
5. Evidence: `screenshots/release1/identity-and-access/`, `docs/release2/evidence/P3/`, `P6/`, `P7/`, `P8/`, `O6/`

## Modern Workplace / Endpoint Engineer

1. `docs/release1/README.md` - Release 1 overview
2. `screenshots/release1/` - Intune, Autopilot, Purview, Exchange hybrid, monitoring evidence
3. `docs/release1/09-compliance-mapping.md` - security and compliance alignment
4. `docs/release2/04-private-platform-secure-workspace.md` - AVD + FSLogix secure workspace
5. Evidence: `screenshots/release1/`

## DevOps / SRE

1. `docs/release2/03-automation-secops-resilience.md` - AWX, monitoring, backup, runtime secrets
2. `docs/release2/11-terraform-state-and-pipeline-map.md` - Terraform state and pipeline model
3. `docs/release2/04-private-platform-secure-workspace.md` - AKS, monitoring, AVD operations workspace
4. Evidence: `docs/release2/evidence/A2-awx-control-plane/`, `P9a/`, `P9b/`, `P9b-redesign/`

## AI Operations / Security Reviewer

1. `docs/release2/05-ai-operations-enclave.md` - full O6 story
2. `docs/release2/06-skills-and-evidence-index.md` - evidence map
3. `kubernetes/` - O6 supporting manifests and live-validation scaffolding
4. Evidence: `docs/release2/evidence/O6/`

All paths assume the reader starts from the repository root.
