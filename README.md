# azawslab Enterprise Hybrid Security Platform

A three-release enterprise platform portfolio demonstrating hybrid identity, Microsoft 365, endpoint management, information protection, Azure secure platform engineering, and secure workload modernization.

## What This Platform Demonstrates

- Hyper-V-based platform engineering, including internal virtual switching, host NAT, differencing-disk reuse, and multi-VM orchestration
- Hybrid Active Directory and Microsoft Entra ID integration using controlled pilot synchronization
- Exchange hybrid migration readiness, troubleshooting, and pilot mailbox validation
- Microsoft 365 collaboration and endpoint administration across Exchange Online, Teams, SharePoint, and Intune
- Multi-platform endpoint scenarios across Windows corporate, Windows BYOD, Ubuntu Linux, and iPhone BYOD
- Compliance, security baseline, BitLocker recovery, and Conditional Access-aligned device control logic
- Purview sensitivity labels, DLP, retention baseline, and monitoring-backed operational validation
- Planned extension into Azure secure platform engineering in Release 2 and secure workload modernization in Release 3

## Release Summary

| Release | Focus | Status |
|---|---|---|
| Release 1 | Hybrid identity, Microsoft 365, endpoint management, information protection, monitoring, and operational recovery | Implemented |
| Release 2 | Azure landing zone, infrastructure as code, governance, delegated administration, network security, Defender for Cloud, and Sentinel | Planned |
| Release 3 | Secure workload hosting, containerization, protected ingress, observability, and resilience | Planned |

## Release 1 Proof Snapshot

Release 1 demonstrates an implemented hybrid Microsoft platform across identity, messaging, collaboration, endpoint management, information protection, monitoring, and operational recovery.

- Hyper-V-based on-premises foundation built with internal switching, host NAT, differencing-disk reuse, and multi-VM orchestration
- Active Directory, DNS, Exchange Server Subscription Edition, and Entra Connect Sync integrated into a controlled pilot hybrid environment
- Exchange hybrid migration path validated, including recovery from HCW migration-endpoint issues and successful pilot mailbox migration
- Microsoft 365 collaboration baseline validated across Exchange Online, Teams, and SharePoint
- Endpoint onboarding demonstrated across Windows corporate, Windows BYOD, Ubuntu Linux, and iPhone BYOD scenarios
- Compliance and security controls validated through Intune compliance policies, Windows security baseline, BitLocker key escrow, and compliant-device access logic
- Purview baseline demonstrated through sensitivity labels, DLP policy-tip triggering, and retention visibility
- Advanced recovery documented through BitLocker recovery, device rebuild, duplicate and stale record cleanup, and restored compliant state

## Release 1 Architecture

![Release 1 end-state architecture](diagrams/01-release1-end-state-architecture.png)

Release 1 end-state view showing the on-premises Hyper-V platform, identity and cloud integration, endpoint management, and control layer.

Related visuals:
- [Three-release roadmap](diagrams/04-phased-roadmap-release1-release2-release3.png)
- [Release 1 implementation flow and proof map](diagrams/05-release1-implementation-flow-and-proof-map.png)

## How to Read This Repository

### For hiring managers and recruiters

- Start with this README
- Review [Release 1 Summary](docs/release1/00-summary.md)
- Review [Roadmap](docs/overview/04-roadmap.md)
- Open [Diagrams](diagrams/README.md) for architecture and release visuals

### For technical reviewers

- Start with [Current-State Architecture](docs/overview/02-current-state-architecture.md)
- Review [Hybrid Identity](docs/release1/01-hybrid-identity.md)
- Review [Endpoint Enrollment](docs/release1/04-endpoint-enrollment.md)
- Review [Endpoint Compliance](docs/release1/05-endpoint-compliance.md)
- Review [Recovery Scenarios](docs/release1/06-recovery-scenarios.md)
- Review [Purview](docs/release1/07-purview.md)
- Use [Screenshots](screenshots/README.md), [Diagrams](diagrams/README.md), [Ansible](ansible/README.md), and `terraform/` as supporting implementation evidence

## Key Differentiators

### Hyper-V platform engineering

The project is built on a deliberate Hyper-V foundation using internal switch design, host NAT, differencing-disk reuse, secure VM lifecycle decisions, and multi-VM orchestration.

### Non-happy-path engineering

Release 1 includes recovery from Exchange hybrid migration issues, BitLocker recovery, trust disruption, stale record cleanup, and re-enrollment validation rather than portal-only happy-path configuration.

### Cross-domain control story

The project connects identity, messaging, collaboration, endpoint compliance, Conditional Access-aligned device logic, and information protection into one coherent platform narrative.

### Evidence-backed presentation

The repository combines diagrams, embedded screenshots, implementation notes, and workstream-level documentation to support technical claims with visible proof.

## Important Namespace Design Decision

The environment intentionally separates namespaces during pilot hybrid work:

- `azawslab.co.uk` remains associated with Zoho for business mail flow
- `corp.azawslab.co.uk` is the dedicated hybrid pilot namespace

This allowed hybrid identity and pilot migration work to proceed without disrupting the root business mail namespace.

## Intentionally Deferred / Out of Scope for Release 1

Release 1 intentionally does not claim full Android BYOD / MAM validation, fully evidenced Windows LAPS password retrieval and recovery operations, or document fingerprinting maturity where validation evidence is incomplete.

## Quick Links

- [Platform Overview](docs/overview/01-platform-overview.md)
- [Current-State Architecture](docs/overview/02-current-state-architecture.md)
- [Roadmap](docs/overview/04-roadmap.md)
- [Release 1 Summary](docs/release1/00-summary.md)
- [Release 1 Build Checklist](docs/release1/11-build-checklist.md)
- [Hybrid Identity](docs/release1/01-hybrid-identity.md)
- [Modern Workplace](docs/release1/02-modern-workplace.md)
- [Endpoint Enrollment](docs/release1/04-endpoint-enrollment.md)
- [Endpoint Compliance](docs/release1/05-endpoint-compliance.md)
- [Recovery Scenarios](docs/release1/06-recovery-scenarios.md)
- [Purview](docs/release1/07-purview.md)
- [Monitoring](docs/release1/08-monitoring.md)
- [Diagrams](diagrams/README.md)
- [Screenshots](screenshots/README.md)
- [Ansible](ansible/README.md)
- [Terraform](terraform/)