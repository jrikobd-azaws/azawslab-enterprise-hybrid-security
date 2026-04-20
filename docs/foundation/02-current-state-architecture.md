# Current-State Architecture

## Purpose

This page describes the starting architecture used to establish Release 1 of the `azawslab Enterprise Hybrid Security Platform`.

It explains the on-premises platform foundation, the initial service boundaries, and the operational constraints that shaped the first release. It should be read as the architectural baseline from which the hybrid platform was introduced.

---

## What This Page Proves

This page shows that the starting environment for the project was:

- a deliberately scoped small-enterprise-style on-premises Microsoft estate
- designed to support a controlled hybrid pilot rather than an immediate full-cloud cutover
- built with enough realism to validate identity, messaging, endpoint, and namespace decisions
- suitable for demonstrating staged modernization rather than one-time lab setup

---

## Why This Matters

A hybrid platform cannot be evaluated properly without understanding what existed before integration work began.

The current-state architecture matters because it explains:

- why hybrid identity was introduced in a controlled way
- why Exchange hybrid was piloted rather than treated as an instant migration
- why namespace and certificate readiness became important design concerns
- why endpoint and access controls were layered onto the platform instead of assumed from the start

Understanding the current state makes the Release 1 decisions easier to evaluate and shows that the project was built around realistic transition constraints rather than an idealized greenfield model.

---

## Current-State Overview

Before hybrid expansion, the platform was centered on a small on-premises Microsoft environment hosted on a local virtualization foundation.

The initial operating model was based on:

- an on-premises Active Directory domain
- on-premises DNS and directory services
- Exchange Server Subscription Edition as the local messaging platform
- Microsoft 365 tenant onboarding as a parallel cloud control plane
- Hyper-V-hosted virtual machines providing the lab and delivery environment
- a controlled pilot user and device scope rather than a full-estate rollout

This baseline was intentionally constrained. The goal was not to simulate a large enterprise in size, but to model the dependencies and trust relationships that matter in a real hybrid transition.

---

## Architectural Baseline

At the beginning of Release 1, the current state can be understood in six core layers.

### 1. Virtualization and host foundation

The platform was hosted on a Hyper-V-based delivery environment designed to support multiple interdependent Microsoft workloads.

This included:
- internal virtual switching
- host NAT for controlled connectivity
- reusable image and differencing-disk strategy
- isolated multi-VM topology for identity, management, and messaging roles

This matters because the project needed a stable and repeatable base from which hybrid identity, messaging, and endpoint scenarios could be validated without depending on external enterprise infrastructure.

### 2. Directory and identity baseline

The starting trust model was based on on-premises Active Directory.

The current-state identity layer included:
- domain controllers providing directory and DNS services
- OU structure and security groups for user, device, and pilot segmentation
- a clean enough on-premises identity source to support later Entra Connect synchronization

At this stage, identity trust was still fundamentally on-premises. Cloud identity integration had not yet become the authoritative control layer.

### 3. Messaging baseline

Messaging began from an Exchange-centered on-premises model.

This layer included:
- Exchange Server Subscription Edition deployment
- local Exchange administration and mailbox platform readiness
- namespace and certificate considerations relevant to later hybrid integration

This was important because the project needed to demonstrate a realistic starting point for Exchange hybrid rather than assuming Exchange Online was already in place.

### 4. Tenant and cloud baseline

A Microsoft 365 tenant existed as the cloud-side platform target, but the current state should not be read as a cloud-native environment.

At current state, the tenant represented:
- a cloud destination and administrative plane
- a service boundary that needed controlled identity alignment
- a platform requiring pilot-based readiness validation

This means the environment had cloud presence, but not yet full hybrid cohesion.

### 5. Endpoint baseline

The current-state endpoint landscape was intentionally limited before management expansion.

The estate did not begin with a fully mature cloud-managed device strategy. Instead, endpoint governance and visibility were introduced through Release 1.

That means the current state should be understood as:
- pre-Intune-management baseline
- pre-compliance-enforcement baseline
- pre-device-based-access-control baseline

This is important because it explains why endpoint enrollment, compliance, and security controls became major Release 1 workstreams rather than assumed inherited capabilities.

### 6. Operational baseline

Operationally, the starting state was functional but not yet fully instrumented for hybrid visibility.

This meant:
- no mature cross-layer hybrid monitoring model yet
- no established compliant-device access story yet
- no validated information-protection control path yet
- no documented recovery-driven endpoint lifecycle yet

Release 1 exists partly to create that operational maturity layer.

---

## Starting Platform Components

The current-state architecture can be summarized through the principal platform components that existed before or at the start of Release 1:

| Component | Role in current state |
|---|---|
| **Hyper-V host foundation** | Provides the virtualization base, internal networking, and reusable VM delivery model |
| **DC1 / DC2** | Establish on-premises directory, DNS, replication, and identity source integrity |
| **MEM1** | Serves as the platform management and synchronization staging point for hybrid administration workflows |
| **EXCH1** | Provides the on-premises Exchange messaging platform used for hybrid readiness and pilot migration work |
| **Microsoft 365 tenant** | Provides the cloud service target for identity alignment, collaboration services, and later policy control |

This component view is useful because it shows that the platform did not begin as “all cloud” or “all on-premises,” but as a staged hybrid candidate environment.

---

## Current-State Constraints

The current-state architecture imposed several important constraints that shaped later design choices.

### Constraint 1: Hybrid had to coexist with existing services
The transition could not assume a clean replacement of all existing services at once. Identity and messaging had to be introduced in a way that preserved control and avoided unnecessary disruption.

### Constraint 2: Namespace and certificate readiness mattered early
Because Exchange hybrid and related validation paths depend on trust, naming, and service accessibility, namespace planning and certificate handling became early architectural concerns rather than late-stage polish.

### Constraint 3: Cloud identity could not be assumed as authoritative from day one
The environment required careful synchronization and pilot scoping before cloud identity could meaningfully support access decisions and Microsoft 365 service delivery.

### Constraint 4: Endpoint trust had to be built, not assumed
Device compliance, platform visibility, and hardened endpoint controls were not part of the baseline state. They had to be introduced through Intune and related Release 1 work.

### Constraint 5: Recovery realism mattered
The platform needed to validate not only successful setup, but also what happens when trust breaks, devices go stale, or endpoint state must be restored.

These constraints are one reason the repository is structured as releases rather than as one undifferentiated implementation log.

---

## Namespace and Mail Flow Positioning

The current-state architecture also included an important namespace boundary.

The project intentionally preserved separation between:
- the primary business namespace associated with existing mail handling
- the hybrid pilot namespace used to validate Release 1 hybrid messaging work

This was important because it allowed:
- pilot hybrid configuration without prematurely disrupting the root business namespace
- controlled validation of Exchange hybrid behavior
- safer experimentation with trust, migration, and namespace-dependent configuration

The current state therefore should not be interpreted as a full production namespace migration. It was a controlled hybrid starting point.

---

## Certificate and Trust Positioning

Certificate trust was a strategic requirement of the current-state to target-state transition, especially in the Exchange hybrid path.

At current state:
- certificate readiness was a design concern
- trust requirements were acknowledged as part of the hybrid dependency chain
- implementation decisions were made pragmatically for Release 1

Release 1 does **not** claim that the current state included a full internal PKI or AD CS deployment.

Instead, certificate handling should be read as:
- strategically important to the architecture
- implemented pragmatically where required
- part of a hybrid readiness story rather than a separate certificate-services programme

This distinction is important for scope honesty.

---

## What the Current State Did Not Yet Provide

Before Release 1 maturity work, the platform did **not** yet provide a fully integrated story for:

- cloud-synchronized identity governance
- compliant-device-based access logic
- multi-platform endpoint enrollment and visibility
- information protection validation
- operational monitoring across sign-ins, policy state, and audit activity
- advanced recovery handling for trust break or stale device records

These are precisely the gaps Release 1 was designed to address.

---

## Transition Pressure Toward the Target State

The current-state architecture created the need for a target state with:

- synchronized hybrid identity
- cloud-integrated productivity services
- managed and policy-aware endpoints
- visible control posture
- data protection controls
- documented operational recovery
- a platform foundation capable of future Azure and workload expansion

That is why Release 1 should be read as the first major platform maturity step, not as a detached lab exercise.

---

## Relationship to Release 1

Release 1 builds directly on the current-state architecture by adding:

- Entra synchronization and pilot identity alignment
- Exchange hybrid validation and pilot migration
- Teams and SharePoint baseline validation
- endpoint enrollment across multiple ownership and platform scenarios
- compliance and security controls in Intune
- Purview label and DLP validation
- monitoring visibility and recovery scenarios

In that sense, the current-state architecture is the baseline problem statement, while Release 1 is the first validated answer.

---

## How to Read This with the Other Foundation Docs

This page should be read alongside:

1. [Business Scenario](00-business-scenario.md)
2. [Platform Overview](01-platform-overview.md)
3. [Target-State Architecture](03-target-state-architecture.md)
4. [Roadmap](04-roadmap.md)

Suggested interpretation:
- **Business Scenario** explains why the platform exists
- **Platform Overview** explains the full three-release structure
- **Current-State Architecture** explains the starting point
- **Target-State Architecture** explains the intended Release 1–anchored design direction
- **Roadmap** explains the sequence of maturity

---

## Related Release 1 Documents

- [Release 1 README](../release1/README.md)
- [Release 1 Summary](../release1/00-summary.md)
- [Hybrid Identity](../release1/01-hybrid-identity.md)
- [Modern Workplace](../release1/02-modern-workplace.md)

---

## Related Diagrams

- [Release 1 End-State Architecture](../../diagrams/01-release1-end-state-architecture.png) — shows the implemented target for Release 1 after hybrid and endpoint capability expansion
- [Identity, Messaging, and Endpoint Control Flow](../../diagrams/02-identity-messaging-endpoint-control-flow.png) — shows how identity, messaging, and endpoint trust interact after Release 1 controls are introduced
- [Three-Release Roadmap](../../diagrams/04-phased-roadmap-release1-release2-release3.png) — shows how the current state evolves into later release stages

---

## Summary

The current-state architecture should be understood as a controlled on-premises Microsoft baseline with:

- virtualized platform delivery
- directory and DNS foundation
- Exchange-based messaging baseline
- cloud tenant readiness without full cloud maturity
- limited initial endpoint governance
- clear architectural pressure toward hybrid identity, managed endpoints, and modern collaboration services

That baseline is what gives Release 1 its meaning.

Without the current-state constraints, the hybrid, endpoint, and operational decisions in the repository would look like isolated configuration tasks. With them, they become part of a coherent platform transition story.