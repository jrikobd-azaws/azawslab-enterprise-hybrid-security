# azawslab Enterprise Hybrid Security Platform

## Overview

This repository documents a phased flagship project designed to model a realistic enterprise hybrid infrastructure, identity, messaging, modern workplace, and security platform.

The project is built as a security-led engineering portfolio to demonstrate practical capability across:

- Active Directory and hybrid identity
- Microsoft Entra ID and Microsoft 365
- Exchange Server Subscription Edition (Exchange SE) and Exchange Online migration
- Intune and endpoint administration
- Zero Trust access controls
- Information protection and compliance mapping
- Monitoring, alerting, and governance-aligned operations

The goal is to present a realistic enterprise build path rather than isolated lab exercises.

This repository now includes active Release 1 implementation evidence across Hyper-V, Active Directory, Microsoft 365, Entra Connect Sync, Exchange hybrid configuration, migration troubleshooting, and completed pilot Exchange Online migration.

---

## Project Objectives

- Design and implement a secure hybrid identity foundation using on-premises Active Directory and Microsoft Entra ID
- Build a realistic Exchange hybrid migration path from on-premises Exchange SE to Microsoft 365
- Establish a Microsoft 365 modern workplace baseline across Exchange Online, Teams, and SharePoint
- Demonstrate endpoint administration and security through Intune, compliance policy, and device governance
- Apply Zero Trust principles across identity, endpoint, and access layers
- Integrate security, compliance, monitoring, and operational evidence into every phase
- Extend the platform in later phases into Azure governance, delegated administration, and workload modernization

---

## Release Model

### Release 1.0 – Secure Hybrid Identity & Modern Workplace

Focus areas:

- Hyper-V-based on-prem foundation
- Active Directory domain services with DC1 and DC2
- Member server and Exchange Server Subscription Edition source platform
- Microsoft 365 tenant setup and namespace onboarding
- Entra Connect pilot synchronization
- Exchange hybrid readiness and pilot migration path
- Exchange Online, Teams, and SharePoint baseline
- Intune endpoint administration and lifecycle management
- Windows security baselines, update rings, and compliance policies
- Android BYOD app protection policies
- Linux support path with Intune visibility where practical and Ansible for Linux configuration
- Conditional Access and MFA
- Information protection with sensitivity labels, DLP, Sensitive Information Types, and document fingerprinting
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

### Release 3.0 – Secure Workload Modernization & Resilience

Planned focus areas:

- 3-tier workload architecture
- Docker-based application deployment
- Future AKS extension if justified
- Secure workload connectivity and observability
- Application security controls
- Disaster recovery and high availability design patterns
- Extended monitoring and alerting across workload and infrastructure layers

---

## Current Implementation Status

Release 1 is no longer at planning stage. The core on-premises and hybrid messaging foundation has been implemented and evidenced in the repository.

### Implemented and validated so far

- Hyper-V base image, internal switch, and host NAT foundation
- Active Directory domain build for `corp.azawslab.co.uk`
- DC1 deployment, promotion, DNS validation, and health checks
- DC2 deployment, additional DC promotion, replication validation, and AD consistency checks
- OU structure, standard users, security groups, and pilot sync scoping with `SG-Pilot-Hybrid-Sync`
- MEM1 deployment and Microsoft Entra Connect Sync configuration
- Microsoft 365 tenant onboarding and domain verification
- Entra Connect pilot synchronization using Password Hash Synchronization
- Exchange Server Subscription Edition deployment on EXCH1
- Exchange administration validation through EAC
- Modern Hybrid configuration using Minimal Hybrid with Hybrid Agent
- recovery from HCW warning `HCW8078 - Migration Endpoint could not be created`
- public-trust SAN certificate correction for:
  - `mail.corp.azawslab.co.uk`
  - `exch1.corp.azawslab.co.uk`
- EWS / MRS Proxy path validation for remote move migration
- migration endpoint created successfully through PowerShell
- successful `Test-MigrationServerAvailability`
- pilot Exchange Online migration completed for:
  - `u.finance01@corp.azawslab.co.uk`
  - `u.hr01@corp.azawslab.co.uk`
- post-migration Outlook on the web validation completed

### What the current evidence set covers

The `screenshots/` tree currently contains organized evidence for:

- base image and Hyper-V foundation
- DC1 and DC2 build
- MEM1 build
- OU and identity preparation
- Microsoft 365 onboarding
- Entra Connect configuration and pilot sync
- EXCH1 build and Exchange setup
- hybrid and migration troubleshooting
- migration endpoint recovery
- pilot migration outcome

### Current Release 1 position

Release 1 has completed the infrastructure, hybrid identity, Exchange source build, hybrid recovery path, and pilot mailbox migration foundation needed to demonstrate a realistic Microsoft 365 hybrid onboarding scenario.

The current focus is now shifting away from hybrid migration unblock and toward the remaining Release 1 workstreams:

- Teams baseline
- SharePoint baseline
- Intune / endpoint management
- MFA and Conditional Access
- Defender and endpoint hardening
- monitoring and alerting
- information protection and compliance mapping

---

## Important Namespace Design Decision

The environment intentionally separates namespaces during pilot migration work:

- `azawslab.co.uk` remains associated with Zoho for business mail flow
- `corp.azawslab.co.uk` is the dedicated hybrid pilot namespace

This allows pilot hybrid and migration work to proceed without disrupting the root business mail namespace.

---

## Real-World Delivery Context

The pilot users in this project were migrated as:

- `u.finance01@corp.azawslab.co.uk`
- `u.hr01@corp.azawslab.co.uk`

The lab validates mailbox migration into Exchange Online, but real enterprise mail routing can vary depending on whether Microsoft 365 is the direct mail ingress point or whether a third-party secure email gateway remains in front.

Common real-world patterns include:

### Option 1 — No third-party gateway

`Internet sender -> Exchange Online Protection / Microsoft 365 -> Exchange Online mailbox`

### Option 2 — Mimecast or Proofpoint in front of Microsoft 365

`Internet sender -> Mimecast / Proofpoint -> Microsoft 365 / Exchange Online -> user mailbox`

### Option 3 — Hybrid coexistence during staged migration

`Internet sender -> Mimecast / Proofpoint -> Microsoft 365 / Exchange Online`

Then Microsoft 365 determines mailbox location:

- if the mailbox is already in Exchange Online, deliver there directly
- if the mailbox is still on-premises, route back to on-premises through the hybrid connector path

This project did not fully implement all of those gateway patterns, but it documents them as part of real-world migration design awareness.

---

## Core Technologies

### Identity & Access
- Active Directory
- Microsoft Entra ID
- Entra Connect Sync
- Password Hash Synchronization
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

### Messaging & Hybrid
- Exchange Server Subscription Edition (Exchange SE)
- Modern Hybrid configuration
- Hybrid Agent
- MRS Proxy
- Exchange remote move migration
- manual migration endpoint recovery path

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

## Documentation Structure

- `docs/01-project-overview.md` – overall scope and vision
- `docs/02-business-scenario.md` – fictional enterprise scenario and requirements
- `docs/03-current-state-architecture.md` – current on-premises implementation state
- `docs/04-target-state-architecture.md` – phased target architecture
- `docs/05-hybrid-identity.md` – AD, Entra ID, sync, namespace, and pilot identity status
- `docs/06-m365-modern-workplace.md` – tenant setup, licensing, migration outcome, and M365 scope
- `docs/07-endpoint-security-intune.md` – Intune, Windows, Linux, and Android BYOD scope
- `docs/08-information-protection-purview.md` – labels, DLP, SITs, and document fingerprinting
- `docs/09-monitoring-alerting.md` – logs, alerts, and operational visibility
- `docs/10-security-compliance-mapping.md` – control mapping against GDPR, NIST, and CIS
- `docs/11-roadmap.md` – future phases
- `docs/12-lessons-learned.md` – technical decisions, troubleshooting notes, and build lessons
- `docs/13-release1-build-checklist.md` – authoritative Release 1 delivery checklist

---

## Supporting Documentation

- Hybrid identity and Exchange hybrid notes: `docs/05-hybrid-identity.md`
- Microsoft 365 / Exchange Online migration and validation: `docs/06-m365-modern-workplace.md`
- Build issues, troubleshooting, and design decisions: `docs/12-lessons-learned.md`
- Current release state: `docs/13-release1-build-checklist.md`

---

## Supporting Artifacts

- Exchange / migration scripts: `scripts/exchange/`
- Screenshots and implementation evidence: `screenshots/`

---

## Evidence Strategy

This repository prioritizes implementation evidence over claims. Evidence includes:

- architecture diagrams
- portal screenshots
- Exchange and PowerShell validation output
- hybrid and migration troubleshooting evidence
- migration batch and outcome evidence
- Outlook on the web validation screenshots
- policy screenshots
- monitoring and alert examples

---

## Guiding Principles

- Security is embedded in every phase
- Governance and compliance are documented, not assumed
- Evidence is prioritized over buzzwords
- Scope is phased to remain realistic and defensible
- The platform is designed for extension into Azure, MSP, and workload modernization scenarios
- Design decisions are recorded and not reworked without clear technical justification

---

## Author

Hashibur Rahman  
Senior Hybrid Cloud & Infrastructure Engineer  
Belfast, UK