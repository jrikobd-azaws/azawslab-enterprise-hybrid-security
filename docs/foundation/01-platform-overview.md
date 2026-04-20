# Platform Overview

## Purpose

This page explains the overall platform shape of the `azawslab Enterprise Hybrid Security Platform`, how the three releases relate to one another, and why the implementation is structured as a staged transformation rather than a single all-at-once build.

It is intended to give hiring managers, technical reviewers, and general readers a clear architectural view of the platform before they move into release-specific detail.

---

## What This Page Proves

This page shows that the repository is structured as:
- a staged enterprise platform journey rather than a collection of disconnected lab tasks
- a Microsoft-centric hybrid foundation that expands into Azure governance and then into secure workload modernization
- a platform designed around identity, endpoint control, collaboration, monitoring, and secure expansion
- an implementation that is conscious of scope, evidence, and operational realism

---

## Why This Matters

The value of this project is not just that technologies were configured. The platform is intended to demonstrate how infrastructure, identity, collaboration, endpoint security, and governance can be introduced in a way that is:

- **staged**, so complexity is controlled
- **operationally realistic**, so recovery and troubleshooting are part of the design
- **evidence-backed**, so claims can be validated
- **extensible**, so future capabilities can be added without restructuring the whole repository

This matters for real-world engineering because most production environments are not rebuilt from scratch in one step. They evolve through controlled releases, risk reduction, and incremental validation.

---

## Platform at a Glance

The platform is organized into three releases:

| Release | Core Theme | What It Adds |
|---|---|---|
| **Release 1** | Hybrid Microsoft foundation | Hybrid identity, Microsoft 365, Exchange hybrid, endpoint management and security, information protection, monitoring, and operational recovery |
| **Release 2** | Azure secure platform expansion | Landing zone design, infrastructure as code, governance, network security, delegated administration, Defender for Cloud, and Sentinel-aligned monitoring |
| **Release 3** | Secure workload modernization | Application hosting, containerization, protected ingress, observability, and resilience |

This structure allows the repository to serve both as:
- a flagship portfolio project
- a role-targeted body of proof depending on which release is most relevant to the reader

---

## Architectural Model

At a high level, the platform is built in layers:

### 1. Platform foundation
The foundation layer provides the delivery environment and supporting infrastructure needed to host and validate the rest of the project.

In Release 1, that foundation includes:
- Hyper-V-based virtual platform engineering
- internal virtual switching and host NAT
- reusable image and differencing-disk strategy
- multi-VM orchestration for identity, management, and messaging systems

This foundation is important because it makes the project reproducible, isolated, and capable of simulating a small-enterprise hybrid estate.

### 2. Identity and access
The identity layer establishes the control plane for the platform:
- on-premises Active Directory
- Entra Connect synchronization
- Microsoft Entra ID tenant alignment
- Conditional Access
- MFA
- SSPR
- group-driven pilot scoping

Identity is treated as the trust boundary for the rest of the platform. Endpoint trust, service access, and collaboration controls all depend on it.

### 3. Productivity and collaboration
The collaboration layer demonstrates how user-facing services are modernized:
- Exchange hybrid and pilot migration
- Teams baseline validation
- SharePoint baseline validation

This layer is included because enterprise platform value is not just about control planes; it is also about validated user outcomes.

### 4. Endpoint management and security
The endpoint layer introduces device enrollment, compliance, and control:
- Windows corporate enrollment
- Windows BYOD distinction
- Ubuntu Linux visibility and management
- iPhone BYOD enrollment
- Intune compliance policies
- Windows security baseline
- Defender Antivirus policy
- ASR policy
- BitLocker recovery-key escrow
- update ring configuration

This layer matters because it connects identity to device trust and turns Zero Trust concepts into visible control decisions.

### 5. Information protection
The information protection layer introduces content-aware controls:
- sensitivity labels
- DLP policy behavior
- retention visibility

This shows that platform security is not limited to identity and devices; it also extends to data handling and user interaction.

### 6. Monitoring and operational review
The operational layer provides visibility into whether the platform is functioning as intended:
- sign-in review
- audit activity
- endpoint visibility
- control and policy status
- example alert conditions
- recovery validation

This layer is a key differentiator because it proves the platform is designed for administration and troubleshooting, not only initial setup.

---

## Release 1 Platform Scope

Release 1 is the most complete and most operationally evidenced part of the platform.

Its purpose is to establish a credible hybrid Microsoft environment that demonstrates:

- hybrid identity design and synchronization discipline
- modern workplace service validation
- endpoint enrollment across multiple device scenarios
- endpoint compliance and security control enforcement
- Purview information protection validation
- operational monitoring and recovery

Release 1 should be read as the implemented foundation on which the later releases build.

---

## Release 2 Platform Direction

Release 2 expands the platform from hybrid Microsoft administration into Azure security and governance engineering.

Its intended role in the platform is to introduce:
- Azure landing zone thinking
- governance and policy control
- delegated administration
- network security architecture
- Defender for Cloud
- Sentinel-oriented visibility and response alignment

This release is important because it moves the repository from hybrid operational foundation into cloud control-plane maturity.

Release 2 should be read as a planned expansion path, not as fully implemented Release 1 scope.

No empty implementation structure should be created to imply completion. Until Release 2 capabilities are actually built and evidenced, they should be represented through roadmap and extension documentation only.

---

## Release 3 Platform Direction

Release 3 extends the platform from administration and governance into secure workload delivery.

Its intended role is to show how the governed platform can host and protect workloads through:
- secure application hosting
- Docker-based modernization
- protected ingress and WAF concepts
- observability
- resilience and recovery design

This release is important because it shows the platform is not just about administration of Microsoft services; it can evolve toward secure workload engineering as well.

Release 3 should also be read as planned expansion, not current Release 1 maturity.

As with Release 2, future workload capabilities should be documented as intended direction until they are implemented and supported by real evidence.

---

## Delivery Platform Positioning

The Release 1 implementation uses Hyper-V as the current platform foundation.

That should be understood as:
- the **current delivery environment**
- a demonstration of virtualization, isolation, and lab engineering discipline
- not the permanent identity of the overall project

This distinction matters because the project is intended to remain extensible. Future platform work could include alternative virtualization implementations or additional hosting models without changing the core documentation model.

In other words, Hyper-V supports the platform, but the project is not “about Hyper-V” alone.

---

## Certificate and Namespace Positioning

Certificate trust and namespace readiness are important platform concerns because they affect hybrid messaging, service validation, and migration reliability.

For Release 1:
- namespace design was treated as a strategic part of the platform
- the hybrid pilot used a dedicated namespace path
- certificate handling was approached pragmatically using Let’s Encrypt via `win-acme` where required for the hybrid configuration path

Release 1 does **not** claim a full internal PKI or AD CS deployment.

This is an example of how the platform is documented:
- strategic concerns are acknowledged
- actual implementation is stated clearly
- scope honesty is preserved

---

## Operational Realism

A major design principle of this repository is that the platform should not only demonstrate successful setup, but also credible operational behavior.

That is why Release 1 includes scenarios and evidence related to:
- Exchange hybrid migration friction
- trust disruption and recovery
- BitLocker recovery key retrieval
- stale record cleanup
- re-enrollment and restored compliance
- visibility across sign-in, audit, and device state

This operational realism is intentional. It makes the platform more useful as engineering proof than a simple “all green” demonstration.

---

## How to Read the Platform

Readers should use this page as the bridge between the business scenario and the detailed release documentation.

Recommended reading path:

1. [Business Scenario](00-business-scenario.md)
2. [Current-State Architecture](02-current-state-architecture.md)
3. [Target-State Architecture](03-target-state-architecture.md)
4. [Roadmap](04-roadmap.md)
5. [Skills and Evidence Index](05-skills-and-evidence-index.md)

Then move into the release most relevant to the role or review context.

---

## Related Releases

- [Release 1 README](../release1/README.md)
- [Release 2 README](../release2/README.md)
- [Release 3 README](../release3/README.md)

---

## Related Diagrams

- [Release 1 End-State Architecture](../../diagrams/01-release1-end-state-architecture.png) — shows the implemented Release 1 hybrid platform end state
- [Identity, Messaging, and Endpoint Control Flow](../../diagrams/02-identity-messaging-endpoint-control-flow.png) — shows how identity, messaging, and endpoint trust interact across the platform
- [Three-Release Roadmap](../../diagrams/04-phased-roadmap-release1-release2-release3.png) — shows the staged release progression across the platform
- [Release 1 Implementation Flow and Proof Map](../../diagrams/05-release1-implementation-flow-and-proof-map.png) — maps Release 1 delivery areas to their supporting proof

---

## Summary

The platform should be read as a release-based, evidence-backed engineering journey:

- **Release 1** establishes the hybrid Microsoft and endpoint control foundation
- **Release 2** extends that foundation into Azure governance and security
- **Release 3** extends it further into secure workload modernization

That structure is intentional. It keeps the project readable, technically credible, and extensible without forcing every capability into a single release.