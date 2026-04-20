# azawslab Enterprise Hybrid Security Platform

A flagship enterprise infrastructure portfolio demonstrating the transformation of a legacy small-enterprise environment into a secure, cloud-integrated, and operationally manageable Microsoft-centric platform.

This repository goes beyond portal screenshots. It presents **architecture, implementation, validation, and operational recovery** across hybrid identity, Microsoft 365, endpoint management, compliance, and Azure security.

Narrative documentation lives under `/docs`, while `/screenshots` contains the supporting evidence archive organised by release and operational domain.

---

## Why This Project Matters

This project demonstrates practical engineering judgment, not just a "happy-path" lab build.

It focuses on:
- **Delivery maturity** over vague "enterprise transformation" claims.
- **Validated outcomes** over portal-only configuration.
- **Operational recovery and troubleshooting**, proving the ability to handle broken trusts, stale records, and migration friction.

**Target Role Alignment:**  
The implemented scope of this project aligns strongly with roles such as:
- Modern Workplace Engineer / M365 Administrator
- Endpoint Administrator / Intune Specialist
- Hybrid Identity and Access / Systems Administrator

---

## Release Summary

| Release | Focus | Status |
| :--- | :--- | :--- |
| **Release 1** | Hybrid Identity (Entra ID), Microsoft 365 Baseline, Endpoint Management (Intune), Compliance (Purview), and Operational Recovery. | **Implemented & Evidenced** |
| **Release 2** | Azure Landing Zone, Infrastructure as Code (IaC), RBAC Governance, Network Security, and SIEM (Sentinel). | *Roadmap* |
| **Release 3** | Secure Workload Hosting, Containerization (Docker), Protected Ingress (WAF), and Observability. | *Roadmap* |

---

## Release 1: Flagship Implementation & Proof

Release 1 is the most complete and most strongly evidenced part of the project, demonstrating a functional hybrid Microsoft platform.  
**Built on a local Hyper-V lab using internal switching, host NAT, and differencing disks to create a controlled hybrid validation environment.**

![Release 1 end-state architecture](diagrams/01-release1-end-state-architecture.png)
*Release 1 end-state view showing the on-premises platform foundation, hybrid identity integration, Microsoft 365 services, endpoint management layer, and control flow.*

### Validated Capabilities
- **Platform Foundation:** Hyper-V multi-VM orchestration with internal switching, host NAT, and differencing-disk reuse.
- **Hybrid Identity:** Active Directory to Entra ID synchronization via Entra Connect Sync (PHS, OU filtering).
- **Messaging & Collaboration:** Exchange hybrid migration validation (including HCW endpoint recovery) and M365 baseline delivery across Teams and SharePoint.
- **Endpoint Management:** Device onboarding across Windows Corporate, Windows BYOD, Ubuntu Linux, and iOS BYOD.
- **Endpoint Security:** Intune Conditional Access, Windows Security Baselines, Defender Antivirus, Attack Surface Reduction (ASR), BitLocker controls, and LAPS policy configuration.
- **Information Protection:** Microsoft Purview baseline including DLP policies, sensitivity labels, and retention.
- **Operational Resilience:** Documented recovery for BitLocker escrow, device rebuilds, and stale Entra record cleanup.

---

## Scope Transparency: What is Deferred

To maintain engineering integrity, this repository clearly separates implemented work from future roadmap items.

The following areas are **not** fully evidenced in Release 1 and are tracked as future enhancements:
- Android BYOD / MAM validation.
- Windows Autopilot / Enrollment Status Page (ESP) optimizations.
- Advanced Purview capabilities (document fingerprinting, large-scale auto-labeling).
- Full Enterprise PKI / AD CS (Let's Encrypt / `win-acme` was utilized for hybrid validation).
- Broader Azure platform security and DevOps workflows (reserved for Releases 2 and 3).

> **Each of these deferred items is documented in the [Release 1 Extensions](./docs/release1/12-extensions-and-future-enhancements.md) file with planned implementation notes.**

---

## How to Navigate This Repository

The documentation is split logically between the foundational architecture and the specific release evidence.

### 1. The Foundation (Start Here)
- [Platform Overview](docs/foundation/01-platform-overview.md)
- [Current-State Architecture](docs/foundation/02-current-state-architecture.md)
- [Target-State Architecture](docs/foundation/03-target-state-architecture.md)
- [Skills and Evidence Index](docs/foundation/05-skills-and-evidence-index.md)
- [Future Roadmap](docs/foundation/04-roadmap.md)

### 2. Release 1 Evidence (Deep Dives)
- [Release 1 README](docs/release1/README.md)
- [Release 1 Summary](docs/release1/00-summary.md)
- [Hybrid Identity](docs/release1/01-hybrid-identity.md)
- [Modern Workplace](docs/release1/02-modern-workplace.md)
- [Endpoint Enrollment](docs/release1/04-endpoint-enrollment.md)
- [Endpoint Compliance and Security](docs/release1/05-endpoint-compliance-and-security.md)
- [Purview Information Protection](docs/release1/07-purview.md)
- [Monitoring & Operations](docs/release1/08-monitoring.md)
- [Recovery Scenarios](docs/release1/06-recovery-scenarios.md)

*(Note: Raw evidence screenshots can be found in the `/screenshots` directory, categorised by operational domain.)*

---

For Modern Workplace, Intune, Entra ID, and hybrid Microsoft roles, the best starting point is the [Release 1 README](docs/release1/README.md).


