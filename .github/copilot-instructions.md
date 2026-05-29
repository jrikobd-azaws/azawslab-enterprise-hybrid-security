# Copilot Instructions - Azawslab Enterprise Hybrid Security Platform

## 1. Repository purpose

This repository documents and implements a staged enterprise hybrid cloud security platform.

The project demonstrates Microsoft hybrid workplace foundations, Azure platform engineering, secure hybrid and multi-cloud networking, automation, private platform delivery, and governed AI operations patterns.

Treat this as an engineering repository with evidence-backed documentation. Do not weaken implemented status, invent evidence, or introduce unverified claims.

## 2. Source of truth

Read `STATUS.md` first when changing documentation or implementation notes.

If files disagree, use this order:

1. `STATUS.md`
2. Root reader documents:
   - `README.md`
   - `PORTFOLIO.md`
   - `ARCHITECTURE.md`
   - `PROOF_GALLERY.md`
   - `ROLE_GUIDE.md`
   - `SKILLS_MATRIX.md`
   - `EVIDENCE_GUIDE.md`
3. Release documentation under `docs/release1/`, `docs/release2/`, and `docs/release3/`
4. Implementation files under `terraform/`, `ansible/`, `kubernetes/`, `.github/workflows/`, and `scripts/`

## 3. Release boundaries

Release 1:
- Hybrid Modern Workplace, Identity, Endpoint Security, and Microsoft 365 security foundations.
- Status: complete and evidenced.

Release 2:
- Azure platform engineering, landing zone, IaC, governance, secure hybrid/multi-cloud networking, automation, private AKS, AVD/FSLogix, and AI Operations Enclave.
- Status: implemented and evidenced.

Release 3:
- Multi-cloud Kubernetes, GitOps, DevSecOps, and platform evolution.
- Status: roadmap / future platform direction.
- Do not describe Release 3 as implemented evidence.

## 4. Terraform and deployment safety

GitHub Actions controlled deployment is the default delivery model.

Do not recommend routine local `terraform apply`.

Do not run or suggest destructive operations unless explicitly requested and scoped.

Never commit or expose:
- `.terraform/`
- `.tfstate`
- `.tfplan`
- `terraform.tfvars`
- `*.auto.tfvars`
- kubeconfig files
- private keys
- certificates
- raw tokens
- raw secrets
- unredacted logs

State boundaries must remain clean:
- `platform-networking` owns hub/spoke connectivity, firewall, FortiGate, VPN, BGP, and shared route control.
- `platform-management` owns management VM and AWX control-plane resources.
- `platform-aks` owns private AKS, ACR integration, identity, Workload Identity, Key Vault CSI, monitoring, and AKS-specific egress.
- `platform-avd` owns AVD, session hosts, FSLogix, and secure workspace components.
- `aws-branch` owns AWS branch networking and Cisco/AWS branch resources.
- `governance` and `platform-shared` own shared policy, monitoring, backup, and platform services according to their root documentation.

## 5. Evidence integrity

Use only existing evidence paths.

Do not invent screenshots, logs, file names, test results, or validation claims.

If evidence is not confirmed, link to the closest existing evidence folder README or state that evidence requires final curation.

Primary evidence locations:
- Release 1 evidence: `screenshots/release1/`
- Release 2 evidence: `docs/release2/evidence/`
- Release 3: roadmap documents only
- O6 Kubernetes support manifests: `kubernetes/`
- O6 formal evidence: `docs/release2/evidence/O6/`

## 6. Documentation standards

Reader-facing documentation should be clear, factual, and evidence-led.

Use business-impact framing when it is directly supported by the implementation, for example:
- secretless deployment through GitHub Actions OIDC
- reduced public exposure through private platform patterns
- governed AI operations through policy-mediated tool use
- separated platform ownership through Terraform root boundaries
- operational validation through evidence folders

Do not use placeholders such as:
- unresolved proof placeholders
- unresolved diagram placeholders
- generic placeholder links
- generic demo media placeholders

Do not include internal migration notes, assistant-workflow notes, or portfolio-build scaffolding in public-facing documentation.

## 7. AI operations boundary

O6 is a governed AI operations pattern.

It may describe AI-assisted operations, policy mediation, MCP gateway behavior, agent simulation, and human-approved workflows.

Do not describe O6 as unrestricted autonomous infrastructure mutation.

Do not claim that AI agents can directly modify production infrastructure without human approval and policy control.

## 8. Primary reader paths

Use these as the main reader-facing entry points:

- `README.md`
- `PORTFOLIO.md`
- `ARCHITECTURE.md`
- `PROOF_GALLERY.md`
- `ROLE_GUIDE.md`
- `SKILLS_MATRIX.md`
- `EVIDENCE_GUIDE.md`
- `DESIGN_DECISIONS.md`
- `STATUS.md`
- `docs/release2/README.md`
- `docs/release2/06-skills-and-evidence-index.md`
- `docs/release2/11-terraform-state-and-pipeline-map.md`
- `terraform/README.md`
- `scripts/README.md`
- `kubernetes/README.md`
- `collections/README.md`

## 9. Reference and archive paths

These paths may contain implementation history or detailed reference material, but they are not the primary portfolio reading path:

- `docs/release2/10-phase-reference/`
- `docs/release3/10-roadmap-reference/`

Do not surface local temporary folders, migration backups, audit exports, or assistant-workflow scaffolding as public portfolio content.