# azawslab-enterprise-hybrid-security
Phased enterprise hybrid security platform covering Entra ID, Microsoft 365, Intune, compliance, and Azure security

# azawslab Enterprise Hybrid Security Platform

## Overview

This repository documents a phased flagship project designed to model an enterprise hybrid cloud, security, and governance platform.

The project is built to demonstrate practical architecture, administration, and security capabilities across hybrid Active Directory, Microsoft Entra ID, Microsoft 365, Intune, endpoint security, information protection, Azure governance, and Zero Trust access patterns.

The goal is to build a realistic and recruiter-facing portfolio that reflects how enterprise environments evolve over time rather than presenting isolated lab exercises.

---

## Project Objectives

- Design and document a secure hybrid identity foundation using on-premises Active Directory and Microsoft Entra ID
- Implement Microsoft 365 and modern workplace administration patterns across Exchange Online, Teams, SharePoint, and endpoint management
- Apply Zero Trust principles across identity, endpoint, and access controls
- Integrate governance, compliance, monitoring, and alerting into every phase
- Extend the environment in later phases into Azure landing zones, delegated MSP-style operations, and workload modernisation

---

## Release Model

### Release 1.0 – Secure Hybrid Identity & Modern Workplace

Focus areas:

- Hybrid Active Directory and Entra ID integration
- Microsoft 365 services baseline
- Exchange Online, Teams, and SharePoint administration
- Intune endpoint administration and lifecycle management
- Windows security baselines, update rings, and compliance policies
- Android BYOD app protection policies
- Linux enrollment and compliance validation
- Conditional Access and MFA enforcement
- Information protection with sensitivity labels, DLP, SITs, and document fingerprinting
- Initial monitoring, audit visibility, and alerting
- Security and compliance mapping against GDPR, NIST, and CIS principles

### Release 2.0 – Azure Secure Platform, MSP Operations & Network Security

Planned focus areas:

- Azure landing zone foundation
- Terraform-based infrastructure deployment
- Azure Policy, RBAC, and governance controls
- Azure Lighthouse for delegated administration / MSP operating model
- Global Secure Access / Entra Private Access
- VPN and routing design patterns
- Monitoring, alerting, and Microsoft Sentinel onboarding
- Defender for Cloud integration
- Expanded compliance and governance controls

### Release 3.0 – Secure Workload Modernisation & Resilience

Planned focus areas:

- 3-tier workload architecture
- Docker-based application deployment
- Future AKS extension
- Secure workload connectivity and observability
- Application security controls
- Disaster recovery and high availability design patterns
- Extended monitoring and alerting across workload and infrastructure layers

---

## Core Technologies

### Identity & Access
- Active Directory
- Microsoft Entra ID
- Entra Connect / hybrid identity
- Conditional Access
- Multi-Factor Authentication
- Role-based administration

### Microsoft 365 & Modern Workplace
- Exchange Online
- Microsoft Teams
- SharePoint Online
- Intune
- Device compliance
- Endpoint lifecycle management

### Security & Governance
- Zero Trust principles
- Sensitivity labels
- Data Loss Prevention
- Sensitive Information Types
- Document fingerprinting
- Security baselines
- Governance-aligned administration

### Infrastructure & Operations
- Hyper-V
- Windows Server
- Ubuntu Linux
- PowerShell
- Ansible
- Monitoring and alerting
- Azure governance (future phase)
- Terraform (future phase)

---

## Lab Design Summary

The lab models a hybrid enterprise with:

- Head office and branch office concept
- On-premises Active Directory domain services
- Hybrid identity integrated with Microsoft Entra ID
- Microsoft 365 collaboration and productivity services
- Intune-managed endpoints
- Security controls applied across identity, endpoint, and data layers
- Monitoring and compliance evidence captured as part of the build

---

## Documentation Structure

- `docs/01-project-overview.md` – overall scope and vision
- `docs/02-business-scenario.md` – fictional enterprise scenario and requirements
- `docs/03-current-state-architecture.md` – legacy / on-prem baseline
- `docs/04-target-state-architecture.md` – phased target architecture
- `docs/05-hybrid-identity.md` – AD, Entra ID, sync, pilot strategy
- `docs/06-m365-modern-workplace.md` – Exchange, Teams, SharePoint, admin scope
- `docs/07-endpoint-security-intune.md` – Intune, Windows, Linux, Android BYOD
- `docs/08-information-protection-purview.md` – labels, DLP, SITs, fingerprinting
- `docs/09-monitoring-alerting.md` – logs, alerts, operational visibility
- `docs/10-security-compliance-mapping.md` – control mapping against GDPR, NIST, CIS
- `docs/11-roadmap.md` – future phases
- `docs/12-lessons-learned.md` – build notes and decisions

---

## Current Status

### In progress

- DC1 built and promoted for `corp.azawslab.co.uk`
- Core OU structure implemented
- Standard users created
- Baseline AD security groups created
- Pilot hybrid sync scope defined
- Forward and reverse DNS configured on DC1
- DC1 DNS validation completed
- DC2 built using a Hyper-V differencing disk
- DC2 joined to `corp.azawslab.co.uk`
- AD DS and DNS installed on DC2
- DC2 promoted as an additional domain controller
- Initial replication validation completed successfully between DC1 and DC2
- `NETLOGON` and `SYSVOL` validated on DC2
- MEM1 built using a Hyper-V differencing disk
- MEM1 joined to `corp.azawslab.co.uk`
- MEM1 moved to `Tier-1 > Member Servers`
- EXCH1 built using a Hyper-V differencing disk
- EXCH1 joined to `corp.azawslab.co.uk`
- EXCH1 moved to `Tier-1 > Member Servers`
- Exchange SE setup initiated on EXCH1
- Exchange SE prerequisites remediated from readiness checks
- Dynamic Memory disabled on EXCH1 before Exchange installation

### Planned next
- Complete Exchange SE installation and validation on EXCH1
- Entra Connect pilot sync
- Microsoft 365 baseline configuration

### Planned evidence
- Architecture diagrams
- Portal configuration screenshots
- Policy screenshots
- Test cases
- PowerShell and Ansible snippets
- Monitoring and alert examples

---

## Guiding Principles

- Security is embedded in every phase
- Governance and compliance are documented, not assumed
- Evidence is prioritised over buzzwords
- Scope is phased to remain realistic and defensible
- The platform is designed for future extension into Azure, MSP, and workload modernisation scenarios

---

## Author

Hashibur Rahman  
Senior Hybrid Cloud & Infrastructure Engineer  
Belfast, UK
