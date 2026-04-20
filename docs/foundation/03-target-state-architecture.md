Here is a **full revised draft** for `docs/foundation/03-target-state-architecture.md`:

```md
# Target-State Architecture

## Purpose

This page describes the intended architectural outcome of Release 1 within the `azawslab Enterprise Hybrid Security Platform`.

It explains how the current-state on-premises baseline evolves into a controlled hybrid Microsoft platform with synchronized identity, modern workplace services, managed endpoints, information protection controls, and improved operational visibility.

This page should be read as the architectural destination for the implemented first release, not as a statement that all future-release capabilities are already in place.

---

## What This Page Proves

This page shows that Release 1 was designed to produce:

- a controlled hybrid identity model between on-premises Active Directory and Microsoft Entra ID
- a validated hybrid messaging and Microsoft 365 collaboration path
- an endpoint management and security layer built around Intune
- a policy-aware access model where device state and identity controls work together
- an operationally visible platform with monitoring, auditability, and recovery workflows
- a foundation capable of later expansion into Azure governance and secure workload modernization

---

## Why This Matters

The target state matters because it shows that Release 1 is not a collection of unrelated tasks. It is a designed end state with a clear control model.

That control model connects:

- identity trust
- messaging and collaboration modernization
- endpoint enrollment and compliance
- security baselines and endpoint hardening
- information protection
- visibility and recovery

This matters in real environments because modernization succeeds when these layers reinforce one another. A cloud mailbox without identity discipline, a compliant device without access logic, or a protection policy without validation evidence does not create a credible operational platform.

---

## Target-State Overview

The target state for Release 1 is a **hybrid Microsoft operating model** where:

- on-premises Active Directory remains the foundational identity source
- Microsoft Entra ID becomes the cloud identity and access control plane for synchronized pilot users and devices
- Exchange hybrid provides the transition bridge between on-premises messaging and Exchange Online
- Teams and SharePoint are validated as part of the modern workplace layer
- Intune introduces multi-device enrollment, policy control, compliance visibility, and endpoint security posture
- Purview introduces information protection validation through labels, DLP, and retention awareness
- monitoring and recovery workflows provide operational confidence rather than setup-only success

This should be read as a controlled hybrid destination, not a full cloud-only replacement of every on-premises dependency.

---

## Target-State Architecture at a Glance

| Layer | Target-state outcome |
|---|---|
| **Platform foundation** | Stable virtualized Microsoft estate capable of supporting hybrid identity, management, messaging, and controlled validation |
| **Identity and access** | On-premises AD synchronized to Entra ID with Conditional Access, MFA, SSPR, and pilot-based cloud identity control |
| **Messaging and collaboration** | Exchange hybrid path validated, pilot mailboxes migrated, Teams and SharePoint baseline services confirmed |
| **Endpoint management and security** | Corporate and personal device scenarios enrolled and visible, compliance and security controls applied through Intune |
| **Information protection** | Sensitivity labels, DLP, and retention awareness introduced as user-facing protection controls |
| **Monitoring and recovery** | Sign-in review, audit review, policy visibility, device-state review, and recovery evidence integrated into the platform story |

---

## Architectural Layering

### 1. Platform foundation

The target state still depends on a locally controlled Microsoft platform foundation.

That foundation includes:
- Hyper-V-hosted platform delivery for Release 1
- domain services, DNS, and core VM roles
- controlled internal networking and host NAT
- reusable images and predictable VM lifecycle handling

The foundation is important because it supports realistic hybrid design without depending on pre-existing enterprise infrastructure.

It should be understood as the current delivery platform, not the permanent identity of the project.

### 2. Identity and access layer

In the target state, identity becomes a hybrid trust model rather than a purely on-premises one.

This includes:
- Active Directory as the source directory
- Entra Connect synchronization into Microsoft Entra ID
- controlled pilot scoping using groups and filtering
- Conditional Access enforcement
- MFA requirements
- SSPR capability
- cloud-aware access logic built around user and device state

The target-state identity model matters because it establishes the control plane for collaboration services and endpoint-aware access.

### 3. Messaging and collaboration layer

The target state introduces a modern workplace service path validated through hybrid and cloud-aligned user scenarios.

This includes:
- Exchange hybrid readiness and configuration
- migration endpoint validation
- pilot mailbox migration
- Outlook / OWA validation after migration
- Teams baseline service validation
- SharePoint baseline service validation

The goal is not to claim a full enterprise tenant transformation in Release 1. The goal is to prove that the hybrid pathway works and that core collaboration services can be used credibly in the target environment.

### 4. Endpoint management and security layer

The target state introduces a managed-device control model across supported pilot scenarios.

This includes:
- Windows corporate device onboarding
- Windows BYOD visibility and ownership distinction
- iPhone BYOD enrollment
- Ubuntu Linux visibility and management
- Intune enrollment and device inventory visibility
- compliance policy enforcement
- Windows security baseline
- Defender Antivirus policy
- ASR policy
- BitLocker-related controls
- update ring policy

This layer matters because it turns identity and cloud administration into a visible endpoint trust and security model.

### 5. Information protection layer

The target state includes a first-stage content protection model.

This includes:
- Purview sensitivity labels
- user-visible label application
- DLP policy-tip triggering
- retention visibility

This demonstrates that the platform is not only identity- and device-aware, but also beginning to handle data-control responsibilities at the content layer.

### 6. Monitoring and recovery layer

A key characteristic of the target state is that the platform is not only configured but also reviewable and recoverable.

This includes:
- sign-in visibility
- audit log visibility
- device-state visibility
- policy and control status review
- example alert visibility
- documented endpoint recovery and compliance restoration scenarios

This operational layer is one of the strongest differentiators in the repository because it shows how the platform behaves under administration, not just at first build.

---

## Identity and Device Trust Model

One of the most important architectural shifts in the target state is the relationship between identity trust and device trust.

The target state aims to establish:

- synchronized pilot identities in Entra ID
- authenticated users governed by MFA and Conditional Access logic
- enrolled and visible devices in Intune and Entra
- compliance-aware device posture
- access logic that increasingly depends on both user identity and device state

This is important because it turns hybrid Microsoft services into a more credible Zero Trust-style operating model.

It does **not** claim full enterprise Zero Trust maturity. It demonstrates the practical beginnings of that model in a controlled Release 1 scope.

---

## Namespace and Certificate Design in the Target State

The target state includes a deliberate namespace approach that supports hybrid validation without disrupting existing business mail assumptions.

This includes:
- preserving the primary business namespace separately from the hybrid pilot path
- introducing a dedicated pilot namespace for Release 1 hybrid work
- treating certificate trust as a required hybrid dependency rather than an afterthought

For Release 1, certificate handling was implemented pragmatically where required using Let’s Encrypt via `win-acme`.

The target state does **not** claim:
- a full internal PKI deployment
- a full AD CS platform rollout
- certificate-services maturity beyond what was needed for the implemented hybrid design

This distinction is important because certificate and PKI concerns were strategically relevant, but the implemented scope was intentionally narrower.

---

## Endpoint Security Positioning in the Target State

The endpoint target state is not just “devices enrolled in Intune.”

It is intended to represent:
- devices onboarded into a managed estate
- ownership distinction between corporate and personal devices
- policy-enforced compliance posture
- security baseline application
- Defender AV and ASR configuration visibility
- BitLocker recovery readiness
- update posture review
- recovery from trust or enrollment disruption

This matters because many roles will interpret endpoint maturity through the lens of security and recoverability, not just enrollment counts.

The target state therefore includes endpoint **management and security**, not only endpoint enrollment.

---

## Information Protection Positioning in the Target State

Release 1 introduces a first-stage information protection model rather than a full enterprise compliance programme.

The target state should be read as proving that:
- protection labels can be created and applied
- user-visible classification behavior can be demonstrated
- DLP policy-tip behavior can be triggered and reviewed
- retention-related controls are visible within the overall platform narrative

It should **not** be read as a claim of full-scale Purview maturity, large-scale auto-labeling, or advanced fingerprinting coverage unless specifically evidenced elsewhere.

---

## Monitoring and Recovery Positioning in the Target State

A major goal of the target state is to ensure the platform can be observed and recovered, not merely configured.

That means the target state includes:
- visibility into authentication activity
- visibility into audit activity
- visibility into device inventory and compliance state
- visibility into security-control status
- visibility into operational alert examples
- proof that failure and recovery scenarios can be handled

This is where the architecture becomes operationally credible rather than aesthetically complete.

---

## What the Target State Does Not Yet Claim

Even in Release 1, the target state has clear boundaries.

It does **not** claim:
- full cloud-only replacement of on-premises dependencies
- advanced enterprise PKI deployment
- full Android BYOD / MAM maturity
- fully evidenced Autopilot / ESP optimization
- complete LAPS retrieval and recovery validation
- full Defender platform breadth beyond the controls specifically evidenced
- Release 2 Azure governance and security implementation
- Release 3 workload modernization implementation

These boundaries should remain explicit throughout the documentation.

---

## Relationship to Release 2 and Release 3

The Release 1 target state is intentionally designed as a foundation for later work.

### Release 2 builds on Release 1 by adding:
- Azure landing zone and platform structure
- governance and policy enforcement
- delegated administration patterns
- network security maturity
- Defender for Cloud
- Sentinel-aligned monitoring and security operations direction

### Release 3 builds further by adding:
- application hosting strategy
- modernization through containerization
- protected ingress and WAF concepts
- observability
- resilience and workload recovery

Release 2 and Release 3 should be read as planned expansion paths, not as hidden or partially implied Release 1 scope.

No empty structure should be created simply to suggest capability. Future-release areas should only become implementation structure when they are actually built and evidenced.

---

## How to Read This with the Other Foundation Docs

Use this page after reading the current-state architecture.

Recommended sequence:
1. [Business Scenario](00-business-scenario.md)
2. [Platform Overview](01-platform-overview.md)
3. [Current-State Architecture](02-current-state-architecture.md)
4. [Target-State Architecture](03-target-state-architecture.md)
5. [Roadmap](04-roadmap.md)
6. [Skills and Evidence Index](05-skills-and-evidence-index.md)

Then move into Release 1 documentation for the implementation and evidence story.

---

## Related Release 1 Documents

- [Release 1 README](../release1/README.md)
- [Release 1 Summary](../release1/00-summary.md)
- [Hybrid Identity](../release1/01-hybrid-identity.md)
- [Modern Workplace](../release1/02-modern-workplace.md)
- [Endpoint Overview](../release1/03-endpoint-overview.md)
- [Endpoint Enrollment](../release1/04-endpoint-enrollment.md)
- [Endpoint Compliance and Security](../release1/05-endpoint-compliance-and-security.md)
- [Recovery Scenarios](../release1/06-recovery-scenarios.md)
- [Purview](../release1/07-purview.md)
- [Monitoring](../release1/08-monitoring.md)

---

## Related Diagrams

- [Release 1 End-State Architecture](../../diagrams/01-release1-end-state-architecture.png) — shows the implemented target architecture for Release 1
- [Identity, Messaging, and Endpoint Control Flow](../../diagrams/02-identity-messaging-endpoint-control-flow.png) — shows how trust and service dependencies interact across the Release 1 control model
- [Three-Release Roadmap](../../diagrams/04-phased-roadmap-release1-release2-release3.png) — shows how the Release 1 target state supports later platform maturity
- [Release 1 Implementation Flow and Proof Map](../../diagrams/05-release1-implementation-flow-and-proof-map.png) — maps the Release 1 target state to documented and evidenced workstreams
- [Release 1 Security and Compliance Mapping](../../diagrams/06-release1-security-and-compliance-mapping.png) — shows how endpoint, identity, and information protection controls connect in Release 1

---

## Summary

The target-state architecture should be understood as a controlled hybrid Microsoft end state for Release 1 in which:

- on-premises identity remains foundational
- cloud identity and access controls become operationally relevant
- Exchange hybrid and Microsoft 365 collaboration services are validated
- endpoints become enrolled, visible, compliant, and security-controlled
- information protection moves from concept into user-visible validation
- monitoring and recovery become part of the platform design

That target state gives Release 1 its architectural coherence.

It shows how the repository moves from an on-premises baseline into a hybrid, managed, and evidence-backed platform foundation capable of supporting later Azure governance and secure workload expansion.
```

A few guidance notes for this file:

* this page should be **destination-oriented**, unlike current-state
* it should define the Release 1 architectural outcome, not narrate every implementation step
* it should stay honest about boundaries
* it should clearly separate Release 1 target state from Release 2/3 planned expansion
* one architecture diagram can support this page well, but do not overload it with screenshots

Next best file is `docs/foundation/04-roadmap.md`.
