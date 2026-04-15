# azawslab Enterprise Hybrid Security Platform

## Overview

This repository documents a phased flagship project designed to model a realistic enterprise hybrid infrastructure, identity, messaging, modern workplace, endpoint administration, and security platform.

The project is built as a security-led engineering portfolio to demonstrate practical capability across:

- Active Directory and hybrid identity
- Microsoft Entra ID and Microsoft 365
- Exchange Server Subscription Edition (Exchange SE) and Exchange Online migration
- Microsoft Teams and SharePoint Online collaboration services
- Intune and endpoint administration
- Windows corporate and BYOD endpoint onboarding
- Linux endpoint visibility and baseline automation
- Zero Trust access controls
- Information protection and compliance mapping
- Monitoring, alerting, and governance-aligned operations

The goal is to present a realistic enterprise build path rather than isolated lab exercises.

This repository now includes active Release 1 implementation evidence across Hyper-V, Active Directory, Microsoft 365, Entra Connect Sync, Exchange hybrid configuration, pilot mailbox migration, Teams baseline validation, SharePoint baseline validation, Microsoft Intune endpoint onboarding, Linux Intune visibility, and Linux baseline automation with Ansible.

---

## Project Objectives

- Design and implement a secure hybrid identity foundation using on-premises Active Directory and Microsoft Entra ID
- Build a realistic Exchange hybrid migration path from on-premises Exchange SE to Microsoft 365
- Establish a Microsoft 365 modern workplace baseline across Exchange Online, Teams, and SharePoint
- Demonstrate endpoint administration and security through Intune, compliance policy, and device governance
- Extend endpoint management beyond Windows into practical Linux visibility and baseline automation
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
- Windows corporate and BYOD endpoint onboarding
- Linux support path with Intune visibility and Ansible baseline automation
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

Release 1 is no longer at planning stage. The core on-premises, hybrid messaging, collaboration, and endpoint baseline has been implemented and validated at practical pilot scope.

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
- Teams baseline validated at pilot scope, including:
  - user access
  - direct chat
  - team/channel collaboration
  - file collaboration
  - meeting/calendar validation
- SharePoint baseline validated at pilot scope, including:
  - site access
  - site membership visibility
  - document library validation
  - file upload
  - file-open validation
- Intune baseline enabled at tenant scope
- EMS E5 licensing path activated for management capability
- Windows 11 corporate-managed endpoint scenario validated
- Windows 11 personal/BYOD-style endpoint scenario validated
- compliant device visibility confirmed in Intune and Microsoft Entra ID
- Linux Intune Agent enrollment path validated
- Ubuntu Linux endpoint visibility confirmed in Microsoft Entra ID and Intune
- Linux baseline automation validated with Ansible, including:
  - inventory and playbook structure
  - connectivity test
  - syntax check
  - baseline execution against Ubuntu target

### Current Release 1 position

Release 1 has completed the infrastructure, hybrid identity, Exchange source build, hybrid recovery path, pilot mailbox migration, practical collaboration baseline, initial endpoint onboarding baseline, and initial Linux management/automation baseline needed to demonstrate a realistic Microsoft 365 hybrid onboarding scenario.

### Current focus

The current focus is now shifting away from baseline activation and toward the remaining Release 1 depth workstreams:

- Windows configuration profiles
- compliance policy depth
- MFA and Conditional Access
- Defender and endpoint hardening
- Linux management depth beyond baseline automation
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

This project does not claim full implementation of all gateway patterns, but it documents them as part of real-world migration design awareness.

---

## Endpoint Direction in Release 1

Release 1 is not limited to identity and messaging. It also establishes a practical endpoint baseline across multiple management scenarios.

### Windows scenarios validated

- corporate-managed Windows 11 device
- personal/BYOD Windows 11 device
- ownership distinction inside Intune
- compliant state visibility for enrolled Windows devices

### Linux scenario validated

- Ubuntu device enrollment path using Microsoft Intune Agent
- Linux device visibility in Entra ID
- Linux device visibility in Intune
- Linux baseline automation using Ansible

This gives the platform a more realistic mixed-endpoint story than a Windows-only lab.

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

### Endpoint & Automation
- Windows 11
- Ubuntu Linux
- Microsoft Intune Agent
- Ansible
- SSH-based Linux automation
- baseline package and configuration automation

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
- Ubuntu Server/Desktop
- PowerShell
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
- `docs/06-m365-modern-workplace.md` – tenant setup, licensing, Exchange migration, Teams, SharePoint, and M365 scope
- `docs/07-endpoint-security-intune.md` – Intune baseline, Windows endpoint scenarios, Linux Intune path, and endpoint status
- `docs/08-information-protection-purview.md` – labels, DLP, SITs, and document fingerprinting
- `docs/09-monitoring-alerting.md` – logs, alerts, and operational visibility
- `docs/10-security-compliance-mapping.md` – control mapping against GDPR, NIST, and CIS
- `docs/11-roadmap.md` – future phases
- `docs/12-lessons-learned.md` – technical decisions, troubleshooting notes, and build lessons
- `docs/13-release1-build-checklist.md` – authoritative Release 1 delivery checklist

---

## Supporting Documentation

- Hybrid identity and Exchange hybrid notes: `docs/05-hybrid-identity.md`
- Microsoft 365 workload baseline and Exchange migration: `docs/06-m365-modern-workplace.md`
- Endpoint and Intune baseline: `docs/07-endpoint-security-intune.md`
- Build issues, troubleshooting, and design decisions: `docs/12-lessons-learned.md`
- Current release state: `docs/13-release1-build-checklist.md`

---

## Supporting Artifacts

- Exchange / migration scripts: `scripts/exchange/`
- Ansible baseline content: `scripts/ansible/` or repository Ansible path if maintained there
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
- Teams collaboration evidence
- SharePoint access and file-validation evidence
- Intune and device-enrollment evidence
- Linux endpoint visibility evidence
- Ansible project and playbook execution evidence
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