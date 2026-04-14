# azawslab Enterprise Hybrid Security Platform

## Overview

This repository documents a phased flagship project designed to model a realistic enterprise hybrid infrastructure, identity, messaging, modern workplace, and security platform.

The project is built as a security-led engineering portfolio to demonstrate practical capability across:

- Active Directory and hybrid identity
- Microsoft Entra ID and Microsoft 365
- Exchange Server Subscription Edition (Exchange SE) and Exchange Online migration readiness
- Intune and endpoint administration
- Zero Trust access controls
- Information protection and compliance mapping
- Monitoring, alerting, and governance-aligned operations

The goal is to present a realistic enterprise build path rather than isolated lab exercises.

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
- Remote move migration readiness

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

- On-premises Active Directory domain services
- Dedicated hybrid identity and messaging transition path
- Microsoft 365 tenant onboarding and pilot cloud access
- Exchange SE as the on-premises messaging source platform
- Microsoft Entra Connect-based pilot synchronization
- Intune-managed endpoint scenarios
- Security controls applied across identity, endpoint, messaging, and data layers
- Monitoring and compliance evidence captured throughout the build

---

## Current Release 1 Position

Release 1 has completed the core hybrid identity and messaging foundation, including:

- AD DS domain build for `corp.azawslab.co.uk`
- DC1 and DC2 deployment
- DNS and replication validation
- Tiered OU structure and pilot user/group preparation
- MEM1 member server deployment
- EXCH1 deployment with Exchange Server Subscription Edition installed
- Pilot on-premises mailbox preparation
- Microsoft 365 tenant onboarding
- Domain onboarding for:
  - `azawslab.co.uk`
  - `corp.azawslab.co.uk`
- Entra Connect pilot synchronization on MEM1
- Pilot licensing completion
- Pilot Microsoft 365 sign-in validation
- Initial Modern Hybrid configuration through Hybrid Configuration Wizard

### Current Technical Blocker

Modern Hybrid is configured, but Hybrid Configuration Wizard finished in a partial-success state with:

`HCW8078 - Migration Endpoint could not be created`

This is the current implementation point.

### Next Technical Milestone

The next work item is to complete:

1. migration endpoint validation
2. remote-move readiness validation
3. pilot mailbox migration for selected users

After the technical blocker is cleared, GitHub documentation and tracker sheets will be fully updated to reflect the completed state.

---

## Important Namespace Design Decision

The environment intentionally separates namespaces during pilot migration work:

- `azawslab.co.uk` remains associated with Zoho for business mail flow
- `corp.azawslab.co.uk` is the dedicated hybrid pilot namespace

This allows pilot hybrid and migration work to proceed without disrupting the root business mail namespace.

---

## Documentation Structure

- `docs/01-project-overview.md` – overall scope and vision
- `docs/02-business-scenario.md` – fictional enterprise scenario and requirements
- `docs/03-current-state-architecture.md` – current on-premises implementation state
- `docs/04-target-state-architecture.md` – phased target architecture
- `docs/05-hybrid-identity.md` – AD, Entra ID, sync, namespace, and pilot identity status
- `docs/06-m365-modern-workplace.md` – tenant setup, licensing, Exchange Online readiness, and M365 scope
- `docs/07-endpoint-security-intune.md` – Intune, Windows, Linux, and Android BYOD scope
- `docs/08-information-protection-purview.md` – labels, DLP, SITs, and document fingerprinting
- `docs/09-monitoring-alerting.md` – logs, alerts, and operational visibility
- `docs/10-security-compliance-mapping.md` – control mapping against GDPR, NIST, and CIS
- `docs/11-roadmap.md` – future phases
- `docs/12-lessons-learned.md` – technical decisions, troubleshooting notes, and build lessons
- `docs/13-release1-build-checklist.md` – authoritative Release 1 delivery checklist

---

## Evidence Strategy

This repository prioritizes implementation evidence over claims. Evidence will include:

- architecture diagrams
- portal screenshots
- Exchange and PowerShell validation output
- policy screenshots
- HCW and migration readiness evidence
- test cases and outcome summaries
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