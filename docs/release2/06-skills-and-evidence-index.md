# 06. Skills & Evidence Index â€” Release 2

> **Part of** [Release 2 â€” Azure Platform Engineering, Security, Automation, Private Platform & AI Operations](./README.md)
>
> **Purpose:** Fast reviewer index connecting each Release 2 capability to its evidence location, capability document, and target role. Designed so a technical reviewer can verify a claim in under 30 seconds.

---

## Capability-to-Evidence Mapping

| Capability | Story | Key Skills | High-Signal Evidence |
|---|---|---|---|
| **Landing Zone, IaC & Governance** | [01-landing-zone-iac-governance](./01-landing-zone-iac-governance.md) | Terraform, OIDC CI/CD, Azure Policy (`pa-loc-prod-norwayeast`, `pa-vmsku-prod-b2alsv2`), RBAC, split-state management, controlled apply | [`P0`](./evidence/P0/), [`P1`](./evidence/P1/), [`P2a`](./evidence/P2a/), [`P2b`](./evidence/P2b/), [`P3`](./evidence/P3/), [`P4`](./evidence/P4/) |
| **Hybrid & Multi-Cloud Networking** | [02-hybrid-multicloud-network-security](./02-hybrid-multicloud-network-security.md) | Hub-spoke, Azure Firewall, FortiGate NVA, VyOS, Cisco CSR, IPSec/BGP, UDR steering, route filtering, `br1.azawslab.co.uk` namespace | [`P5`](./evidence/P5/), [`P6`](./evidence/P6/), [`P5-vpn`](./evidence/P5-vpn/), [`O1`](./evidence/O1/), [`O3b`](./evidence/O3b/), [`O3c`](./evidence/O3c/), [`A1-ansible-network-baseline`](./evidence/A1-ansible-network-baseline/) |
| **Automation, SecOps & Resilience** | [03-automation-secops-resilience](./03-automation-secops-resilience.md) | AWX control plane (Entra SSO, RBAC, tiered jobs), Ansible read-only validation, runtime secrets (Key Vault/SSM), Defender for Cloud, Sentinel, Azure Monitor alerts, Recovery Vault (immutability, MUA) | [`A2-awx-control-plane`](./evidence/A2-awx-control-plane/), [`A1-ansible-network-baseline`](./evidence/A1-ansible-network-baseline/), [`P7`](./evidence/P7/), [`P8`](./evidence/P8/), [`P9a`](./evidence/P9a/), [`P9b`](./evidence/P9b/), [`P9b-redesign`](./evidence/P9b-redesign/) |
| **Private Platform & Secure Workspace** | [04-private-platform-secure-workspace](./04-private-platform-secure-workspace.md) | Private AKS (private API, Azure CNI, UDR egress, managed Prometheus/Grafana), AVD + FSLogix (private endpoint, no-public-IP, persistent profiles, admin toolchain), Norway East/West governance | [`O4`](./evidence/O4/), [`O5`](./evidence/O5/) |
| **AI Operations Enclave** | [05-ai-operations-enclave](./05-ai-operations-enclave.md) | Governed AI CloudOps: MCP gateway, deny-by-default tool access, local multi-model inference, optional cloud-API integration, human-in-the-loop gating, evidence logging | [`O6`](./evidence/O6/), [`kubernetes`](../../kubernetes/) supporting manifests, [`local-ai-lab-infra`](https://github.com/jrikobd-azaws/local-ai-lab-infra) |

---

## Role-to-Evidence Paths

| Target Role | Primary Capability Docs | Verify Here |
|---|---|---|
| **Senior Cloud Platform Engineer** | [01 Landing Zone](./01-landing-zone-iac-governance.md), [04 Private Platform](./04-private-platform-secure-workspace.md) | [`P0`](./evidence/P0/), [`P1`](./evidence/P1/), [`P2a`](./evidence/P2a/), [`P2b`](./evidence/P2b/), [`P3`](./evidence/P3/), [`P4`](./evidence/P4/), [`O4`](./evidence/O4/), [`O5`](./evidence/O5/) |
| **Hybrid Cloud / Infrastructure Engineer** | [02 Networking](./02-hybrid-multicloud-network-security.md) | [`P5`](./evidence/P5/), [`P6`](./evidence/P6/), [`P5-vpn`](./evidence/P5-vpn/), [`O1`](./evidence/O1/), [`O3b`](./evidence/O3b/), [`O3c`](./evidence/O3c/) |
| **DevOps / SRE** | [03 Automation](./03-automation-secops-resilience.md) | [`A2-awx-control-plane`](./evidence/A2-awx-control-plane/), [`P9a`](./evidence/P9a/), [`P9b`](./evidence/P9b/), [`P9b-redesign`](./evidence/P9b-redesign/) |
| **Cloud Security Architect** | [01 Landing Zone](./01-landing-zone-iac-governance.md), [03 Automation](./03-automation-secops-resilience.md), [05 AI Enclave](./05-ai-operations-enclave.md) | [`P3`](./evidence/P3/), [`P6`](./evidence/P6/), [`P7`](./evidence/P7/), [`P8`](./evidence/P8/), [`O6`](./evidence/O6/) |
| **AI Operations / Security Reviewer** | [05 AI Enclave](./05-ai-operations-enclave.md) | [`O6`](./evidence/O6/), [`kubernetes`](../../kubernetes/) supporting manifests, [`local-ai-lab-infra`](https://github.com/jrikobd-azaws/local-ai-lab-infra) |
| **Recruiter / Hiring Manager** | [00 Summary](./00-summary.md), [Release 2 README](./README.md) | Start with capability overview, then follow role paths above |

---

## Reviewer Shortcuts

| Need to verify | Start here |
|---|---|
| Secretless Terraform delivery (OIDC) | [01 Landing Zone](./01-landing-zone-iac-governance.md) -> [`P0`](./evidence/P0/) |
| Policy deny enforcement (region/SKU) | [01 Landing Zone](./01-landing-zone-iac-governance.md) -> [`P3`](./evidence/P3/) |
| Multi-cloud transitive routing (Azure -> AWS) | [02 Networking](./02-hybrid-multicloud-network-security.md) -> [`O3c`](./evidence/O3c/) |
| AWX automation control plane | [03 Automation](./03-automation-secops-resilience.md) -> [`A2-awx-control-plane`](./evidence/A2-awx-control-plane/) |
| Azure Monitor alert firing (synthetic CPU stress) | [03 Automation](./03-automation-secops-resilience.md) -> [`P9a`](./evidence/P9a/) |
| Immutable backup with MUA (P9b redesign) | [03 Automation](./03-automation-secops-resilience.md) -> [`P9b-redesign`](./evidence/P9b-redesign/) |
| Private AKS (pod egress, managed monitoring) | [04 Private Platform](./04-private-platform-secure-workspace.md) -> [`O4`](./evidence/O4/) |
| AVD + FSLogix secure workspace | [04 Private Platform](./04-private-platform-secure-workspace.md) -> [`O5`](./evidence/O5/) |
| AI governance (MCP gateway, policy logs) | [05 AI Enclave](./05-ai-operations-enclave.md) -> [`O6`](./evidence/O6/) |

---

## Evidence Navigation Notes

- **All Release 2 evidence** is stored under [`docs/release2/evidence/`](./evidence/). Implemented phase/capability folders include P0-P9b, P5-vpn, P9b-redesign, O1, O2, O3b, O3c, O4, O5, O6, A1-ansible-network-baseline, A2-awx-control-plane, and supporting folders.
- **Preferred evidence format:** `.txt`, `.json`, `.md` for CLI-first validation; `.png` only where UI state is the primary proof.
- **Redaction standard:** All tenant IDs, subscription IDs, internal IPs, secrets, and credentials are stripped. Enough metadata is preserved to prove the claim.
- **Proof-link convention:** `proof link to be inserted` marks evidence that exists but whose final public path is not yet confirmed.
- For full redaction rules and evidence organisation standards, see [`EVIDENCE_GUIDE.md`](../../EVIDENCE_GUIDE.md).
- Model details for the AI Operations Enclave are maintained in [05-ai-operations-enclave.md](./05-ai-operations-enclave.md); the index deliberately avoids duplicating a list that may evolve.

---

*This index is maintained alongside the Release 2 documentation. Evidence paths are updated as proof links are finalised.*