# 03. Automation, SecOps & Resilience

> **Part of** [Release 2 - Azure Platform Engineering, Security, Automation, Private Platform & AI Operations](./README.md)
>
> **Status:** Implemented and evidenced.

---

## What This Solves

Manual operations, hard-coded credentials, and ad-hoc security monitoring create fragility and slow incident response. Without an automation control plane, runtime secrets management, and integrated security operations, a platform cannot prove it is supportable, recoverable, or audit-ready.

This capability story demonstrates how the platform operationalises infrastructure through an AWX automation control plane, enforces runtime secrets retrieval from Azure Key Vault and AWS SSM, activates Microsoft Defender and Sentinel for continuous security posture management, and validates backup protection controls and recovery readiness.

---

## What Was Built

| Layer | Components | Evidence |
|---|---|---|
| **Ansible Network Baseline (A1)** | Read-only validation playbooks for FortiGate, VyOS, Cisco; configuration backups; multi-vendor state scraping | `docs/release2/evidence/A1-ansible-network-baseline/` |
| **AWX Control Plane (A2)** | Kubernetes-hosted AWX, Microsoft Entra ID SSO, RBAC, GitHub project sync, tiered job templates, runtime secrets from Key Vault and AWS SSM | `docs/release2/evidence/A2-awx-control-plane/` |
| **Defender for Cloud** | Defender for Servers Plan 1 activated, secure score, security recommendations | `docs/release2/evidence/P7/` |
| **Microsoft Sentinel** | Log Analytics workspace, analytic rules, incident generation, data connectors | `docs/release2/evidence/P8/` |
| **Azure Monitor Alerts** | Activity log alerts, metric alerts, action groups, alert firing validation (synthetic CPU stress) | `docs/release2/evidence/P9a/` |
| **Backup Protection & Recovery** | Recovery Services Vault with immutability and Multi-User Authorization (Resource Guard); soft-delete validation; redesign stages `stage1-platform-shared`, `stage2-governance`, `stage3-backup-validation` | `docs/release2/evidence/P9b/`, `P9b-redesign/` |

---

## Architecture

```text
┌-----------------------------------------------------┐
|           AWX Automation Control Plane               |
|                                                     |
|  ┌--------------┐ ┌--------------┐ ┌-------------┐  |
|  | Job Templates| |  Inventories | | RBAC / Teams |  |
|  `------┬-------┘ `------┬-------┘ `------┬------┘  |
|         |                |               |         |
|         `----------------┼---------------┘         |
|                          |                         |
|              ┌-----------▼-----------┐             |
|              |  GitHub Project Sync  |             |
|              `-----------------------┘             |
|              ┌-----------------------┐             |
|              | Runtime Secrets       |             |
|              | Azure Key Vault /     |             |
|              | AWS SSM               |             |
|              `-----------------------┘             |
`----------------------┬------------------------------┘
                       |
        ┌--------------┼--------------┐
        ▼              ▼              ▼
┌--------------┐ ┌--------------┐ ┌------------------┐
| Network      | | Configuration| | Operational      |
| Validation   | | Backup       | | Runbooks         |
| (A1 read-only| | Evidence     | | (controlled      |
|  playbooks)  | |              | |  remediation)    |
`--------------┘ `--------------┘ `------------------┘

┌-----------------------------------------------------┐
|        Continuous Security & Resilience              |
|                                                     |
|  ┌-----------------┐ ┌-------------┐ ┌-----------┐  |
|  | Defender for    | | Sentinel    | | Azure     |  |
|  | Cloud (CSPM)    | | (SIEM)      | | Monitor   |  |
|  `-----------------┘ `-------------┘ `-----------┘  |
|  ┌-------------------------------------------------┐ |
|  | Recovery Services Vault (immutability, MUA)     | |
|  `-------------------------------------------------┘ |
`-----------------------------------------------------┘
```

![Release 2 automation SecOps and resilience](../../diagrams/release2/automation-secops-resilience.png)

---

## How It Works

### 1. From Ansible Baseline to Governed Control Plane

**A1** proves the Ansible read-only validation model: playbooks extract routing tables, firewall policies, and interface states from FortiGate, VyOS, and Cisco devices without making configuration changes. Outputs are stored as version-controlled evidence under `docs/release2/evidence/A1-ansible-network-baseline/`, including validation outputs and sanitized configuration backup evidence.

**A2** converts that automation foundation into a governed AWX control plane. AWX is deployed on Kubernetes with Microsoft Entra ID SSO integration. RBAC scopes engineer access; GitHub project sync keeps playbooks current; tiered job templates separate read-only validation from controlled remediation. Specific job execution evidence in the A2 evidence folder proves dynamic runtime operation.

### 2. Zero-Hardcoded-Secret Automation

AWX retrieves runtime secrets from Azure Key Vault and AWS Systems Manager Parameter Store. No operational credentials are committed to source control. Service principal credentials and API tokens are parsed into memory at runtime and purged upon playbook completion.

### 3. Continuous Security Posture Management

| Control | Role |
|---|---|
| **Defender for Cloud** | CSPM, inventory, security recommendations, secure score |
| **Microsoft Sentinel** | SIEM analytics, incident generation, investigation surface |
| **Azure Monitor** | Activity log and metric alerts, action groups, notification delivery |

Defender for Servers Plan 1 provides a continuous secure score and configuration recommendations. Sentinel ingests logs via data connectors, runs analytic rules, and generates incidents. Azure Monitor alert rules fire on activity log events and metric thresholds; alert firing has been validated through synthetic CPU stress and confirmed via portal and email notification evidence.

### 4. Backup Protection and Recovery Readiness

A Recovery Services Vault protects platform resources with soft-delete and immutability enforced. Multi-User Authorization (Resource Guard) requires separate security principal approval for critical delete operations. The backup architecture evolved through a deliberate redesign (`P9b-redesign/`), tracked across `stage1-platform-shared`, `stage2-governance`, and `stage3-backup-validation`, proving lifecycle-aware resilience engineering.

---

## Evidence

| What | Where | Why It Matters |
|---|---|---|
| AWX control plane deployment, Entra SSO, RBAC, GitHub sync | `docs/release2/evidence/A2-awx-control-plane/` | Proves governed automation platform with identity integration |
| Runtime secrets retrieval from Key Vault / SSM | `docs/release2/evidence/A2-awx-control-plane/` | Proves zero-hardcoded-secret architecture |
| Ansible read-only network validation | `docs/release2/evidence/A1-ansible-network-baseline/` | Proves automated device state audit without configuration drift |
| Defender for Servers activation and secure score | `docs/release2/evidence/P7/` | Proves CSPM baseline established |
| Sentinel deployment and analytic rules | `docs/release2/evidence/P8/` | Proves SIEM capability and incident generation |
| Azure Monitor alert firing validation | `docs/release2/evidence/P9a/` | Proves alerting pipeline operational with synthetic load testing |
| Backup Vault with immutability and MUA | `docs/release2/evidence/P9b/`, `P9b-redesign/` | Proves recoverability with deletion protection and staged architectural refinement |

---

## Operational Notes

- **AWX is the central Ansible automation control plane** for operational runbooks, validation jobs, backups, and controlled remediation. Terraform and GitHub Actions remain the infrastructure-delivery authority.
- **Operational Ansible execution is centralised through AWX** so job history, RBAC, inventories, and evidence remain auditable.
- **Runtime secrets are never stored in code.** Key Vault and AWS SSM are the only sources of operational credentials.
- **A1 playbooks are read-only by design.** They capture state for audit; they do not push configuration.
- **Defender, Sentinel, and Monitor provide continuous security visibility** across posture, SIEM, and alerting.
- **Recovery Services Vault immutability and MUA are enforced.** Critical delete operations require separate security principal approval; the `P9b-redesign/` stages document the architectural evolution of this protection.

---

## What I Learned

- **An automation control plane is a platform service, not a script.** AWX adds RBAC, scheduling, audit trails, and inventory management that turn automation into a governed capability.
- **Runtime secrets retrieval is the foundation of operational trust.** Zero-hardcoded-secret automation means no secret rotation emergencies and no operational keys committed to version control.
- **Defender, Sentinel, and Monitor together form a credible SecOps baseline** without additional tooling cost. CSPM + SIEM + alerting cover both proactive posture and reactive investigation.
- **Backup immutability and MUA close the last mile of resilience.** The P9b redesign proved that real-world backup engineering requires staged iteration across platform, governance, and validation layers.
- **Synthetic alert testing validates monitoring sincerity.** Using a CPU stress script to trigger real alerts ensures notification paths work before they are needed in an incident.

---

## Implementation Positioning

This automation and SecOps capability proves the platform is supportable, monitored, and recoverable. The AWX control plane demonstrates senior-level operational design; the integration of Key Vault and AWS SSM proves secrets management maturity; and the Defender/Sentinel/Monitor stack provides continuous security visibility. The Recovery Services Vault with immutability, MUA, and a documented redesign history closes the resilience loop with production-grade credibility.

Reviewers evaluating this for **DevOps / SRE** and **Cloud Security Architect** roles should focus on:
- The A1 -> A2 progression from read-only automation baseline to governed control plane.
- The zero-hardcoded-secret automation pattern and runtime credential retrieval model.
- The evidence of synthetic alert firing and staged backup redesign, which proves operational readiness beyond deployment.